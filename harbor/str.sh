#!/bin/bash
AcontainsB()
{
if [[ $2 =~ $3 ]]
then
#  echo "包含"
    echo 1
else
#  echo "不包含"
    echo 0
fi
}

$1