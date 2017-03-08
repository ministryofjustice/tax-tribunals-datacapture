# Tax Tribunals Full-Stack Smoke Tests

These are **NOT** standard cucumber features and should not be treated
as such.  They are a set of simple features used to smoke test the
application stack in various 'real' enviroments. They will not work
locally, nor will they work against the docker-container stack.

## Running

```
export DATACAPTURE_URI=https://tax-tribunals-datacapture-dev.dsd.io
bundle exec cucumber
```

### Running on CI

The script for running the Docker contain on MoJ's CI is as follows:

```bash
#!/bin/bash

set -euo pipefail

docker build -f Dockerfile.smoketests -t smoketests .;
docker run smoketests
```



## Caution

The smoke tests create new cases on GLiMR. Do not run them against the
production environment without consulting the Tribnal staff, first.
