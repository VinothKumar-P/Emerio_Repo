#!/bin/bash
TOMEEPKGSLIST=/usr/local/ansible/playbooks/tomee/tomee_pkg_list
DEPLOY_PKGS=""
if [ -z "$RELEASE_NAME" ]
then
	export RELEASE_NAME="TEST"
fi

for RPM in `echo $DEPLOY_PKG`
do
	REMOVE=`echo $RPM | awk -F"-" {'print $1"-"$2'}`
	grep -w $REMOVE $TOMEEPKGSLIST >> /dev/null;
	if [ $? -eq 0 ]
	then
		TOMEE_RPMS_ADD="$RPM $TOMEE_RPMS_ADD"
		TOMEE_RPMS_REMOVE="$REMOVE $TOMEE_RPMS_REMOVE"
		DEPLOY_PKGS=`echo $DEPLOY_PKG | sed "s/$RPM//"`
		DEPLOY_PKG=$DEPLOY_PKGS
		DEPLOY_PKGS=""
	fi
done

TOMEE_RPMS_ADD_COUNT=`echo $TOMEE_RPMS_ADD | wc -w`
if [ $TOMEE_RPMS_ADD_COUNT -eq 0 ]
then
	echo "No TOMEE RPMS" 
	exit
fi
PKG_INSTALL=$(/usr/local/ansible/playbooks/tomee/tolist.sh $TOMEE_RPMS_ADD)
PKG_REMOVE=$(/usr/local/ansible/playbooks/tomee/tolist.sh $TOMEE_RPMS_REMOVE)


cd /usr/local/ansible/playbooks/
ansible-playbook /usr/local/ansible/playbooks/sites.yml --extra-var="host=$stack.tomee pkg_install=$PKG_INSTALL role=tomee pkg_remove=$PKG_REMOVE rpms_uninstall='$TOMEE_RPMS_REMOVE' releasename=$RELEASE_NAME"

export DEPLOY_PKG;
