# Tax Tribunals Data Capture Feature Tests

Copy and paste the '.env.test.example' file in the root directory as '.env.test' and change line 2 to : 'DATABASE_URL=postgresql://x@localhost/tt-datacapture_test' where x is your postgres username.

$ cucumber features

To run the all scenarios in a particular feature file:

$ cucumber features/homepage.feature

To run a particular scenario using line number:

$ cucumber features/homepage.feature:7

To run in a browser:

$ DRIVER=chrome cucumber

$ DRIVER=firefox cucumber
