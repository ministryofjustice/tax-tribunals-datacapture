Settings.prepend_source!(Rails.root.join('features', 'support', 'saucelabs', 'browsers.yml').to_s)
Settings.reload!
