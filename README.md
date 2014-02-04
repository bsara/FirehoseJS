# firehosejs

Javascript library for interacting with the Firehose API.

## Getting Started

Add this to your bower.json file:

    "firehosejs": "mysterioustrousers/FirehoseJS"

## Documentation
_(Coming soon)_

## Examples
_(Coming soon)_

## Contributing

Make sure you install the following npm packages:

    sudo npm install -g coffeedoc
    sudo npm install -g exec
    
Make sure these two env vars are set in your .bash_profile:

    export FH_API_PATH='/Users/adamkirk/mt/projects/firehose/firehose'
    export FH_BILLING_PATH='/Users/adamkirk/mt/projects/firehose/billing'
    
So that the start_server.sh script knows where your apps are to start them for testing.

You must also make sure that both your local API and billing apps have `rake db:create RAILS_ENV=testclient` and `rake db:migrate RAILS_ENV=testclient`