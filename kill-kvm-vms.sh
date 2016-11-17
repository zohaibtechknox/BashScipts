#!/bin/bash -x

#if the vms are running
RUNNING_LIST=`virsh list |grep running| awk -F ' ' '{print $2}'`
read -a arr <<<$RUNNING_LIST
for i in ${arr[@]};
do
virsh shutdown $i
PIDNO=`ps ax | grep $i | grep kvm | cut -c 1-6 | head -n1`
#echo $PIDNO
sudo kill -9 $PIDNO

done
