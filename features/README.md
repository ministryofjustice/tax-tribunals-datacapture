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

### Stubbing

`RSpec::Mocks` is used to stub `Uploader`. This allows the feature tests to progress beyond the pages, i.e. document upload steps, that require a document upload. An example of this can be found in the `complete_valid_appeal_application` method in `navigation_helpers.rb`.

### Navigation

To make navigation between pages quicker, `FactoryBot` is used to create users that possess particular traits. This means that once the driver has logged in, pages can be accessed by URL (using `load_page` method). To create a new `navigation_helper` method, a specific set of application traits is necessary to access a particular page i.e. to access the Check Answers page, create an application that possesses all the details of a completed application.

### Brakeman

[Brakeman](https://github.com/presidentbeef/brakeman) is a static analysis tool which checks Ruby on Rails applications for security vulnerabilities.