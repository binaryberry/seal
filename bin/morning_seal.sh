#!/bin/bash

teams=(
  content-api
  content-tools
  email
  frontend-design
  govuk-infrastructure
  govuk-madetech
  modelling-services
  navigation
  publishing-frontend
  search-team
  servicemanual
  taxonomy
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
