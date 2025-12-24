#!/bin/bash

if [[ $CI_BRANCH == release* ]] 
then
  export ENVIRONMENT="production-environment"
  export APPLICATION_NAME="release-27"
else
  export ENVIRONMENT="Staging-27-env"
  export APPLICATION_NAME="staging-27"
fi