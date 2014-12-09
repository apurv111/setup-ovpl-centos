#!/bin/bash

DATE=$(date)
LOGGFILE="setup-ovpl.log"
cd /root

if [ ! -d "ovpl" ];then
	echo "[[$DATE:: $0 :: Line $LINENO::]] Cloning https://github.com/vlead/ovpl.git into /root/" 2>&1 | tee -a $LOGGFILE
	git clone https://github.com/vlead/ovpl.git
	if [ $? -eq 0 ]
	then	
		echo "[[$DATE:: $0 :: Line $LINENO::]] Finished Cloning https://github.com/vlead/ovpl.git into /root/" 2>&1 | tee -a $LOGGFILE
	else 
		echo "[[$DATE:: $0 :: Line $LINENO::]] Error in Cloning https://github.com/vlead/ovpl.git into /root/" 2>&1 | tee -a $LOGGFILE
		exit 1
	fi
else
	echo "[[$DATE:: $0 :: Line $LINENO::]] Pulling ovpl from origin master" 2>&1 | tee -a $LOGGFILE
	cd ovpl/
	git pull origin master
	echo "[[$DATE:: $0 :: Line $LINENO::]] finished pulling https://github.com/vlead/ovpl.git into /root/" 2>&1 | tee -a $LOGGFILE
	echo "[[$DATE:: $0 :: Line $LINENO::]] Checking out version v1.0.0 .." 2>&1 | tee -a $LOGGFILE
	git checkout tags/v1.0.0

fi

echo "[[$DATE:: $0 :: Line $LINENO::]] Running 'python setup.py install' to install pre-requisites for run ovpl " 2>&1 | tee -a $LOGGFILE
python setup.py install
if [[ $? -ne 0 ]];then	
	echo "[[$DATE:: $0 :: Line $LINENO::]] Error in installing 'python setup.py install' " 2>&1 | tee -a $LOGGFILE
	exit 1
fi
echo "=========================================================================================================="
echo "[[$DATE:: $0 :: Line $LINENO::]] Congrats! You have setup OVPL successfully!!! :-)" 2>&1 | tee -a $LOGGFILE
echo "Now run 'make' from inside the src directory"
echo " of OVPL to start the services."
echo "=========================================================================================================="

exit 0
