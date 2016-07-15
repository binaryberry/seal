# Angry Seal

##What is it?

A Bot that nags a team on slack about Pull Requests needing attention. It's quieter than the github sack notifications, giving only one nag a day. It is a fork of

[AngrySeal](https://github.com/binaryberry/seal)

and is set to run on TC on a daily basis. To add your team simply push a new version config\grabcad.yml, the member names are case sensitive, but beyond that no magic


    lighthouse:
      members:
        - adigrabcad
        - atardugno
        - bitosome
        - DanielDignam
        - robert-may1
        - zhelezina
    
      channel:
        "#lighthouse"


This will cause the ligthhouse channel to get a nag of Pull Requests created by the specified members of the team. The notification is currently 
sent by a job that runs on TeamCity on a daily basis at 7:00 UTC. This means the developers get to see the nag when they get in. The job is run by this TC build configuration

[TeamCityAngrySeal](https://teamcity.grabcad.net/viewType.html?buildTypeId=PrintServiceProjects_CiHelpers_LighthouseAngrySeal)