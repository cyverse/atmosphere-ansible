# Globus Personal Connect

## Generating and using GPC endpoint and setup-key

1. Generate an endpoint for the client. Generate setup key [here.](https://www.globus.org/app/endpoints/create-gcp)
1. Follow step by step instructions to add key to clint.  Those instructions can be found [here.](https://docs.globus.org/how-to/globus-connect-personal-linux/)

## Overview of process

Atmosphere will “create” a globus connect endpoint name

This endpoint is scoped to the Globus name ... 

(REST call will be how Atmo fetches it) 

there is a Globus Connect client to install ... 

can grab ‘latest’ - it will untar with a version number

setup codes are one-time-use (with a potential lifetime / expiry)

setup is hidden in `$HOME/.globusonline/lta`

```
./globusconnect -start & 
```

then you can see the endpoints within GLOBUS website

demo’d the steps in the How-to linked above ... 

moved onto Transfer API: <https://docs.globus.org/api/transfer/>

Getting a Globus token that will be scoped to Transfer API - this isn’t in the permissions step

we currently have ... 

any REST client will do, but they have a Python one:

<https://github.com/globusonline/transfer-api-client-python>

Lee Liming also suggested that a Globus Personal Connect Endpoint for the installed

GlobusConnect (name) be visible in the Instance Detail View under “Links” (like Web Shell,

Remote Desktop, etc).

An endpoint per instance! One-to-one association. 

this assumes that an instance can have some metadata associated with it about the “GC

Endpoint"

Endpoints may be perishable (expire at some point) 

<https://docs.globus.org/how-to/globus-connect-personal-cli/>

Some implications on Jetstream needing to do Globus Connect cleanup before destroying

the instance....

BUT! You could “cleanup” the endpoint after the fact with the Globus token. 

All the How-tos:

<https://docs.globus.org/how-to/>