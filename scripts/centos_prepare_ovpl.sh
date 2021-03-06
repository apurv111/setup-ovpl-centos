#!/bin/bash
# Script to setup a fresh installation of CentOS to run OVPL
# Installs: Dependencies: python-devel, git, pip; mongodb; openvz.

# read proxy settings from config file
if [[ -f "config.sh" ]];then
	echo "[[$DATE:: $0 :: Line $LINENO::]] Reading config.sh file for proxy settings" 2>&1 | tee -a $LOGFILE
	source ./config.sh
	if [[ -n $http_proxy ]]; then
  		
  		export http_proxy=$http_proxy
  		echo "[[$DATE:: $0 :: Line $LINENO::]] export http_proxy = $http_proxy" 2>&1 | tee -a $LOGFILE
	fi
	if [[ -n $https_proxy ]]; then
  		export https_proxy=$https_proxy
  		echo "[[$DATE:: $0 :: Line $LINENO::]] export https_proxy = $https_proxy" 2>&1 | tee -a $LOGFILE
	fi
else
	echo "[[$DATE:: $0 :: Line $LINENO::]] config.sh file not exist" 2>&1 | tee -a $LOGFILE
	exit 1
fi

if [[ -f $LOGFILE ]];then
	echo "================================================="
	echo "logfilepath = setup-ovpl-centos/scripts/$LOGFILE"
	echo "================================================="
else
	touch $LOGFILE
	echo "================================================="
	echo "logfilepath = setup-ovpl-centos/scripts/$LOGFILE"
	echo "================================================="
fi

# check if script is run as root
if [[ $UID -ne 0 ]]; then
  echo ""
  echo "$0 must be run as root!"
  echo "[[$DATE:: $0 :: Line $LINENO::]] $0 must be run as root...." 2>&1 | tee -a $LOGFILE
  echo "check log file exiting...."
  exit 1

else
  echo "[[$DATE:: $0 :: Line $LINENO::]] Started Invoking centos_prepare_ovpl.sh...." 2>&1 | tee -a $LOGFILE

fi

# check if meta directory exists
if [[ ! -d "../meta" ]]; then
  echo ""
  echo "[[$DATE:: $0 :: Line $LINENO::]] You don't have the necessary files please contact the author of the script...." 2>&1 | tee -a $LOGFILE
  echo "Check log file exiting...."
  exit 1

fi

#updating system
echo ""
echo "========================== UPDATING SYSTEM ================================"
echo "[[$DATE:: $0 :: Line $LINENO::]] Updating System...." 2>&1 | tee -a $LOGFILE
yum update -y
if [[ $? -ne 0 ]];then
	echo "[[$DATE:: $0 :: Line $LINENO::]] Error in updating system " 2>&1 | tee -a $LOGFILE
	exit 1
else
	echo "" 	
	echo "[[$DATE:: $0 :: Line $LINENO::]] System updation complete.." 2>&1 | tee -a $LOGFILE
	echo ""
fi


if [[ -f "install_dependencies.sh" ]];then
	echo "[[$DATE:: $0 :: Line $LINENO::]] Invoking install_dependencies.sh" 2>&1 | tee -a $LOGFILE
	./install_dependencies.sh
	if [ $? -ne 0 ]; then
 		echo ""
  		echo "[[$DATE:: $0 :: Line $LINENO::]] Error installing dependencies. Quitting!" 2>&1 | tee -a $LOGFILE
		echo "======================"
		echo "See logs at $LOGFILE"
		echo "====================="
  		exit 1
	else
       		echo "[[$DATE:: $0 :: Line $LINENO::]] successfully installed dependencies..." 2>&1 | tee -a $LOGFILE

	fi
else
	echo "[[$DATE:: $0 :: Line $LINENO::]] install_dependencies.sh file not exist" 2>&1 | tee -a $LOGFILE
	exit 1
fi

if [[ -f "install_openvz.sh" ]];then
	echo "[[$DATE:: $0 :: Line $LINENO::]] Invoking install_openvz.sh" 2>&1 | tee -a $LOGFILE
	./install_openvz.sh
	if [ $? -ne 0 ]; then
 		echo ""
  		echo "[[$DATE:: $0 :: Line $LINENO::]] Error installing openvz. Quitting!" 2>&1 | tee -a $LOGFILE
		echo "======================"
		echo "See logs at $LOGFILE"
		echo "====================="
		exit 1
	else
       		echo "[[$DATE:: $0 :: Line $LINENO::]] successfully installed openvz..." 2>&1 | tee -a $LOGFILE

	 
	fi
else
	echo "[[$DATE:: $0:: Line $LINENO::]] install_openvz.sh file not exist" 2>&1 | tee -a $LOGFILE
	exit 1
fi

if [[ -f "install_mongodb.sh" ]];then
	echo "[[$DATE:: $0 :: Line $LINENO::]] Invoking install_mongodb.sh" 2>&1 | tee -a $LOGFILE
	./install_mongodb.sh
	if [ $? -ne 0 ]; then
 		echo ""
  		echo "[[$DATE:: $0 :: Line $LINENO::]] Error installing mongodb. Quitting! " 2>&1 | tee -a $LOGFILE
		echo "======================"
		echo "See logs at $LOGFILE"
		echo "====================="
 		exit 1
		
	else
      		echo "[[$DATE:: $0 :: Line $LINENO::]] successfully installed mongodb..." 2>&1 | tee -a $LOGFILE

	fi
else
	echo "[[$DATE:: $0 :: Line $LINENO::]] install_mongodb.sh file not exist" 2>&1 | tee -a $LOGFILE
	exit 1
fi

if [[ -f "install_ovpl.sh" ]];then
	echo "[[$DATE:: $0 :: Line $LINENO::]] Invoking install_ovpl.sh" 2>&1 | tee -a $LOGFILE
	./install_ovpl.sh
	if [ $? -ne 0 ]; then
 		echo ""
  		echo "[[$DATE:: $0 :: Line $LINENO::]] Error installing ovpl. Quitting! " 2>&1 | tee -a $LOGFILE
		echo "======================"
		echo "See logs at $LOGFILE"
		echo "====================="
 		exit 1
	else
       	
		echo "=========================================================================================================="
		echo "[[$DATE:: $0 :: Line $LINENO::]] Congrats! You have setup OVPL successfully!!! :-)" 2>&1 | tee -a $LOGFILE
		echo "Now run 'make' from inside the src directory"
		echo " of OVPL to start the services."
		echo "=========================================================================================================="   		
	fi
else
	echo "[[$DATE:: $0 :: Line $LINENO::]] install_ovpl.sh file not exist" 2>&1 | tee -a $LOGFILE
	exit 1
fi

exit 0
