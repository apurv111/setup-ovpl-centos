#!/bin/bash
# Script to setup repo and install MongoDB

meta_dir="../meta"
DATE=$(date)
LOGGFILE="setup-ovpl.log"

echo "[[$DATE:: $0 :: Line $LINENO::]] Setting up MongoDB repo...." 2>&1 | tee -a $LOGGFILE
cp $meta_dir/mongodb.repo /etc/yum.repos.d/mongodb.repo

echo "[[$DATE:: $0 :: Line $LINENO::]] Installing MongoDB......" 2>&1 | tee -a $LOGGFILE
yum -y install mongodb-org
if [[ $? -ne 0 ]];then	
	echo "[[$DATE:: $0 :: Line $LINENO::]] Error in installing mongodb.." 2>&1 | tee -a $LOGGFILE
	exit 1
fi

echo "[[$DATE:: $0 :: Line $LINENO::]] Starting mongod service.." 2>&1 | tee -a $LOGGFILE
service mongod start
if [ $? -eq 0 ];then
	echo "[[$DATE:: $0 :: Line $LINENO::]] Mongodb service started.." 2>&1 | tee -a $LOGGFILE
elif [ $? -eq 1 ];then
        sed 's/.*deamon.*/new/g' /etc/init.d/mongod
	service mongod restart
	
else
	echo "[[$DATE:: $0 :: Line $LINENO::]] Error in starting Mongodb service.." 2>&1 | tee -a $LOGGFILE
	exit 1	
	
fi
exit 0
