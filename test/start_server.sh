# load in bash profile and change to firehose rails directory
source ~/.bash_profile


# start API server
cd $FH_API_PATH
# kill any previously running rails server
if [ -e tmp/pids/server.pid ]
then
  PID=$(cat tmp/pids/server.pid)
  kill -s 9 $PID 2> /dev/null         # suppresses error if there is no server running or process with that id
fi
# prepare the test db and start up the rails server in test environment
bundle exec rake fh:test:client:prepare
rails s -e testclient -p 3010 -d


# start the billing server
cd $FH_BILLING_PATH
# kill any previously running rails server
if [ -e tmp/pids/server.pid ]
then
  PID=$(cat tmp/pids/server.pid)
  kill -s 9 $PID 2> /dev/null         # suppresses error if there is no server running or process with that id
fi
# prepare the test db and start up the rails server in test environment
bundle exec rake fh_billing:test:client:prepare
rails s -e testclient -p 3012 -d
