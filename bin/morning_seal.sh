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
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
