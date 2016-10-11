# -*- coding: UTF-8 -*-
import requests
import os
import datetime
import subprocess

dt = datetime.datetime.now()
cd = str(dt.year)+'0'+str(dt.month)+str(dt.day)
os.makedirs('Bing',exist_ok=True)
url = 'http://www.bing.com/' 
soup = requests.get(url)
p=13+soup.text.find("g_img=")
s=''
while soup.text[p]!="'" and soup.text[p]!='"':
	if(soup.text[p]!='\\'):
		s=s+soup.text[p]
	p=p+1
image_url=s
print(image_url)
res = requests.get(image_url)
with open(os.path.join('Bing',cd+'.bmp'),'wb') as file:
    file.write(res.content) 
p=subprocess.Popen(['runas', '/user:'+os.getlogin(), 'REG ADD "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "'+os.getcwd()+'\Bing'+chr(92)+cd+'.bmp" /f'])
p.communicate()
p.wait()
p=subprocess.Popen(['runas', '/user:'+os.getlogin(), 'RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters'])
p.communicate()
p.wait()
