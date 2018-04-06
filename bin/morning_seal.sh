#!/bin/bash

teams=(
  data-informed-content
  govuk-design-system
  platform_support
  porg-pages
  reliability-engineering
  taxonomy-and-navigation
  gov-uk-licensing-support
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
