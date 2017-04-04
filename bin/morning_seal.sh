#!/bin/bash

teams=(
  benchmarking
  content-tools
  navigation
  content-transformation
  email
  search
  govuk-infrastructure
  servicemanual
  templateconsolidation
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
