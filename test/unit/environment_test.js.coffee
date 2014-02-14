module "Environment",
  teardown: ->
    window.unitTestDocumentURL = null
  
test 'infer browser development', ->
  window.unitTestDocumentURL = "http://localhost:4001"
  Firehose.client.environment._inferEnvironmentFromURL()
  ok Firehose.client.environment._environment == 'development'
  ok Firehose.client.environment._server == 'local'
  
test 'infer browser production', ->
  window.unitTestDocumentURL = "https://firehoseapp.com"
  Firehose.client.environment._inferEnvironmentFromURL()
  ok Firehose.client.environment._environment == 'production'
  ok Firehose.client.environment._server == 'production'
  
test 'infer browser development -> production', ->
  window.unitTestDocumentURL = "http://localhost:4201"
  Firehose.client.environment._inferEnvironmentFromURL()
  ok Firehose.client.environment._environment == 'development'
  ok Firehose.client.environment._server == 'production'
  
test 'infer browser development -> mini', ->
  window.unitTestDocumentURL = "http://localhost:4101"
  Firehose.client.environment._inferEnvironmentFromURL()
  ok Firehose.client.environment._environment == 'development'
  ok Firehose.client.environment._server == 'mini'
  
test 'infer client app with server number (throws)', ->
  window.unitTestDocumentURL = "http://locahost:3000"
  throws Firehose.client.environment._inferEnvironmentFromURL()
  
test 'infer client app with server number (throws)', ->
  window.unitTestDocumentURL = "http://locahost:3211"
  throws Firehose.client.environment._inferEnvironmentFromURL()
  
test 'infer browser development port overrides to test', ->
  window.unitTestDocumentURL = "http://localhost:4011"
  Firehose.client.environment._inferEnvironmentFromURL()
  ok Firehose.client.environment._environment == 'test'
  ok Firehose.client.environment._server == 'local'
  
  
  
  
test 'produce browser development URL', ->
  window.unitTestDocumentURL = "http://localhost:4001"
  ok Firehose.baseURLFor('API') == "http://localhost:3000"
  ok Firehose.baseURLFor('browser') == "http://localhost:4001"
  ok Firehose.baseURLFor('billing') == "http://localhost:3002"
  ok Firehose.baseURLFor('frhio') == "http://localhost:3003"
  ok Firehose.baseURLFor('marketing') == "http://localhost:4004"
  ok Firehose.baseURLFor('settings') == "http://localhost:4005"
  ok Firehose.baseURLFor('tweetlonger') == "http://localhost:4006"
  ok Firehose.baseURLFor('kb', 'mystrou') == "http://mystrou.lvh.me:4567"
  
test 'produce browser development URL in test environment', ->
  window.unitTestDocumentURL = "http://localhost:4011"
  ok Firehose.baseURLFor('API') == "http://localhost:3010"
  ok Firehose.baseURLFor('browser') == "http://localhost:4011"
  ok Firehose.baseURLFor('billing') == "http://localhost:3012"
  ok Firehose.baseURLFor('frhio') == "http://localhost:3013"
  ok Firehose.baseURLFor('marketing') == "http://localhost:4014"
  ok Firehose.baseURLFor('settings') == "http://localhost:4015"
  ok Firehose.baseURLFor('tweetlonger') == "http://localhost:4016"
  ok Firehose.baseURLFor('kb', 'mt') == "http://mt.lvh.me:4567"
  
test 'produce browser development pointing at production URL', ->
  window.unitTestDocumentURL = "http://localhost:4201"
  ok Firehose.baseURLFor('API') == "https://api.firehoseapp.com"
  ok Firehose.baseURLFor('browser') == "http://localhost:4201"
  ok Firehose.baseURLFor('billing') == "https://billing.firehoseapp.com"
  ok Firehose.baseURLFor('frhio') == "https://frh.io"
  ok Firehose.baseURLFor('marketing') == "http://localhost:4204"
  ok Firehose.baseURLFor('settings') == "http://localhost:4205"
  ok Firehose.baseURLFor('tweetlonger') == "http://localhost:4206"
  ok Firehose.baseURLFor('kb', 'mystrou') == "http://mystrou.lvh.me:4567"
  
test 'produce browser development pointing at production URL', ->
  window.unitTestDocumentURL = "https://getfirehose.com"
  ok Firehose.baseURLFor('API') == "https://api.firehoseapp.com"
  ok Firehose.baseURLFor('browser') == "https://firehoseapp.com"
  ok Firehose.baseURLFor('billing') == "https://billing.firehoseapp.com"
  ok Firehose.baseURLFor('frhio') == "https://frh.io"
  ok Firehose.baseURLFor('marketing') == "https://getfirehose.com"
  ok Firehose.baseURLFor('settings') == "https://settings.firehoseapp.com"
  ok Firehose.baseURLFor('tweetlonger') == "https://tl.frh.io"
  ok Firehose.baseURLFor('kb') == "https://firehosehelp.com"

test 'produce browser beta URLs', ->
  window.unitTestDocumentURL = "https://beta.firehoseapp.com"
  ok Firehose.baseURLFor('API') == "https://api.firehoseapp.com"
  ok Firehose.baseURLFor('browser') == "https://beta.firehoseapp.com"
  ok Firehose.baseURLFor('billing') == "https://billing.firehoseapp.com"
  ok Firehose.baseURLFor('frhio') == "https://frh.io"
  ok Firehose.baseURLFor('marketing') == "https://beta.getfirehose.com"
  ok Firehose.baseURLFor('settings') == "https://beta_settings.firehoseapp.com"
  ok Firehose.baseURLFor('tweetlonger') == "https://beta_tl.frh.io"
  ok Firehose.baseURLFor('kb') == "https://beta.firehosehelp.com"
