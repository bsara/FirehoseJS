class FirehoseJS.OutgoingAttachment extends FirehoseJS.Object
  
  
  @firehoseType: "OutgoingAttachment"
  
  filename: null
  
  MIMEType: null
  
  token: null
  
  downloadURL: null
  
  uploadURL: null
  
  uploaded: false
  
  file: null
  
    
  @outgoingAttachmentWithFile: (file) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.OutgoingAttachment,
      id:   id
      file: file
    
  
  upload: (completionHandler, errorHandler, progressHandler) ->
    params = 
      route: "companies/#{@id}/outgoing_attachments"
      body: this._toJSON()
    FirehoseJS.client.post( params ).done (data) =>
      
      # Because we can't use jquery exactly, we have to do a bit of tomfoolery
      # to create the xhr object
      xhr = new XMLHttpRequest()
      
      if ("withCredentials" of xhr) 
        xhr.open('PUT', data.upload_url, true)
        
      else if (typeof XDomainRequest != "undefined") 
        xhr = new XDomainRequest()
        xhr.open('PUT', data.upload_url)

      xhr.upload?.addEventListener 'progress', (event) ->
        if event.lengthComputable
          percentComplete = parseInt(event.loaded / event.total * 100, 10)
          if percentComplete >= 95
            progressHandler(95)
          else
            progressHandler(percentComplete)

      # Essentially the 'done' callback, have to check for success
      xhr.onload = =>

        if xhr.status == 200
          # Let the server know that it was uploaded. Important for later when
          # we might want to show users their uploaded attachments, we don't want
          # to show them attachments that were never uploaded correctly.
          params = 
            route: "outgoing_attachments/#{data.id}"
            body: this._toJSON()
          FirehoseJS.client.post( params ).done ->
            completionHandler()
          .fail (jqXHR, textStatus, errorThrown) ->
            errorHandler(errorThrown)
        else
          errorHandler("Your attachment failed to upload successfully, please try again. Please contact support@getfirehose.com if the problem persists and we'll get it fixed for you.")

      # These have to match what the server does because it's part of the URL signature
      xhr.setRequestHeader('Content-Type', @file.type)
      xhr.setRequestHeader('x-amz-acl', 'authenticated-read')
      xhr.send(@file) 
    
    .fail (jqXHR, textStatus, errorThrown) ->
      errorHandler(errorThrown)
    
    
  _toJSON: ->
    outgoing_attachment:
      filename: @filename
      mimetype: @MIMEType
      uploaded: @uploaded