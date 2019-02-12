#!/bin/bash

teams=(
  design-system-dev
  digitalmarketplace
  govuk-content-pages
  govuk-data-informed
  govuk-euexit-ready
  govuk-finding-brexit
  govuk-licensing
  govuk-pay
  govuk-platform-health
  govuk-pub-workflow
  re-autom8
  re-infra-internal
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
