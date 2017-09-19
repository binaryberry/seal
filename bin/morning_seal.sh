#!/bin/bash
teams=(
  frontend 
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
