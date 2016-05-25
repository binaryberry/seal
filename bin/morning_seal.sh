#!/bin/bash

teams=(core-formats
       publishing-platform
       specialist-publisher
       finding-things
       custom
       govuk-infrastructure
       servicemanual)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
