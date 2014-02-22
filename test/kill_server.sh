# load in bash profile and change to firehose rails directory
if [ -e "~/.bash_profile" ]; then
  source ~/.bash_profile
fi


cd $FH_API_PATH
# kill any previously running rails server
if [ -e tmp/pids/server.pid ]
then
    PID=$(cat tmp/pids/server.pid)
    kill -s 9 $PID 2> /dev/null         # suppresses error if there is no server running or process with that id
fi


cd $FH_BILLING_PATH
# kill any previously running rails server
if [ -e tmp/pids/server.pid ]
then
    PID=$(cat tmp/pids/server.pid)
    kill -s 9 $PID 2> /dev/null         # suppresses error if there is no server running or process with that id
fi