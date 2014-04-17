class Firehose.CloudFile extends Firehose.Object

  # @nodoc
  @_firehoseType: "CloudFile"

  ###
  @property [Company]
  ###
  company: null

  ###
  @property [String]
  ###
  token: null

  ###
  @property [String]
  ###
  downloadURL: null

  ###
  @property [String]
  ###
  uploadURL: null

  ###
  @property [boolean]
  ###
  uploaded: false

  ###
  @property [File]
  ###
  file: null


  @CloudFileWithFile: (file, company) ->
    new Firehose.CloudFile
      file:    file
      company: company


  @openFilePicker: (completion) ->
    # Make an unattached input tag to be garbage collected when we're done
    fileEl = $('<input type="file"/>')

    fileEl.bind "change", (e) =>
      file = e.target.files[0]

      # Can't upload file larger than 1 GB
      if file.size > 1024*1024*1024
        alert "Files must be smaller than 1GB."
        return

      if file.size > 300*1024*1024
        alert "File sizes greater than 300MB have a higher chance of failure when uploaded from a browser. If you experience problems, perhaps try it from the Mac app."
        return

      completion file

    fileEl.trigger 'click'



  upload: (options = {}) ->
    params =
      route: "companies/#{@company.id}/cloud_files"
      body: this._toJSON()
    Firehose.client.post( this, params ).done (data) =>

      this._populateWithJSON data

      # Because we can't use jquery exactly, we have to do a bit of tomfoolery
      # to create the xhr object
      xhr = new XMLHttpRequest()

      if "withCredentials" of xhr
        xhr.open 'PUT', data.upload_url, true

      else if typeof XDomainRequest != "undefined"
        xhr = new XDomainRequest()
        xhr.open 'PUT', data.upload_url

      if options.progress?
        xhr.upload?.addEventListener 'progress', (event) ->
          if event.lengthComputable
            percentComplete = parseInt event.loaded / event.total * 100, 10
            if percentComplete >= 95
              options.progress 95
            else
              options.progress percentComplete

      # Essentially the 'done' callback, have to check for success
      xhr.onload = =>

        if xhr.status == 200
          # Let the server know that it was uploaded. Important for later when
          # we might want to show users their uploaded attachments, we don't want
          # to show them attachments that were never uploaded correctly.
          @uploaded = true
          params =
            route: "cloud_files/#{data.id}"
            body: this._toJSON()
          Firehose.client.put( this, params ).done ->
            options.success? data.download_url
          .fail (jqXHR, textStatus, errorThrown) ->
            options.error? errorThrown
        else
          options.error? "Your attachment failed to upload successfully, please try again. Please contact support@getfirehose.com if the problem persists and we'll get it fixed for you."

      xhr.onerror = (error) =>
        options.error? "Your attachment failed to upload successfully, please try again. Please contact support@getfirehose.com if the problem persists and we'll get it fixed for you."

      # These have to match what the server does because it's part of the URL signature
      xhr.setRequestHeader 'Content-Type', @file.type
      xhr.setRequestHeader 'x-amz-acl', 'authenticated-read'
      xhr.send @file

    .fail (jqXHR, textStatus, errorThrown) ->
      options.error? errorThrown


  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "downloadURL", json.download_url
    this._setIfNotNull "uploadURL", json.upload_url
    super json


  # @nodoc
  _toJSON: ->
    cloud_file:
      filename: @file.name
      mimetype: @file.type || "application/zip"
      uploaded: @uploaded


