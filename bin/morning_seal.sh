#!/bin/bash

teams=(
  benchmarking
  content-tools
  navigation
  content-transformation
  email
  hold-gov-to-account
  search
  govuk-infrastructure
  servicemanual
  templateconsolidation
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
