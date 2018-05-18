#!/bin/bash

teams=(
  govuk-datagovuk-tech
  govuk-data-informed
  design-system-dev
  govuk-platform-health
  govuk-porg-pages
  re-infra-internal
  govuk-tax-and-nav
  govuk-licensing
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
