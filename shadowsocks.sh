#! /bin/bash
###
### 直接运行该脚本 采用 start、stop、restart
### eg: ./shadowsocks.sh start
### 端口和密码即可采用默认的，也可以自定义 但可选端口为8000 -9000之间
###
SS_HOME=~/shadowsocks
PID_FILE=$SS_HOME/shadowsocks.pid
LOG_FILE=$SS_HOME/shadowsocks.log
CFG_FILE=$SS_HOME/shadowsocks.json
USERNAME=`whoami`
if [ -z $1 ] ; then
	echo 'please input a argument !'
	exit 1
elif [[  $1 =~ ^(stop|restart)$ ]]; then
	if [ ! -e $PID_FILE ]; then
		echo "please start first !"
		exit 1
	else
		SS_CMD=$1
	fi
elif [[ $1 =~ ^(start)$ ]];then
	if [  -e $PID_FILE ]; then
		echo "The shadwosocks is already running, please do not start again."
		exit 1
	else
		SS_CMD=$1
	fi
else
	echo 'please input "start/stop/restart"!'
	exit 1
fi


if [ ! -e $SS_HOME ];then
	mkdir -p $SS_HOME
fi

if [ $USERNAME = 'jianzhi' ];then
	CFG_PWD='"8088": "Hello@g00g1e","8089": "Hello@0rac1e"'
elif [ $USERNAME = 'hongsheng' ];then
	CFG_PWD='"8212": "Hello@g1thub","8213": "Hello@y0utube"'
elif [ $USERNAME = 'keping' ];then
	CFG_PWD='"8312": "Hello@red1s","8313": "Hello@m0ngodb"'
elif [ $USERNAME = 'yawei' ];then
        CFG_PWD='"8060": "He110@0rac1e","8061": "He110@mysq1"'
else
	CFG_PWD='"9000": "Hello@s1ng1e"'
fi

if [ ! -e $CFG_FILE ];then
cat >> $CFG_FILE << EOF
{
    "server":"0.0.0.0",
    "local_address": "127.0.0.1",
    "local_port":1080,
    "port_password": {
	$CFG_PWD
    },
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false
}
EOF
fi

/usr/local/python36/bin/ssserver -c $CFG_FILE --pid-file $PID_FILE --log-file $LOG_FILE -d $SS_CMD > /dev/null
#/usr/local/python36/bin/ssserver -c $CFG_FILE --pid-file $PID_FILE --log-file /dev/null -d $SS_CMD > /dev/null

if [ $? -eq 0 ];then
	if [ $SS_CMD = 'stop' ]; then
		echo "shadowsocks is stoped successfully!"
	elif [ $SS_CMD = 'restart' ]; then
		echo "shadowsocks is restart successfully!"
	else
		echo "hello $USERNAME boy, shadowsocks is started ,please enjoy it"
	fi
	
else
	echo "some error ..."
fi
