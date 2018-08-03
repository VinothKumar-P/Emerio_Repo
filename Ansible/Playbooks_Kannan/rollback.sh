#!/bin/bash

# Consildate the rpms list ###########

BASEDIR=/usr/local/packages
RELEASE_NAME=$1
if [ -z $1 ];
then
	echo "RELEASE_NAME is empty"
        exit 1
fi
rm -f  $BASEDIR/$RELEASE_NAME.rollback
for i in `ls  $BASEDIR/$RELEASE_NAME*`
do
	cat $i >> $BASEDIR/rollback.$RELEASE_NAME
done

#cat $BASEDIR/$RELEASE_NAME.rollback | tr "\n" " " > $BASEDIR/$RELEASE_NAME.rollback1
cat $BASEDIR/rollback.$RELEASE_NAME
