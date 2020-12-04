# Pa11y Accessibility Testing (TT Datacapture App)

## Summary
Pa11y is an automated accessibility testing tool.
Pa11y accessibility tests are used to examine whether a site complies with Web Content Accessibility Guidelines (WCAG) 
2.1 standards. w3.org states:

"Following these guidelines will make content more accessible to a wider range of people 
with disabilities, including accommodations for blindness and low vision, deafness and hearing loss, limited movement, 
speech disabilities, photosensitivity, and combinations of these, and some accommodation for learning disabilities and 
cognitive limitations; but will not address every user need for people with these disabilities. These guidelines 
address accessibility of web content on desktops, laptops, tablets, and mobile devices. Following these guidelines will 
also often make Web content more usable to users in general."

The following shows how to implement Pa11y-CI, a variant of Pa11y which iterates over a list of
webpages and highlights accessibility issues.

### Using Pa11y

Install pa11y-ci using documentation at https://github.com/pa11y/pa11y-ci.
Set up the MOJ uploader so that pages with upload functionality can be accessed https://github.com/ministryofjustice/mojfile-uploader

For the tt-datacapture, tests may be carried out on the Appeal journey or the Closure journey.

First, open 3 terminals and cd into the `mojfile-uploader` in one and `tax-tribunals-datacapture` in the other two.

Run the mojfile-uploader using `DO_NOT_SCAN=true dotenv rackup`

Run  TT datacapture in one of the two remaining terminals using `rails s -p 3000`

In the final terminal, depending on which journey you wish to test, execute the following commands:

#### Appeal journey:

with screenshots:
```
mkdir -p pa11y/screenshots/appeal   
pa11y-ci --config pa11y/tests/appeal/.pa11yci_ss.json
```
without screenshots:
```
pa11y-ci --config pa11y/tests/appeal/.pa11yci.json
```

#### Closure journey:

with screenshots:
```
mkdir -p pa11y/screenshots/closure   
pa11y-ci --config pa11y/tests/closure/.pa11yci_ss.json
```
without screenshots:
```
pa11y-ci --config pa11y/tests/closure/.pa11yci.json
```

### Issues
Cannot access the following pages because document upload is required:
- ~/steps/details/check_answers
- ~/steps/details/confirmation

so these must be tested manually using WAVE or `pa11y <url>` while in a session after upload has been done.
### WCAG standards

In the default configuration, the compliance standard is WCAG2.1AA. To change this, go to the .pa11yci.json (or 
.pa11yci_ss.json) file and change the 'standard' attribute to either WCAG2.1A, WCAG2.1AA or WCAG2.1AAA.

### Official documentation

https://github.com/pa11y/pa11y-ci