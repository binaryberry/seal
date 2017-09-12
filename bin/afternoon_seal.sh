#!/bin/bash

teams=(
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
