import select
import subprocess

popen = subprocess.Popen("./test.sh", stdout=subprocess.PIPE)
fs = select.select([popen.stdout], [], [], 3)
if popen.stdout in fs[0]:
    output = popen.stdout.read()
    print len(output)
else:
    print "timeout"
