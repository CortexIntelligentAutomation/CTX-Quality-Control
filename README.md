<a href="https://www.cortex-ia.co.uk/" target="_blank"><img src="https://github.com/CortexIATest/CTXImages/blob/master/Cortex-350-120.png" alt="Welcome to Cortex!" width="350" height="120" border="0"></a>

# CTX-Quality-Control Cortex Module
Cortex Flows to assess flow and subtask quality according to best practices

The module allows users to perform the following functionality:
* View flow/subtask quality for a group via LivePortal
* Generate a flow/subtask quality report in Excel

## Table of Contents
1) [Dependencies](#dependencies)
    * [Cortex Version](#cortex-version)
    * [OCIs](#ocis)
    * [Files](#files)
    * [Other](#other)
2) [Installation](#installation)
3) [How to use](#how-to-use)
4) [How you can contribute](#how-you-can-contribute)
5) [Versioning](#versioning)
6) [Licensing](#licensing)


## Dependencies
### Cortex Version
This version of the CTX-Quality-Control module was developed in Cortex version 6.5. Some functionality may not be available on different versions of Cortex.

### OCIs
The  module requires the following Cortex OCIs:
* Database
* Powershell

### Files
The CTX-Quality-Control module requires the following files:
* [CTX-Quality-Control.studiopkg](https://github.com/CortexIntelligentAutomation/CTX-Quality-Control/releases/download/v1.0/CTX-Quality-Control.studiopkg)
* [FlowChecks.psm1](https://github.com/CortexIntelligentAutomation/CTX-Quality-Control/releases/download/v1.0/QC/FlowChecks.psm1)
* [FlowTree.psm1](https://github.com/CortexIntelligentAutomation/CTX-Quality-Control/releases/download/v1.0/QC/FlowTree.psm1)

### Other
The CTX-Quality-Control module has the following additional requirements which are explained in detail in the [Installation section](#Installation):
* PowerShell v5 to be installed on the application server
* ImportExcel PowerShell module installed

## Installation
Details of the installation can be found in the [CTX-Quality-Control Deployment Plan](https://github.com/CortexIntelligentAutomation/CTX-Quality-Control/blob/master/CTX-Quality-Control%20-%20Deployment%20Plan.pdf).
## How to use
A detailed User Guide has been provided with instructions on how to use the flows/subtasks, available [here](https://github.com/CortexIntelligentAutomation/CTX-Quality-Control/blob/master/CTX-Quality-Control%20-%20User%20Guide.pdf). Configuration of subtask inputs and outputs are detailed in notes on the subtask workspace.

## How you can contribute
Unfortunately, we cannot offer pull requests at this time or accept any improvements.

## Versioning
CTX-Quality-Control has the following versions, starting with the most recent

Version | Release | Functionality | Notes
------------ | ------------- | ----------- | -----------
v1.0 | 11/10/2019 | View Flow Quality | Created
v1.0 | 11/10/2019 | Create Quality Report | Created

## Licensing
All functionality within this module is licensed under the [Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0).

Copyright 2018 Cortex Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
