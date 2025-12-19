#!/bin/bash

dt=$(date +'%Y-%m-%d %H:%M')

if [[ $BRANCH == master* ]] 
then
  export ENVIRONMENT="production-environment"
  export ZIP="CB_master_$dt.zip"

else
  export ENVIRONMENT="Staging-27-env"
  export ZIP="CB_staging_$dt.zip"
fi