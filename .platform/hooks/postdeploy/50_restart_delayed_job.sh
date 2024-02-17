#!/usr/bin/env bash
EB_APP_CURRENT_DIR=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppDeployDir)

cd $EB_APP_CURRENT_DIR

sudo chmod 0666 log/delayed_job.log
bin/delayed_job --pid-dir=/var/app/containerfiles/pids restart
