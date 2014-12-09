#!/bin/bash
# Script to setup OpenVZ repo, install and configure OpenVZ


DATE=$(date)
LOGGFILE="setup-ovpl.log"
meta_dir="../meta"
vz_template_file="ubuntu-12.04-custom-x86_64.tar.gz"


cd $meta_dir
echo "[[$DATE:: $0 :: Line $LINENO::]] Downloading $vz_template_file file to $meta_dir directory" 2>&1 | tee -a $LOGGFILE
echo ""
wget community.virtual-labs.ac.in/downloads/ubuntu-12.04-custom-x86_64.tar.gz
if [[ $? -ne 0 ]];then	
	echo "[[$DATE:: $0 :: Line $LINENO::]] Error in Downloading $vz_template_file file to $meta_dir directory.." 2>&1 | tee -a $LOGGFILE
fi

#wget -P /etc/yum.repos.d/ http://ftp.openvz.org/openvz.repo
echo "[$DATE:: $0 :: Line $LINENO::]] copying openvz.repo into /etc/yum/repos.d/" 2>&1 | tee -a $LOGGFILE
cp $meta_dir/openvz.repo /etc/yum.repos.d/openvz.repo

echo "[$DATE:: $0 :: Line $LINENO::]] Importing RPM-GPG-Key for openvz.." 2>&1 | tee -a $LOGGFILE
rpm --import http://ftp.openvz.org/RPM-GPG-Key-OpenVZ

echo "[[$DATE:: $0 :: Line $LINENO::]] Installing the OpenVZ kernel.." 2>&1 | tee -a $LOGGFILE
yum -y install vzkernel
if [[ $? -ne 0 ]];then	
	echo "[[$DATE:: $0 :: Line $LINENO::]] Error in Installing the OpenVZ kernel...." 2>&1 | tee -a $LOGGFILE
	exit 1
fi

echo "[[$DATE:: $0 :: Line $LINENO::]] Configuring OpenVZ.." 2>&1 | tee -a $LOGGFILE
cat $meta_dir/updated_sysctl.conf >> /etc/sysctl.conf
echo "SELINUX=disabled" > /etc/sysconfig/selinux
echo "[[$DATE:: $0 :: Line $LINENO::]] Disabled SELINUX.." 2>&1 | tee -a $LOGGFILE

echo "[[$DATE:: $0 :: Line $LINENO::]] Installing OpenVZ tools.." 2>&1 | tee -a $LOGGFILE
yum -y install vzctl vzquota ploop vzstats
if [[ $? -ne 0 ]];then	
	echo "[[$DATE:: $0 :: Line $LINENO::]] Error in Installing the OpenVZ tools...." 2>&1 | tee -a $LOGGFILE
	exit 1
fi

if [[ ! -f $meta_dir/$vz_template_file ]]; then
  echo ""
  echo "[[$DATE:: $0 :: Line $LINENO::]] VZ OS template file not found!" 2>&1 | tee -a $LOGGFILE
  echo "Please obtain an VZ OS template image and manually"
  echo "copy that into /vz/template/cache folder."
  echo "Failing the above step will result in OVPL not working."
  echo "Please contact VLEAD for further clarifications."
else

  echo "[[$DATE:: $0 :: Line $LINENO::]] Copying the default OS template for containers....." 2>&1 | tee -a $LOGGFILE
  cp $meta_dir/$vz_template_file /vz/template/cache
fi

# Not needed!? Not sure.
echo "[[$DATE:: $0 :: Line $LINENO::]] Allowing multiple subnets to reside on the same network interface.." 2>&1 | tee -a $LOGGFILE
sed -i 's/#NEIGHBOUR_DEVS=all/NEIGHBOUR_DEVS=all/g' /etc/vz/vz.conf
sed -i 's/#NEIGHBOUR_DEVS=detect/NEIGHBOUR_DEVS=all/g' /etc/vz/vz.conf

echo "[[$DATE:: $0 :: Line $LINENO::]] Setting container layout to default to ploop (VM in a file).." 2>&1 | tee -a $LOGGFILE
sed -i 's/VE_LAYOUT=simfs/VE_LAYOUT=ploop/g' /etc/vz/vz.conf

echo "[[$DATE:: $0 :: Line $LINENO::]] Setting Ubuntu 12.04 64bit to be the default template.." 2>&1 | tee -a $LOGGFILE
sed -i 's/centos-6-x86/ubuntu-12.04-x86_64/g' /etc/vz/vz.conf
#
#sysctl -p
#
#echo "Disabling iptables.."
#/etc/init.d/iptables stop && chkconfig iptables off
echo "[[$DATE:: $0 :: Line $LINENO::]] Setting iptables" 2>&1 | tee -a $LOGGFILE
iptables -F FORWARD
echo "[[$DATE:: $0 :: Line $LINENO::]] Saving iptables" 2>&1 | tee -a $LOGGFILE
service iptables save
echo "[[$DATE:: $0 :: Line $LINENO::]] Finished installing OpenVZ" 2>&1 | tee -a $LOGGFILE

exit 0
