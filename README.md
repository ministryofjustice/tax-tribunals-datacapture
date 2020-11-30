# Tax Tribunals Data Capture

[![Build
Status](https://travis-ci.org/ministryofjustice/tax-tribunals-datacapture.svg?branch=master)](https://travis-ci.org/ministryofjustice/tax-tribunals-datacapture)

Ruby on Rails Web application for making an appeal to the Tax Tribunal.

## Setup & Run (locally)

This app uses Docker Compose to run locally, which lets you spin up an app container and a database with minimal effort:

```
# Set up environment variables
cp .env.example .env

# Create the database
docker-compose run web rails db:create db:migrate

# Run the containers
docker-compose up
```

## Heroku demo environment

Can be found at: https://tax-tribunals-demo.herokuapp.com/

It automatically tracks `master`, and deploys after each successful
CircleCI run.

It depends on the heroku apps:

 https://glimr-api-emulator.herokuapp.com/

and

 https://mojfile-uploader-emulator.herokuapp.com/

Which also track their respective master branches.

It is running on a free dyno, so there may be a short delay while it
starts up.

### Running the app directly on your machine

You are of course free to run the app directly too, in which case you will need to bring your own Ruby-ready environment and PostgreSQL server. You will also need to tweak the `DATABASE_URL` environment variable in `.env`.

## Mutation testing performance issues and resolution

### Background

At the end of March 2017, we encountered problems with CircleCI and
mutation testing.  Calls to `self` in `TribunalCase` were causing heavy
recursion in two of the mutation tests run against that model's spec [1].
These consumed large amounts of memory, ran very slowly, and effectively
blocked two mutants threads for hours on a locally running instance.

### CircleCI vs. Travis

Even after the issue was fixed, the mutation tests sometimes exceeded the 4GB
memory limit imposed by CircleCI.  Circle was also consitently slow to
run the mutations.  Experiments with Travis, however, showed it to be
consistently much more performant with the mutations.

### Running on Travis

Early experiments with `.travis.yml` showed that it was not properly
setting the environment variables.  To work around this, the following
variables are set directly in the trais configuration:

* `DATABASE_URL`
* `GLIMR_API_URL`
* `GOVUK_NOTIFY_API_KEY`
* `MOJ_FILE_UPLOADER_ENDPOINT`
* `TAX_TRIBUNALS_DOWNLOADER_URL`

[1]: At the time of writing, `TribunalCase` brings in 17 other objects via the
`.has_value_object` call.  Any mutation referencing a `self` call will
need to include all of these in its syntax tree.

### Update October 2020 ###

We migrated to latest MOJ design system https://design-system.service.gov.uk/
