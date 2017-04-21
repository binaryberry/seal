#!/bin/bash

teams=(
  benchmarking
  content-tools
  navigation
  taxonomy
  email
  hold-gov-to-account
  search
  govuk-infrastructure
  servicemanual
  templateconsolidation
  worldwide-publishing
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
