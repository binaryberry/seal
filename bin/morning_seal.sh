#!/bin/bash

teams=(
  development
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
