import sys
import time
import os
import fnmatch
import MySQLdb as mdb

#genereer timestamp afgerond op min
timestamp = int(time.time()/100)*100

os.system('modprobe w1-gpio')
os.system('modprobe w1-therm')


#function for storing readings into MySql
def insertDB(IDs, temp, temp_int):

  try:
    con = mdb.connect('localhost', 'temp_user1', 'pwd_user1', 'temperature');
    cursor = con.cursor()

    for i in range(0,len(temp)):
      sql = "INSERT INTO temp_log(sensor_id, date, time, timestamp, value, value_int) \
      VALUES ('%s', '%s', '%s', '%s', '%s', '%s' )" % \
      (IDs[i], time.strftime("%Y-%m-%d"), time.strftime("%H:%M"), timestamp, temp[i], temp_int[i])
      cursor.execute(sql)
      sql = []
      con.commit()

    con.close()

  except mdb.Error, e:
     print e

#get readings from sensors and store them to MySql
temp = []
temp_int = []
IDs = []

for filename in os.listdir("/sys/bus/w1/devices"):
  if fnmatch.fnmatch(filename, '28-*'):
    with open("/sys/bus/w1/devices/" + filename + "/w1_slave") as fileobj:
      lines = fileobj.readlines()
      if lines[0].find("YES"):
        pok = lines[1].find('=')
        temp.append(float(lines[1][pok+1:pok+6])/1000)
        temp_int.append(float(lines[1][pok+1:pok+6]))
        IDs.append(filename)

if (len(temp)>0):
  insertDB(IDs, temp, temp_int)

