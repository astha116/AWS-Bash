echo -e "Enter Service Name \n1.EC2\n2.RDS"
read Service
if [[ $Service == EC2 || $Service == ec2 ]]
then
bash aws.sh
else 
bash rds.sh
fi
