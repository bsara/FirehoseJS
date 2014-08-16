class Firehose.Product extends Firehose.Object


  # @nodoc
  @_firehoseType: "Product"

  ###
  @property [Company] The company this product belongs to.
  ###
  company: null

  ###
  @property [String] The name of this product.
  ###
  name: null

  ###
  @property [String]
  ###
  knowledgeBaseSubdomain: null

  ###
  @property [String]
  ###
  knowledgeBaseCustomDomain: null

  ###
  @property [String]
  ###
  knowledgeBaseCSS: null

  ###
  @property [String]
  ###
  knowledgeBaseLayoutTemplate: null

  ###
  @property [String]
  ###
  knowledgeBaseSearchTemplate: null

  ###
  @property [String]
  ###
  knowledgeBaseArticleTemplate: null

  ###
  @property [String]
  ###
  chatTitleTextColor: null

  ###
  @property [String]
  ###
  chatTitleBackgroundColor: null

  ###
  @property [String]
  ###
  chatAgentColor: null

  ###
  @property [String]
  ###
  chatCustomerColor: null

  ###
  @property [String]
  ###
  chatFieldTextColor: null

  ###
  @property [String]
  ###
  chatFieldBackgroundColor: null

  ###
  @property [String]
  ###
  chatBackgroundColor: null

  ###
  @property [String]
  ###
  chatResponseBackgroundColor: null

  ###
  @property [String]
  ###
  chatCSS: null

  ###
  @property [String]
  ###
  chatOnlineHeaderText: null

  ###
  @property [String]
  ###
  chatOnlineWelcomeText: null

  ###
  @property [String]
  ###
  chatOfflineHeaderText: null

  ###
  @property [String]
  ###
  chatOfflineWelcomeText: null

  ###
  @property [String]
  ###
  chatOfflineEmailAddress: null

  ###
  @property [String]
  ###
  chatAppearance: null

  ###
  @property [String]
  ###
  chatTabPosition: null

  ###
  @property [String]
  ###
  chatUseCustomCSS: null

  ###
  @property [String]
  ###
  websiteURL: null


  # Remote Arrays

  # @nodoc
  _articles: null

  # @nodoc
  _searchedArticles: null



  # Private

  # @nodoc
  _includesKnowledgeBaseAttributes: false

  # @nodoc
  _includesChatAttributes: false



  ###
  The designated method of creating a new product.
  @param name [String] The short display name.
  @param text [String] The actual text of the product.
  @param company [Company] The company this product will belong to once saved to the server.
  ###
  @productWithName: (name, company) ->
    Firehose.Object._objectOfClassWithID Firehose.Product,
      name:    name
      company: company


  ###
  Create a product object when all you have is an id. You can then fetch articles or fetch the product's properties if you're authenticated as an agent of the company.
  @param id [number] The id of the product.
  @return [Product] Returns a product object. If a product object with this id already exists in the cache, it will be returned.
  ###
  @productWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.Product,
      id:      id
      company: company


  ###
  Create a product object when all you have is the subdomain for the knowledge base. You can then call `fetch` to get the products's `id` and `name`.
  @param subdomain [String] The subdomain of the product.
  @return [Product] Returns a product object you can then call `fetch` on.
  ###
  @productWithKBSubdomain: (subdomain) ->
    Firehose.Object._objectOfClassWithID Firehose.Product,
      knowledgeBaseSubdomain: subdomain


  ###
  Create a product object when all you have is the custom domain for the knowledge base. You can then call `fetch` to get the products's `id` and `name`.
  @param customDomain [String] The custom domain that maps (via a CNAME DNS record) to the subdomain of the products's kb.
  @return [Product] Returns a product object you can then call `fetch` on.
  ###
  @productWithKBCustomDomain: (customDomain) ->
    Firehose.Object._objectOfClassWithID Firehose.Product,
      knowledgeBaseCustomDomain: customDomain


  ###
  Save the product to the server.
  @return [Promise] A jqXHR Promise.
  @note If it has never been saved, it creates it on the server. Otherwise it updates it.
  @example Creating and saving a product.
    product = Firehose.Product.productWithName "Product", company
    product.save().done ->
      console.log "saved!"
  ###
  save: ->
    if @id?
      params =
        route: "products/#{@id}"
        body:  this._toJSON()
      Firehose.client.put( this, params )
    else
      params =
        route: "companies/#{@company.id}/products"
        body:  this._toJSON()
      Firehose.client.post( this, params ).done (data) =>
        this._populateWithJSON data
        @company.products.insertObject this


  ###
  Fetch a companies properties based on `id`, `knowledgeBaseSubdomain` or `knowledgeBaseCustomDomain`.
  @param  options [Object] A hash of options. Currently the only option is "include". This allows you to include knowledge base settings and chat settings attributes for this product.
  @option options [String] include Use this query string param to include settings for "kb" or "chat" or both.
  @return [jqXHR Promise] Promise
  ###
  fetch: (options = {}) ->
    if @id?
      request =
        route: "products/#{@id}"
        params:
          include: options.include.join(",") if options.include?

    else if @knowledgeBaseSubdomain
      request =
        auth:   false
        route:  "products"
        params:
          kb_subdomain: @knowledgeBaseSubdomain

    else if @knowledgeBaseCustomDomain
      request =
        auth:   false
        route:  "products"
        params:
          kb_custom_domain: @knowledgeBaseCustomDomain

    else
      throw "You can't call 'fetch' on a product unless 'id', 'knowledgeBaseSubdomain' or 'knowledgeBaseCustomDomain' is set."

    Firehose.client.get( this, request ).done (data) =>
      this._populateWithJSON data


  ###
  Destroy this product from the server. This will destroy all articles that belong to this product.
  @return [Promise] A jqXHR Promise.
  ###
  destroy: ->
    params =
      route: "products/#{@id}"
    Firehose.client.delete( this, params ).done =>
      @company.products.dropObject this


  ###
  All the articles of a product.
  @return [RemoteArray<Article>] The found articles.
  ###
  articles: ->
    unless @_articles?
      articlesRemoteArray = new Firehose.RemoteArray "products/#{@id}/articles", null, (json) =>
        Firehose.Article.articleWithID( json.id, this )
      articlesRemoteArray.auth = false
      this._setIfNotNull "_articles", articlesRemoteArray
    @_articles


  ###
  Returns a remote array of articles found by searching for `text`.
  @param text [String] The string of text you want to search for articles containing.
  @note Every time you call this on a product, you are creating a new remote array and any previously created have their network requests cancelled.
  @return [RemoteArray<Article>] The found articles.
  ###
  searchedArticles: (text) ->
    currentSearchedArticles = this.get '_searchedArticles'
    if currentSearchedArticles
      currentSearchedArticles.abort()
    articlesRemoteArray = new Firehose.RemoteArray "products/#{@id}/article_search", q: text, (json) =>
      article = Firehose.Article.articleWithID( json.id, this )
      article._populateWithJSON json
      article
    articlesRemoteArray.auth = false
    this._setIfNotNull "_searchedArticles", articlesRemoteArray
    articlesRemoteArray


  ###
  Returns the base URL for the product's knowledge base for the current environment.
  @note In production, if a custom domain is set on the product, it returns that. Otherwise, it returns the products subdomain URL. (i.e. calvetica.firehosehelp.com)
  @note The beta URL for the kb is firehosesupport.com. So instead of calvetica.firehosehelp.com like in production, the beta URL would be calvetica.firehosesupport.com.
  @return [String] The URL for the product's knowledge base in the current environment.
  ###
  kbBaseURL: ->
    throw "You must call `Product#fetch( include: ['kb'] )` before you can call this." unless @_includesKnowledgeBaseAttributes
    if Firehose.environment() == 'production' and customDomain = this.get('knowledgeBaseCustomDomain')
      "http://#{customDomain}"
    else
      Firehose.baseURLFor 'kb', this.get('knowledgeBaseSubdomain')


  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "name",                          json.name
    this._setIfNotNull "token",                         json.token
    this.set "_includesKnowledgeBaseAttributes", (typeof json.kb_subdomain != 'undefined')
    this._setIfNotNull "knowledgeBaseSubdomain",        json.kb_subdomain
    this._setIfNotNull "knowledgeBaseCustomDomain",     json.kb_custom_domain
    this._setIfNotNull "knowledgeBaseCSS",              json.kb_css
    this._setIfNotNull "knowledgeBaseLayoutTemplate",   json.kb_layout_template
    this._setIfNotNull "knowledgeBaseSearchTemplate",   json.kb_search_template
    this._setIfNotNull "knowledgeBaseArticleTemplate",  json.kb_article_template
    this.set "_includesChatAttributes", (typeof json.chat_title_text_color != 'undefined')
    this._setIfNotNull "chatTitleTextColor",            json.chat_title_text_color
    this._setIfNotNull "chatTitleBackgroundColor",      json.chat_title_background_color
    this._setIfNotNull "chatAgentColor",                json.chat_agent_color
    this._setIfNotNull "chatCustomerColor",             json.chat_customer_color
    this._setIfNotNull "chatFieldTextColor",            json.chat_field_text_color
    this._setIfNotNull "chatFieldBackgroundColor",      json.chat_field_background_color
    this._setIfNotNull "chatBackgroundColor",           json.chat_background_color
    this._setIfNotNull "chatResponseBackgroundColor",   json.chat_response_background_color
    this._setIfNotNull "chatCSS",                       json.chat_css
    this._setIfNotNull "chatOnlineHeaderText",          json.chat_online_header_text
    this._setIfNotNull "chatOnlineWelcomeText",         json.chat_online_welcome_text
    this._setIfNotNull "chatOfflineHeaderText",         json.chat_offline_header_text
    this._setIfNotNull "chatOfflineWelcomeText",        json.chat_offline_welcome_text
    this._setIfNotNull "chatOfflineEmailAddress",       json.chat_offline_email_address
    this._setIfNotNull "chatAppearance",                json.chat_appearance
    this._setIfNotNull "chatTabPosition",               json.chat_tab_position
    this._setIfNotNull "chatUseCustomCSS",              json.chat_use_custom_css
    this._setIfNotNull "websiteURL",                    json.website
    super json


  # @nodoc
  _toJSON: ->
    product:
      name                           : @name                             if @name?
      kb_subdomain                   : @knowledgeBaseSubdomain           if @knowledgeBaseSubdomain?
      website                        : @websiteURL                       if @websiteURL?
      kb_custom_domain               : @knowledgeBaseCustomDomain        if @_includesKnowledgeBaseAttributes
      kb_css                         : @knowledgeBaseCSS                 if @_includesKnowledgeBaseAttributes
      kb_layout_template             : @knowledgeBaseLayoutTemplate      if @_includesKnowledgeBaseAttributes
      kb_search_template             : @knowledgeBaseSearchTemplate      if @_includesKnowledgeBaseAttributes
      kb_article_template            : @knowledgeBaseArticleTemplate     if @_includesKnowledgeBaseAttributes
      chat_title_text_color          : @chatTitleTextColor               if @_includesChatAttributes
      chat_title_background_color    : @chatTitleBackgroundColor         if @_includesChatAttributes
      chat_agent_color               : @chatAgentColor                   if @_includesChatAttributes
      chat_customer_color            : @chatCustomerColor                if @_includesChatAttributes
      chat_field_text_color          : @chatFieldTextColor               if @_includesChatAttributes
      chat_field_background_color    : @chatFieldBackgroundColor         if @_includesChatAttributes
      chat_background_color          : @chatBackgroundColor              if @_includesChatAttributes
      chat_response_background_color : @chatResponseBackgroundColor      if @_includesChatAttributes
      chat_css                       : @chatCSS                          if @_includesChatAttributes
      chat_online_header_text        : @chatOnlineHeaderText             if @_includesChatAttributes
      chat_online_welcome_text       : @chatOnlineWelcomeText            if @_includesChatAttributes
      chat_offline_header_text       : @chatOfflineHeaderText            if @_includesChatAttributes
      chat_offline_welcome_text      : @chatOfflineWelcomeText           if @_includesChatAttributes
      chat_offline_email_address     : @chatOfflineEmailAddress          if @_includesChatAttributes
      chat_appearance                : @chatAppearance                   if @_includesChatAttributes
      chat_tab_position              : @chatTabPosition                  if @_includesChatAttributes
      chat_use_custom_css            : @chatUseCustomCSS                 if @_includesChatAttributes

   # @nodoc
  _toArchivableJSON: ->
    $.extend super(),
      name                           : @name
      token                          : @token
      kb_subdomain                   : @knowledgeBaseSubdomain
      kb_custom_domain               : @knowledgeBaseCustomDomain
      kb_css                         : @knowledgeBaseCSS
      kb_layout_template             : @knowledgeBaseLayoutTemplate
      kb_search_template             : @knowledgeBaseSearchTemplate
      kb_article_template            : @knowledgeBaseArticleTemplate
      chat_title_text_color          : @chatTitleTextColor
      chat_title_background_color    : @chatTitleBackgroundColor
      chat_agent_color               : @chatAgentColor
      chat_customer_color            : @chatCustomerColor
      chat_field_text_color          : @chatFieldTextColor
      chat_field_background_color    : @chatFieldBackgroundColor
      chat_background_color          : @chatBackgroundColor
      chat_response_background_color : @chatResponseBackgroundColor
      chat_css                       : @chatCSS
      chat_online_header_text        : @chatOnlineHeaderText
      chat_online_welcome_text       : @chatOnlineWelcomeText
      chat_offline_header_text       : @chatOfflineHeaderText
      chat_offline_welcome_text      : @chatOfflineWelcomeText
      chat_offline_email_address     : @chatOfflineEmailAddress
      website                        : @websiteURL
