#!/bin/bash

teams=(content-tools
       core-formats
       publishing-platform
       govuk-infrastructure)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
