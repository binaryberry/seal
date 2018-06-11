#!/bin/bash

teams=(
  design-system-dev
  govuk-data-informed
  govuk-datagovuk-tech
  govuk-licensing
  govuk-platform-health
  govuk-porg-pages
  govuk-tax-and-nav
  re-infra-internal
  re-tools-internal
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
