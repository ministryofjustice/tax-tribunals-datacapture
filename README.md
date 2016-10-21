# Tax Tribunals Data Capture

[![CircleCI](https://circleci.com/gh/ministryofjustice/tax-tribunals-datacapture.svg?style=svg)](https://circleci.com/gh/ministryofjustice/tax-tribunals-datacapture)

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

### Running the app directly on your machine

You are of course free to run the app directly too, in which case you will need to bring your own Ruby-ready environment and PostgreSQL server. You will also need to tweak the `DATABASE_URL` environment variable in `.env`.
