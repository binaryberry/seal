#!/bin/bash

teams=(
  design-system-dev
  digitalmarketplace
  govuk-cookies
  govuk-data-informed
  govuk-euexit-ready
  govuk-searchandnav
  govuk-licensing
  govuk-pay
  govuk-platform-health
  govuk-pub-workflow
  govuk-search-perf
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
