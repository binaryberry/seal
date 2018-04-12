#!/bin/bash

teams=(
  data-gov-uk
  data-informed-content
  govuk-design-system
  platform-health
  porg-pages
  reliability-engineering
  taxonomy-and-navigation
  gov-uk-licensing-support
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
