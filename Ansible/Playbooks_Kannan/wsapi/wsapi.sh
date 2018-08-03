#!/bin/bash
WSAPIPKGSLIST=/usr/local/ansible/playbooks/wsapi/wsapi_pkg_list
#TEMPFILE=/usr/local/ansible/playbooks/temp1.yml

if [ -z "$RELEASE_NAME" ]
then
        export RELEASE_NAME="TEST"
fi

for RPM in `echo $DEPLOY_PKG`
do
	REMOVE=`echo $RPM | awk -F"-" {'print $1"-"$2'}`
	grep $REMOVE $WSAPIPKGSLIST >> /dev/null;
	if [ $? -eq 0 ]
	then
		WSAPI_RPMS_ADD="$RPM $WSAPI_RPMS_ADD"
		WSAPI_RPMS_REMOVE="$REMOVE $WSAPI_RPMS_REMOVE"
		DEPLOY_PKGS=`echo $DEPLOY_PKG | sed "s/$RPM//"`
		#echo $DEPLOY_PKGS
		DEPLOY_PKG=$DEPLOY_PKGS
		DEPLOY_PKGS=""
		######Remove that RPM from the $DEPLOY_PKG ##########
	fi
done
#export DEPLOY_PKG
#echo $DEPLOY_PKG

WSAPI_RPMS_ADD_COUNT=`echo $WSAPI_RPMS_ADD | wc -w`
if [ $WSAPI_RPMS_ADD_COUNT -eq 0 ]
then
	echo "No WSAPI RPMS" 
	exit
fi
PKG_INSTALL=$(/usr/local/ansible/playbooks/wsapi/tolist.sh $WSAPI_RPMS_ADD)
PKG_REMOVE=$(/usr/local/ansible/playbooks/wsapi/tolist.sh $WSAPI_RPMS_REMOVE)
cd /usr/local/ansible/playbooks/
ansible-playbook /usr/local/ansible/playbooks/sites.yml --extra-var="host=$stack.wsapi pkg_install=$PKG_INSTALL role=wsapi pkg_remove=$PKG_REMOVE rpms_uninstall='$WSAPI_RPMS_REMOVE'  releasename=$RELEASE_NAME" 

export DEPLOY_PKG;
#echo $WSAPI_RPMS_ADD;
#echo -e "---------------------"
#echo $WSAPI_RPMS_REMOVE;
#echo -e "---------------------"
#echo $DEPLOY_PKG

############## Convert to YAML list ############

#/usr/local/ansible/playbooks/wsapi/tolist.sh $WSAPI_RPMS_ADD
#/usr/local/ansible/playbooks/wsapi/tolist.sh $WSAPI_RPMS_REMOVE
