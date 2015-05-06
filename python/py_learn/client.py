if __name__ == '__main__': 
        import argparse
        parser = argparse.ArgumentParser(description='Online Complier')
        parser.add_argument('-t', action='store',help='Program language', dest='language')
        parser.add_argument('-f', action='store',help='Filename', dest='file')
        args=parser.parse_args();
	import socket  
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  
	sock.connect(('127.0.0.1', 8001))  
	import time  
	time.sleep(2)
	sock.send(args.language+'\n'+args.file)
	print sock.recv(1024)  
	print sock.recv(1024)  
	print sock.recv(1024)  
	sock.close()  
