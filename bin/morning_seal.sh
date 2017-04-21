#!/bin/bash

teams=(
  benchmarking
  content-tools
  navigation
  taxonomy
  email
  search
  govuk-infrastructure
  servicemanual
  templateconsolidation
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
