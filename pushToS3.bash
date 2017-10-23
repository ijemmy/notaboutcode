#/bin/bash

rm -rf public
hugo

export AWS_PROFILE=notaboutcode
aws s3 sync --delete ./public s3://www.notaboutcode.com/ --cache-control max-age=3600
