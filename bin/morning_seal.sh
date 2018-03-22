#!/bin/bash

teams=(
  data-informed-content
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
  gov-uk-licensing-support
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
