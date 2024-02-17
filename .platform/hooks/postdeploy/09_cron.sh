#!/usr/bin/env bash
set -xe

EB_DEPLOY_DIR=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppDeployDir)

cd $EB_DEPLOY_DIR
su -c "bundle exec whenever --update-cron"
su -c "crontab -l"