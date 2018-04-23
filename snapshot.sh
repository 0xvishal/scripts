#!/bin/bash
aws ec2 describe-tags --query "Tags[*].{Name:Value,ResourceId:ResourceId}" --filters "Name=key,Values=Name"  --filters "Name=resource-type,Values=volume" --output text > /tmp/snapshot
while read -r line; do
   value1=$(echo "$line"| awk -F" "  '{print $1}')
   value2=$(echo "$line"| awk -F" "  '{print $2}')
   #sed -i "s/$value1/$value2/g" circos.conf 
echo $value2
aws ec2 create-snapshot --volume-id $value2 --description "name:"$value1"  id:"$value2
done < /tmp/snapshot