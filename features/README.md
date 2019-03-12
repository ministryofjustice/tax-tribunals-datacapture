# Tax Tribunals Full-Stack Smoke Tests

Cucumber tests with the tag: @smoke
These are **NOT** standard cucumber features and should not be treated
as such.  They are a set of simple features used to smoke test the
application stack in various 'real' enviroments. They will not work
locally, nor will they work against the docker-container stack.

**These smoketests create GLiMR and analytics records. They should
generally NOT be run against the production enviroment.**

## Running

Run all Cucumber tests headless:
```
bundle exec cucumber
```

Run all Cucumber smoke tests:
```
bundle exec cucumber --tags @smoke
```

Run all Cucumber tests that run in Firefox:
```
DRIVER=firefox bundle exec cucumber --tags ~@headless
```


### Running on CI

The script for running the Docker container on MoJ's CI is as follows:

```bash
#!/bin/bash

set -euo pipefail

docker build -f Dockerfile.smoketests -t smoketests .
docker run smoketests
```
The default target environment is dev.  You can change this at run
time by overriding the DATACAPTURE_URI environment variable:

```bash
#!/bin/bash

set -euo pipefail

docker build -f Dockerfile.smoketests -t smoketests .
docker run -e "DATACAPTURE_URI=https://tax-tribunals-datacapture-staging.dsd.io" smoketests
```

### Containerisation Rationale/Why not docker-compose?

This is being run from a container because there were difficulties
getting PhantomJS installed (and kept up-to-date) on Jenkins.
Containeriseing the dependencies seemed like the most efficient
maintenance strategy.

At the time the smoke-tests were developed, `docker-compose` was not
available on Jenkins. As with containerising the dependencies, it was
decided that a simple `docker build.../docker run` approach would be
easiest to maintain on Jenkins in the medium to long term.

## Caution

The smoke tests create new cases on GLiMR and will also skew web
analytics figures on environments that are recording such.

In short: do not run smoke test against the production environment
without consulting all the stakeholders, first.

These tests are **HAPPY PATH ONLY** and only test one of the happy paths
(there are multiple possible happy paths). That said, they do touch the
critical functionality of all paths.
