#!/bin/bash

teams=(
  modelling-services
  content-tools
  navigation
  taxonomy
  email
  content-api
  search-team
  govuk-infrastructure
  servicemanual
  publishing-frontend
  frontend-design
  govuk-madetech
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
