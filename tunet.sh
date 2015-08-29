#!/bin/bash
####################################################
do_login() {
     login_data='***************'

	# check whether already online
		# start login
		res=`curl -d $login_data -s http://net.tsinghua.edu.cn/do_login.php`
}

do_logout() {
	# start logout
    topost="action=logout"
	res=`curl -d $topost -s http://net.tsinghua.edu.cn/do_login.php`

}

##################################################################################
if [ "$1" == "login" ]; then
do_login
elif [ "$1" == "logout" ]; then
do_logout
else
	echo "Usage: "$0" {login|logout}"
fi 
echo $res
