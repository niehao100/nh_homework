#!/bin/bash
# your info's username
uname=your_username
# your info's password's md5sum
pass=your_password_md5
####################################################
do_login() {
login_data='username='$uname'&password='$pass'&drop=0&type=1&n=100'
check_data='action=check_online'

# check whether already online
con=`curl -d $check_data -s http://net.tsinghua.edu.cn/cgi-bin/do_login`

if [ -z $con ]; then
# start login
res=`curl -d $login_data -s http://net.tsinghua.edu.cn/cgi-bin/do_login`

#handle result
pe=`echo $res | grep error`
if [ -z $pe ]; then
echo "Login Success!"
else
echo $pe
exit 0
fi

# display flux infomation
flux=`echo $res | awk -F ',' '{print $3}'`
a=$(($flux/1000000000))
b=$((($flux%1000000000)/100000000))
c=$((($flux%100000000)/10000000))
echo "Used Flux: "$a"."$b$c"G."

else
echo "Already Online!"

# display flux information and online time
flux=`echo $con | awk -F ',' '{print $3}'`
time=`echo $con | awk -F ',' '{print $5}'`
a=$(($flux/1000000000))
b=$((($flux%1000000000)/100000000))
c=$((($flux%100000000)/10000000))
h=$(($time/3600))
m=$(($(($time%3600))/60))
s=$(($(($time%3600))%60))
echo "Used Flux: "$a"."$b$c"G, Online Time: "$h":"$m":"$s"."
fi
}

do_logout() {
# start logout
res=`curl -s http://net.tsinghua.edu.cn/cgi-bin/do_logout`

#handle result
if [ "$res" == "logout_ok" ]; then
echo "Logout Success!"
elif [ "$res" == "not_online_error" ]; then
echo "You're not Online!"
else
echo "Operation Failed!"
fi
}

##################################################################################
if [ "$1" == "login" ]; then
do_login
elif [ "$1" == "logout" ]; then
do_logout
else
echo "Usage: "$0" {login|logout}"
fi 
