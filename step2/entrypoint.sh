#!/bin/bash

cd /root

echo container start!!

while [ -f message.txt ]; do
  echo $MESSAGE_PREFIX $(cat message.txt)
  sleep 1
done

echo container done!!
