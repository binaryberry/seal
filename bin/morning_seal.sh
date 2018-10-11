#!/bin/bash

teams=(
  design-system-dev
  govuk-data-informed
  govuk-finding-brexit
  govuk-licensing
  govuk-platform-health
  govuk-pub-workflow
  govuk-content-pages
  re-infra-internal
  re-observe
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
