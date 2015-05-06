import commands
(status, output1) = commands.getstatusoutput('docker logs '+'0c57e5fdd64c02c8bfcb7a7d3f21d1da7b639a32e9aea74d21edcf8caa8c87a2')
print output1
