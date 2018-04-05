#!/bin/bash

teams=(
  data-informed-content
  frontend-design
  govuk-design-system
  modelling-services
  platform_support
  reliability-engineering
  taxonomy-and-navigation
  gov-uk-licensing-support
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
