#!/bin/sh

echo "What's your region?"
read Region
while :
do
aws rds describe-db-instances --query 'DBInstances[].{Name: DBInstanceIdentifier, State: DBInstanceStatus}' --region $Region --output table
echo -e "1.Enter DB Instance Intentifier \n2.-1 to exit \n3.0 to main menu"
read DbInstanceIdentifier
if [[ $DbInstanceIdentifier == "0" ]]
then
bash main.sh
elif [[ $DbInstanceIdentifier == "-1" ]]
 then
    break
fi
for i in $DbInstanceIdentifier
do
rdsvar=$(aws rds describe-db-instances --db-instance-identifier $i --query 'DBInstances[].[DBInstanceStatus]|[0]' --output text)
if [[ $rdsvar == "available" ]]
then
echo "Stopping"
aws rds stop-db-instance --db-instance-identifier $i > /dev/null
elif [[ $rdsvar == "stopped" ]]
then
echo "Starting"
aws rds start-db-instance --db-instance-identifier $i > /dev/null
else
echo "its in pending state"
fi
done
done