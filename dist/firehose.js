(function(){var e,t,n,r,i,s={}.hasOwnProperty,o=function(e,t){function r(){this.constructor=e}for(var n in t)s.call(t,n)&&(e[n]=t[n]);return r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype,e},u=this;this.Stripe=function(){function e(){}return e.version=2,e.endpoint="https://api.stripe.com/v1",e.setPublishableKey=function(t){e.key=t},e.complete=function(t){return function(n,r,i){var s;if(n!=="success")return s=Math.round((new Date).getTime()/1e3),(new Image).src="http://q.stripe.com?event=stripejs-error&type="+n+"&key="+e.key+"&timestamp="+s,typeof t=="function"?t(500,{error:{code:n,type:n,message:"An unexpected error has occurred submitting your credit\ncard to our secure credit card processor. This may be\ndue to network connectivity issues, so you should try\nagain (you won't be charged twice). If this problem\npersists, please let us know!"}}):void 0}},e}.call(this),e=this.Stripe,this.Stripe.token=function(){function t(){}return t.validate=function(e,t){if(!e)throw t+" required";if(typeof e!="object")throw t+" invalid"},t.formatData=function(t,n){return e.utils.isElement(t)&&(t=e.utils.paramsFromForm(t,n)),e.utils.underscoreKeys(t),t},t.create=function(t,n){return t.key||(t.key=e.key||e.publishableKey),e.utils.validateKey(t.key),e.ajaxJSONP({url:""+e.endpoint+"/tokens",data:t,method:"POST",success:function(e,t){return typeof n=="function"?n(t,e):void 0},complete:e.complete(n),timeout:4e4})},t.get=function(t,n){if(!t)throw"token required";return e.utils.validateKey(e.key),e.ajaxJSONP({url:""+e.endpoint+"/tokens/"+t,data:{key:e.key},success:function(e,t){return typeof n=="function"?n(t,e):void 0},complete:e.complete(n),timeout:4e4})},t}.call(this),this.Stripe.card=function(t){function n(){return n.__super__.constructor.apply(this,arguments)}return o(n,t),n.tokenName="card",n.whitelistedAttrs=["number","cvc","exp_month","exp_year","name","address_line1","address_line2","address_city","address_state","address_zip","address_country"],n.createToken=function(t,r,i){var s;return r==null&&(r={}),e.token.validate(t,"card"),typeof r=="function"?(i=r,r={}):typeof r!="object"&&(s=parseInt(r,10),r={},s>0&&(r.amount=s)),r[n.tokenName]=e.token.formatData(t,n.whitelistedAttrs),e.token.create(r,i)},n.getToken=function(t,n){return e.token.get(t,n)},n.validateCardNumber=function(e){return e=(e+"").replace(/\s+|-/g,""),e.length>=10&&e.length<=16&&n.luhnCheck(e)},n.validateCVC=function(t){return t=e.utils.trim(t),/^\d+$/.test(t)&&t.length>=3&&t.length<=4},n.validateExpiry=function(t,n){var r,i;return t=e.utils.trim(t),n=e.utils.trim(n),/^\d+$/.test(t)?/^\d+$/.test(n)?parseInt(t,10)<=12?(i=new Date(n,t),r=new Date,i.setMonth(i.getMonth()-1),i.setMonth(i.getMonth()+1,1),i>r):!1:!1:!1},n.luhnCheck=function(e){var t,n,r,i,s,o;r=!0,i=0,n=(e+"").split("").reverse();for(s=0,o=n.length;s<o;s++){t=n[s],t=parseInt(t,10);if(r=!r)t*=2;t>9&&(t-=9),i+=t}return i%10===0},n.cardType=function(e){return n.cardTypes[e.slice(0,2)]||"Unknown"},n.cardTypes=function(){var e,t,n,r;t={};for(e=n=40;n<=49;e=++n)t[e]="Visa";for(e=r=50;r<=59;e=++r)t[e]="MasterCard";return t[34]=t[37]="American Express",t[60]=t[62]=t[64]=t[65]="Discover",t[35]="JCB",t[30]=t[36]=t[38]=t[39]="Diners Club",t}(),n}.call(this,this.Stripe.token),this.Stripe.bankAccount=function(t){function n(){return n.__super__.constructor.apply(this,arguments)}return o(n,t),n.tokenName="bank_account",n.whitelistedAttrs=["country","routing_number","account_number"],n.createToken=function(t,r,i){return r==null&&(r={}),e.token.validate(t,"bank account"),typeof r=="function"&&(i=r,r={}),r[n.tokenName]=e.token.formatData(t,n.whitelistedAttrs),e.token.create(r,i)},n.getToken=function(t,n){return e.token.get(t,n)},n.validateRoutingNumber=function(t,r){t=e.utils.trim(t);switch(r){case"US":return/^\d+$/.test(t)&&t.length===9&&n.routingChecksum(t);case"CA":return/\d{5}\-\d{3}/.test(t)&&t.length===9;default:return!0}},n.validateAccountNumber=function(t,n){t=e.utils.trim(t);switch(n){case"US":return/^\d+$/.test(t)&&t.length>=1&&t.length<=17;default:return!0}},n.routingChecksum=function(e){var t,n,r,i,s,o;r=0,t=(e+"").split(""),o=[0,3,6];for(i=0,s=o.length;i<s;i++)n=o[i],r+=parseInt(t[n])*3,r+=parseInt(t[n+1])*7,r+=parseInt(t[n+2]);return r!==0&&r%10===0},n}.call(this,this.Stripe.token),t=["createToken","getToken","cardType","validateExpiry","validateCVC","validateCardNumber"];for(r=0,i=t.length;r<i;r++)n=t[r],this.Stripe[n]=this.Stripe.card[n];typeof module!="undefined"&&module!==null&&(module.exports=this.Stripe),typeof define=="function"&&define("stripe",[],function(){return u.Stripe})}).call(this),function(){var e,t,n,r=[].slice;e=encodeURIComponent,t=(new Date).getTime(),n=function(t,r,i){var s,o;r==null&&(r=[]);for(s in t)o=t[s],i&&(s=""+i+"["+s+"]"),typeof o=="object"?n(o,r,s):r.push(""+s+"="+e(o));return r.join("&").replace(/%20/g,"+")},this.Stripe.ajaxJSONP=function(e){var i,s,o,u,a,f;return e==null&&(e={}),o="sjsonp"+ ++t,a=document.createElement("script"),s=null,i=function(t){var n;return t==null&&(t="abort"),clearTimeout(s),(n=a.parentNode)!=null&&n.removeChild(a),o in window&&(window[o]=function(){}),typeof e.complete=="function"?e.complete(t,f,e):void 0},f={abort:i},a.onerror=function(){return f.abort(),typeof e.error=="function"?e.error(f,e):void 0},window[o]=function(){var t;t=1<=arguments.length?r.call(arguments,0):[],clearTimeout(s),a.parentNode.removeChild(a);try{delete window[o]}catch(n){window[o]=void 0}return typeof e.success=="function"&&e.success.apply(e,t),typeof e.complete=="function"?e.complete("success",f,e):void 0},e.data||(e.data={}),e.data.callback=o,e.method&&(e.data._method=e.method),a.src=e.url+"?"+n(e.data),u=document.getElementsByTagName("head")[0],u.appendChild(a),e.timeout>0&&(s=setTimeout(function(){return f.abort("timeout")},e.timeout)),f}}.call(this),function(){var e=[].indexOf||function(e){for(var t=0,n=this.length;t<n;t++)if(t in this&&this[t]===e)return t;return-1};this.Stripe.utils=function(){function t(){}return t.trim=function(e){return(e+"").replace(/^\s+|\s+$/g,"")},t.underscore=function(e){return(e+"").replace(/([A-Z])/g,function(e){return"_"+e.toLowerCase()}).replace(/-/g,"_")},t.underscoreKeys=function(e){var t,n,r;r=[];for(t in e)n=e[t],delete e[t],r.push(e[this.underscore(t)]=n);return r},t.isElement=function(e){return typeof e!="object"?!1:typeof jQuery!="undefined"&&jQuery!==null&&e instanceof jQuery?!0:e.nodeType===1},t.paramsFromForm=function(t,n){var r,i,s,o,u,a,f,l,c,h;n==null&&(n=[]),typeof jQuery!="undefined"&&jQuery!==null&&t instanceof jQuery&&(t=t[0]),s=t.getElementsByTagName("input"),u=t.getElementsByTagName("select"),a={};for(f=0,c=s.length;f<c;f++){i=s[f],r=this.underscore(i.getAttribute("data-stripe"));if(e.call(n,r)<0)continue;a[r]=i.value}for(l=0,h=u.length;l<h;l++){o=u[l],r=this.underscore(o.getAttribute("data-stripe"));if(e.call(n,r)<0)continue;o.selectedIndex!=null&&(a[r]=o.options[o.selectedIndex].value)}return a},t.validateKey=function(e){if(!e||typeof e!="string")throw new Error("You did not set a valid publishable key. Call Stripe.setPublishableKey() with your publishable key. For more info, see https://stripe.com/docs/stripe.js");if(/\s/g.test(e))throw new Error("Your key is invalid, as it contains whitespace. For more info, see https://stripe.com/docs/stripe.js");if(/^sk_/.test(e))throw new Error("You are using a secret key with Stripe.js, instead of the publishable one. For more info, see https://stripe.com/docs/stripe.js")},t}()}.call(this),function(){var e=[].indexOf||function(e){for(var t=0,n=this.length;t<n;t++)if(t in this&&this[t]===e)return t;return-1};this.Stripe.validator={"boolean":function(e,t){if(t!=="true"&&t!=="false")return"Enter a boolean string (true or false)"},integer:function(e,t){if(!/^\d+$/.test(t))return"Enter an integer"},positive:function(e,t){if(!(!this.integer(e,t)&&parseInt(t,10)>0))return"Enter a positive value"},range:function(t,n){var r;if(r=parseInt(n,10),e.call(t,r)<0)return"Needs to be between "+t[0]+" and "+t[t.length-1]},required:function(e,t){if(e&&(t==null||t===""))return"Required"},year:function(e,t){if(!/^\d{4}$/.test(t))return"Enter a 4-digit year"},birthYear:function(e,t){var n;n=this.year(e,t);if(n)return n;if(parseInt(t,10)>2e3)return"You must be over 18";if(parseInt(t,10)<1900)return"Enter your birth year"},month:function(e,t){if(this.integer(e,t))return"Please enter a month";if(this.range([1,2,3,4,5,6,7,8,9,10,11,12],t))return"Needs to be between 1 and 12"},choices:function(t,n){if(e.call(t,n)<0)return"Not an acceptable value for this field"},email:function(e,t){if(!/^[^@<\s>]+@[^@<\s>]+$/.test(t))return"That doesn't look like an email address"},url:function(e,t){if(!/^https?:\/\/.+\..+/.test(t))return"Not a valid url"},usTaxID:function(e,t){if(!/^\d{2}-?\d{1}-?\d{2}-?\d{4}$/.test(t))return"Not a valid tax ID"},ein:function(e,t){if(!/^\d{2}-?\d{7}$/.test(t))return"Not a valid EIN"},ssnLast4:function(e,t){if(!/^\d{4}$/.test(t))return"Not a valid last 4 digits for an SSN"},ownerPersonalID:function(e,t){var n;n=function(){switch(e){case"CA":return/^\d{3}-?\d{3}-?\d{3}$/.test(t);case"US":return!0}}();if(!n)return"Not a valid ID"},bizTaxID:function(e,t){var n,r,i,s,o,u,a,f;u={CA:["Tax ID",[/^\d{9}$/]],US:["EIN",[/^\d{2}-?\d{7}$/]]},o=u[e];if(o!=null){n=o[0],s=o[1],r=!1;for(a=0,f=s.length;a<f;a++){i=s[a];if(i.test(t)){r=!0;break}}if(!r)return"Not a valid "+n}},zip:function(e,t){var n;n=function(){switch(e.toUpperCase()){case"CA":return/^[\d\w]{6}$/.test(t!=null?t.replace(/\s+/g,""):void 0);case"US":return/^\d{5}$/.test(t)||/^\d{9}$/.test(t)}}();if(!n)return"Not a valid zip"},bankAccountNumber:function(e,t){if(!/^\d{1,17}$/.test(t))return"Invalid bank account number"},usRoutingNumber:function(e){var t,n,r,i,s,o,u;if(!/^\d{9}$/.test(e))return"Routing number must have 9 digits";s=0;for(t=o=0,u=e.length-1;o<=u;t=o+=3)n=parseInt(e.charAt(t),10)*3,r=parseInt(e.charAt(t+1),10)*7,i=parseInt(e.charAt(t+2),10),s+=n+r+i;if(s===0||s%10!==0)return"Invalid routing number"},caRoutingNumber:function(e){if(!/^\d{5}\-\d{3}$/.test(e))return"Invalid transit number"},routingNumber:function(e,t){switch(e.toUpperCase()){case"CA":return this.caRoutingNumber(t);case"US":return this.usRoutingNumber(t)}},phoneNumber:function(e,t){var n;n=t.replace(/[^0-9]/g,"");if(n.length!==10)return"Invalid phone number"},bizDBA:function(e,t){if(!/^.{1,23}$/.test(t))return"Statement descriptors can only have up to 23 characters"},nameLength:function(e,t){if(t.length===1)return"Names need to be longer than one character"}}}.call(this);
/*
This is a module-level docstring, and will be displayed at the top of the module documentation.
Documentation generated by [CoffeeDoc](http://github.com/omarkhan/coffeedoc)
*/

window.FirehoseJS = {};

/*
@param    server [string] The name of the server. Possible values: 'API', 'browser', 'billing', 'frhio', 'marketing', 'settings'
@return   [string] The root url of the server based on the current environement.
@example  Create a URL to the login page of the browser app.
  "#{FirehoseJS.rootFor('browser')/home/login"
*/


FirehoseJS.rootFor = function(server) {
  return FirehoseJS.client.serverAddress(server);
};

/*
@param    service [string] The name of the service. Possible values: 'pusher', 'stripe'
@return   [string] The token/key used for that service's library.
*/


FirehoseJS.tokenFor = function(service) {
  return FirehoseJS.client.serviceToken(service);
};

/*
Used to determine the current environment.
@return [Hash] A hash of all possible environments and only the current environment will be defined. So you can do `FirehoseJS.env.production?` in coffeescript.
*/


FirehoseJS.env = function() {
  return FirehoseJS.client._currentEnvironment();
};

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.UniqueArray = (function(_super) {
  __extends(UniqueArray, _super);

  UniqueArray.prototype._sortOn = null;

  UniqueArray.prototype._sortDirection = 'asc';

  function UniqueArray() {
    UniqueArray.__super__.constructor.apply(this, arguments);
  }

  UniqueArray.prototype.appendObject = function() {
    var arg, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = arguments.length; _i < _len; _i++) {
      arg = arguments[_i];
      if (this.indexOf(arg) === -1) {
        _results.push(this.push(arg));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  UniqueArray.prototype.appendObjects = function(objects) {
    var obj, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = objects.length; _i < _len; _i++) {
      obj = objects[_i];
      _results.push(this.appendObject(obj));
    }
    return _results;
  };

  UniqueArray.prototype.insertObject = function() {
    this.appendObject.apply(this, arguments);
    return this.sortObjects();
  };

  UniqueArray.prototype.insertObjects = function(objects) {
    this.appendObjects(objects);
    return this.sortObjects();
  };

  UniqueArray.prototype.dropObject = function() {
    var arg, idx, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = arguments.length; _i < _len; _i++) {
      arg = arguments[_i];
      idx = this.indexOf(arg);
      if (idx !== -1) {
        _results.push(this.splice(idx, 1));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  UniqueArray.prototype.dropObjects = function(objects) {
    var obj, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = objects.length; _i < _len; _i++) {
      obj = objects[_i];
      _results.push(this.dropObject(obj));
    }
    return _results;
  };

  UniqueArray.prototype.sortOn = function(property, direction) {
    this._sortOn = property;
    return this._sortDirection = direction || 'asc';
  };

  UniqueArray.prototype.sortObjects = function() {
    var _this = this;
    if (this._sortOn == null) {
      return;
    }
    this.sort(function(obj1, obj2) {
      if (obj1[_this._sortOn] > obj2[_this._sortOn]) {
        return 1;
      } else if (obj1[_this._sortOn] < obj2[_this._sortOn]) {
        return -1;
      } else {
        return 0;
      }
    });
    if (this._sortDirection === 'desc') {
      return this.reverse();
    }
  };

  UniqueArray.prototype._toArchivableJSON = function() {
    var archiveArray, obj, _i, _len;
    archiveArray = [];
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      obj = this[_i];
      archiveArray.push(obj._toArchivableJSON());
    }
    return archiveArray;
  };

  return UniqueArray;

})(Array);

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.RemoteArray = (function(_super) {
  __extends(RemoteArray, _super);

  RemoteArray.prototype.perPage = -1;

  RemoteArray.prototype.page = 1;

  RemoteArray.prototype.totalRows = 0;

  RemoteArray.prototype._path = null;

  RemoteArray.prototype._params = null;

  RemoteArray.prototype._creationFunction = null;

  RemoteArray.prototype._fetchingFunction = null;

  RemoteArray.prototype._fresh = true;

  function RemoteArray(path, params, creationFunction) {
    var _this = this;
    this._path = path;
    this._params = params || {};
    this._creationFunction = creationFunction;
    this._fetchingFunction = function(page) {
      var options;
      options = {
        route: _this._path,
        params: _this._params,
        page: page,
        perPage: _this.perPage
      };
      return FirehoseJS.client.get(options).done(function(data) {
        var aggregate, json, object, _i, _len;
        if (data.constructor === Array && data.length > 0) {
          _this.totalRows = data[0].total_rows;
          aggregate = [];
          for (_i = 0, _len = data.length; _i < _len; _i++) {
            json = data[_i];
            object = _this._creationFunction(json);
            object._populateWithJSON(json);
            aggregate.push(object);
          }
          return _this.insertObjects(aggregate);
        }
      });
    };
  }

  RemoteArray.prototype.isAllLoaded = function() {
    return !this._fresh && parseInt(this.length) === parseInt(this.totalRows);
  };

  RemoteArray.prototype.next = function() {
    if (!this._fresh && this.length === this.totalRows) {
      return null;
    }
    this._fresh = false;
    return this._fetchingFunction(this.page++);
  };

  RemoteArray.prototype.empty = function() {
    return this.dropObjects(this.splice(0));
  };

  RemoteArray.prototype.reset = function() {
    this.empty();
    this.totalRows = 0;
    this._fresh = true;
    return this.page = 1;
  };

  return RemoteArray;

})(FirehoseJS.UniqueArray);

FirehoseJS.Client = (function() {
  Client.prototype.APIAccessToken = null;

  Client.prototype.URLToken = null;

  Client.prototype.billingAccessToken = null;

  Client.prototype.env = null;

  Client.prototype.statusCodeHandlers = null;

  function Client() {
    this._firefoxHack();
    this._ensureEnvironment();
  }

  Client.prototype.setEnvironment = function(environment) {
    this.env = environment;
    return Stripe.setPublishableKey(this._environments[this.env]["stripeKey"]);
  };

  Client.prototype.get = function(options) {
    $.extend(options, {
      method: 'GET'
    });
    return this._sendRequest(options);
  };

  Client.prototype.post = function(options) {
    $.extend(options, {
      method: 'POST'
    });
    return this._sendRequest(options);
  };

  Client.prototype.put = function(options) {
    $.extend(options, {
      method: 'PUT'
    });
    return this._sendRequest(options);
  };

  Client.prototype["delete"] = function(options) {
    $.extend(options, {
      method: 'DELETE'
    });
    return this._sendRequest(options);
  };

  Client.prototype.serverAddress = function(server) {
    this._ensureEnvironment();
    return this._environments[this.env]["" + server + "URL"];
  };

  Client.prototype.serviceToken = function(service) {
    this._ensureEnvironment();
    return this._environments[this.env]["" + service + "Key"];
  };

  Client.prototype._sendRequest = function(options) {
    var body, defaults, headers, key, method, page, paramStrings, params, perPage, route, server, url, value;
    this._ensureEnvironment();
    defaults = {
      server: 'API',
      route: '',
      method: 'GET',
      page: -1,
      perPage: -1,
      params: {},
      body: null
    };
    $.extend(defaults, options);
    server = defaults.server;
    route = defaults.route;
    method = defaults.method;
    page = defaults.page;
    perPage = defaults.perPage;
    params = defaults.params;
    body = defaults.body;
    if (page > -1) {
      params["page"] = page;
    }
    if (perPage > -1) {
      params["per_page"] = perPage;
    }
    paramStrings = [];
    for (key in params) {
      value = params[key];
      if (value == null) {
        continue;
      }
      paramStrings.push("" + key + "=" + value);
    }
    url = "" + (this.serverAddress(server)) + "/" + route;
    if (paramStrings.length > 0) {
      url += "?" + (paramStrings.join('&'));
    }
    headers = {
      "Accept": "application/json"
    };
    if ((this.APIAccessToken != null) && server === 'API') {
      $.extend(headers, {
        "Authorization": "Token token=\"" + this.APIAccessToken + "\""
      });
    } else if ((this.billingAccessToken != null) && server === 'billing') {
      $.extend(headers, {
        "Authorization": "Token token=\"" + this.billingAccessToken + "\""
      });
    }
    return $.ajax({
      type: method,
      url: url,
      data: body ? JSON.stringify(body) : void 0,
      processData: false,
      dataType: 'json',
      headers: headers,
      contentType: 'application/json',
      statusCode: this.statusCodeHandlers || {}
    });
  };

  Client.prototype._environments = {
    production: {
      APIURL: "https://api.firehoseapp.com",
      browserURL: "https://firehoseapp.com",
      billingURL: "https://billing.firehoseapp.com",
      frhioURL: "https://frh.io",
      marketingURL: "https://getfirehose.com",
      settingsURL: "https://settings.firehoseapp.com",
      tweetlongerURL: "https://tl.frh.io",
      kbURL: "https://firehosehelp.com",
      stripeKey: "pk_live_CGPaLboKkpr7tqswA4elf8NQ",
      pusherKey: "d3e373f7fac89de7bde8"
    },
    staging: {
      APIURL: "https://api.firehoseapp.com",
      browserURL: "https://staging.firehoseapp.com",
      billingURL: "https://staging.billing.firehoseapp.com",
      frhioURL: "https://frh.io",
      marketingURL: "https://staging.getfirehose.com",
      settingsURL: "https://staging.settings.firehoseapp.com",
      tweetlongerURL: "https://staging.tl.frh.io",
      kbURL: "https://staging.firehosehelp.com",
      stripeKey: "pk_live_CGPaLboKkpr7tqswA4elf8NQ",
      pusherKey: "d3e373f7fac89de7bde8"
    },
    development: {
      APIURL: "http://localhost:3000",
      browserURL: "http://localhost:3001",
      billingURL: "http://localhost:3002",
      frhioURL: "http://localhost:3003",
      marketingURL: "http://localhost:3004",
      settingsURL: "http://localhost:3005",
      tweetlongerURL: "http://localhost:3006",
      kbURL: "http://localhost:3007",
      stripeKey: "pk_test_oIyMNHil987ug1v8owRhuJwr",
      pusherKey: "2f64ac0434cc8a94526e"
    },
    test: {
      APIURL: "http://localhost:3010",
      browserURL: "http://localhost:3011",
      billingURL: "http://localhost:3012",
      frhioURL: "http://localhost:3013",
      marketingURL: "http://localhost:3014",
      settingsURL: "http://localhost:3015",
      tweetlongerURL: "http://localhost:3016",
      kbURL: "http://localhost:3017",
      stripeKey: "pk_test_oIyMNHil987ug1v8owRhuJwr",
      pusherKey: "2f64ac0434cc8a94526e"
    }
  };

  Client.prototype._ensureEnvironment = function() {
    var anchor;
    if (this.env != null) {
      return;
    }
    anchor = document.createElement("a");
    anchor.href = document.URL;
    if (anchor.hostname === "localhost") {
      if (anchor.port[2] === "1") {
        this.setEnvironment("test");
      }
      if (anchor.port[2] === "2") {
        return this.setEnvironment("production");
      } else {
        return this.setEnvironment("development");
      }
    } else if (anchor.hostname.match(/staging/)) {
      return this.setEnvironment('staging');
    } else {
      return this.setEnvironment("production");
    }
  };

  Client.prototype._currentEnvironment = function() {
    this._ensureEnvironment();
    return this.env;
  };

  Client.prototype._firefoxHack = function() {
    var xhrCorsHeaders, _super;
    _super = jQuery.ajaxSettings.xhr;
    xhrCorsHeaders = ["Cache-Control", "Content-Language", "Content-Type", "Expires", "Last-Modified", "Pragma"];
    return jQuery.ajaxSettings.xhr = function() {
      var getAllResponseHeaders, xhr;
      xhr = _super();
      getAllResponseHeaders = xhr.getAllResponseHeaders;
      xhr.getAllResponseHeaders = function() {
        var allHeaders, e;
        allHeaders = "";
        try {
          allHeaders = getAllResponseHeaders.apply(xhr);
          if (allHeaders != null) {
            return allHeaders;
          }
        } catch (_error) {
          e = _error;
        }
        $.each(xhrCorsHeaders, function(i, headerName) {
          if (xhr.getResponseHeader(headerName)) {
            allHeaders += "" + headerName + ": " + (xhr.getResponseHeader(headerName)) + "\n";
          }
          return true;
        });
        return allHeaders;
      };
      return xhr;
    };
  };

  return Client;

})();

FirehoseJS.client = new FirehoseJS.Client;

FirehoseJS.Object = (function() {
  /*
  @property [Number] Unique ID of object
  */

  Object.prototype.id = null;

  /*
  @property [Date] When the object was created on the server
  */


  Object.prototype.createdAt = null;

  /*
  @property [Array<Object>] The static array that holds the entire object graph
  @nodoc
  */


  Object._objects = [];

  /*
  @note You never need to construct a `FirehoseJS.Object` object directly. Use a subclass' factory method.
  @private
  */


  function Object(properties) {
    var prop;
    for (prop in properties) {
      this[prop] = properties[prop];
    }
  }

  /*
  To be overridden by subclasses
  @nodoc
  */


  Object.prototype._setup = function() {};

  /*
  A placeholder for third-party libraries to replace. (e.g Ember.js, Backbone.js)
  @note A client-side library that uses observers often uses get/set methods. You can do `FirehoseJS.Object.set = Ember.Object.set` for example.
  */


  Object.prototype.get = function(key) {
    return this[key];
  };

  /*
  A placeholder for third-party libraries to replace. (e.g Ember.js, Backbone.js)
  @note A client-side library that uses observers often uses get/set methods. You can do `FirehoseJS.Object.get = Ember.Object.get` for example.
  */


  Object.prototype.set = function(key, value) {
    return this[key] = value;
  };

  /*
  Uses the classes 'archivableProperties' to stringify this object and save it in localStorage.
  @param key [string] an optional key to archive the object by if the 'id' is not available.
  */


  Object.prototype.archive = function(key) {
    var index;
    if (key == null) {
      key = this.id;
    }
    index = "" + this.constructor._firehoseType + "_" + key;
    return localStorage[index] = JSON.stringify(this._toArchivableJSON());
  };

  /*
  Unarchives the object from local storage.
  @param key [string] an optional key to unarchive the object by if 'id' is not available.
  @return [boolean] true if the object was in localStorage, false if it was not.
  */


  Object.prototype.unarchive = function(key) {
    var index, json;
    if (key == null) {
      key = this.id;
    }
    index = "" + this.constructor._firehoseType + "_" + key;
    if (localStorage[index] != null) {
      json = $.parseJSON(localStorage[index]);
      this._populateWithJSON(json);
      return true;
    } else {
      return false;
    }
  };

  /*
  Create an object to be cached
  @nodoc
  */


  Object._objectOfClassWithID = function(klass, properties) {
    var obj, parsedID, _i, _len, _ref;
    parsedID = parseInt(properties.id);
    if (!isNaN(parsedID)) {
      properties.id = parsedID;
    }
    if (parsedID) {
      _ref = this._objects;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        obj = _ref[_i];
        if (obj.id && obj.id === parsedID && obj.constructor._firehoseType === klass._firehoseType) {
          return obj;
        }
      }
    }
    obj = new klass(properties);
    obj._setup();
    this._objects.push(obj);
    return obj;
  };

  Object.prototype._populateAssociatedObjects = function(owner, association, json, creation) {
    var aggregate, object, objectJSON, objects, _i, _len;
    if (json != null) {
      objects = new FirehoseJS.UniqueArray;
      owner.set(association, objects);
      aggregate = [];
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        objectJSON = json[_i];
        object = creation(objectJSON);
        object._populateWithJSON(objectJSON);
        aggregate.push(object);
      }
      return objects.insertObjects(aggregate);
    }
  };

  Object.prototype._populateAssociatedObjectWithJSON = function(owner, association, json, creation) {
    var object;
    if (json != null) {
      object = creation(json);
      owner.set(association, object);
      return object._populateWithJSON(json);
    }
  };

  Object.prototype._populateAssociatedObjectWithID = function(owner, association, id, creation) {
    return owner.set(association, id != null ? creation(id) : null);
  };

  Object.prototype._populateWithJSON = function(json) {
    if (this.id == null) {
      this._setIfNotNull("id", json.id);
    }
    if (this.createdAt == null) {
      return this._setIfNotNull("createdAt", Date.parse(json.created_at));
    }
  };

  Object.prototype._setIfNotNull = function(key, value) {
    if (value != null) {
      return this.set(key, value);
    }
  };

  Object.prototype._toArchivableJSON = function() {
    return {
      id: this.id,
      created_at: this.createdAt
    };
  };

  return Object;

})();

var _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.Agent = (function(_super) {
  __extends(Agent, _super);

  function Agent() {
    this._handleSuccessfulLogin = __bind(this._handleSuccessfulLogin, this);
    _ref = Agent.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Agent._firehoseType = "Agent";

  Agent.loggedInAgent = null;

  Agent.prototype.accessToken = null;

  Agent.prototype.URLToken = null;

  Agent.prototype.firstName = null;

  Agent.prototype.lastName = null;

  Agent.prototype.email = null;

  Agent.prototype.currentCompany = null;

  Agent.prototype._password = null;

  Agent.prototype.companies = null;

  Agent.prototype._setup = function() {
    return this.companies = new FirehoseJS.UniqueArray;
  };

  Agent.agentWithAccessToken = function(accessToken) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Agent, {
      accessToken: accessToken
    });
  };

  Agent.agentWithEmailAndPassword = function(email, password) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Agent, {
      email: email,
      _password: password
    });
  };

  Agent.agentWithID = function(id) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Agent, {
      id: id
    });
  };

  /*
  Create a new agent.
  @param firstName [string] The first name of the agent that will be shown in the interace and to customers.
  @param lastName [string] The last name of the agent.
  @param inviteToken [string] If The user is accepting an invite from an email, the invite token will be in the url and you can pass it in here to link this agent to that company when they sign up.
  @return [Promise] a jqXHR Promise.
  */


  Agent.prototype.signUpWithFirstAndLastName = function(firstName, lastName, inviteToken) {
    var params,
      _this = this;
    this._setIfNotNull("firstName", firstName);
    this._setIfNotNull("lastName", lastName);
    params = {
      route: 'agents',
      body: {
        token: inviteToken != null ? inviteToken : void 0,
        agent: {
          email: this.email,
          password: this._password,
          first_name: this.firstName,
          last_name: this.lastName
        }
      }
    };
    return FirehoseJS.client.post(params).done(function(data) {
      _this._populateWithJSON(data);
      return _this._handleSuccessfulLogin();
    });
  };

  /*
  Logs the agent in and stores the access token for all future requests.
  @note If the username and password properties are set, they are used to log in and obtain an access token and populate the agent.
        If no username or password is set, but the accessToken is set, it will login using the access token and populate the agent.
  @return [Promise] A jqXHR Promise.
  */


  Agent.prototype.login = function() {
    var params,
      _this = this;
    if ((this.firstName != null) && this.lastName && (this.email != null)) {
      this._handleSuccessfulLogin();
      return $.Deferred().resolve(this._toArchivableJSON());
    }
    FirehoseJS.client.APIAccessToken = null;
    params = {
      route: 'login'
    };
    if ((this.email != null) && (this._password != null)) {
      params.body = {
        email: this.email,
        password: this._password
      };
    } else if (this.accessToken != null) {
      FirehoseJS.client.APIAccessToken = this.accessToken;
    }
    return FirehoseJS.client.post(params).done(function(data) {
      _this._populateWithJSON(data);
      return _this._handleSuccessfulLogin();
    });
  };

  /*
  Makes no call to the server but simply nulls out all the stored credentials that are used to authenticate requests.
  Any requests made after calling `logout()` on any agent will cause every request that requires authenticattion to fail.
  */


  Agent.prototype.logout = function() {
    this._setIfNotNull("accessToken", null);
    this._setIfNotNull("URLToken", null);
    FirehoseJS.Agent.loggedInAgent = null;
    FirehoseJS.client.APIAccessToken = null;
    FirehoseJS.client.URLToken = null;
    return FirehoseJS.client.billingAccessToken = null;
  };

  /*
  Fetches the latest data about this agent from the server and populates the agent's properties.
  @return [Promise] A jqXHR Promise.
  */


  Agent.prototype.fetch = function() {
    var params,
      _this = this;
    params = {
      route: "agents/" + this.id
    };
    return FirehoseJS.client.get(params).done(function(data) {
      _this._populateWithJSON(data);
      return _this._handleSuccessfulLogin();
    });
  };

  /*
  Persists all properties that can be saved to the server.
  @return [Promise] A jqXHR Promise.
  */


  Agent.prototype.save = function() {
    var params;
    params = {
      route: "agents/" + this.id,
      body: this._toJSON()
    };
    return FirehoseJS.client.put(params);
  };

  /*
  Deletes this agent from the server.
  @note The logic of what this does is somewhat complex. The rules are: Every company this agent belongs to where this is the only agent the company has will be destroyed
        with the agent. Any company this agent belongs to that has other agents will not be destroyed and if the agent was the company's owner, the agent will still be 
        destroyed and a new owner will be selected from remaining agents at random.
  @return [Promise] A jqXHR Promise.
  */


  Agent.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "agents/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      var company, _i, _len, _ref1, _results;
      _ref1 = _this.companies;
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        company = _ref1[_i];
        _results.push(company.agents.dropObject(_this));
      }
      return _results;
    });
  };

  Agent.prototype.dismissNotifications = function(notifications) {
    var ids, notification, params, _i, _len;
    ids = [];
    for (_i = 0, _len = notifications.length; _i < _len; _i++) {
      notification = notifications[_i];
      ids.push(notification.id);
    }
    params = {
      route: "agents/" + this.id + "/notifications/" + (ids.join(','))
    };
    return FirehoseJS.client.put(params);
  };

  Agent.requestPasswordReset = function(email) {
    var params;
    params = {
      route: "request_reset_password",
      body: {
        email: email
      }
    };
    return FirehoseJS.client.post(params);
  };

  Agent.resetPassword = function(token, newPassword) {
    var params;
    params = {
      route: "reset_password",
      body: {
        token: token,
        password: newPassword
      }
    };
    return FirehoseJS.client.post(params);
  };

  Agent.prototype.setNewPassword = function(newPassword) {
    return this._setIfNotNull("_password", newPassword);
  };

  Agent.prototype.fullName = function() {
    return "" + this.firstName + " " + this.lastName;
  };

  /*
  The agents gravatar given their email address.
  @return [string] the url of the agent's gravatar.
  */


  Agent.prototype.gravatarURL = function() {
    var e, hashedEmail;
    if (this.email) {
      e = this.email.trim().toLowerCase();
      hashedEmail = md5(e);
    }
    return "https://www.gravatar.com/avatar/" + hashedEmail + "?d=identicon";
  };

  Agent.prototype._handleSuccessfulLogin = function() {
    FirehoseJS.client.APIAccessToken = this.accessToken;
    FirehoseJS.client.URLToken = this.URLToken;
    return FirehoseJS.Agent.loggedInAgent = this;
  };

  Agent.prototype._populateWithJSON = function(json) {
    var _this = this;
    if (this.accessToken == null) {
      this._setIfNotNull("accessToken", json.access_token);
    }
    if (this.URLToken == null) {
      this._setIfNotNull("URLToken", json.url_token);
    }
    this._setIfNotNull("firstName", json.first_name);
    this._setIfNotNull("lastName", json.last_name);
    this._setIfNotNull("email", json.email);
    this._populateAssociatedObjects(this, "companies", json.companies, function(json) {
      return FirehoseJS.Company.companyWithID(json.id, _this);
    });
    if (this.companies.length > 0 && (this.currentCompany == null)) {
      this._setIfNotNull("currentCompany", this.companies[0]);
    }
    return Agent.__super__._populateWithJSON.call(this, json);
  };

  Agent.prototype._toJSON = function() {
    return {
      agent: {
        first_name: this.firstName,
        last_name: this.lastName,
        email: this.email,
        password: this._password != null ? this._password : void 0
      }
    };
  };

  Agent.prototype._toArchivableJSON = function() {
    var _ref1;
    return $.extend(Agent.__super__._toArchivableJSON.call(this), {
      access_token: this.accessToken,
      url_token: this.URLToken,
      first_name: this.firstName,
      last_name: this.lastName,
      email: this.email,
      password: this._password != null ? this._password : void 0,
      companies: (_ref1 = this.companies) != null ? _ref1._toArchivableJSON() : void 0
    });
  };

  return Agent;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.Company = (function(_super) {
  __extends(Company, _super);

  function Company() {
    _ref = Company.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Company._firehoseType = "Company";

  Company.prototype.title = null;

  Company.prototype.token = null;

  Company.prototype.lastFetchAt = null;

  Company.prototype.fetchAutomatically = true;

  Company.prototype.forwardingEmailAddress = null;

  Company.prototype.knowledgeBaseSubdomain = null;

  Company.prototype.unresolvedCount = 0;

  Company.prototype.numberOfAccounts = 0;

  Company.prototype.agents = null;

  Company.prototype.agentInvites = null;

  Company.prototype.tags = null;

  Company.prototype.cannedResponses = null;

  Company.prototype._customers = null;

  Company.prototype._notifications = null;

  Company.prototype._twitterAccounts = null;

  Company.prototype._facebookAccounts = null;

  Company.prototype._emailAccounts = null;

  Company.prototype._articles = null;

  Company.prototype.creditCard = null;

  Company.prototype.billingEmail = null;

  Company.prototype.billingRate = 8.0;

  Company.prototype.trialExpirationDate = null;

  Company.prototype.nextBillingDate = null;

  Company.prototype.isGracePeriodOver = false;

  Company.prototype.daysLeftInGracePeriod = -1;

  Company.prototype.isCurrent = false;

  Company.prototype.hasSuccessfulBilling = false;

  Company.prototype._creator = null;

  Company.prototype._setup = function() {
    this.agents = new FirehoseJS.UniqueArray;
    this.agentInvites = new FirehoseJS.UniqueArray;
    this.tags = new FirehoseJS.UniqueArray;
    this.cannedResponses = new FirehoseJS.UniqueArray;
    this.agents.sortOn("firstName");
    this.tags.sortOn("label");
    return this.cannedResponses.sortOn("name");
  };

  Company.companyWithTitle = function(title, creator) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Company, {
      title: title,
      _creator: creator
    });
  };

  Company.companyWithID = function(id, creator) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Company, {
      id: id,
      _creator: creator
    });
  };

  Company.prototype.fetch = function() {
    var params,
      _this = this;
    params = {
      route: "companies/" + this.id
    };
    return FirehoseJS.client.get(params).done(function(data) {
      return _this._populateWithJSON(data);
    });
  };

  Company.prototype.save = function() {
    var params,
      _this = this;
    if (this.id != null) {
      params = {
        route: "companies/" + this.id,
        body: this._toJSON()
      };
      return FirehoseJS.client.put(params);
    } else {
      params = {
        route: "agents/" + this._creator.id + "/companies",
        body: this._toJSON()
      };
      return FirehoseJS.client.post(params).done(function(data) {
        return _this._populateWithJSON(data);
      });
    }
  };

  Company.prototype.forceChannelsFetch = function() {
    var params;
    params = {
      route: "companies/" + this.id + "/force_channels_fetch"
    };
    return FirehoseJS.client.put(params);
  };

  Company.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "companies/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return FirehoseJS.Agent.loggedInAgent.companies.dropObject(_this);
    });
  };

  Company.prototype.customersWithCriteria = function(criteria) {
    var customers, params,
      _this = this;
    if (criteria == null) {
      criteria = {};
    }
    params = {
      filter: (criteria.everything != null) && criteria.everything ? "everything" : "unresolved",
      channel: criteria.channels != null ? criteria.channels.join(",") : void 0,
      sort: criteria.sort != null ? criteria.sort : "newest_first",
      search_text: criteria.searchString ? encodeURIComponent(criteria.searchString) : void 0
    };
    customers = new FirehoseJS.RemoteArray("companies/" + this.id + "/customers", params, function(json) {
      return FirehoseJS.Customer.customerWithID(json.id, _this);
    });
    if (params.sort === 'newest_first') {
      customers.sortOn("newestInteractionReceivedAt", "desc");
    } else {
      customers.sortOn("newestInteractionReceivedAt", "asc");
    }
    return customers;
  };

  Company.prototype.notifications = function() {
    var _this = this;
    if (this._notifications == null) {
      this._setIfNotNull("_notifications", new FirehoseJS.RemoteArray("companies/" + this.id + "/notifications", null, function(json) {
        return FirehoseJS.Notification._notificationWithID(json.id, _this);
      }));
      this._notifications.sortOn("title");
    }
    return this._notifications;
  };

  Company.prototype.twitterAccounts = function() {
    var _this = this;
    if (this._twitterAccounts == null) {
      this._setIfNotNull("_twitterAccounts", new FirehoseJS.RemoteArray("companies/" + this.id + "/twitter_accounts", null, function(json) {
        return FirehoseJS.TwitterAccount._twitterAccountWithID(json.id, _this);
      }));
      this._twitterAccounts.sortOn("screenName");
    }
    return this._twitterAccounts;
  };

  Company.prototype.facebookAccounts = function() {
    var _this = this;
    if (this._facebookAccounts == null) {
      this._setIfNotNull("_facebookAccounts", new FirehoseJS.RemoteArray("companies/" + this.id + "/facebook_accounts", null, function(json) {
        return FirehoseJS.FacebookAccount._facebookAccountWithID(json.id, _this);
      }));
      this._facebookAccounts.sortOn("name");
    }
    return this._facebookAccounts;
  };

  Company.prototype.emailAccounts = function() {
    var _this = this;
    if (this._emailAccounts == null) {
      this._setIfNotNull("_emailAccounts", new FirehoseJS.RemoteArray("companies/" + this.id + "/email_accounts", null, function(json) {
        return FirehoseJS.EmailAccount._emailAccountWithID(json.id, _this);
      }));
      this._emailAccounts.sortOn("username");
    }
    return this._emailAccounts;
  };

  Company.prototype.articles = function() {
    var _this = this;
    if (this._articles == null) {
      this._setIfNotNull("_articles", new FirehoseJS.RemoteArray("companies/" + this.id + "/articles", null, function(json) {
        return FirehoseJS.Article.articleWithID(json.id, _this);
      }));
      this._articles.sortOn("title");
    }
    return this._articles;
  };

  Company.prototype.addAgent = function(agent) {
    var params,
      _this = this;
    params = {
      route: "companies/" + this.id + "/agents/" + agent.id
    };
    return FirehoseJS.client.put(params).done(function() {
      return _this.agents.insertObject(agent);
    });
  };

  Company.prototype.removeAgent = function(agent) {
    var params,
      _this = this;
    params = {
      route: "companies/" + this.id + "/agents/" + agent.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.agents.dropObject(agent);
    });
  };

  Company.prototype.fetchBillingInfo = function() {
    var fetchBlock,
      _this = this;
    fetchBlock = function() {
      var params;
      FirehoseJS.client.billingAccessToken = _this.token;
      params = {
        server: "billing",
        route: "entities/" + _this.id
      };
      return FirehoseJS.client.get(params).done(function(json) {
        if (json.credit_card != null) {
          _this._setIfNotNull("creditCard", FirehoseJS.CreditCard.creditCardWithID(json.credit_card.id, _this));
          _this.creditCard._populateWithJSON(json.credit_card);
        }
        _this._setIfNotNull("billingEmail", json.email || FirehoseJS.Agent.loggedInAgent.email);
        _this._setIfNotNull("billingRate", json.rate / 100.0);
        return _this._setIfNotNull("trialExpirationDate", Date.parse(json.free_trial_expiration_date || new Date(+(new Date) + 12096e5)));
      });
    };
    if (this.token) {
      return fetchBlock();
    } else {
      return this.fetch().then(function() {
        return fetchBlock();
      });
    }
  };

  Company.prototype._populateWithJSON = function(json) {
    var _this = this;
    this._setIfNotNull("title", json.title);
    if (this.token == null) {
      this._setIfNotNull("token", json.token);
    }
    this._setIfNotNull("fetchAutomatically", json.fetch_automatically);
    this._setIfNotNull("lastFetchAt", json.last_fetch_at);
    if (this.forwardingEmailAddress == null) {
      this._setIfNotNull("forwardingEmailAddress", json.forwarding_email);
    }
    this._setIfNotNull("knowledgeBaseSubdomain", json.kb_subdomain);
    this._setIfNotNull("unresolvedCount", json.unresolved_count);
    this._setIfNotNull("numberOfAccounts", json.number_of_accounts);
    this._populateAssociatedObjects(this, "agents", json.agents, function(json) {
      var agent;
      agent = FirehoseJS.Agent.agentWithID(json.id);
      agent.companies.insertObject(_this);
      return agent;
    });
    this._populateAssociatedObjects(this, "agentInvites", json.agent_invites, function(json) {
      return FirehoseJS.AgentInvite._agentInviteWithID(json.id, _this);
    });
    this._populateAssociatedObjects(this, "tags", json.tags, function(json) {
      return FirehoseJS.Tag._tagWithID(json.id, _this);
    });
    this._populateAssociatedObjects(this, "cannedResponses", json.canned_responses, function(json) {
      return FirehoseJS.CannedResponse._cannedResponseWithID(json.id, _this);
    });
    FirehoseJS.client.billingAccessToken = this.token;
    return Company.__super__._populateWithJSON.call(this, json);
  };

  Company.prototype._toJSON = function() {
    return {
      company: {
        title: this.title,
        fetch_automatically: this.fetchAutomatically
      }
    };
  };

  Company.prototype._toArchivableJSON = function() {
    return $.extend(Company.__super__._toArchivableJSON.call(this), {
      title: this.title,
      token: this.token,
      fetch_automatically: this.fetchAutomatically,
      last_fetch_at: this.lastFetchAt,
      forwarding_email: this.forwardingEmailAddress,
      kb_subdomain: this.knowledgeBaseSubdomain,
      unresolved_count: this.unresolvedCount,
      number_of_accounts: this.numberOfAccounts,
      agent_invites: this.agentInvites._toArchivableJSON(),
      tags: this.tags._toArchivableJSON(),
      canned_responses: this.cannedResponses._toArchivableJSON()
    });
  };

  return Company;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.Interaction = (function(_super) {
  __extends(Interaction, _super);

  function Interaction() {
    _ref = Interaction.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Interaction._firehoseType = "Interaction";

  Interaction.prototype.customer = null;

  Interaction.prototype.token = null;

  Interaction.prototype.responseDraft = null;

  Interaction.prototype.happiness = null;

  Interaction.prototype.resolved = false;

  Interaction.prototype.body = null;

  Interaction.prototype.privateURL = null;

  Interaction.prototype.channel = null;

  Interaction.prototype.receivedAt = null;

  Interaction.prototype.customerAccount = null;

  Interaction.prototype.agent = null;

  Interaction.prototype.originalInteraction = null;

  Interaction.prototype.responseInteractions = null;

  Interaction.prototype.notes = null;

  Interaction.prototype.tags = null;

  Interaction.prototype.flaggedAgents = null;

  Interaction.prototype._setup = function() {
    this.responseInteractions = new FirehoseJS.UniqueArray;
    this.notes = new FirehoseJS.UniqueArray;
    this.tags = new FirehoseJS.UniqueArray;
    this.flaggedAgents = new FirehoseJS.UniqueArray;
    this.responseInteractions.sortOn("receivedAt");
    this.notes.sortOn("createdAt");
    this.tags.sortOn("label");
    return this.flaggedAgents.sortOn("firstName");
  };

  /*
  Used to create a generic interaction that can then be fetched, without authentication, by the token.
  @param token [string] 
  @note: Any interactions is publicly visible with a token.
  @return [Interaction] a generic interaction object.
  */


  Interaction.interactionWithToken = function(token) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Interaction, {
      token: token
    });
  };

  Interaction._interactionWithJSON = function(json, customer) {
    var interaction;
    interaction = null;
    if (json.channel === "twitter") {
      interaction = FirehoseJS.TwitterInteraction._twitterInteractionWithID(json.id);
    } else if (json.channel === "facebook") {
      interaction = FirehoseJS.FacebookInteraction._facebookInteractionWithID(json.id);
    } else if (json.channel === "email") {
      interaction = FirehoseJS.EmailInteraction._emailInteractionWithID(json.id);
    }
    interaction._setCustomer(customer);
    interaction._populateWithJSON(json);
    return interaction;
  };

  Interaction.prototype.subject = function() {
    if (this.constructor._firehoseType === "EmailInteraction") {
      return this.emailSubject;
    } else if (this.constructor._firehoseType === "TwitterInteraction") {
      if (this.inReplyToScreenName) {
        return "Reply to " + this.inReplyToScreenName;
      } else {
        return "Mention of " + this.toScreenName;
      }
    } else if (this.constructor._firehoseType === "FacebookInteraction") {
      return this.type[0].toUpperCase() + this.type.slice(1);
    }
  };

  Interaction.prototype.reply = function() {
    var body, params,
      _this = this;
    body = {
      interaction: {
        body: this.responseDraft
      }
    };
    params = {
      route: "interactions/" + this.id + "/reply",
      body: body
    };
    return FirehoseJS.client.post(params).done(function(data) {
      var response;
      _this._setIfNotNull("responseDraft", null);
      response = FirehoseJS.Interaction._interactionWithJSON(data, _this.customer);
      _this.responseInteractions.insertObject(response);
      response._setIfNotNull("agent", FirehoseJS.Agent.loggedInAgent);
      return _this.responseInteractions.sort(function(interaction1, interaction2) {
        return interaction1.createdAt > interaction2.createdAt;
      });
    });
  };

  Interaction.prototype.save = function() {
    var params;
    params = {
      route: "interactions/" + this.id,
      body: this._toJSON()
    };
    return FirehoseJS.client.put(params);
  };

  /*
  Fetches the latest data from the server and populates the object's properties with it.
  @note: If an id is used, an access token is required and you will a more comprehensive JSON object in return. If no id is present, but a token is, it will fetch without authentication.
  @return [Promise] a jqXHR Promise
  */


  Interaction.prototype.fetch = function() {
    var params,
      _this = this;
    params = {
      route: "interactions/" + (this.token || this.id)
    };
    return FirehoseJS.client.get(params).done(function(data) {
      return _this._populateWithJSON(data);
    });
  };

  Interaction.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "interactions/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.customer.interactions().dropObject(_this);
    });
  };

  Interaction.prototype.addTag = function(tag) {
    var params,
      _this = this;
    params = {
      route: "interactions/" + this.id + "/tags/" + tag.id
    };
    return FirehoseJS.client.put(params).done(function() {
      return _this.tags.insertObject(tag);
    });
  };

  Interaction.prototype.removeTag = function(tag) {
    var params,
      _this = this;
    params = {
      route: "interactions/" + this.id + "/tags/" + tag.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.tags.dropObject(tag);
    });
  };

  Interaction.prototype.flagAgent = function(agent) {
    var params,
      _this = this;
    params = {
      route: "interactions/" + this.id + "/agents/" + agent.id
    };
    return FirehoseJS.client.put(params).done(function() {
      return _this.flaggedAgents.insertObject(agent);
    });
  };

  Interaction.prototype.unflagAgent = function(agent) {
    var params,
      _this = this;
    params = {
      route: "interactions/" + this.id + "/agents/" + agent.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.flaggedAgents.dropObject(agent);
    });
  };

  Interaction.prototype.happinessString = function() {
    if (this.happiness === 0) {
      return "Upset";
    } else if (this.happiness === 1) {
      return "Satisfied";
    } else if (this.happiness === 2) {
      return "Happy";
    }
  };

  Interaction.prototype._setCustomer = function(customer) {
    return this._setIfNotNull("customer", customer);
  };

  Interaction.prototype._populateWithJSON = function(json) {
    var _this = this;
    if (this.token == null) {
      this._setIfNotNull("token", json.token);
    }
    this._setIfNotNull("body", json.body);
    this._setIfNotNull("responseDraft", json.response_draft);
    this._setIfNotNull("channel", json.channel);
    this._setIfNotNull("receivedAt", Date.parse(json.received_at));
    this._setIfNotNull("privateURL", json.private_url);
    this._setIfNotNull("happiness", json.happiness);
    this._setIfNotNull("resolved", json.resolved);
    this._populateAssociatedObjectWithJSON(this, "agent", json.agent, function(json) {
      return FirehoseJS.Agent.agentWithID(json.id);
    });
    this._populateAssociatedObjectWithJSON(this, "customerAccount", json.customer_account, function(json) {
      json.channel = _this.channel;
      return FirehoseJS.CustomerAccount._customerAccountWithID(json.id, _this.customer);
    });
    this._populateAssociatedObjects(this, "responseInteractions", json.response_interactions, function(json) {
      var interaction;
      json.channel = _this.channel;
      interaction = FirehoseJS.Interaction._interactionWithJSON(json, _this.customer);
      return interaction.set('originalInteraction', _this);
    });
    this._populateAssociatedObjects(this, "notes", json.notes, function(json) {
      return FirehoseJS.Note._noteWithID(json.id, _this);
    });
    this._populateAssociatedObjects(this, "tags", json.tags, function(json) {
      return FirehoseJS.Tag._tagWithID(json.id, _this.customer.company);
    });
    this._populateAssociatedObjects(this, "flaggedAgents", json.flagged_agents, function(json) {
      return FirehoseJS.Agent.agentWithID(json.id);
    });
    return Interaction.__super__._populateWithJSON.call(this, json);
  };

  Interaction.prototype._toJSON = function() {
    return {
      interaction: {
        resolved: this.resolved,
        response_draft: this.responseDraft
      }
    };
  };

  return Interaction;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.AgentInvite = (function(_super) {
  __extends(AgentInvite, _super);

  function AgentInvite() {
    _ref = AgentInvite.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  AgentInvite._firehoseType = "AgentInvite";

  AgentInvite.prototype.toEmail = null;

  AgentInvite.prototype.company = null;

  AgentInvite.agentInviteWithEmail = function(email, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.AgentInvite, {
      toEmail: email,
      company: company
    });
  };

  AgentInvite._agentInviteWithID = function(id, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.AgentInvite, {
      id: id,
      company: company
    });
  };

  AgentInvite.prototype.save = function() {
    var params,
      _this = this;
    params = {
      route: "companies/" + this.company.id + "/agent_invites",
      body: this._toJSON()
    };
    return FirehoseJS.client.post(params).done(function(data) {
      _this._populateWithJSON(data);
      return _this.company.agentInvites.insertObject(_this);
    });
  };

  AgentInvite.prototype.resend = function() {
    var params;
    params = {
      route: "agent_invites/" + this.id + "/resend"
    };
    return FirehoseJS.client.put(params);
  };

  AgentInvite.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "agent_invites/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.company.agentInvites.dropObject(_this);
    });
  };

  AgentInvite.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("email", json.email);
    return AgentInvite.__super__._populateWithJSON.call(this, json);
  };

  AgentInvite.prototype._toJSON = function() {
    return {
      agent_invite: {
        email: this.toEmail
      }
    };
  };

  AgentInvite.prototype._toArchivableJSON = function() {
    return $.extend(AgentInvite.__super__._toArchivableJSON.call(this), {
      email: this.toEmail
    });
  };

  return AgentInvite;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.Attachment = (function(_super) {
  __extends(Attachment, _super);

  function Attachment() {
    _ref = Attachment.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Attachment._firehoseType = "Attachment";

  Attachment.prototype.emailInteraction = null;

  Attachment.prototype.filename = null;

  Attachment.prototype.temporaryURL = null;

  Attachment._attachmentWithID = function(id, emailInteraction) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Attachment, {
      id: id,
      emailInteraction: emailInteraction
    });
  };

  Attachment.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("filename", json.filename);
    this._setIfNotNull("temporaryURL", json.temporary_url);
    return Attachment.__super__._populateWithJSON.call(this, json);
  };

  return Attachment;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.CannedResponse = (function(_super) {
  __extends(CannedResponse, _super);

  function CannedResponse() {
    _ref = CannedResponse.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  CannedResponse._firehoseType = "CannedResponse";

  /*
  @property [Comany] The company this canned response belongs to.
  */


  CannedResponse.prototype.company = null;

  /*
  @property [string] The name of this canned response.
  */


  CannedResponse.prototype.name = null;

  /*
  @property [string] A string used for providing a fast shortcut that expands to the full canned response.
  @deprecated
  */


  CannedResponse.prototype.shortcut = null;

  /*
  @property [string] The actual text of the canned response.
  */


  CannedResponse.prototype.text = null;

  /*
  The designated method of creating a new canned response.  
  @param name [string] The short display name
  @param text [string] The actual text of the canned response
  @param company [Company] The company this canned response will belong to once saved to the server.
  */


  CannedResponse.cannedResponseWithNameAndText = function(name, text, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.CannedResponse, {
      name: name,
      text: text,
      company: company
    });
  };

  CannedResponse._cannedResponseWithID = function(id, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.CannedResponse, {
      id: id,
      company: company
    });
  };

  /*
  Save the canned response to the server.
  @return [Promise] A jqXHR Promise.
  @note If it has never been saved, it creates it on the server. Otherwise it updates it.
  @example Creating and saving a canned response.
    cannedResponse = FirehoseJS.CannedResponse.cannedResponseWithNameAndText "Name", "Canned Response", company
    cannedResponse.save().done ->
      console.log "saved!"
  */


  CannedResponse.prototype.save = function() {
    var params,
      _this = this;
    if (this.id != null) {
      params = {
        route: "canned_responses/" + this.id,
        body: this._toJSON()
      };
      return FirehoseJS.client.put(params);
    } else {
      params = {
        route: "companies/" + this.company.id + "/canned_responses",
        body: this._toJSON()
      };
      return FirehoseJS.client.post(params).done(function(data) {
        _this._populateWithJSON(data);
        return _this.company.cannedResponses.insertObject(_this);
      });
    }
  };

  /*
  Destroy this canned response from the server.
  @return [Promise] A jqXHR Promise.
  */


  CannedResponse.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "canned_responses/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.company.cannedResponses.dropObject(_this);
    });
  };

  CannedResponse.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("name", json.name);
    this._setIfNotNull("shortcut", json.shortcut);
    this._setIfNotNull("text", json.text);
    return CannedResponse.__super__._populateWithJSON.call(this, json);
  };

  CannedResponse.prototype._toJSON = function() {
    return {
      canned_response: {
        name: this.name,
        shortcut: this.shortcut,
        text: this.text
      }
    };
  };

  CannedResponse.prototype._toArchivableJSON = function() {
    return $.extend(CannedResponse.__super__._toArchivableJSON.call(this), {
      name: this.name,
      shortcut: this.shortcut,
      text: this.text
    });
  };

  return CannedResponse;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.CreditCard = (function(_super) {
  __extends(CreditCard, _super);

  function CreditCard() {
    _ref = CreditCard.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  CreditCard._firehoseType = "CreditCard";

  CreditCard.prototype.company = null;

  CreditCard.prototype.number = null;

  CreditCard.prototype.cvc = null;

  CreditCard.prototype.expirationMonth = null;

  CreditCard.prototype.expirationYear = null;

  CreditCard.prototype.lastFour = null;

  CreditCard.prototype.stripeToken = null;

  CreditCard.prototype.email = null;

  CreditCard.creditCardWithNumber = function(number, cvc, expMonth, expYear, email, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.CreditCard, {
      number: number,
      cvc: cvc,
      expirationMonth: expMonth,
      expirationYear: expYear,
      email: email,
      company: company
    });
  };

  CreditCard.creditCardWithID = function(id, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.CreditCard, {
      id: id,
      company: company
    });
  };

  CreditCard.prototype.submitToStripe = function(callback) {
    var _this = this;
    return Stripe.card.createToken({
      number: this.number,
      cvc: this.cvc,
      exp_month: this.expirationMonth,
      exp_year: this.expirationYear
    }, function(status, response) {
      if (!response.error) {
        _this._setIfNotNull("expirationMonth", response.card.exp_month);
        _this._setIfNotNull("expirationYear", response.card.exp_year);
        _this._setIfNotNull("lastFour", response.card.last4);
        _this._setIfNotNull("stripeToken", response.id);
        _this._setIfNotNull("email", FirehoseJS.Agent.loggedInAgent.email);
        return callback();
      } else {
        return callback(status, response);
      }
    });
  };

  CreditCard.prototype.save = function() {
    var params;
    FirehoseJS.client.billingAccessToken = this.company.token;
    params = {
      server: "billing",
      route: "entities/" + this.company.id + "/credit_card",
      body: this._toJSON()
    };
    return FirehoseJS.client.put(params);
  };

  CreditCard.prototype.fetch = function() {
    var params,
      _this = this;
    FirehoseJS.client.billingAccessToken = this.company.token;
    params = {
      server: "billing",
      route: "entities/" + this.company.id + "/credit_card"
    };
    return FirehoseJS.client.get(params).done(function(data) {
      return _this._populateWithJSON(data);
    });
  };

  CreditCard.prototype.destroy = function() {
    var params,
      _this = this;
    FirehoseJS.client.billingAccessToken = this.company.token;
    params = {
      server: "billing",
      route: "entities/" + this.company.id + "/credit_card"
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.company.set('creditCard', null);
    });
  };

  CreditCard.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("expirationMonth", json.expiration_month);
    this._setIfNotNull("expirationYear", json.expiration_year);
    this._setIfNotNull("lastFour", json.last_four);
    return CreditCard.__super__._populateWithJSON.call(this, json);
  };

  CreditCard.prototype._toJSON = function() {
    return {
      credit_card: {
        expiration_month: this.expirationMonth,
        expiration_year: this.expirationYear,
        last_four: this.lastFour,
        stripe_token: this.stripeToken,
        email: this.email
      }
    };
  };

  return CreditCard;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.Customer = (function(_super) {
  __extends(Customer, _super);

  function Customer() {
    _ref = Customer.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Customer._firehoseType = "Customer";

  Customer.prototype.company = null;

  Customer.prototype.name = null;

  Customer.prototype.location = null;

  Customer.prototype.timeZone = null;

  Customer.prototype.newestInteractionId = null;

  Customer.prototype.newestInteractionExcerpt = null;

  Customer.prototype.newestInteractionReceivedAt = null;

  Customer.prototype.agentWithDibs = null;

  Customer.prototype.customerAccounts = null;

  Customer.prototype.customerFlaggedAgents = null;

  Customer.prototype._interactions = null;

  Customer.prototype._setup = function() {
    this.customerAccounts = new FirehoseJS.UniqueArray;
    this.customerFlaggedAgents = new FirehoseJS.UniqueArray;
    return this.customerFlaggedAgents.sortOn("firstName");
  };

  Customer.customerWithID = function(id, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Customer, {
      id: id,
      company: company
    });
  };

  Customer.prototype.fetch = function() {
    var params,
      _this = this;
    params = {
      route: "customers/" + this.id
    };
    return FirehoseJS.client.get(params).done(function(data) {
      return _this._populateWithJSON(data);
    });
  };

  Customer.prototype.resolveAllInteractions = function() {
    var params;
    params = {
      route: "customers/" + this.id + "/resolve_all_interactions"
    };
    return FirehoseJS.client.put(params);
  };

  Customer.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "customers/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      var _ref1;
      return (_ref1 = _this.company._customers) != null ? _ref1.dropObject(_this) : void 0;
    });
  };

  Customer.prototype.interactions = function() {
    var _this = this;
    if (this._interactions == null) {
      this._setIfNotNull("_interactions", new FirehoseJS.RemoteArray("customers/" + this.id + "/interactions", null, function(json) {
        return FirehoseJS.Interaction._interactionWithJSON(json, _this);
      }));
      this._interactions.sortOn("receivedAt");
    }
    return this._interactions;
  };

  Customer.prototype._populateWithJSON = function(json) {
    var _this = this;
    this._setIfNotNull("name", json.name);
    this._setIfNotNull("location", json.location);
    this._setIfNotNull("timeZone", json.time_zone);
    this._setIfNotNull("newestInteractionId", json.newest_interaction_id);
    this._setIfNotNull("newestInteractionExcerpt", json.newest_interaction_excerpt);
    this._setIfNotNull("newestInteractionReceivedAt", Date.parse(json.newest_interaction_received_at));
    this._populateAssociatedObjects(this, "customerAccounts", json.customer_accounts, function(json) {
      return FirehoseJS.CustomerAccount._customerAccountWithID(json.id, _this);
    });
    this._populateAssociatedObjects(this, "interactionFlaggedAgents", json.interaction_flagged_agents, function(json) {
      return FirehoseJS.Agent.agentWithID(json.id);
    });
    this._populateAssociatedObjectWithJSON(this, "agentWithDibs", json.agent_with_dibs, function(json) {
      return FirehoseJS.Agent.agentWithID(json.id);
    });
    return Customer.__super__._populateWithJSON.call(this, json);
  };

  return Customer;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.CustomerAccount = (function(_super) {
  __extends(CustomerAccount, _super);

  function CustomerAccount() {
    _ref = CustomerAccount.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  CustomerAccount._firehoseType = "CustomerAccount";

  CustomerAccount.prototype.customer = null;

  CustomerAccount.prototype.username = null;

  CustomerAccount.prototype.followingUs = null;

  CustomerAccount.prototype.imageURL = null;

  CustomerAccount.prototype.description = null;

  CustomerAccount.prototype.followersCount = null;

  CustomerAccount.prototype.channel = null;

  CustomerAccount._customerAccountWithID = function(id, customer) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.CustomerAccount, {
      id: id,
      customer: customer
    });
  };

  /*
  The customer account's avatar URL.
  @return [string] the url of the customer's avatar.
  */


  CustomerAccount.prototype.avatarURL = function() {
    var e, hashedEmail;
    if (this.imageURL) {
      return this.imageURL;
    }
    if (this.username.match(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i)) {
      e = this.username.trim().toLowerCase();
      hashedEmail = md5(e);
    }
    if (!hashedEmail) {
      hashedEmail = md5(this.username);
    }
    return "https://www.gravatar.com/avatar/" + hashedEmail + "?d=identicon";
  };

  CustomerAccount.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("username", json.username);
    this._setIfNotNull("followingUs", json.following_us);
    this._setIfNotNull("imageURL", json.image_url);
    this._setIfNotNull("description", json.description);
    this._setIfNotNull("followersCount", json.followers_count);
    this._setIfNotNull("channel", json.channel);
    return CustomerAccount.__super__._populateWithJSON.call(this, json);
  };

  return CustomerAccount;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.EmailAccount = (function(_super) {
  __extends(EmailAccount, _super);

  function EmailAccount() {
    _ref = EmailAccount.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  EmailAccount._firehoseType = "EmailAccount";

  EmailAccount.prototype.company = null;

  EmailAccount.prototype.emailAddress = null;

  EmailAccount.prototype.isForwarding = false;

  EmailAccount.prototype.title = null;

  EmailAccount.prototype.kind = 'IMAP';

  EmailAccount.prototype.server = null;

  EmailAccount.prototype.port = null;

  EmailAccount.prototype.username = null;

  EmailAccount.prototype.password = null;

  EmailAccount.prototype.SSL = true;

  EmailAccount.prototype.deleteFromServer = false;

  EmailAccount.emailAccountWithSettings = function(company, settings) {
    var emailAccount;
    emailAccount = {};
    emailAccount.company = company;
    if (settings != null) {
      if (settings.emailAddress != null) {
        emailAccount.emailAddress = settings.emailAddress;
      }
      if (settings.title != null) {
        emailAccount.title = settings.title;
      }
      if (settings.kind != null) {
        emailAccount.kind = settings.kind;
      }
      if (settings.server != null) {
        emailAccount.server = settings.server;
      }
      if (settings.port != null) {
        emailAccount.port = settings.port;
      }
      if (settings.username != null) {
        emailAccount.username = settings.username;
      }
      if (settings.password != null) {
        emailAccount.password = settings.password;
      }
      if (settings.SSL != null) {
        emailAccount.SSL = settings.SSL;
      }
      if (settings.deleteFromServer != null) {
        emailAccount.deleteFromServer = settings.deleteFromServer;
      }
    }
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.EmailAccount, emailAccount);
  };

  EmailAccount._emailAccountWithID = function(id, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.EmailAccount, {
      id: id,
      company: company
    });
  };

  EmailAccount.prototype.save = function() {
    var params,
      _this = this;
    if (this.id != null) {
      params = {
        route: "email_accounts/" + this.id,
        body: this._toJSON()
      };
      return FirehoseJS.client.put(params);
    } else {
      params = {
        route: "companies/" + this.company.id + "/email_accounts",
        body: this._toJSON()
      };
      return FirehoseJS.client.post(params).done(function(data) {
        return _this._populateWithJSON(data);
      });
    }
  };

  EmailAccount.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "email_accounts/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.company.emailAccounts().dropObject(_this);
    });
  };

  EmailAccount.prototype._popularServices = [
    {
      domain: "gmail.com",
      kind: "IMAP",
      SSL: true,
      port: 993,
      server: "imap.googlemail.com"
    }, {
      domain: "hotmail.com",
      kind: "POP",
      SSL: true,
      port: 995,
      server: "pop3.live.com"
    }, {
      domain: "aol.com",
      kind: "IMAP",
      SSL: true,
      port: 993,
      server: "imap.aol.com"
    }, {
      domain: "aim.com",
      kind: "IMAP",
      SSL: true,
      port: 993,
      server: "imap.aim.com"
    }, {
      domain: "me.com",
      kind: "IMAP",
      SSL: true,
      port: 993,
      server: "imap.mail.me.com"
    }, {
      domain: "mac.com",
      kind: "IMAP",
      SSL: true,
      port: 993,
      server: "imap.mail.me.com"
    }, {
      domain: "icloud.com",
      kind: "IMAP",
      SSL: true,
      port: 993,
      server: "imap.mail.me.com"
    }, {
      domain: "yahoo.com",
      kind: "IMAP",
      SSL: true,
      port: 993,
      server: "imap.mail.yahoo.com"
    }
  ];

  EmailAccount.prototype.guessFieldsFromEmail = function() {
    var domain, service, _i, _len, _ref1;
    _ref1 = this._popularServices;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      service = _ref1[_i];
      domain = "@" + service.domain;
      if (this.username.indexOf(domain) !== -1) {
        this._setIfNotNull("kind", service.kind);
        this._setIfNotNull("SSL", service.SSL);
        this._setIfNotNull("port", service.port);
        this._setIfNotNull("server", service.server);
        this._setIfNotNull("isForwarding", false);
        return true;
      }
    }
    return false;
  };

  EmailAccount.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("emailAddress", json.email);
    if (this.title == null) {
      this._setIfNotNull("title", json.title);
    }
    this._setIfNotNull("isForwarding", json.forwarding);
    this._setIfNotNull("server", json.incoming_server);
    this._setIfNotNull("SSL", json.incoming_ssl);
    if (this.port == null) {
      this._setIfNotNull("port", json.incoming_port);
    }
    this._setIfNotNull("username", json.incoming_username);
    this._setIfNotNull("kind", json.kind);
    this._setIfNotNull("deleteFromServer", json.delete_from_server);
    return EmailAccount.__super__._populateWithJSON.call(this, json);
  };

  EmailAccount.prototype._toJSON = function() {
    return {
      email_account: {
        email: this.emailAddress,
        title: this.title,
        forwarding: this.isForwarding,
        incoming_server: this.server,
        incoming_ssl: this.SSL,
        incoming_port: this.port,
        incoming_username: this.username,
        incoming_password: this.password,
        kind: this.kind,
        delete_from_server: this.deleteFromServer
      }
    };
  };

  return EmailAccount;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.EmailInteraction = (function(_super) {
  __extends(EmailInteraction, _super);

  function EmailInteraction() {
    _ref = EmailInteraction.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  EmailInteraction._firehoseType = "EmailInteraction";

  EmailInteraction.prototype.emailSubject = null;

  EmailInteraction.prototype.replyTo = null;

  EmailInteraction.prototype.toEmail = null;

  EmailInteraction.prototype.fromEmail = null;

  EmailInteraction.prototype.attachments = null;

  EmailInteraction.prototype._setup = function() {
    return this.attachments = new FirehoseJS.UniqueArray;
  };

  EmailInteraction._emailInteractionWithID = function(id) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.EmailInteraction, {
      id: id
    });
  };

  EmailInteraction.prototype._populateWithJSON = function(json) {
    var emailJSON,
      _this = this;
    if (json.email_interaction != null) {
      emailJSON = json.email_interaction;
      this._setIfNotNull("emailSubject", emailJSON.subject);
      this._setIfNotNull("replyTo", emailJSON.reply_to);
      this._setIfNotNull("toEmail", emailJSON.to_email);
      this._setIfNotNull("fromEmail", emailJSON.from_email);
      this._populateAssociatedObjects(this, "attachments", emailJSON.attachments, function(json) {
        return FirehoseJS.Attachment._attachmentWithID(json.id, _this);
      });
      this._populateAssociatedObjectWithJSON(this, "emailAccount", emailJSON.email_account, function(json) {
        return FirehoseJS.EmailAccount._emailAccountWithID(json.id);
      });
    }
    return EmailInteraction.__super__._populateWithJSON.call(this, json);
  };

  return EmailInteraction;

})(FirehoseJS.Interaction);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.FacebookAccount = (function(_super) {
  __extends(FacebookAccount, _super);

  function FacebookAccount() {
    _ref = FacebookAccount.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  FacebookAccount._firehoseType = "FacebookAccount";

  FacebookAccount.prototype.company = null;

  FacebookAccount.prototype.username = null;

  FacebookAccount.prototype.facebookUserId = null;

  FacebookAccount.prototype.imageURL = null;

  FacebookAccount.prototype.name = null;

  FacebookAccount.prototype.facebookPages = null;

  FacebookAccount.prototype._setup = function() {
    return this.facebookPages = new FirehoseJS.UniqueArray;
  };

  FacebookAccount._facebookAccountWithID = function(id, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.FacebookAccount, {
      id: id,
      company: company
    });
  };

  FacebookAccount.OAuthURLForCompanyWithCallback = function(company, callback) {
    return "" + (FirehoseJS.rootFor('API')) + "/companies/" + company.id + "/oauth_facebook?url_token=" + FirehoseJS.client.URLToken + "&callback_url=" + (encodeURIComponent(callback));
  };

  FacebookAccount.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "facebook_accounts/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.company.facebookAccounts().dropObject(_this);
    });
  };

  FacebookAccount.prototype._populateWithJSON = function(json) {
    var _this = this;
    this._setIfNotNull("username", json.username);
    this._setIfNotNull("facebookUserId", json.facebook_user_id);
    this._setIfNotNull("imageURL", json.image_url);
    this._setIfNotNull("name", json.name);
    this._populateAssociatedObjects(this, "facebookPages", json.facebook_pages, function(json) {
      return FirehoseJS.FacebookPage._facebookPageWithID(json.id, _this);
    });
    return FacebookAccount.__super__._populateWithJSON.call(this, json);
  };

  return FacebookAccount;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.FacebookInteraction = (function(_super) {
  __extends(FacebookInteraction, _super);

  function FacebookInteraction() {
    _ref = FacebookInteraction.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  FacebookInteraction._firehoseType = "FacebookInteraction";

  FacebookInteraction.prototype.fromUserId = null;

  FacebookInteraction.prototype.fromName = null;

  FacebookInteraction.prototype.toUserId = null;

  FacebookInteraction.prototype.toName = null;

  FacebookInteraction.prototype.postId = null;

  FacebookInteraction.prototype.commentId = null;

  FacebookInteraction.prototype.postType = null;

  FacebookInteraction.prototype.postExcerpt = null;

  FacebookInteraction.prototype.likeCount = 0;

  FacebookInteraction.prototype.type = null;

  FacebookInteraction._facebookInteractionWithID = function(id) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.FacebookInteraction, {
      id: id
    });
  };

  FacebookInteraction.prototype._populateWithJSON = function(json) {
    var facebookJSON;
    if (json.facebook_interaction != null) {
      facebookJSON = json.facebook_interaction;
      this._setIfNotNull("fromUserId", facebookJSON.from_user_id);
      this._setIfNotNull("fromName", facebookJSON.from_name);
      this._setIfNotNull("toUserId", facebookJSON.to_user_id);
      this._setIfNotNull("toName", facebookJSON.to_name);
      this._setIfNotNull("postId", facebookJSON.post_id);
      this._setIfNotNull("commentId", facebookJSON.comment_id);
      this._setIfNotNull("postType", facebookJSON.post_type);
      this._setIfNotNull("postExcerpt", facebookJSON.post_excerpt);
      this._setIfNotNull("likeCount", facebookJSON.like_count);
      this._populateAssociatedObjectWithJSON(this, "facebookAccount", facebookJSON.facebook_account, function(json) {
        return FirehoseJS.FacebookAccount._facebookAccountWithID(json.id);
      });
    }
    return FacebookInteraction.__super__._populateWithJSON.call(this, json);
  };

  return FacebookInteraction;

})(FirehoseJS.Interaction);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.FacebookPage = (function(_super) {
  __extends(FacebookPage, _super);

  function FacebookPage() {
    _ref = FacebookPage.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  FacebookPage._firehoseType = "FacebookPage";

  FacebookPage.prototype.facebookAccount = null;

  FacebookPage.prototype.name = null;

  FacebookPage.prototype.category = null;

  FacebookPage.prototype.pageId = null;

  FacebookPage.prototype.active = false;

  FacebookPage._facebookPageWithID = function(id, facebookAccount) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.FacebookPage, {
      id: id,
      facebookAccount: facebookAccount
    });
  };

  FacebookPage.prototype.save = function() {
    var params;
    params = {
      route: "facebook_pages/" + this.id,
      body: this._toJSON()
    };
    return FirehoseJS.client.put(params);
  };

  FacebookPage.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("name", json.name);
    this._setIfNotNull("category", json.category);
    this._setIfNotNull("pageId", json.page_id);
    this._setIfNotNull("active", json.active);
    return FacebookPage.__super__._populateWithJSON.call(this, json);
  };

  FacebookPage.prototype._toJSON = function() {
    return {
      facebook_page: {
        active: this.active
      }
    };
  };

  return FacebookPage;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.Note = (function(_super) {
  __extends(Note, _super);

  function Note() {
    _ref = Note.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Note._firehoseType = "Note";

  Note.prototype.interaction = null;

  Note.prototype.body = null;

  Note.prototype.agent = null;

  Note.noteWithBody = function(body, interaction) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Note, {
      body: body,
      interaction: interaction
    });
  };

  Note._noteWithID = function(id, interaction) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Note, {
      id: id,
      interaction: interaction
    });
  };

  Note.prototype.save = function() {
    var params,
      _this = this;
    if (this.id != null) {
      params = {
        route: "notes/" + this.id,
        body: this._toJSON()
      };
      return FirehoseJS.client.put(params);
    } else {
      params = {
        route: "interactions/" + this.interaction.id + "/notes",
        body: this._toJSON()
      };
      return FirehoseJS.client.post(params).done(function(data) {
        _this._populateWithJSON(data);
        return _this.interaction.notes.insertObject(_this);
      });
    }
  };

  Note.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "notes/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.interaction.notes.dropObject(_this);
    });
  };

  Note.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("body", json.body);
    this._populateAssociatedObjectWithJSON(this, "agent", json.agent, function(json) {
      return FirehoseJS.Agent.agentWithID(json.id);
    });
    return Note.__super__._populateWithJSON.call(this, json);
  };

  Note.prototype._toJSON = function() {
    return {
      note: {
        body: this.body
      }
    };
  };

  return Note;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.Notification = (function(_super) {
  __extends(Notification, _super);

  function Notification() {
    _ref = Notification.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Notification._firehoseType = "Notification";

  Notification.prototype.company = null;

  Notification.prototype.title = null;

  Notification.prototype.text = null;

  Notification.prototype.level = 0;

  Notification._notificationWithID = function(id, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Notification, {
      id: id,
      company: company
    });
  };

  Notification.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("title", json.title);
    this._setIfNotNull("text", json.text);
    this._setIfNotNull("level", json.level);
    return Notification.__super__._populateWithJSON.call(this, json);
  };

  return Notification;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.OutgoingAttachment = (function(_super) {
  __extends(OutgoingAttachment, _super);

  function OutgoingAttachment() {
    _ref = OutgoingAttachment.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  OutgoingAttachment._firehoseType = "OutgoingAttachment";

  OutgoingAttachment.prototype.company = null;

  OutgoingAttachment.prototype.token = null;

  OutgoingAttachment.prototype.downloadURL = null;

  OutgoingAttachment.prototype.uploadURL = null;

  OutgoingAttachment.prototype.uploaded = false;

  OutgoingAttachment.prototype.file = null;

  OutgoingAttachment.outgoingAttachmentWithFile = function(file, company) {
    return new FirehoseJS.OutgoingAttachment({
      file: file,
      company: company
    });
  };

  OutgoingAttachment.openFilePicker = function(completion) {
    var fileEl,
      _this = this;
    fileEl = $('<input type="file"/>');
    fileEl.bind("change", function(e) {
      var file;
      file = e.target.files[0];
      if (file.size > 1024 * 1024 * 1024) {
        alert("Files must be smaller than 1GB.");
        return;
      }
      if (file.size > 300 * 1024 * 1024) {
        alert("File sizes greater than 300MB have a higher chance of failure when uploaded from a browser. If you experience problems, perhaps try it from the Mac app.");
        return;
      }
      return completion(file);
    });
    return fileEl.trigger('click');
  };

  OutgoingAttachment.prototype.upload = function(options) {
    var params,
      _this = this;
    if (options == null) {
      options = {};
    }
    params = {
      route: "companies/" + this.company.id + "/outgoing_attachments",
      body: this._toJSON()
    };
    return FirehoseJS.client.post(params).done(function(data) {
      var xhr, _ref1;
      _this._populateWithJSON(data);
      xhr = new XMLHttpRequest();
      if ("withCredentials" in xhr) {
        xhr.open('PUT', data.upload_url, true);
      } else if (typeof XDomainRequest !== "undefined") {
        xhr = new XDomainRequest();
        xhr.open('PUT', data.upload_url);
      }
      if (options.progress != null) {
        if ((_ref1 = xhr.upload) != null) {
          _ref1.addEventListener('progress', function(event) {
            var percentComplete;
            if (event.lengthComputable) {
              percentComplete = parseInt(event.loaded / event.total * 100, 10);
              if (percentComplete >= 95) {
                return options.progress(95);
              } else {
                return options.progress(percentComplete);
              }
            }
          });
        }
      }
      xhr.onload = function() {
        if (xhr.status === 200) {
          _this.uploaded = true;
          params = {
            route: "outgoing_attachments/" + data.id,
            body: _this._toJSON()
          };
          return FirehoseJS.client.put(params).done(function() {
            return typeof options.success === "function" ? options.success(data.download_url) : void 0;
          }).fail(function(jqXHR, textStatus, errorThrown) {
            return typeof options.error === "function" ? options.error(errorThrown) : void 0;
          });
        } else {
          return typeof options.error === "function" ? options.error("Your attachment failed to upload successfully, please try again. Please contact support@getfirehose.com if the problem persists and we'll get it fixed for you.") : void 0;
        }
      };
      xhr.onerror = function(error) {
        return typeof options.error === "function" ? options.error("Your attachment failed to upload successfully, please try again. Please contact support@getfirehose.com if the problem persists and we'll get it fixed for you.") : void 0;
      };
      xhr.setRequestHeader('Content-Type', _this.file.type);
      xhr.setRequestHeader('x-amz-acl', 'authenticated-read');
      return xhr.send(_this.file);
    }).fail(function(jqXHR, textStatus, errorThrown) {
      return typeof options.error === "function" ? options.error(errorThrown) : void 0;
    });
  };

  OutgoingAttachment.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("downloadURL", json.download_url);
    this._setIfNotNull("uploadURL", json.upload_url);
    return OutgoingAttachment.__super__._populateWithJSON.call(this, json);
  };

  OutgoingAttachment.prototype._toJSON = function() {
    return {
      outgoing_attachment: {
        filename: this.file.name,
        mimetype: this.file.type || "application/zip",
        uploaded: this.uploaded
      }
    };
  };

  return OutgoingAttachment;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.Tag = (function(_super) {
  __extends(Tag, _super);

  function Tag() {
    _ref = Tag.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Tag._firehoseType = "Tag";

  Tag.prototype.company = null;

  Tag.prototype.label = null;

  Tag.tagWithLabel = function(label, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Tag, {
      label: label,
      company: company
    });
  };

  Tag._tagWithID = function(id, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Tag, {
      id: id,
      company: company
    });
  };

  Tag.prototype.save = function() {
    var params,
      _this = this;
    if (this.id != null) {
      params = {
        route: "tags/" + this.id,
        body: this._toJSON()
      };
      return FirehoseJS.client.put(params);
    } else {
      params = {
        route: "companies/" + this.company.id + "/tags",
        body: this._toJSON()
      };
      return FirehoseJS.client.post(params).done(function(data) {
        _this._populateWithJSON(data);
        return _this.company.tags.insertObject(_this);
      });
    }
  };

  Tag.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "tags/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.company.tags.dropObject(_this);
    });
  };

  Tag.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("label", json.label);
    return Tag.__super__._populateWithJSON.call(this, json);
  };

  Tag.prototype._toJSON = function() {
    return {
      tag: {
        label: this.label
      }
    };
  };

  Tag.prototype._toArchivableJSON = function() {
    return $.extend(Tag.__super__._toArchivableJSON.call(this), {
      label: this.label
    });
  };

  return Tag;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.TwitterAccount = (function(_super) {
  __extends(TwitterAccount, _super);

  function TwitterAccount() {
    _ref = TwitterAccount.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  TwitterAccount._firehoseType = "TwitterAccount";

  TwitterAccount.prototype.company = null;

  TwitterAccount.prototype.screenName = null;

  TwitterAccount.prototype.twitterUserId = null;

  TwitterAccount.prototype.imageURL = null;

  TwitterAccount._twitterAccountWithID = function(id, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.TwitterAccount, {
      id: id,
      company: company
    });
  };

  TwitterAccount.OAuthURLForCompanyWithCallback = function(company, callback) {
    return "" + (FirehoseJS.rootFor('API')) + "/companies/" + company.id + "/oauth_twitter?url_token=" + FirehoseJS.client.URLToken + "&callback_url=" + (encodeURIComponent(callback));
  };

  TwitterAccount.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "twitter_accounts/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.company.twitterAccounts().dropObject(_this);
    });
  };

  TwitterAccount.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("screenName", json.screen_name);
    this._setIfNotNull("twitterUserId", json.twitter_user_id);
    this._setIfNotNull("imageURL", json.image_url);
    return TwitterAccount.__super__._populateWithJSON.call(this, json);
  };

  return TwitterAccount;

})(FirehoseJS.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.TwitterInteraction = (function(_super) {
  __extends(TwitterInteraction, _super);

  function TwitterInteraction() {
    _ref = TwitterInteraction.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  TwitterInteraction._firehoseType = "TwitterInteraction";

  TwitterInteraction.prototype.favorited = false;

  TwitterInteraction.prototype.tweetId = null;

  TwitterInteraction.prototype.inReplyToScreenName = null;

  TwitterInteraction.prototype.inReplyToStatusId = null;

  TwitterInteraction.prototype.retweetCount = 0;

  TwitterInteraction.prototype.tweetSource = null;

  TwitterInteraction.prototype.toUserId = null;

  TwitterInteraction.prototype.toScreenName = null;

  TwitterInteraction.prototype.fromUserId = null;

  TwitterInteraction._twitterInteractionWithID = function(id) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.TwitterInteraction, {
      id: id
    });
  };

  TwitterInteraction.prototype._populateWithJSON = function(json) {
    var twitterJSON;
    if (json.twitter_interaction != null) {
      twitterJSON = json.twitter_interaction;
      this._setIfNotNull("favorited", twitterJSON.favorited);
      this._setIfNotNull("tweetId", twitterJSON.tweet_id);
      this._setIfNotNull("inReplyToScreenName", twitterJSON.in_reply_to_screen_name);
      this._setIfNotNull("inReplyToStatusId", twitterJSON.in_reply_to_status_id);
      this._setIfNotNull("retweetCount", twitterJSON.retweet_count);
      this._setIfNotNull("tweetSource", twitterJSON.tweet_source);
      this._setIfNotNull("toUserId", twitterJSON.to_user_id);
      this._setIfNotNull("toScreenName", twitterJSON.twitter_account.screen_name);
      this._setIfNotNull("fromUserId", twitterJSON.from_user_id);
      this._populateAssociatedObjectWithJSON(this, "twitterAccount", twitterJSON.twitter_account, function(json) {
        return FirehoseJS.TwitterAccount._twitterAccountWithID(json.id);
      });
    }
    return TwitterInteraction.__super__._populateWithJSON.call(this, json);
  };

  return TwitterInteraction;

})(FirehoseJS.Interaction);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

FirehoseJS.Article = (function(_super) {
  __extends(Article, _super);

  function Article() {
    _ref = Article.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Article._firehoseType = "Article";

  Article.prototype.company = null;

  Article.prototype.title = null;

  Article.prototype.body = null;

  Article.articleWithTitleBodyAndCompany = function(title, body, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Article, {
      title: title,
      body: body,
      company: company
    });
  };

  Article.articleWithID = function(id, company) {
    return FirehoseJS.Object._objectOfClassWithID(FirehoseJS.Article, {
      id: id,
      company: company
    });
  };

  Article.prototype.fetch = function() {
    var params,
      _this = this;
    params = {
      route: "articles/" + this.id
    };
    return FirehoseJS.client.get(params).done(function(data) {
      return _this._populateWithJSON(data);
    });
  };

  Article.prototype.save = function() {
    var params,
      _this = this;
    if (this.id != null) {
      params = {
        route: "articles/" + this.id,
        body: this._toJSON()
      };
      return FirehoseJS.client.put(params);
    } else {
      params = {
        route: "companies/" + this.company.id + "/articles",
        body: this._toJSON()
      };
      return FirehoseJS.client.post(params).done(function(data) {
        _this._populateWithJSON(data);
        return _this.company.articles().insertObject(_this);
      });
    }
  };

  Article.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "articles/" + this.id
    };
    return FirehoseJS.client["delete"](params).done(function() {
      return _this.company.articles().dropObject(_this);
    });
  };

  Article.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("title", json.title);
    this._setIfNotNull("body", json.body);
    return Article.__super__._populateWithJSON.call(this, json);
  };

  Article.prototype._toJSON = function() {
    return {
      article: {
        title: this.title,
        body: this.body
      }
    };
  };

  return Article;

})(FirehoseJS.Object);
