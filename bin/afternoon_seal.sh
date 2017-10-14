#!/bin/bash

: ${SEAL_ORGANISATION:?"must set SEAL_ORGANISATION"}
: ${GITHUB_TOKEN:?"must set GITHUB_TOKEN"}
: ${SLACK_WEBHOOK:?"must set SLACK_WEBHOOK"}

teams=(
  DevOps
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team
done
