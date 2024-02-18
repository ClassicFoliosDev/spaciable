#!/usr/bin/env bash
EB_APP_CURRENT_DIR=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppDeployDir)

cd $EB_APP_CURRENT_DIR

sudo chmod 0666 log/delayed_job.log

trap 'kill $(jobs -p)' EXIT; until bin/delayed_job --pid-dir=/var/app/containerfiles/pids restart & wait; do
    echo "delayed_job crashed with exit code $?. Respawning.." >&2
    sleep 1
done
