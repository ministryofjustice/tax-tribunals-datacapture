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


### Running cross browser and device tests using Sauce Labs
Replace 'SAUCE_USERNAME' and 'SAUCE_ACCESS_KEY' in tax-tribunals-datacapture/.env with your account details

Run tunnel:
Go to your terminal
Example go to the path where you've downloaded Sauce connect

Latest sauce version on Mac -> sc-4.6.3-osx

`$ cd Downloads/sc-4.6.3-osx`

Run Below command

`$ sc-4.6.3-osx % bin/sc -u <SAUCE_USERNAME> -k  <SAUCE_ACCESS_KEY> --se-port 4449`

Replace '<SAUCE_USERNAME>' and '<SAUCE_ACCESS_KEY>' with your account details

Wait for 'Sauce Connect is up, you may start your tests.'

[Add the tag '@saucelabs' to a scenario/s that you want to run.]

To run Sauce Labs feature using specific browser:

Open new session on terminal

Go to your tax-tribunals-datacapture folder path

Run Below command
Example:

`$ DRIVER=chrome_saucelabs cucumber --tags @saucelabs`