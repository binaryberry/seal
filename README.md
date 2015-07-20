# README

##What is it?

This is a Slack bot that publishes a team's pull requests to their Slack Channel, once provided the organisation name, the team members' github names, and a list of repos to follow. It is my first 20% project at GDS. 

![image](https://github.com/binaryberry/seal/blob/master/images/informative.png)
![image](https://github.com/binaryberry/seal/blob/master/images/angry.png)

##How to use it?
Fork the repo, and change the config file to put: your team's name, the github names of your team members, the list of repos to follow, and the Slack channel you want to post to.

In your shell profile, put in:
```
export SEAL_ORGANISATION="your_github_organisation"
export GITHUB_TOKEN="get_your_github_token_from_yourgithub_settings"
export SLACK_WEBHOOK="get_your_incoming_webhook_link_for_your_slack_group_channel"
```
To test the script locally, go to Slack and create a channel or private group called "#angry-seal-bot-test". Then run `./bin/informative_seal.rb your_team_name` in your command line, and you should see the post in the #angry-seal-bot-test channel.

When that works, you can push the app to Heroku, add the GITHUB_TOKEN and SLACK_WEBHOOK environment variables to heroku, and use the Heroku scheduler add-on to create repeated rasks - I set Informative Seal to run at 9.30am every morning (the seal won't post on weekends), and will set Angry Seal to run every afternoon.

Any questions feel free to contact me on Twitter -  my handle is binaryberry

##How to run the tests?
Just run `rspec` in the command line

## Diary of how this app was built

10th April:
- Finalised what the app does:
    - Hourly, checks if any pull requests are over 6 hours old (angry seal)
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

To be done:
- ensure Angry seal doesn't get triggered at the weekend
- fix API stubbing
- do not display [DO NOT MERGE] pull requests?

Potential additional features:
- angry seal post when PRs forgotten about
- add age of pull requests

How to find out list of alphagov repos modified within the last year:
In irb, from the folder of the project, run:
```
require "./lib/github_fetcher.rb"
@github = Github.new oauth_token: ENV['GITHUB_TOKEN'], auto_pagination: true
response = @github.repos.list org:"alphagov"
array = []
repos_response.each do |repo|
date = repo.updated_at
array << repo.name if Date.parse(date) > Date.new(2015,5,5)
end
array
```
`array` returns the value of the repos modified since the 5th of May.
## CRC

Github fetcher:
- queries Github's API

Message Builder:
- produces message from Github API's content

Slack Poster:
- posts message to Slack

Trello board: https://trello.com/b/sgakJmlY/moody-seal
