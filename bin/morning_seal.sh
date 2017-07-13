#!/bin/bash

teams=(
  benchmarking
  content-tools
  navigation
  taxonomy
  email
  hold-gov-to-account
  search-team
  govuk-infrastructure
  servicemanual
  publishing-frontend
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
