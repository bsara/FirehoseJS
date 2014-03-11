module "Email Account"

firehoseTest 'Create', 4, (agent) ->
  company = agent.companies[0]
  emailAccount = Firehose.EmailAccount.emailAccountWithSettings company,
    emailAddress: Faker.Internet.email()
    title:        Faker.Lorem.words(1).join(" ")
    kind:         "IMAP"
    server:       "mail.example.com"
    port:         537
    username:     Faker.Internet.userName()
    password:     Faker.Lorem.words(1).join(" ")
    SSL:          true
  emailAccount.save()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok emailAccount.emailAddress?
    ok emailAccount.title?
    ok emailAccount.isForwarding?
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  emailAccount = Firehose.EmailAccount.emailAccountWithSettings company,
    emailAddress: Faker.Internet.email()
    title:        Faker.Lorem.words(1).join(" ")
    kind:         "IMAP"
    server:       "mail.example.com"
    port:         537
    username:     Faker.Internet.userName()
    password:     Faker.Lorem.words(1).join(" ")
    SSL:          true
  emailAccount.save()
  .done (data, textStatus) ->
    emailAccount.server = "mailbox.example.com"
    emailAccount.save()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  emailAccount = Firehose.EmailAccount.emailAccountWithSettings company,
    emailAddress: Faker.Internet.email()
    title:        Faker.Lorem.words(1).join(" ")
    kind:         "IMAP"
    server:       "mail.example.com"
    port:         537
    username:     Faker.Internet.userName()
    password:     Faker.Lorem.words(1).join(" ")
    SSL:          true
  emailAccount.save()
  .done (data, textStatus) ->
    emailAccount.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
    
firehoseTest 'Guess Fields From Email: Gmail', 5, (agent) ->
  company = agent.companies[0]
  emailAccount = Firehose.EmailAccount.emailAccountWithSettings company,
    emailAddress: Faker.Internet.email()
    title:        Faker.Lorem.words(1).join(" ")
    kind:         "IMAP"
    server:       "mail.example.com"
    port:         537
    username:     "test@gmail.com"
    password:     Faker.Lorem.words(1).join(" ")
    SSL:          true
  emailAccount.errors = [ "error 1", "error 2" ]

  ok emailAccount.guessFieldsFromEmail()
  equal emailAccount.kind, "IMAP"
  ok emailAccount.SSL == true
  ok emailAccount.port == 993
  ok emailAccount.server == "imap.googlemail.com"
  start()
    
    
firehoseTest "Guess Fields From Email", 12, (agent) ->
  company = agent.companies[0]
  emailAccount = Firehose.EmailAccount.emailAccountWithSettings company,
    emailAddress: Faker.Internet.email()
    title:        Faker.Lorem.words(1).join(" ")
    kind:         "IMAP"
    server:       "mail.example.com"
    port:         537
    username:     "test@gmail.com"
    password:     Faker.Lorem.words(1).join(" ")
    SSL:          true
  emailAccount.errors = [ "error 1", "error 2" ]

  # gmail
  ok emailAccount.guessFieldsFromEmail(), "guessFieldsFromEmail() should succeed in guessing fields"
  equal emailAccount.kind, "IMAP"
  equal emailAccount.SSL, true
  equal emailAccount.port, 993
  equal emailAccount.server, "imap.googlemail.com"
  equal emailAccount.errors.length, 0, "errors should not contain any errors"

  # hotmail
  emailAccount.username = "test@hotmail.com"
  emailAccount.errors = [ "error 1", "error 2" ]

  ok emailAccount.guessFieldsFromEmail(), "guessFieldsFromEmail() should succeed in guessing fields"
  equal emailAccount.kind, "POP"
  equal emailAccount.SSL, true
  equal emailAccount.port, 995
  equal emailAccount.server, "pop3.live.com"
  equal emailAccount.errors.length, 0, "errors should not contain any errors"

  start()
    
    
firehoseTest "Guess Fields From Email: Username is NULL", 9, (agent) ->
  company = agent.companies[0]

  expectedEmailAddress = null
  expectedTitle = Faker.Lorem.words(1).join(" ")
  expectedKind = "POP"
  expectedServer = "mail.example.com"
  expectedPort = 537
  expectedUsername = null
  expectedPassword = Faker.Lorem.words(1).join(" ")
  expectedSSL = false

  emailAccount = Firehose.EmailAccount.emailAccountWithSettings company,
    emailAddress: expectedEmailAddress
    title:        expectedTitle
    kind:         expectedKind
    server:       expectedServer
    port:         expectedPort
    username:     expectedUsername
    password:     expectedPassword
    SSL:          expectedSSL
  emailAccount.errors = [ "error 1", "error 2" ]

  ok !emailAccount.guessFieldsFromEmail(), "guessFieldsFromEmail() should fail to guess fields"
  equal emailAccount.emailAddress, expectedEmailAddress, "emailAddress should not have changed"
  equal emailAccount.title, expectedTitle, "title should not have changed"
  equal emailAccount.kind, expectedKind, "kind should not have changed"
  equal emailAccount.server, expectedServer, "server should not have changed"
  equal emailAccount.port, expectedPort, "port should not have changed"
  equal emailAccount.username, expectedUsername, "username should not have changed"
  equal emailAccount.SSL, expectedSSL, "SSL should not have changed"
  equal emailAccount.errors.length, 1, "errors should only contain 1 error"

  start()