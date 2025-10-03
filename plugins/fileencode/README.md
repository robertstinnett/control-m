# Control-M File Encoding Conversion Job Type

## Changes on this version

| Date | Who | What | Contact |
| - | - | - | - |
| 2025-09-30 | Robert Stinnett | Initial Release | robert@robertstinnett.com |
## Detailed Description

This Control-M Application Integrator job type enables the automation of character code (page code) conversion of text based files on Linux/Unix systems.  This allows you to convert from one character type encoding (such as UTF-8 w/ BOM) to another such as (ANSI Windows-1252).  This can often be useful when platforms or systems you are interacting with require specific encoding of files for processing.

The job uses the Linux command *iconv* for processing.  Therefore it must run on a Linux platform with that package installed.


The available actions are:

    Convert
        Delete Original Upon Conversion Success
        Omit Invalid Characters When Converting

## Fields and available actions

### Connection Profile

    Run As User: <username>
    Password: <password>
    

### File Encoding Job Form

#### Parameters

    Convert From <File Encoding Type> - Note this is a dynamic list and will pull all available types from the iconv command.
    Convert To <File Encoding Type> - Note this is a dynamic list and will pull all available types from the iconv command.
    Input File - Complete path and name of file
    Output File - Complete path and name of file
    Delete Original - Should original file be deleted if conversion finishes successfully?
    Omit Invalid Characters - If a character is not supported in convert to file encoding format, should it be dropped?
    

## Additional Information

Please, feel free to modify and contribute!  The more we share, the more we all learn.

## Requirements

    Control-M/Agent with Control-M Application Integrator plug-in installed, running on Unix/Linux, version 9.0.20 or higher.

## Platforms and versions

The job was created and tested with the following platforms and versions:

    Control-M/EM and Control-M/Server 9.0.22.035, running on Linux.
