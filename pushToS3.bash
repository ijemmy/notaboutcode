#/bin/bash

rm -rf public
hugo
aws s3 cp ./public s3://www.notaboutcode.com/ --recursive

