#!/bin/sh 

echo "\n**********************"
echo "START FIREHOSE SERVERS"
echo "**********************\n"

if [ ! -e "$HOME/.bash_profile" ] ; then
  source $HOME/.bash_profile
fi

FH_CONFIG_FILE="$HOME/.firehoseconfig.sh"
  
if [ ! -e $FH_CONFIG_FILE ] ; then
  
  PATHS_EXAMPLE="# Edit this file so each export points to the right directory. Save and run the script again.
# Comment out the apps you don't want to start with the script.
export FH_API_DIR=~/mt/projects/firehose/api
export FH_BROWSER_DIR=~/mt/projects/firehose/browser
export FH_BILLING_DIR=~/mt/projects/firehose/billing
export FH_TINY_URL_DIR=~/mt/projects/firehose/tinyurl
export FH_MARKETING_DIR=~/mt/projects/firehose/marketing
export FH_SETTINGS_DIR=~/mt/projects/firehose/settings
export FH_TWEET_LONGER_DIR=~/mt/projects/firehose/tweetlonger
export FH_KB_DIR=~/mt/projects/firehose/kb"
  
  echo "$PATHS_EXAMPLE" > $FH_CONFIG_FILE
  chmod +x $FH_CONFIG_FILE
  
  if [ EDITOR ] ; then
    $EDITOR $FH_CONFIG_FILE
  else
    vi $FH_CONFIG_FILE
  fi
  exit 1
fi



. $FH_CONFIG_FILE

echo $FH_API_DIR

if [ FH_API_DIR ] && [ -e $FH_API_DIR ] ; then
  echo "-> Starting API rails server"
  cd $FH_API_DIR && rails s &
fi

if [ FH_BROWSER_DIR ] && [ -e $FH_API_DIR ] ; then
  echo "-> starting browser middleman server"
  cd $FH_BROWSER_DIR && middleman -p 4001 &
fi

if [ FH_BILLING_DIR ] && [ -e $FH_BILLING_DIR ] ; then
  echo "-> Starting billing rails server"
  cd $FH_BILLING_DIR && rails s -p 3002 &
fi

if [ FH_TINY_URL_DIR ] && [ -e $FH_TINY_URL_DIR ] ; then
  echo "-> Starting tinyurl rails server"
  cd $FH_TINY_URL_DIR && rails s -p 3003 &
fi

if [ FH_MARKETING_DIR ] && [ -e $FH_MARKETING_DIR ] ; then
  echo "-> Starting marketing middleman server"
  cd $FH_MARKETING_DIR && middleman -p 4004 &
fi

if [ FH_SETTINGS_DIR ] && [ -e $FH_SETTINGS_DIR ] ; then
  echo "-> Starting settings middleman server"
  cd $FH_SETTINGS_DIR && middleman -p 4005 &
fi

# TODO
# if [ $FH_TWEET_LONGER_DIR ] ; then
#   echo "-> Starting tweet longer grunt server"
#   cd $FH_TWEET_LONGER_DIR & grunt watch
# fi

if [ FH_KB_DIR ] && [ -e $FH_KB_DIR ] ; then
  echo "-> Starting kb middleman server"
  cd $FH_KB_DIR && middleman &
fi

