#!/bin/sh

echo "What's your region"
read Region
while :
do
aws ec2 describe-instances --query 'Reservations[].Instances[].{InstanceId: InstanceId,State: State.Name,Name: Tags[?Key==`Name`]|[0].Value}' --region $Region --output table
echo -e "1.Enter space separated instanceids\n2.-1 to exit\n3.0 to main menu" 
read InstanceId
if [[ $InstanceId == "0" ]]
then
bash main.sh
elif [[ $InstanceId == "-1" ]]
 then
    break
fi

for i in $InstanceId
do
var=$(aws ec2 describe-instances --instance-ids $i --query 'Reservations[].Instances[].[State.Name]' --output text)
if [[ $var == "running" ]]
then
echo "Stopping"
aws ec2 stop-instances --instance-ids $i > /dev/null
elif [[ $var == "stopped" ]]
then
echo "Starting"
aws ec2 start-instances --instance-ids $i > /dev/null
else
echo "its in pending state"
fi
done
done

