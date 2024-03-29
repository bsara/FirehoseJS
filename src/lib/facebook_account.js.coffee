class Firehose.FacebookAccount extends Firehose.Object


  # @nodoc
  @_firehoseType: "FacebookAccount"

  ###
  @property [Company]
  ###
  company: null

  ###
  @property [String]
  ###
  username: null

  ###
  @property [String]
  ###
  facebookUserId: null

  ###
  @property [String]
  ###
  imageURL: null

  ###
  @property [String]
  ###
  name: null

  # associations

  ###
  @property [Array<FacebookPage>]
  ###
  facebookPages: null


  # @nodoc
  _setup: ->
    @facebookPages = new Firehose.UniqueArray


  # @nodoc
  @_facebookAccountWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.FacebookAccount,
      id:      id
      company: company


  @OAuthURLForCompanyWithCallback: (company, callback)  ->
    "#{Firehose.baseURLFor('API')}/companies/#{company.id}/oauth_facebook?url_token=#{Firehose.client.URLToken}&callback_url=#{encodeURIComponent(callback)}"


  destroy: ->
    params =
      route: "facebook_accounts/#{@id}"
    Firehose.client.delete( this, params ).done =>
      @company.facebookAccounts().dropObject this


  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "username",       json.username
    this._setIfNotNull "facebookUserId", json.facebook_user_id
    this._setIfNotNull "imageURL",       json.image_url
    this._setIfNotNull "name",           json.name

    this._populateAssociatedObjects this, "facebookPages", json.facebook_pages, (json) =>
      Firehose.FacebookPage._facebookPageWithID( json.id, this )

    super json

