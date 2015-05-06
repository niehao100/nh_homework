import commands
if __name__ == '__main__':  
    import socket  
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  
    sock.bind(('', 8001))  
    sock.listen(5)  
    while True:  
        connection,address = sock.accept()  
        try:  
            connection.settimeout(15)  
            buf = connection.recv(1024)
            buf =buf.split('\n')
            print buf   
            if buf[0] == 'c':  
                connection.send('welcome to server!')
                (status, output) = commands.getstatusoutput('cd /home/niehao/teamstyle16/upload/')
               	(status, output) = commands.getstatusoutput('gcc -O1 '+buf[1])
                connection.send(output)
               	(status, output) = commands.getstatusoutput('./a.out')
                connection.send(output)
  
            else:  
                connection.send('please go out!')  
        except socket.timeout:  
            print 'time out'  
        connection.close()  
