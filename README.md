# Firehose.js

Javascript library for interacting with the Firehose API.




## Getting Started

Add this to your bower.json file:

    "firehosejs": "mysterioustrousers/Firehose"



## Documentation

### Environments

Because Firehose.js is meant to be used in a browser environment, it's environment is directly tied to the current base URL. It uses the browser's current URL to figure out what environment it is running in and that, in turn, dictates what api server it talks to, what billing server it talks to, etc. It also means that Firehose.js can be used to generate links to other Firehose clients and the environment will be maintained as the browser navigates to different clients. For example,
consider a link in the brower app:

    <a href="javascript:Firehose.baseURLFor('marketing') + '/home/login';">Log In</a>

If you were viewing the browser app in development at `http://localhost:4001` then the link would be generated as `http://localhost:4004/home/login`. If the current browser app was running in production at `https://firehoseapp.com` the linke would be generated as `https://getfirehose.com/home/login`.

#### Beta

Every browser client will have a variation of the production hostname, each with a `beta.*` prefix. This will be used by all of us and any customers who want to use pre-release versions of our browser clients. This only applies to browser clients, there will be no such thing for our server apps (API, billing, frh.io) since they have production data involved. So, for example, `https://beta.firehoseapp.com/` will be the next version of our browser app that anyone can use (at their own risk) and it will point to production API, billing, frh.io. Firehose.js knows when it's running in beta because the browser's url has `beta` in it. It will talk to production servers, but all links to other browser clients will also be have the beta prefix. So if you're using the beta browser app, logging out and clicking on the firhose logo will take you to `https://beta.getfirehose.com/`

#### Port Numbers

On localhost, where you are supplying port numbers, you can modify the different digits of the port number to modify how Firehose.js generates URLs. In production, there are no port numbers, so Firehose.js will use the default expected behavior. The different port number digits represent the following:

* **[1]** The type of service served. Changing this does not actually affect anything at all, it's just going to be convention that servers will have the first digit of `3` and browser clients will have the first digit of `4`. This way, when you look at a URL, you can quickly tell if the url can be visted in a browser or if it's simply a json server. The API, billing and frh.io URLs have port numbers starting with 3, all the rest start with 4. So When testing the browser client locally, run middleman with `middleman -p 4001`

    	3: Sever
    	4: Client

* **[2]** The server to use. Usually this just needs to be 0, for development. But, sometimes you want to run a client served by middleman locally but have Firehose.js talk to the production server, so you could run the browser app at `4201` and you'd get a locally running browser client talking to the production API billing **and** servers. In the future, I plan to have all the server apps running on our mac mini colo with each app downloading a copy of the live db regularly. This will mostly be useful for Rob, who can easily run browser clients with middleman, but has a very hard time getting the dev server apps up and running. This would allow him to run the browser clients on his local machine, have them talk to copies of our product apps on the mini colo and be safe from accidental changes to the production db while using an in-dev version
of the browser client.

    	0: development
    	1. mini
    	2. production

* **[3]** The environment. Because the environment is usually inferred from the hostname, this is an optional override for when you are developing a browser client locally. For example, the test suite of Firehose.js runs on port `4011` to pose as if it's the browser app, but pointing to the local server and its test environment. This only makes sense for running in dev or test.

		0: development
		1: test

* **[4]** The app. Running marketing on port \*\*\*1 would change nothing, except that Firehose.js assumes everything is running on it's designated port. So if the billing app was running on \*\*\*7, and you took some action that resulted in the browser app redirecting you to the marketing app, it would try to send you to \*\*\*4, because that's where it assumes it is running. In this scenario of not following the rules, it would say server could not be found because nothing is running at \*\*\*4. So, it's just in your best interest to learn these and run apps locally on the right fourth digit port number.

    	0: API
    	1: browser
    	2: billing
	    3: files
    	4: marketing
    	5: settings
    	6: tweetlonger
    	7: kb
        8: chat browser
        9: chat billing




## Examples

See the [Documentation](https://docs.firehoseapp.com/firehosejs)




## Contributing

Make sure you install the following npm packages:

    sudo npm install -g coffeedoc
    sudo npm install -g exec

Make sure these two env vars are set in your .bash_profile:

    export FH_API_PATH='/Users/adamkirk/mt/projects/firehose/firehose'
    export FH_BILLING_PATH='/Users/adamkirk/mt/projects/firehose/billing'

So that the start_server.sh script knows where your apps are to start them for testing.

You must also make sure that both your local API and billing apps have run `rake db:create RAILS_ENV=testclient` and `rake db:migrate RAILS_ENV=testclient`

#### Testing

Unlike rails integration tests, libraries have no direct access to the application to create the test data needed for a test as part of the test, we must prepare a database full of all the different data scenarios we need to test. To generate these prepopulated postgres dbs you run rake tasks. For each app:

	API: rake fh:test:client:prepare[200]
	Billing: rake fh_billing:test:client:prepare[30]

The number in brackets does 2 things, it tells the task how many "set ups" to create. An agent with companies, customers, interactions, notes, etc. is one setup for the API app, for example. Each test will log in as an agent (e.g. agent23@example.com, each test incrementing the agent number) and that agent will have a full "set up" so the test that acts as that agent will have any data it might need. Most of the time when you run tests, the server boot up scripts will run the above commands without brackets/numbers, which will just swap in a "gold master" copy of the database you have generated previously. If, however, the db schema changes in any way, you will need to run the above commands again to generate a new db that uses the new schema. So **If all or many of your tests are failing, it's probably because you need to regenerate the db**.



#### Documentation

If you've built and generated docs, you can push the `docs` submodule to:

    git@mtmini.com:/mt/git/production/docs/firehosejs.git

