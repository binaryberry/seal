# Seal
[![Build Status](https://travis-ci.org/binaryberry/seal.svg)](https://travis-ci.org/binaryberry/seal)

## What is it?

This is a Slack bot that publishes a team's pull requests to their Slack Channel, once provided the organisation name and the team members' github names. It is my first 20% project at GDS.

![image](https://github.com/binaryberry/seal/blob/master/images/readme/informative.png)
![image](https://github.com/binaryberry/seal/blob/master/images/readme/angry.png)

## How to use it?

### Config
Fork the repo and add/change the config files that relate to your github organisation. For example, the alphagov config file is located at [config/alphagov.yml](config/alphagov.yml) and the config for scheduled daily visits can be found in [bin](bin)

Include your team's name, the Github names of your team members, and the Slack channel you want to post to.

In your shell profile, put in:

```sh
export SEAL_ORGANISATION="your_github_organisation"
export GITHUB_TOKEN="get_your_github_token_from_yourgithub_settings"
export SLACK_WEBHOOK="get_your_incoming_webhook_link_for_your_slack_group_channel"
export GITHUB_API_ENDPOINT="your_github_api_endpoint" # OPTIONAL If you are using a Github Enterprise instance
```

### Env variables

Another option, which is 12-factor-app ready is to use ENV variables for basically everything.
In that case you don't need a config file at all.

Divider is ',' (comma) symbol.

In your shell profile, put in:

```sh
export SEAL_ORGANISATION="your_github_organisation"
export GITHUB_TOKEN="get_your_github_token_from_yourgithub_settings"
export GITHUB_API_ENDPOINT="your_github_api_endpoint" # OPTIONAL If you are using a Github Enterprise instance
export SLACK_WEBHOOK="get_your_incoming_webhook_link_for_your_slack_group_channel"
export SLACK_CHANNEL="#whatever-channel-you-prefer"
export GITHUB_MEMBERS="netflash,binaryberry,otheruser"
export GITHUB_USE_LABELS=true
export GITHUB_EXCLUDE_LABELS="[DO NOT MERGE],Don't merge,DO NOT MERGE,Waiting on factcheck,wip"
export GITHUB_EXCLUDE_REPOS="notmyproject,someotherproject" # Ensure these projects are *NOT* included
export GITHUB_INCLUDE_REPOS="definitelymyproject,forsuremyproject" # Ensure *only* these projects will be included
export SEAL_QUOTES="Everyone should have the opportunity to learn. Don’t be afraid to pick up stories on things you don’t understand and ask for help with them.,Try to pair when possible."
```

- To get a new `GITHUB_TOKEN`, head to: https://github.com/settings/tokens
- To get a new `SLACK_WEBHOOK`, head to: https://slack.com/services/new/incoming-webhook

### Bash scripts
In your forked repo, include your team names in the appropriate bash script. Ex. `bin/morning_seal.sh`

### Local testing

To test the script locally, go to Slack and create a channel or private group called "#angry-seal-bot-test" (the Slack webhook you set up should have its channel set to "#angry-seal-bot-test" in the Integration Settings). Then run `./bin/seal.rb your_team_name` in your command line, and you should see the post in the #angry-seal-bot-test channel.

If you don't want to post github pull requests but a random quote from your team's quotes config, run `./bin/seal.rb your_team_name quotes`

### Slack configuration

You should also set up the following custom emojis in Slack:
- :informative_seal:
- :angrier_seal:
- :seal_of_approval:
- :happyseal:
- :halloween_informative_seal:
- :halloween_angrier_seal:
- :halloween_seal_of_approval:
- :festive_season_informative_seal:
- :festive_season_angrier_seal:
- :festive_season_seal_of_approval:
- :manatea:

You can use the images in images/emojis that have the corresponding names.

When that works, you can push the app to Heroku and add the GITHUB_TOKEN and SLACK_WEBHOOK environment variables to heroku.

Use the Heroku scheduler add-on to create repeated tasks - I set the seal to run at 9.30am every morning (the seal won't post on weekends). The scheduler is at [https://scheduler.heroku.com/dashboard](https://scheduler.heroku.com/dashboard) and the command to run is `bin/seal.rb your_team_name`

Any questions feel free to contact me on Twitter -  my handle is binaryberry

## Deploy to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## How to run the tests?
Just run `rspec` in the command line

## Docker container

You can build your own docker container, Dockerfile is provided.

```sh
docker build -t seal .
```

And then run it (assuming you already set all the env variables)

```sh
#!/bin/bash
docker run -it --rm --name seal \
  -e "SEAL_ORGANISATION=${SEAL_ORGANISATION}" \
  -e GITHUB_TOKEN=${GITHUB_TOKEN} \
  -e GITHUB_API_ENDPOINT=${GITHUB_API_ENDPOINT} \
  -e SLACK_WEBHOOK=${SLACK_WEBHOOK} \
  -e DYNO=${DYNO} \
  -e SLACK_CHANNEL=${SLACK_CHANNEL} \
  -e GITHUB_MEMBERS=${GITHUB_MEMBERS} \
  -e GITHUB_USE_LABELS=${GITHUB_USE_LABELS} \
  -e "GITHUB_EXCLUDE_LABELS=${GITHUB_EXCLUDE_LABELS}" \
  -e "SEAL_QUOTES=${SEAL_QUOTES}" \
  seal
```

## Diary of how this app was built

10th April:
- Finalised what the app does:
    - Checks if any pull requests are over 2 days old (angry seal)
    - at 9.45am prepares an overview of all pull requests that need reviewing (informative seal)
    - when a team member posts a new pull request, publishes it on slack (notification seal) (this feature was then abandoned, as I thought it's best for this not to be automated, it's more motivating when real people ask for a review, not a bot)

- Researched what technologies and gems I could use and what the app structure would be like
- Started the Rails app

17th April:
- researched github_api

24th April:
- got github_api working, first test with dummy data passing

1st of May
- got github_listener to take into account organisations

8th of May:
- tried stubbing Github API

15th of May:
- Github listener can now return the list of repos of an organisation
- further attempts to stub GithubAPI using these methods: https://robots.thoughtbot.com/how-to-stub-external-services-in-tests.

21st of May:
- Building Sinatra app for stubbing
- Attempts to filter the 3,400 repo list by date the repo was modified - tests (and app) are still very slow

28th of May:
- Due to new team structure that assigns a list of repos to each team, decided the manually enter the list of repos that belong to a team instead of scanning through all of them. That should sort the speed problem, the stubbing problem, a lot of things.
- moved to a non-Rails app to make it lighter
- got Github to list repos; works for my personal pull requests, but doesn't work with the GOV.UK stuff yet, need to figure out why

5th of June:
- Github fetcher class now works with organisations, hence GOV.UK stuff

11th of June:
- Stubbed Github API

12th of June:
- Github Fetcher now also returns the link to the pull request
- Started Slackbot poster class, it can post to Slack
- Started Message builder class, not finished

13th of June:
- finished Slackbot poster class
- finished Message builder class
- added name of repo to info sent by GithubFetcher
- added options to the Slackbot poster class so each post comes from informative seal
- Works locally in test room. YEAY!

17th of June:
- refactoring of Github fetcher
- pushed to Heroku

18th of June:
- started Heroku scheduler and launched on core-formats team room!

22nd of June
- Ensure Angry seal doesn't get triggered at the weekend

26th of June:
- launched on finding-stuff team
- investigated adding comments

3rd of July:
- launched on custom team
- added comments
- investigating angry seal - stuck by a strange syntax error line 34 when trying to run the script

10th of July
- Extracted config information to yaml files
- fixed informative seal - mood_hash was causing issues

17th of July
- Angry Seal!

21st of July
- fix API stubbing

22nd of July
- Add age of pull requests

24th of July
- Optionally display labels for a pull request, if they exist (`use_labels` config option)
- Optionally hide pull requests with certain labels (`exclude_labels` config
  list)
- Optionally hide pull requests with certain phrases in the title
  (`exclude_titles` config list)

19th of August
- Seal will bark at all teams in the config if no team is specified as an
  argument to `./bin/{angry,informative}_seal.rb`, making Heroku scheduling
  easier.

4th of September
- Seal now displays thumbs up when present in comments
- Angry seal now looks angrier

13th of September
- Seal now has only one script to be triggered - will start either the angry seal, the informative seal or the seal of approval each day.

6th of January
- Seal can now post random quotes from the team's list of quotes in the config. Can be used as a reminder or for inspirational quotes!

## Tips

How to list your organisation's repositories modified within the last year:

In `irb`, from the folder of the project, run:

```ruby
require 'octokit'
github = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'], auto_pagination: true)
response = github.repos(org: ENV['SEAL_ORGANISATION'])
repo_names = response.select { |repo| Date.parse(repo.updated_at.to_s) > (Date.today - 365) }.map(&:name)
```

## CRC

Github fetcher:
- queries Github's API

Message Builder:
- produces message from Github API's content

Slack Poster:
- posts message to Slack

Trello board: https://trello.com/b/sgakJmlY/moody-seal

## License

See the [LICENSE](LICENSE) file for license rights and limitations (MIT).
