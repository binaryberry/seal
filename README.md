# Angry Seal

[![Build Status](https://teamcity.grabcad.net/viewType.html?buildTypeId=PrintServiceProjects_CiHelpers_LighthouseAngrySeal)](https://teamcity.grabcad.net/app/rest/builds/buildType:(id:PrintServiceProjects_CiHelpers_LighthouseAngrySeal)/statusIcon)

##What is it?

This is a fork of

https://github.com/binaryberry/seal

and is set to run on TC on a daily basis.To add your team simply clone and edit config\grabcad.yml, the member names are case sensitive, but beyond that no magic


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


This will cause the ligthhouse channel to get a nag of Pull Requests created by the specified members of the team. The notification is currently sent by a job that runs on TeamCity on a daily basis at 7:00 UTC. This means the developers get to see the nag when they get in.

https://teamcity.grabcad.net/viewType.html?buildTypeId=PrintServiceProjects_CiHelpers_LighthouseAngrySeal