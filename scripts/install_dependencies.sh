#!/bin/bash

meta_dir="../meta"
DATE=$(date)
LOGGFILE="setup-ovpl.log"

#wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
echo "[[$DATE:: $0 :: Line $LINENO::]] Setting up EPEL repo.." 2>&1 | tee -a $LOGGFILE
rpm -ivh $meta_dir/epel-release-6-8.noarch.rpm

echo "[[$DATE:: $0 :: Line $LINENO::]] Installing dependencies.. " 2>&1 | tee -a $LOGGFILE
echo "[[$DATE:: $0 :: Line $LINENO::]] Running yum -y install gcc python-devel.x86_64 python-pip openssh-clients openssh-server git" 2>&1 | tee -a $LOGGFILE
yum -y install gcc python-devel.x86_64 python-pip openssh-clients openssh-server git
if [[ $? -ne 0 ]];then	
	echo "[[$DATE:: $0 :: Line $LINENO::]] Error in installing dependencies.." 2>&1 | tee -a $LOGGFILE
	exit 1
else
	echo "[[$DATE:: $0 :: Line $LINENO::]] Completed installation of gcc python-devel.x86_64 python-pip openssh-clients openssh-server git" 2>&1 | tee -a $LOGGFILE
fi

exit 0
