#!/bin/bash

teams=(content-tools
       core-formats
       publishing-platform
       specialist-publisher
       finding-things
       email
       custom
       govuk-infrastructure
       mainstream-pop-up
       servicemanual)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
