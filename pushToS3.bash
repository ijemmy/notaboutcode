#/bin/bash

rm -rf public
hugo

export AWS_PROFILE=notaboutcode
aws s3 cp ./public s3://www.notaboutcode.com/ --recursive
