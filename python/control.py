#! /usr/bin/env python
"""\

Scan for serial ports.



Part of pySerial (http://pyserial.sf.net)

(C) 2002-2003 <cliechti@gmx.net>



The scan function of this module tries to open each port number

from 0 to 255 and it builds a list of those ports where this was

successful.

"""
import serial
import msvcrt
def scan():

    """scan for available ports. return a list of tuples (num, name)"""

    available = []

    for i in range(256):

        try:

            s = serial.Serial(i)

            available.append( (i, s.portstr))

            s.close()   # explicit close 'cause of delayed GC in java

        except serial.SerialException:

            pass

    return available



if __name__=='__main__':
 print("w,s,a,d move, pause close the motor, `(~) restart and esc exit")
 for n,s in scan():
  print ("(%d) %s" % (n,s))
 while (True):
  port = raw_input("Choose the port:")
  rate = int(raw_input("Input Baud rate:"))
  ser=serial.Serial(port,rate)
  print (ser.portstr)

  while (True):
   ch = msvcrt.getch()
   print(ch)   
   if  	ch == b'`':
    break
   if	ch == b'\x1b':
    print ("bye")    
    exit()
   if 	ch == b'w':
    n=ser.write('\x72\x72\x03')
   if 	ch == b's':
    n=ser.write('\x0e\x0e\x03')			 
   if 	ch == b'a':
    n=ser.write('\x0e\x72\x03')		
   if 	ch == b'd':
    n=ser.write('\x72\x0e\x03')
   if 	ch == b' ':
    n=ser.write('\x41\x41\x03')
