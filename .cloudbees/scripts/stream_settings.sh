#!/bin/bash

dt=$(date +'%Y%m%d%H%M%S')

if [[ $CI_BRANCH == release* ]] 
then
  export ENVIRONMENT="production-environment"
  export ZIPFILE="CB_master_$dt.zip"
  export APPLICATION_NAME="release-27"
else
  export ENVIRONMENT="Staging-27-env"
  export ZIPFILE="CB_staging_$dt.zip"
  export APPLICATION_NAME="staging-27"
fi

export ZIPFILE="CB_staging_20251220172604.zip"