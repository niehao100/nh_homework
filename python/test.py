# -*- coding: utf-8 -*-
from threading import Thread
import time
import  commands
import threading

class TimeoutException(Exception):
    pass

ThreadStop = Thread._Thread__stop#获取私有函数

def timelimited(timeout):
    def decorator(function):
        def decorator2(*args,**kwargs):
            class TimeLimited(Thread):
                def __init__(self,_error= None,):
                    Thread.__init__(self)
                    self._error =  _error
                    
                def run(self):
                    try:
                        self.result = function(*args,**kwargs)
                    except Exception,e:
                        self._error =e

                def _stop(self):
                    if self.isAlive():
                        ThreadStop(self)

            t = TimeLimited()
            t.start()
            t.join(timeout)
     
            if isinstance(t._error,TimeoutException):
                t._stop()
                raise TimeoutException('timeout for %s' % (repr(function)))

            if t.isAlive():
                t._stop()
		(status, output) = commands.getstatusoutput('killall app')
                print "wrong"

            if t._error is None:
                return 1

        return decorator2
    return decorator
	
@timelimited(1) 
def test(num):  
		(status, output) = commands.getstatusoutput('~/app')
		print num
		return 'Finished'

threads = []
t1 = threading.Thread(target=test,args=(1,))
threads.append(t1)
t1 = threading.Thread(target=test,args=(2,))
threads.append(t1)
	
if __name__ == '__main__':
    for t in threads:
        t.setDaemon(True)
        t.start()
    
    t.join()

    print "all over %s" %time.ctime()
