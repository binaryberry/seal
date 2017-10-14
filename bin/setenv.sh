#!/usr/bin/env bash -l
set -e

echo "==> Setting up"
ruby_version=`cat .ruby-version`
ruby_gemset=`cat .ruby-gemset`
rvm install $ruby_version
rvm use $ruby_version@$ruby_gemset --create
bundler_version=`ruby -e 'puts $<.read[/BUNDLED WITH\n   (\S+)$/, 1] || "<1.10"' Gemfile.lock`
gem install bundler --conservative --no-document -v $bundler_version

echo "==> Bundling"
bundle check || bundle install
echo "==> Bundle complete"
echo "==> Ready to go"
