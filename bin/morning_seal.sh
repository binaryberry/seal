#!/bin/bash

teams=(
  content-tools
  email
  frontend-design
  govuk-design-system
  govuk-easier-finding
  govuk-madetech
  modelling-services
  platform_support
  publishing-frontend
  reliability-engineering
  taxonomy
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
