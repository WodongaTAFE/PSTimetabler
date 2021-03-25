# PSTimetabler
PowerShell Module for Celcat Timetabler (https://www.celcat.com/software/timetabler-8)

This module contains some helpful cmdlets for managing your Celcat Timetabler databases.

## Installing

The module can be installed from the [PowerShell Gallery](https://www.powershellgallery.com/packages/Timetabler/) from an elevated prompt using this command:

    Install-Module Timetabler

## Connect to the Timetabler API

The first thing you'll need to do is connect to the Celcat Timetabler API. We do this with Connect-CT, supplying a URL, your API code, and (optionally) a timetable ID:

    Connect-CT 'https://celcatapi.example.com' -ApiCode 'myApiCode' -TimetableId 1

Note that TimetableId should be specified if you have more than one timetable registered with your API. Otherwise only the Get-CTTimetable function will work.

## Disconnecting

To ensure the API code is not preserved in your session, you can disconnect from the Timetabler API using this command:

    Disconnect-CT

Note that no network connections are maintained that need to be cleaned up with this command. It's only used to clear the locally cached URI and token.