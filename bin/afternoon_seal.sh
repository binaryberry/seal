#!/bin/bash

teams=(core-formats
       publishing-platform
       govuk-infrastructure)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
