if [ ! -e "~/.firehoseconfig" ] then
  echo "You must have a ~/.firehoseconfig file that exports the following variables:"
  echo "FH_API_DIR"
  echo "FH_BROWSER_DIR"
  echo "FH_BILLING_DIR"
  echo "FH_TINY_URL_DIR"
  echo "FH_MARKETING_DIR"
  echo "FH_SETTINGS_DIR"
  echo "FH_TWEET_LONGER_DIR"
  echo "FH_KB_DIR"
  echo "If any of those are not exported, the booting up of the server will be skipped."
fi