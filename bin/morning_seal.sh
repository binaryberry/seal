#!/bin/bash

teams=(
  design-system-dev
  digitalmarketplace
  govuk-data-informed
  govuk-euexit-ready
  govuk-finding-brexit
  govuk-licensing
  govuk-platform-health
  govuk-pub-workflow
  govuk-content-pages
  re-infra-internal
  govuk-pay
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
