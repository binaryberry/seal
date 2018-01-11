#!/bin/bash

teams=(
  content-tools
  email
  frontend-design
  govuk-madetech
  modelling-services
  navigation
  publishing-frontend
  reliability-engineering
  search-team
  servicemanual
  taxonomy
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
