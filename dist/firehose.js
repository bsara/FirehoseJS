(function(){var e,t,n,r,i,s={}.hasOwnProperty,o=function(e,t){function r(){this.constructor=e}for(var n in t)s.call(t,n)&&(e[n]=t[n]);return r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype,e},u=this;this.Stripe=function(){function e(){}return e.version=2,e.endpoint="https://api.stripe.com/v1",e.setPublishableKey=function(t){e.key=t},e.complete=function(t){return function(n,r,i){var s;if(n!=="success")return s=Math.round((new Date).getTime()/1e3),(new Image).src="http://q.stripe.com?event=stripejs-error&type="+n+"&key="+e.key+"&timestamp="+s,typeof t=="function"?t(500,{error:{code:n,type:n,message:"An unexpected error has occurred submitting your credit\ncard to our secure credit card processor. This may be\ndue to network connectivity issues, so you should try\nagain (you won't be charged twice). If this problem\npersists, please let us know!"}}):void 0}},e}.call(this),e=this.Stripe,this.Stripe.token=function(){function t(){}return t.validate=function(e,t){if(!e)throw t+" required";if(typeof e!="object")throw t+" invalid"},t.formatData=function(t,n){return e.utils.isElement(t)&&(t=e.utils.paramsFromForm(t,n)),e.utils.underscoreKeys(t),t},t.create=function(t,n){return t.key||(t.key=e.key||e.publishableKey),e.utils.validateKey(t.key),e.ajaxJSONP({url:""+e.endpoint+"/tokens",data:t,method:"POST",success:function(e,t){return typeof n=="function"?n(t,e):void 0},complete:e.complete(n),timeout:4e4})},t.get=function(t,n){if(!t)throw"token required";return e.utils.validateKey(e.key),e.ajaxJSONP({url:""+e.endpoint+"/tokens/"+t,data:{key:e.key},success:function(e,t){return typeof n=="function"?n(t,e):void 0},complete:e.complete(n),timeout:4e4})},t}.call(this),this.Stripe.card=function(t){function n(){return n.__super__.constructor.apply(this,arguments)}return o(n,t),n.tokenName="card",n.whitelistedAttrs=["number","cvc","exp_month","exp_year","name","address_line1","address_line2","address_city","address_state","address_zip","address_country"],n.createToken=function(t,r,i){var s;return r==null&&(r={}),e.token.validate(t,"card"),typeof r=="function"?(i=r,r={}):typeof r!="object"&&(s=parseInt(r,10),r={},s>0&&(r.amount=s)),r[n.tokenName]=e.token.formatData(t,n.whitelistedAttrs),e.token.create(r,i)},n.getToken=function(t,n){return e.token.get(t,n)},n.validateCardNumber=function(e){return e=(e+"").replace(/\s+|-/g,""),e.length>=10&&e.length<=16&&n.luhnCheck(e)},n.validateCVC=function(t){return t=e.utils.trim(t),/^\d+$/.test(t)&&t.length>=3&&t.length<=4},n.validateExpiry=function(t,n){var r,i;return t=e.utils.trim(t),n=e.utils.trim(n),/^\d+$/.test(t)?/^\d+$/.test(n)?parseInt(t,10)<=12?(i=new Date(n,t),r=new Date,i.setMonth(i.getMonth()-1),i.setMonth(i.getMonth()+1,1),i>r):!1:!1:!1},n.luhnCheck=function(e){var t,n,r,i,s,o;r=!0,i=0,n=(e+"").split("").reverse();for(s=0,o=n.length;s<o;s++){t=n[s],t=parseInt(t,10);if(r=!r)t*=2;t>9&&(t-=9),i+=t}return i%10===0},n.cardType=function(e){return n.cardTypes[e.slice(0,2)]||"Unknown"},n.cardTypes=function(){var e,t,n,r;t={};for(e=n=40;n<=49;e=++n)t[e]="Visa";for(e=r=50;r<=59;e=++r)t[e]="MasterCard";return t[34]=t[37]="American Express",t[60]=t[62]=t[64]=t[65]="Discover",t[35]="JCB",t[30]=t[36]=t[38]=t[39]="Diners Club",t}(),n}.call(this,this.Stripe.token),this.Stripe.bankAccount=function(t){function n(){return n.__super__.constructor.apply(this,arguments)}return o(n,t),n.tokenName="bank_account",n.whitelistedAttrs=["country","routing_number","account_number"],n.createToken=function(t,r,i){return r==null&&(r={}),e.token.validate(t,"bank account"),typeof r=="function"&&(i=r,r={}),r[n.tokenName]=e.token.formatData(t,n.whitelistedAttrs),e.token.create(r,i)},n.getToken=function(t,n){return e.token.get(t,n)},n.validateRoutingNumber=function(t,r){t=e.utils.trim(t);switch(r){case"US":return/^\d+$/.test(t)&&t.length===9&&n.routingChecksum(t);case"CA":return/\d{5}\-\d{3}/.test(t)&&t.length===9;default:return!0}},n.validateAccountNumber=function(t,n){t=e.utils.trim(t);switch(n){case"US":return/^\d+$/.test(t)&&t.length>=1&&t.length<=17;default:return!0}},n.routingChecksum=function(e){var t,n,r,i,s,o;r=0,t=(e+"").split(""),o=[0,3,6];for(i=0,s=o.length;i<s;i++)n=o[i],r+=parseInt(t[n])*3,r+=parseInt(t[n+1])*7,r+=parseInt(t[n+2]);return r!==0&&r%10===0},n}.call(this,this.Stripe.token),t=["createToken","getToken","cardType","validateExpiry","validateCVC","validateCardNumber"];for(r=0,i=t.length;r<i;r++)n=t[r],this.Stripe[n]=this.Stripe.card[n];typeof module!="undefined"&&module!==null&&(module.exports=this.Stripe),typeof define=="function"&&define("stripe",[],function(){return u.Stripe})}).call(this),function(){var e,t,n,r=[].slice;e=encodeURIComponent,t=(new Date).getTime(),n=function(t,r,i){var s,o;r==null&&(r=[]);for(s in t)o=t[s],i&&(s=""+i+"["+s+"]"),typeof o=="object"?n(o,r,s):r.push(""+s+"="+e(o));return r.join("&").replace(/%20/g,"+")},this.Stripe.ajaxJSONP=function(e){var i,s,o,u,a,f;return e==null&&(e={}),o="sjsonp"+ ++t,a=document.createElement("script"),s=null,i=function(t){var n;return t==null&&(t="abort"),clearTimeout(s),(n=a.parentNode)!=null&&n.removeChild(a),o in window&&(window[o]=function(){}),typeof e.complete=="function"?e.complete(t,f,e):void 0},f={abort:i},a.onerror=function(){return f.abort(),typeof e.error=="function"?e.error(f,e):void 0},window[o]=function(){var t;t=1<=arguments.length?r.call(arguments,0):[],clearTimeout(s),a.parentNode.removeChild(a);try{delete window[o]}catch(n){window[o]=void 0}return typeof e.success=="function"&&e.success.apply(e,t),typeof e.complete=="function"?e.complete("success",f,e):void 0},e.data||(e.data={}),e.data.callback=o,e.method&&(e.data._method=e.method),a.src=e.url+"?"+n(e.data),u=document.getElementsByTagName("head")[0],u.appendChild(a),e.timeout>0&&(s=setTimeout(function(){return f.abort("timeout")},e.timeout)),f}}.call(this),function(){var e=[].indexOf||function(e){for(var t=0,n=this.length;t<n;t++)if(t in this&&this[t]===e)return t;return-1};this.Stripe.utils=function(){function t(){}return t.trim=function(e){return(e+"").replace(/^\s+|\s+$/g,"")},t.underscore=function(e){return(e+"").replace(/([A-Z])/g,function(e){return"_"+e.toLowerCase()}).replace(/-/g,"_")},t.underscoreKeys=function(e){var t,n,r;r=[];for(t in e)n=e[t],delete e[t],r.push(e[this.underscore(t)]=n);return r},t.isElement=function(e){return typeof e!="object"?!1:typeof jQuery!="undefined"&&jQuery!==null&&e instanceof jQuery?!0:e.nodeType===1},t.paramsFromForm=function(t,n){var r,i,s,o,u,a,f,l,c,h;n==null&&(n=[]),typeof jQuery!="undefined"&&jQuery!==null&&t instanceof jQuery&&(t=t[0]),s=t.getElementsByTagName("input"),u=t.getElementsByTagName("select"),a={};for(f=0,c=s.length;f<c;f++){i=s[f],r=this.underscore(i.getAttribute("data-stripe"));if(e.call(n,r)<0)continue;a[r]=i.value}for(l=0,h=u.length;l<h;l++){o=u[l],r=this.underscore(o.getAttribute("data-stripe"));if(e.call(n,r)<0)continue;o.selectedIndex!=null&&(a[r]=o.options[o.selectedIndex].value)}return a},t.validateKey=function(e){if(!e||typeof e!="string")throw new Error("You did not set a valid publishable key. Call Stripe.setPublishableKey() with your publishable key. For more info, see https://stripe.com/docs/stripe.js");if(/\s/g.test(e))throw new Error("Your key is invalid, as it contains whitespace. For more info, see https://stripe.com/docs/stripe.js");if(/^sk_/.test(e))throw new Error("You are using a secret key with Stripe.js, instead of the publishable one. For more info, see https://stripe.com/docs/stripe.js")},t}()}.call(this),function(){var e=[].indexOf||function(e){for(var t=0,n=this.length;t<n;t++)if(t in this&&this[t]===e)return t;return-1};this.Stripe.validator={"boolean":function(e,t){if(t!=="true"&&t!=="false")return"Enter a boolean string (true or false)"},integer:function(e,t){if(!/^\d+$/.test(t))return"Enter an integer"},positive:function(e,t){if(!(!this.integer(e,t)&&parseInt(t,10)>0))return"Enter a positive value"},range:function(t,n){var r;if(r=parseInt(n,10),e.call(t,r)<0)return"Needs to be between "+t[0]+" and "+t[t.length-1]},required:function(e,t){if(e&&(t==null||t===""))return"Required"},year:function(e,t){if(!/^\d{4}$/.test(t))return"Enter a 4-digit year"},birthYear:function(e,t){var n;n=this.year(e,t);if(n)return n;if(parseInt(t,10)>2e3)return"You must be over 18";if(parseInt(t,10)<1900)return"Enter your birth year"},month:function(e,t){if(this.integer(e,t))return"Please enter a month";if(this.range([1,2,3,4,5,6,7,8,9,10,11,12],t))return"Needs to be between 1 and 12"},choices:function(t,n){if(e.call(t,n)<0)return"Not an acceptable value for this field"},email:function(e,t){if(!/^[^@<\s>]+@[^@<\s>]+$/.test(t))return"That doesn't look like an email address"},url:function(e,t){if(!/^https?:\/\/.+\..+/.test(t))return"Not a valid url"},usTaxID:function(e,t){if(!/^\d{2}-?\d{1}-?\d{2}-?\d{4}$/.test(t))return"Not a valid tax ID"},ein:function(e,t){if(!/^\d{2}-?\d{7}$/.test(t))return"Not a valid EIN"},ssnLast4:function(e,t){if(!/^\d{4}$/.test(t))return"Not a valid last 4 digits for an SSN"},ownerPersonalID:function(e,t){var n;n=function(){switch(e){case"CA":return/^\d{3}-?\d{3}-?\d{3}$/.test(t);case"US":return!0}}();if(!n)return"Not a valid ID"},bizTaxID:function(e,t){var n,r,i,s,o,u,a,f;u={CA:["Tax ID",[/^\d{9}$/]],US:["EIN",[/^\d{2}-?\d{7}$/]]},o=u[e];if(o!=null){n=o[0],s=o[1],r=!1;for(a=0,f=s.length;a<f;a++){i=s[a];if(i.test(t)){r=!0;break}}if(!r)return"Not a valid "+n}},zip:function(e,t){var n;n=function(){switch(e.toUpperCase()){case"CA":return/^[\d\w]{6}$/.test(t!=null?t.replace(/\s+/g,""):void 0);case"US":return/^\d{5}$/.test(t)||/^\d{9}$/.test(t)}}();if(!n)return"Not a valid zip"},bankAccountNumber:function(e,t){if(!/^\d{1,17}$/.test(t))return"Invalid bank account number"},usRoutingNumber:function(e){var t,n,r,i,s,o,u;if(!/^\d{9}$/.test(e))return"Routing number must have 9 digits";s=0;for(t=o=0,u=e.length-1;o<=u;t=o+=3)n=parseInt(e.charAt(t),10)*3,r=parseInt(e.charAt(t+1),10)*7,i=parseInt(e.charAt(t+2),10),s+=n+r+i;if(s===0||s%10!==0)return"Invalid routing number"},caRoutingNumber:function(e){if(!/^\d{5}\-\d{3}$/.test(e))return"Invalid transit number"},routingNumber:function(e,t){switch(e.toUpperCase()){case"CA":return this.caRoutingNumber(t);case"US":return this.usRoutingNumber(t)}},phoneNumber:function(e,t){var n;n=t.replace(/[^0-9]/g,"");if(n.length!==10)return"Invalid phone number"},bizDBA:function(e,t){if(!/^.{1,23}$/.test(t))return"Statement descriptors can only have up to 23 characters"},nameLength:function(e,t){if(t.length===1)return"Names need to be longer than one character"}}}.call(this);
/*
This is a module-level docstring, and will be displayed at the top of the module documentation.
Documentation generated by [CoffeeDoc](http://github.com/omarkhan/coffeedoc)
*/

window.Firehose = {};

/*
Returns the current environment that Firehose is running in based on the current docment URL.
@return   [string] The current environment. 'production', 'beta', 'test' or 'development'.
*/


Firehose.environment = function() {
  Firehose.client.environment._inferEnvironmentFromURL();
  return Firehose.client.environment._environment;
};

/*
@param    server [string] The name of the server. Possible values: 'API', 'browser', 'billing', 'files', 'marketing', 'settings'
@param    subdomain [string] If the generated url should have a subdomain you can optionally provide it.
@return   [string] The root url of the server based on the current environement.
@example  Create a URL to the login page of the browser app.
  "#{Firehose.baseURLFor('browser')/home/login"
*/


Firehose.baseURLFor = function(app, subdomain) {
  return Firehose.client.environment.baseURLFor(app, subdomain);
};

/*
@param    service [string] The name of the service. Possible values: 'pusher', 'stripe'
@return   [string] The token/key used for that service's library.
*/


Firehose.tokenFor = function(service) {
  return Firehose.client.environment.serviceToken(service);
};

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.UniqueArray = (function(_super) {
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

Firehose.RemoteArray = (function(_super) {
  __extends(RemoteArray, _super);

  /*
  @property [integer]
  */


  RemoteArray.prototype.perPage = -1;

  /*
  @property [integer]
  */


  RemoteArray.prototype.page = 1;

  /*
  @property [boolean]
  */


  RemoteArray.prototype.auth = true;

  /*
  @property [integer]
  */


  RemoteArray.prototype.totalRows = 0;

  /*
  @property [Object] query params you only want sent on the first `next()` call.
  */


  RemoteArray.prototype.onceParams = null;

  RemoteArray.prototype._path = null;

  RemoteArray.prototype._params = null;

  RemoteArray.prototype._creationFunction = null;

  RemoteArray.prototype._fetchingFunction = null;

  RemoteArray.prototype._fresh = true;

  RemoteArray._currentXHR = null;

  function RemoteArray(path, params, creationFunction) {
    var _this = this;
    if (params == null) {
      params = {};
    }
    this._path = path;
    this._params = params;
    this._creationFunction = creationFunction;
    this._fetchingFunction = function(page) {
      var options;
      options = {
        route: _this._path,
        auth: _this.auth,
        params: _this.onceParams ? $.extend(_this.onceParams, _this._params) : _this._params,
        page: page,
        perPage: _this.perPage
      };
      _this.onceParams = null;
      return _this._currentXHR = Firehose.client.get(_this, options).done(function(data) {
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
      }).always(function() {
        return _this._currentXHR = null;
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

  RemoteArray.prototype.abort = function() {
    var _ref;
    return (_ref = this._currentXHR) != null ? _ref.abort() : void 0;
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

})(Firehose.UniqueArray);

Firehose.Environment = (function() {
  function Environment() {}

  Environment.prototype.baseURLFor = function(app, subdomain) {
    var domain, port, scheme;
    this._inferEnvironmentFromURL();
    scheme = this._schemeFor(app);
    subdomain = subdomain && subdomain + "." || "";
    domain = this._domainNameFor(app);
    port = this._portFor(app);
    return "" + scheme + subdomain + domain + port;
  };

  Environment.prototype.serviceToken = function(service) {
    var env;
    this._inferEnvironmentFromURL();
    env = this._server === "production" ? "production" : this._environment;
    return this._serviceKeys[env][service];
  };

  Environment.prototype.environment = function() {
    this._inferEnvironmentFromURL();
    return this._environment;
  };

  Environment.prototype._server = null;

  Environment.prototype._environment = null;

  Environment.prototype._typeNumber = {
    server: 3,
    client: 4
  };

  Environment.prototype._serverNumber = {
    local: 0,
    mini: 1,
    production: 2
  };

  Environment.prototype._environmentNumber = {
    development: 0,
    test: 1
  };

  Environment.prototype._appNumber = {
    API: 0,
    browser: 1,
    billing: 2,
    files: 3,
    marketing: 4,
    settings: 5,
    tweetlonger: 6,
    kb: 7
  };

  Environment.prototype._appDomainNames = {
    API: {
      development: "localhost",
      test: "localhost",
      beta: "api.firehoseapp.com",
      production: "api.firehoseapp.com"
    },
    browser: {
      development: "localhost",
      test: "localhost",
      beta: "beta.firehoseapp.com",
      production: "firehoseapp.com"
    },
    billing: {
      development: "localhost",
      test: "localhost",
      beta: "billing.firehoseapp.com",
      production: "billing.firehoseapp.com"
    },
    files: {
      development: "localhost",
      test: "localhost",
      beta: "frh.io",
      production: "frh.io"
    },
    marketing: {
      development: "localhost",
      test: "localhost",
      beta: "beta.getfirehose.com",
      production: "getfirehose.com"
    },
    settings: {
      development: "localhost",
      test: "localhost",
      beta: "beta_settings.firehoseapp.com",
      production: "settings.firehoseapp.com"
    },
    tweetlonger: {
      development: "localhost",
      test: "localhost",
      beta: "beta_tl.frh.io",
      production: "tl.frh.io"
    },
    kb: {
      development: "lvh.me",
      test: "lvh.me",
      beta: "firehosesupport.com",
      production: "firehosehelp.com"
    }
  };

  Environment.prototype._appTypes = {
    API: "server",
    browser: "client",
    billing: "server",
    files: "server",
    marketing: "client",
    settings: "client",
    tweetlonger: "client",
    kb: "client"
  };

  Environment.prototype._serviceKeys = {
    development: {
      stripe: "pk_test_oIyMNHil987ug1v8owRhuJwr",
      pusher: "2f64ac0434cc8a94526e"
    },
    test: {
      stripe: "pk_test_oIyMNHil987ug1v8owRhuJwr",
      pusher: "2f64ac0434cc8a94526e"
    },
    beta: {
      stripe: "pk_live_CGPaLboKkpr7tqswA4elf8NQ",
      pusher: "d3e373f7fac89de7bde8"
    },
    production: {
      stripe: "pk_live_CGPaLboKkpr7tqswA4elf8NQ",
      pusher: "d3e373f7fac89de7bde8"
    }
  };

  Environment.prototype._inferEnvironmentFromURL = function() {
    var currentURL, domainName, environmentNumber, key, serverNumber, value, _ref, _ref1;
    currentURL = document.createElement("a");
    currentURL.href = window.unitTestDocumentURL || document.URL;
    domainName = currentURL.hostname.split('.').slice(-2).join(".");
    this._server = 'production';
    this._environment = 'production';
    if (parseInt(currentURL.port) > 0) {
      this._server = 'local';
      this._environment = 'development';
      serverNumber = parseInt(currentURL.port[1]);
      _ref = this._serverNumber;
      for (key in _ref) {
        value = _ref[key];
        if (value === serverNumber) {
          this._server = key;
        }
      }
      environmentNumber = parseInt(currentURL.port[2]);
      _ref1 = this._environmentNumber;
      for (key in _ref1) {
        value = _ref1[key];
        if (value === environmentNumber) {
          this._environment = key;
        }
      }
    }
    if (currentURL.hostname.match(/^beta(\.|_)/)) {
      return this._environment = 'beta';
    }
  };

  Environment.prototype._environmentFor = function(app) {
    if (this._appTypes[app] === 'server' && this._server === 'production') {
      return "production";
    } else {
      return this._environment;
    }
  };

  Environment.prototype._schemeFor = function(app) {
    var environment;
    environment = this._environmentFor(app);
    if (environment === 'development' || environment === 'test' || app === 'kb') {
      return "http://";
    } else {
      return "https://";
    }
  };

  Environment.prototype._domainNameFor = function(app) {
    var environment;
    environment = this._environmentFor(app);
    return this._appDomainNames[app][environment];
  };

  Environment.prototype._portFor = function(app) {
    var environment, port;
    environment = this._environmentFor(app);
    if (environment === 'production' || environment === 'beta') {
      return "";
    }
    port = ":";
    port += this._typeNumber[this._appTypes[app]];
    port += this._appTypes[app] === "client" ? this._serverNumber[this._server] : 0;
    port += this._environmentNumber[environment];
    port += this._appNumber[app];
    return port;
  };

  Environment.prototype._values = function(obj) {
    var key, value, values;
    values = [];
    for (key in obj) {
      value = obj[key];
      values.push(value);
    }
    return values;
  };

  return Environment;

})();

Firehose.Client = (function() {
  /*
  @property [hash] A hash of http status codes that could be returned by the API server and functions to handle them.
  @example Assigning this a hash with a 401 status code to handle an unauthorized request:
    Firehose.client.statusCodeHandlers =
      401: =>
        this.logout()
      422: (jqXHR, textStatus, errorThrown) ->
        …
  */

  Client.prototype.statusCodeHandlers = null;

  /*
  @property [Function(jqXHR, textStatus, errorThrown)] A function that is called whenever a call to the API service fails.
  */


  Client.prototype.errorHandler = null;

  Client.prototype.APIAccessToken = null;

  Client.prototype.URLToken = null;

  Client.prototype.billingAccessToken = null;

  Client.prototype.environment = null;

  function Client() {
    this._firefoxHack();
    this.environment = new Firehose.Environment;
    Stripe.setPublishableKey(this.environment.serviceToken('stripe'));
  }

  Client.prototype.get = function(object, options) {
    $.extend(options, {
      method: 'GET'
    });
    return this._sendRequest(object, options);
  };

  Client.prototype.post = function(object, options) {
    $.extend(options, {
      method: 'POST'
    });
    return this._sendRequest(object, options);
  };

  Client.prototype.put = function(object, options) {
    $.extend(options, {
      method: 'PUT'
    });
    return this._sendRequest(object, options);
  };

  Client.prototype["delete"] = function(object, options) {
    $.extend(options, {
      method: 'DELETE'
    });
    return this._sendRequest(object, options);
  };

  Client.prototype._sendRequest = function(object, options) {
    var auth, body, defaults, headers, key, method, page, paramStrings, params, perPage, route, server, url, value,
      _this = this;
    defaults = {
      server: 'API',
      auth: true,
      route: '',
      method: 'GET',
      page: -1,
      perPage: -1,
      params: {},
      body: null
    };
    $.extend(defaults, options);
    server = defaults.server;
    auth = defaults.auth;
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
      paramStrings.push("" + key + "=" + (encodeURIComponent(value)));
    }
    url = "" + (this.environment.baseURLFor(server)) + "/" + route;
    if (paramStrings.length > 0) {
      url += "?" + (paramStrings.join('&'));
    }
    headers = {
      "Accept": "application/json",
      "X-Firehose-Environment": this.environment.environment() === 'beta' ? "beta" : void 0
    };
    if (auth) {
      if ((this.APIAccessToken != null) && server === 'API') {
        $.extend(headers, {
          "Authorization": "Token token=\"" + this.APIAccessToken + "\""
        });
      } else if ((this.billingAccessToken != null) && server === 'billing') {
        $.extend(headers, {
          "Authorization": "Token token=\"" + this.billingAccessToken + "\""
        });
      }
    }
    return $.ajax({
      type: method,
      url: url,
      data: body ? JSON.stringify(body) : void 0,
      processData: false,
      dataType: 'json',
      headers: headers,
      contentType: 'application/json',
      statusCode: server === 'API' ? this.statusCodeHandlers || {} : void 0
    }).fail(function(jqXHR, textStatus, errorThrown) {
      var errors, json, _ref, _results;
      if (server === 'API') {
        if (_this.errorHandler != null) {
          _this.errorHandler(jqXHR, textStatus, errorThrown);
        }
        if (Number(jqXHR.status) === 422 && (jqXHR.responseJSON != null) && (object != null)) {
          json = jqXHR.responseJSON;
          if (json.constructor === Object) {
            delete object.errors;
            _ref = jqXHR.responseJSON;
            _results = [];
            for (key in _ref) {
              errors = _ref[key];
              _results.push(object.errors.push("" + (_this._humanize(key)) + " " + (errors.join(', '))));
            }
            return _results;
          } else if (json.constructor === Array) {
            return object.errors = json;
          } else {
            return object.errors = ("" + json).split("\n");
          }
        }
      }
    });
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

  Client.prototype._humanize = function(str) {
    return str.replace(/_id$/, '').replace(/_/g, ' ').replace(/^\w/g, function(s) {
      return s.toUpperCase();
    });
  };

  return Client;

})();

/*
A few methods are publicized on the client, although a mostly private object used internally.
@return [Client] The client singleton used by firehose.js internally.
*/


Firehose.client = new Firehose.Client;

Firehose.Object = (function() {
  /*
  @property [Number] Unique ID of object
  */

  Object.prototype.id = null;

  /*
  @property [Date] When the object was created on the server
  */


  Object.prototype.createdAt = null;

  /*
  @property [Array<String>] The errors the server returned about fields that did not contain valid values.
  */


  Object.prototype.errors = [];

  /*
  @property [Array<Object>] The static array that holds the entire object graph
  @nodoc
  */


  Object._objects = [];

  /*
  @note You never need to construct a `Firehose.Object` object directly. Use a subclass' factory method.
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
  @note A client-side library that uses observers often uses get/set methods. You can do `Firehose.Object.set = Ember.Object.set` for example.
  */


  Object.prototype.get = function(key) {
    return this[key];
  };

  /*
  A placeholder for third-party libraries to replace. (e.g Ember.js, Backbone.js)
  @note A client-side library that uses observers often uses get/set methods. You can do `Firehose.Object.get = Ember.Object.get` for example.
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
  Takes the `errors` property and formats it's items for display in HTML.
  @return [string] An HTML marked-up version of the `errors` property in the form of an unordered list (<ul>).
  */


  Object.prototype.HTMLErrorString = function() {
    var HTML, line, lines, _i, _len;
    HTML = "<ul>";
    lines = this.errors;
    if (lines != null) {
      for (_i = 0, _len = lines.length; _i < _len; _i++) {
        line = lines[_i];
        HTML += "<li>" + line + "</li>";
      }
    }
    HTML += "</ul>";
    return HTML;
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
    var object, objectJSON, objects, _i, _len;
    if (json != null) {
      objects = new Firehose.UniqueArray;
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        objectJSON = json[_i];
        object = creation(objectJSON);
        object._populateWithJSON(objectJSON);
        objects.push(object);
      }
      return owner.set(association, objects);
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
    if (!this.createdAt) {
      return this._setIfNotNull("createdAt", this._date(json.created_at));
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

  Object.prototype._textOrNull = function(value) {
    if ((value != null ? value.length : void 0) > 0) {
      return value;
    } else {
      return null;
    }
  };

  Object.prototype._date = function(dateString) {
    var date;
    date = new Date(dateString);
    if (isNaN(date)) {
      return null;
    } else {
      return date;
    }
  };

  return Object;

})();

var _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.Agent = (function(_super) {
  __extends(Agent, _super);

  function Agent() {
    this._handleSuccessfulLogin = __bind(this._handleSuccessfulLogin, this);
    _ref = Agent.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Agent._firehoseType = "Agent";

  /*
  @property [Agent] Once you call `login` or `signUPWith…` this will contain the logged in agent, available globally on the class.
  @example Firehose.Agent.loggedInAgent
  */


  Agent.loggedInAgent = null;

  /*
  @property [string] Available once the agent is logged in. You can store this locally for automatic login on the user's next visit.
  */


  Agent.prototype.accessToken = null;

  /*
  @property [string]
  */


  Agent.prototype.URLToken = null;

  /*
  @property [string]
  */


  Agent.prototype.firstName = null;

  /*
  @property [string]
  */


  Agent.prototype.lastName = null;

  /*
  @property [string]
  */


  Agent.prototype.email = null;

  /*
  @property [Company]
  */


  Agent.prototype.currentCompany = null;

  Agent.prototype._password = null;

  Agent.prototype.companies = null;

  Agent.prototype._setup = function() {
    return this.companies = new Firehose.UniqueArray;
  };

  Agent.agentWithAccessToken = function(accessToken) {
    return Firehose.Object._objectOfClassWithID(Firehose.Agent, {
      accessToken: accessToken
    });
  };

  Agent.agentWithEmailAndPassword = function(email, password) {
    return Firehose.Object._objectOfClassWithID(Firehose.Agent, {
      email: email,
      _password: password
    });
  };

  Agent.agentWithID = function(id) {
    return Firehose.Object._objectOfClassWithID(Firehose.Agent, {
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
    return Firehose.client.post(this, params).done(function(data) {
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
    Firehose.client.APIAccessToken = null;
    params = {
      route: 'login'
    };
    if ((this.email != null) && (this._password != null)) {
      params.body = {
        email: this.email,
        password: this._password
      };
    } else if (this.accessToken != null) {
      Firehose.client.APIAccessToken = this.accessToken;
    }
    return Firehose.client.post(this, params).done(function(data) {
      _this._populateWithJSON(data);
      return _this._handleSuccessfulLogin();
    });
  };

  /*
  Logs the agent out by invalidating the browser's auth token token and nulls out all the stored credentials that are used to authenticate requests.
  Any requests made after calling `logout()` on any agent will cause every request that requires authenticattion to fail.
  @return [Promise] A jqXHR Promise.
  */


  Agent.prototype.logout = function() {
    var params,
      _this = this;
    params = {
      route: 'logout'
    };
    return Firehose.client["delete"](this, params).always(function() {
      _this._setIfNotNull("accessToken", null);
      _this._setIfNotNull("URLToken", null);
      Firehose.Agent.loggedInAgent = null;
      Firehose.client.APIAccessToken = null;
      Firehose.client.URLToken = null;
      return Firehose.client.billingAccessToken = null;
    });
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
    return Firehose.client.get(this, params).done(function(data) {
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
    return Firehose.client.put(this, params);
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
    return Firehose.client["delete"](this, params).done(function() {
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
    return Firehose.client.put(this, params);
  };

  Agent.requestPasswordReset = function(email) {
    var params;
    params = {
      route: "request_reset_password",
      body: {
        email: email
      }
    };
    return Firehose.client.post(this, params);
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
    return Firehose.client.post(this, params);
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
    Firehose.client.APIAccessToken = this.accessToken;
    Firehose.client.URLToken = this.URLToken;
    return Firehose.Agent.loggedInAgent = this;
  };

  Agent.prototype._populateWithJSON = function(json) {
    var _this = this;
    if (this.accessToken == null) {
      this._setIfNotNull("accessToken", json.browser_token);
    }
    if (this.URLToken == null) {
      this._setIfNotNull("URLToken", json.url_token);
    }
    this._setIfNotNull("firstName", json.first_name);
    this._setIfNotNull("lastName", json.last_name);
    this._setIfNotNull("email", json.email);
    this._populateAssociatedObjects(this, "companies", json.companies, function(json) {
      return Firehose.Company.companyWithID(json.id, null, _this);
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.Company = (function(_super) {
  __extends(Company, _super);

  function Company() {
    _ref = Company.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Company._firehoseType = "Company";

  /*
  @property [string]
  */


  Company.prototype.title = null;

  /*
  @property [string]
  */


  Company.prototype.token = null;

  /*
  @property [Date]
  */


  Company.prototype.lastFetchAt = null;

  /*
  @property [string]
  */


  Company.prototype.forwardingEmailAddress = null;

  /*
  @property [integer]
  */


  Company.prototype.unresolvedCount = 0;

  /*
  @property [integer]
  */


  Company.prototype.numberOfAccounts = 0;

  /*
  @property [boolean]
  */


  Company.prototype.fetchAutomatically = true;

  /*
  @property [string]
  */


  Company.prototype.knowledgeBaseSubdomain = null;

  /*
  @property [string]
  */


  Company.prototype.knowledgeBaseCustomDomain = null;

  /*
  @property [string]
  */


  Company.prototype.knowledgeBaseCSS = null;

  /*
  @property [string]
  */


  Company.prototype.knowlegeBaseLayoutTemplate = null;

  /*
  @property [string]
  */


  Company.prototype.knowlegeBaseSearchTemplate = null;

  /*
  @property [string]
  */


  Company.prototype.knowlegeBaseArticleTemplate = null;

  /*
  @property [Array<Agent>]
  */


  Company.prototype.agents = null;

  /*
  @property [Array<AgentInvite>]
  */


  Company.prototype.agentInvites = null;

  /*
  @property [Array<Tag>]
  */


  Company.prototype.tags = null;

  /*
  @property [Array<CannedResponse>]
  */


  Company.prototype.cannedResponses = null;

  Company.prototype._customers = null;

  Company.prototype._notifications = null;

  Company.prototype._twitterAccounts = null;

  Company.prototype._facebookAccounts = null;

  Company.prototype._emailAccounts = null;

  Company.prototype._articles = null;

  Company.prototype._searchedArticles = null;

  /*
  @property [CreditCard]
  */


  Company.prototype.creditCard = null;

  /*
  @property [string]
  */


  Company.prototype.billingEmail = null;

  /*
  @property [float]
  */


  Company.prototype.billingRate = -1;

  /*
  @property [float]
  */


  Company.prototype.nextBillAmountBeforeDiscounts = 0.0;

  /*
  @property [float]
  */


  Company.prototype.nextBillAmountAfterDiscounts = 0.0;

  /*
  @property [boolean]
  */


  Company.prototype.isFreeTrialEligible = false;

  /*
  @property [Date]
  */


  Company.prototype.trialExpirationDate = null;

  /*
  @property [Array<Object>] Contains all the discounts for a billing account. Each object will have 4 keys: `name`, `applyType`, `amount`, `expirationDate`. `applyType` will be either `percentage` or `fixed amount`.
  */


  Company.prototype.discounts = null;

  /*
  @property [Date]
  */


  Company.prototype.nextBillingDate = null;

  /*
  @property [boolean]
  */


  Company.prototype.isGracePeriodOver = false;

  /*
  @property [integer]
  */


  Company.prototype.daysLeftInGracePeriod = -1;

  /*
  @property [boolean]
  */


  Company.prototype.isCurrent = false;

  /*
  @property [boolean]
  */


  Company.prototype.hasSuccessfulBilling = false;

  Company.prototype._creator = null;

  Company.prototype._setup = function() {
    this.agents = new Firehose.UniqueArray;
    this.agentInvites = new Firehose.UniqueArray;
    this.tags = new Firehose.UniqueArray;
    this.cannedResponses = new Firehose.UniqueArray;
    this.agents.sortOn("firstName");
    this.tags.sortOn("label");
    return this.cannedResponses.sortOn("name");
  };

  /*
  Create a brand new company with a title and an optional creator.
  @param title [string] The title of the company.
  @param creator [Agent] The creator of the company. You can leave blank and it will make the current agent the creator.
  */


  Company.companyWithTitle = function(title, creator) {
    return Firehose.Object._objectOfClassWithID(Firehose.Company, {
      title: title,
      _creator: creator || Firehose.Agent.loggedInAgent
    });
  };

  /*
  Create a company object when all you have is an id. You can then fetch articles or fetch the companies properties if you're authenticated as an agent of the company.
  @param id [number] The id of the company.
  @param token [number] The company token.
  @param creator [Agent] The agent that is the creator of this company. (This is mostly used internally).
  @return [Company] Returns a company object. If a company object with this id already exists in the cache, it will be returned.
  */


  Company.companyWithID = function(id, token, creator) {
    return Firehose.Object._objectOfClassWithID(Firehose.Company, {
      id: id,
      token: token,
      _creator: creator
    });
  };

  /*
  Create a company object when all you have is the subdomain for the knowledge base. You can then call `fetch` to get the company's `id` and `title`.
  @param subdomain [string] The subdomain of the company
  @return [Company] Returns a company object you can then call `fetch` on.
  */


  Company.companyWithKBSubdomain = function(subdomain) {
    return Firehose.Object._objectOfClassWithID(Firehose.Company, {
      knowledgeBaseSubdomain: subdomain
    });
  };

  /*
  Create a company object when all you have is the custom domain for the knowledge base. You can then call `fetch` to get the company's `id` and `title`.
  @param customDomain [string] The custom domain that maps (via a CNAME DNS record) to the subdomain of the company's kb.
  @return [Company] Returns a company object you can then call `fetch` on.
  */


  Company.companyWithKBCustomDomain = function(customDomain) {
    return Firehose.Object._objectOfClassWithID(Firehose.Company, {
      knowledgeBaseCustomDomain: customDomain
    });
  };

  /*
  Fetch a companies properties based on `id`, `knowledgeBaseSubdomain` or `knowledgeBaseCustomDomain`.
  @return [jqXHR Promise] Promise
  */


  Company.prototype.fetch = function(options) {
    var request, requested_settings,
      _this = this;
    if (options == null) {
      options = {};
    }
    if (this.id != null) {
      requested_settings = options.include_settings != null ? "?include=" + (options.include_settings.join(",")) : "";
      request = {
        route: "companies/" + this.id + requested_settings
      };
    } else if (this.knowledgeBaseSubdomain) {
      request = {
        auth: false,
        route: "companies",
        params: {
          kb_subdomain: this.knowledgeBaseSubdomain
        }
      };
    } else if (this.knowledgeBaseCustomDomain) {
      request = {
        auth: false,
        route: "companies",
        params: {
          kb_custom_domain: this.knowledgeBaseCustomDomain
        }
      };
    } else {
      throw "You can't call 'fetch' on a company unless 'id', 'knowledgeBaseSubdomain' or 'knowledgeBaseCustomDomain' is set.";
    }
    return Firehose.client.get(this, request).done(function(data) {
      return _this._populateWithJSON(data);
    });
  };

  /*
  Persists any changes you've made to the company to the server. Properties that can be updated: `title`, `fetch_automatically`
  @return [jqXHR Promise] Promise
  */


  Company.prototype.save = function() {
    var params,
      _this = this;
    if (this.id != null) {
      params = {
        route: "companies/" + this.id,
        body: this._toJSON()
      };
      return Firehose.client.put(this, params);
    } else {
      params = {
        route: "agents/" + this._creator.id + "/companies",
        body: this._toJSON()
      };
      return Firehose.client.post(this, params).done(function(data) {
        return _this._populateWithJSON(data);
      });
    }
  };

  /*
  Force a company to fetch it's accounts right now. (otherwise it's about every 10 minutes if `fetch_automatically` is true)
  @return [jqXHR Promise] Promise
  */


  Company.prototype.forceChannelsFetch = function() {
    var params;
    params = {
      route: "companies/" + this.id + "/force_channels_fetch"
    };
    return Firehose.client.put(this, params);
  };

  /*
  Destroy a company. This will destroy all data associated with the company, including customers, interactions, notes, etc. It is asynchronous, so it will
  not be deleted immediately but in the background over the course of possibly an hour.
  @return [jqXHR Promise] Promise
  */


  Company.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "companies/" + this.id
    };
    return Firehose.client["delete"](this, params).done(function() {
      return Firehose.Agent.loggedInAgent.companies.dropObject(_this);
    });
  };

  /*
  The customers of a company, filtered by a criteria.
  @param criteria [Object] A hash of criteria by which customers should be searched. 
  @option criteria [string] filter "everything" or "unresolved"
  @option criteria [string] channel A comma seperated list of channels to fetch (e.g. "twitter,email"). Omit to include all channels.
  @option criteria [string] sort "newest_first" or "oldest_first"
  @option criteria [string] search_text Any text that will be searched for an a customers name, email/twitter/facebook accunt name, and interaction body.
  @option criteria [string] preFetch Any one channel. If included, the server will synchronously fetch the channel specified. (e.g. "twitter")
  @return [RemoteArray<Customer>] The customer that matched the criteria.
  */


  Company.prototype.customersWithCriteria = function(criteria) {
    var params,
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
    this._customers = new Firehose.RemoteArray("companies/" + this.id + "/customers", params, function(json) {
      return Firehose.Customer.customerWithID(json.id, _this);
    });
    if (params.sort === 'newest_first') {
      this._customers.sortOn("newestInteractionReceivedAt", "desc");
    } else {
      this._customers.sortOn("newestInteractionReceivedAt", "asc");
    }
    if (criteria.preFetch != null) {
      this._customers.onceParams = {
        pre_fetch: criteria.preFetch
      };
    }
    return this._customers;
  };

  /*
  The notifications of a company.
  @return [RemoteArray<TwitterAccount>] the Twitter accounts
  */


  Company.prototype.notifications = function() {
    var _this = this;
    if (this._notifications == null) {
      this._setIfNotNull("_notifications", new Firehose.RemoteArray("companies/" + this.id + "/notifications", null, function(json) {
        return Firehose.Notification._notificationWithID(json.id, _this);
      }));
      this._notifications.sortOn("title");
    }
    return this._notifications;
  };

  /*
  The Twitter accounts of a company
  @return [RemoteArray<TwitterAccount>] the Twitter accounts
  */


  Company.prototype.twitterAccounts = function() {
    var _this = this;
    if (this._twitterAccounts == null) {
      this._setIfNotNull("_twitterAccounts", new Firehose.RemoteArray("companies/" + this.id + "/twitter_accounts", null, function(json) {
        return Firehose.TwitterAccount._twitterAccountWithID(json.id, _this);
      }));
      this._twitterAccounts.sortOn("screenName");
    }
    return this._twitterAccounts;
  };

  /* 
  The Facebook accounts of a company.
  @return [RemoteArray<facebookAccount>] The found articles.
  */


  Company.prototype.facebookAccounts = function() {
    var _this = this;
    if (this._facebookAccounts == null) {
      this._setIfNotNull("_facebookAccounts", new Firehose.RemoteArray("companies/" + this.id + "/facebook_accounts", null, function(json) {
        return Firehose.FacebookAccount._facebookAccountWithID(json.id, _this);
      }));
      this._facebookAccounts.sortOn("name");
    }
    return this._facebookAccounts;
  };

  /* 
  The email accounts of a company.
  @return [RemoteArray<EmailAccount>] The found articles.
  */


  Company.prototype.emailAccounts = function() {
    var _this = this;
    if (this._emailAccounts == null) {
      this._setIfNotNull("_emailAccounts", new Firehose.RemoteArray("companies/" + this.id + "/email_accounts", null, function(json) {
        return Firehose.EmailAccount._emailAccountWithID(json.id, _this);
      }));
      this._emailAccounts.sortOn("username");
    }
    return this._emailAccounts;
  };

  /* 
  All the articles of a company.
  @return [RemoteArray<Article>] The found articles.
  */


  Company.prototype.articles = function() {
    var articlesRemoteArray,
      _this = this;
    if (this._articles == null) {
      articlesRemoteArray = new Firehose.RemoteArray("companies/" + this.id + "/articles", null, function(json) {
        return Firehose.Article.articleWithID(json.id, _this);
      });
      articlesRemoteArray.auth = false;
      this._setIfNotNull("_articles", articlesRemoteArray);
    }
    return this._articles;
  };

  /*
  Returns a remote array of articles found by searching for `text`.
  @param text [string] The string of text you want to search for articles containing.
  @note Every time you call this on a company, you are creating a new remote array and any previously created have their network requests cancelled.
  @return [RemoteArray<Article>] The found articles.
  */


  Company.prototype.searchedArticles = function(text) {
    var articlesRemoteArray, currentSearchedArticles,
      _this = this;
    currentSearchedArticles = this.get('_searchedArticles');
    if (currentSearchedArticles) {
      currentSearchedArticles.abort();
    }
    articlesRemoteArray = new Firehose.RemoteArray("companies/" + this.id + "/article_search", {
      q: text
    }, function(json) {
      var article;
      article = Firehose.Article.articleWithID(json.id, _this);
      article._populateWithJSON(json);
      return article;
    });
    articlesRemoteArray.auth = false;
    this._setIfNotNull("_searchedArticles", articlesRemoteArray);
    return articlesRemoteArray;
  };

  /*
  Associates an agent with a company.
  @param agent [Agent] The agent to add.
  @return [jqXHR Promise] Promise
  */


  Company.prototype.addAgent = function(agent) {
    var params,
      _this = this;
    params = {
      route: "companies/" + this.id + "/agents/" + agent.id
    };
    return Firehose.client.put(this, params).done(function() {
      return _this.agents.insertObject(agent);
    });
  };

  /*
  Removes an agent's association with a company.
  @param agent [Agent] The agent to remove.
  @return [jqXHR Promise] Promise
  */


  Company.prototype.removeAgent = function(agent) {
    var params,
      _this = this;
    params = {
      route: "companies/" + this.id + "/agents/" + agent.id
    };
    return Firehose.client["delete"](this, params).done(function() {
      return _this.agents.dropObject(agent);
    });
  };

  /*
  Fetches the billing info for the company from the billing server.
  This will populate `discounts` with a list of discount objects each having the follower properties:
    name: [string] The name of the discount.
    applyType: [string] either "percentage" or "fixed amount"
    amount: [number] The percentage or fixed amount to discount from the total price.
    expirationDate: [Date] When the discount expires and should not longer be applied to the monthly billing.
    @return [jqXHR Promise] Promise
  */


  Company.prototype.fetchBillingInfo = function() {
    var fetchBlock,
      _this = this;
    fetchBlock = function() {
      var params;
      Firehose.client.billingAccessToken = _this.token;
      params = {
        server: "billing",
        route: "entities/" + _this.id
      };
      return Firehose.client.get(_this, params).done(function(json) {
        var discount, discountAmt, discountAmtStr, totalDiscount, _i, _len, _ref1;
        if (json.credit_card != null) {
          _this._setIfNotNull("creditCard", Firehose.CreditCard.creditCardWithID(json.credit_card.id, _this));
          _this.creditCard._populateWithJSON(json.credit_card);
        }
        _this._setIfNotNull("billingEmail", json.email || Firehose.Agent.loggedInAgent.email);
        _this._setIfNotNull("billingRate", (json.rate / 100.0).toFixed(2));
        _this._setIfNotNull("nextBillAmountBeforeDiscounts", (_this.billingRate * _this.agents.length).toFixed(2));
        _this._setIfNotNull("isFreeTrialEligible", json.is_free_trial_eligible);
        _this._setIfNotNull("trialExpirationDate", _this._date(json.free_trial_expiration_date) || new Date(+(new Date) + 12096e5));
        _this._setIfNotNull("nextBillingDate", json.next_bill_date ? _this._date(json.next_bill_date) : void 0);
        _this._setIfNotNull("isGracePeriodOver", json.grace_period_over);
        _this._setIfNotNull("daysLeftInGracePeriod", json.days_left_in_grace_period);
        _this._setIfNotNull("isCurrent", json.current);
        _this._setIfNotNull("hasSuccessfulBilling", json.has_successful_billing);
        totalDiscount = 0.0;
        discountAmt = 0.0;
        discountAmtStr = "";
        _this.discounts = [];
        _ref1 = json.discount_list;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          discount = _ref1[_i];
          if (discount.apply_type === "fixed amount") {
            discountAmt = (discount.amount / 100.0).toFixed(2);
            discountAmtStr = "$" + discountAmt;
            totalDiscount = Number(totalDiscount) + Number(discountAmt);
          } else {
            discountAmt = discount.amount;
            discountAmtStr = discountAmt + "%";
            totalDiscount = Number(totalDiscount) + Number(_this.nextBillAmountBeforeDiscounts * (discountAmt / 100));
          }
          _this.discounts.push({
            name: discount.name,
            applyType: discount.apply_type,
            amount: discountAmt,
            amountStr: discountAmtStr,
            expirationDate: discount.expiration_date ? _this._date(discount.expiration_date) : void 0
          });
        }
        return _this.nextBillAmountAfterDiscounts = (Number(totalDiscount) > Number(_this.nextBillAmountBeforeDiscounts) ? 0 : _this.nextBillAmountBeforeDiscounts - totalDiscount).toFixed(2);
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

  /*
  If the company is still in trial and has 3 days left in its trial, the trial can be extended by the length of the original trial period.
  @return [jqXHR Promise] Promise
  */


  Company.prototype.extendTrial = function() {
    var requestBlock,
      _this = this;
    requestBlock = function() {
      var params;
      Firehose.client.billingAccessToken = _this.token;
      params = {
        server: "billing",
        route: "entities/" + _this.id + "/renew_trial"
      };
      return Firehose.client.put(_this, params).done(function(json) {
        return _this._setIfNotNull("trialExpirationDate", _this._date(json.free_trial_expiration_date));
      });
    };
    if (this.token) {
      return requestBlock();
    } else {
      return this.fetch().then(function() {
        return requestBlock();
      });
    }
  };

  /*
  Returns the base URL for the company's knowledge base for the current environment.
  @note In production, if a custom domain is set on the company, it returns that. Otherwise, it returns the companies subdomain URL. (i.e. msytrou.firehosehelp.com)
  @note The beta URL for the kb is firehosesupport.com. So instead of mystrou.firehosehelp.com like in production, the beta URL would be mystrou.firehosesupport.com.
  @return [string] The URL for the company's knowledge base in the current environment.
  */


  Company.prototype.kbBaseURL = function() {
    var customDomain;
    if (Firehose.environment() === 'production' && (customDomain = this.get('knowledgeBaseCustomDomain'))) {
      return "http://" + customDomain;
    } else {
      return Firehose.baseURLFor('kb', this.get('knowledgeBaseSubdomain'));
    }
  };

  Company.prototype._populateWithJSON = function(json) {
    var _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7,
      _this = this;
    this._setIfNotNull("title", json.title);
    if (this.token == null) {
      this._setIfNotNull("token", json.token);
    }
    if (json.last_fetch_at != null) {
      this._setIfNotNull("lastFetchAt", this._date(json.last_fetch_at));
    }
    if (this.forwardingEmailAddress == null) {
      this._setIfNotNull("forwardingEmailAddress", json.forwarding_email);
    }
    this._setIfNotNull("unresolvedCount", json.unresolved_count);
    this._setIfNotNull("numberOfAccounts", json.number_of_accounts);
    this._setIfNotNull("fetchAutomatically", (_ref1 = json.company_settings) != null ? _ref1.fetch_automatically : void 0);
    this._setIfNotNull("knowledgeBaseSubdomain", (_ref2 = json.company_settings) != null ? _ref2.kb_subdomain : void 0);
    this._setIfNotNull("knowledgeBaseCustomDomain", (_ref3 = json.company_settings) != null ? _ref3.kb_custom_domain : void 0);
    this._setIfNotNull("knowledgeBaseCSS", (_ref4 = json.company_settings) != null ? _ref4.kb_css : void 0);
    this._setIfNotNull("knowledgeBaseLayoutTemplate", (_ref5 = json.company_settings) != null ? _ref5.kb_layout_template : void 0);
    this._setIfNotNull("knowledgeBaseSearchTemplate", (_ref6 = json.company_settings) != null ? _ref6.kb_search_template : void 0);
    this._setIfNotNull("knowledgeBaseArticleTemplate", (_ref7 = json.company_settings) != null ? _ref7.kb_article_template : void 0);
    this._populateAssociatedObjects(this, "agents", json.agents, function(json) {
      var agent;
      agent = Firehose.Agent.agentWithID(json.id);
      agent.companies.insertObject(_this);
      return agent;
    });
    this._populateAssociatedObjects(this, "agentInvites", json.agent_invites, function(json) {
      return Firehose.AgentInvite._agentInviteWithID(json.id, _this);
    });
    this._populateAssociatedObjects(this, "tags", json.tags, function(json) {
      return Firehose.Tag._tagWithID(json.id, _this);
    });
    this._populateAssociatedObjects(this, "cannedResponses", json.canned_responses, function(json) {
      return Firehose.CannedResponse._cannedResponseWithID(json.id, _this);
    });
    Firehose.client.billingAccessToken = this.token;
    return Company.__super__._populateWithJSON.call(this, json);
  };

  Company.prototype._toJSON = function() {
    return {
      company: {
        title: this.title,
        company_settings_attributes: {
          fetch_automatically: this.fetchAutomatically,
          kb_subdomain: this.knowledgeBaseSubdomain ? this.knowledgeBaseSubdomain : void 0,
          kb_custom_domain: this._textOrNull(this.knowledgeBaseCustomDomain),
          kb_css: this._textOrNull(this.knowledgeBaseCSS),
          kb_layout_template: this._textOrNull(this.knowledgeBaseLayoutTemplate),
          kb_search_template: this._textOrNull(this.knowledgeBaseSearchTemplate),
          kb_article_template: this._textOrNull(this.knowledgeBaseArticleTemplate)
        }
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.Interaction = (function(_super) {
  __extends(Interaction, _super);

  function Interaction() {
    _ref = Interaction.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Interaction._firehoseType = "Interaction";

  /*
  @property [Customer]
  */


  Interaction.prototype.customer = null;

  /*
  @property [string]
  */


  Interaction.prototype.token = null;

  /*
  @property [string]
  */


  Interaction.prototype.responseDraft = null;

  /*
  @property [integer] 1 = unhappy, 2 = satisfied, 3 = happy
  @deprecated
  */


  Interaction.prototype.happiness = null;

  /*
  @property [boolean]
  */


  Interaction.prototype.resolved = false;

  /*
  @property [boolean]
  */


  Interaction.prototype.isOutgoing = null;

  /*
  @property [string]
  */


  Interaction.prototype.body = null;

  /*
  @property [string]
  */


  Interaction.prototype.privateURL = null;

  /*
  @property [string] What channel the interaction is through (email, fb, twitter)
  */


  Interaction.prototype.channel = null;

  /*
  @property [Date]
  */


  Interaction.prototype.receivedAt = null;

  /*
  @property [CustomerAccount] The account this interaction is linked to.
  */


  Interaction.prototype.customerAccount = null;

  /*
  @property [Agent] If this is a response interaction, the agent that wrote it.
  */


  Interaction.prototype.agent = null;

  /*
  @property [Interaction]
  */


  Interaction.prototype.originalInteraction = null;

  /*
  @property [Array<Interaction>]
  */


  Interaction.prototype.responseInteractions = null;

  /*
  @property [Array<Note>]
  */


  Interaction.prototype.notes = null;

  /*
  @property [Array<Tag>]
  */


  Interaction.prototype.tags = null;

  /*
  @property [Array<Agent>]
  */


  Interaction.prototype.flaggedAgents = null;

  Interaction.prototype._setup = function() {
    this.responseInteractions = new Firehose.UniqueArray;
    this.notes = new Firehose.UniqueArray;
    this.tags = new Firehose.UniqueArray;
    this.flaggedAgents = new Firehose.UniqueArray;
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
    return Firehose.Object._objectOfClassWithID(Firehose.Interaction, {
      token: token
    });
  };

  Interaction._interactionWithJSON = function(json, customer) {
    var interaction;
    interaction = null;
    if (json.channel === "twitter") {
      interaction = Firehose.TwitterInteraction._twitterInteractionWithID(json.id);
    } else if (json.channel === "facebook") {
      interaction = Firehose.FacebookInteraction._facebookInteractionWithID(json.id);
    } else if (json.channel === "email") {
      interaction = Firehose.EmailInteraction._emailInteractionWithID(json.id);
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
    return Firehose.client.post(this, params).done(function(data) {
      var response;
      _this._setIfNotNull("responseDraft", null);
      response = Firehose.Interaction._interactionWithJSON(data, _this.customer);
      _this.responseInteractions.insertObject(response);
      response._setIfNotNull("agent", Firehose.Agent.loggedInAgent);
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
    return Firehose.client.put(this, params);
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
    return Firehose.client.get(this, params).done(function(data) {
      return _this._populateWithJSON(data);
    });
  };

  Interaction.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "interactions/" + this.id
    };
    return Firehose.client["delete"](this, params).done(function() {
      return _this.customer.interactions().dropObject(_this);
    });
  };

  Interaction.prototype.addTag = function(tag) {
    var params,
      _this = this;
    params = {
      route: "interactions/" + this.id + "/tags/" + tag.id
    };
    return Firehose.client.put(this, params).done(function() {
      return _this.tags.insertObject(tag);
    });
  };

  Interaction.prototype.removeTag = function(tag) {
    var params,
      _this = this;
    params = {
      route: "interactions/" + this.id + "/tags/" + tag.id
    };
    return Firehose.client["delete"](this, params).done(function() {
      return _this.tags.dropObject(tag);
    });
  };

  Interaction.prototype.flagAgent = function(agent) {
    var params,
      _this = this;
    params = {
      route: "interactions/" + this.id + "/agents/" + agent.id
    };
    return Firehose.client.put(this, params).done(function() {
      return _this.flaggedAgents.insertObject(agent);
    });
  };

  Interaction.prototype.unflagAgent = function(agent) {
    var params,
      _this = this;
    params = {
      route: "interactions/" + this.id + "/agents/" + agent.id
    };
    return Firehose.client["delete"](this, params).done(function() {
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
    this._setIfNotNull("receivedAt", this._date(json.received_at));
    this._setIfNotNull("privateURL", json.private_url);
    this._setIfNotNull("happiness", json.happiness);
    this._setIfNotNull("resolved", json.resolved);
    this._setIfNotNull("isOutgoing", json.outgoing);
    this._populateAssociatedObjectWithJSON(this, "agent", json.agent, function(json) {
      return Firehose.Agent.agentWithID(json.id);
    });
    this._populateAssociatedObjectWithJSON(this, "customerAccount", json.customer_account, function(json) {
      json.channel = _this.channel;
      return Firehose.CustomerAccount._customerAccountWithID(json.id, _this.customer);
    });
    this._populateAssociatedObjects(this, "responseInteractions", json.response_interactions, function(json) {
      var interaction;
      json.channel = _this.channel;
      interaction = Firehose.Interaction._interactionWithJSON(json, _this.customer);
      interaction.set('originalInteraction', _this);
      return interaction;
    });
    this._populateAssociatedObjects(this, "notes", json.notes, function(json) {
      return Firehose.Note._noteWithID(json.id, _this);
    });
    this._populateAssociatedObjects(this, "tags", json.tags, function(json) {
      return Firehose.Tag._tagWithID(json.id, _this.customer.company);
    });
    this._populateAssociatedObjects(this, "flaggedAgents", json.flagged_agents, function(json) {
      return Firehose.Agent.agentWithID(json.id);
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.AgentInvite = (function(_super) {
  __extends(AgentInvite, _super);

  function AgentInvite() {
    _ref = AgentInvite.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  AgentInvite._firehoseType = "AgentInvite";

  /*
  @property [string]
  */


  AgentInvite.prototype.toEmail = null;

  /*
  @property [Company]
  */


  AgentInvite.prototype.company = null;

  AgentInvite.agentInviteWithEmail = function(email, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.AgentInvite, {
      toEmail: email,
      company: company
    });
  };

  AgentInvite._agentInviteWithID = function(id, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.AgentInvite, {
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
    return Firehose.client.post(this, params).done(function(data) {
      _this._populateWithJSON(data);
      return _this.company.agentInvites.insertObject(_this);
    });
  };

  AgentInvite.prototype.resend = function() {
    var params;
    params = {
      route: "agent_invites/" + this.id + "/resend"
    };
    return Firehose.client.put(this, params);
  };

  AgentInvite.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "agent_invites/" + this.id
    };
    return Firehose.client["delete"](this, params).done(function() {
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.Attachment = (function(_super) {
  __extends(Attachment, _super);

  function Attachment() {
    _ref = Attachment.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Attachment._firehoseType = "Attachment";

  /*
  @property [EmailInteraction]
  */


  Attachment.prototype.emailInteraction = null;

  /*
  @property [string]
  */


  Attachment.prototype.filename = null;

  /*
  @property [string]
  */


  Attachment.prototype.temporaryURL = null;

  Attachment._attachmentWithID = function(id, emailInteraction) {
    return Firehose.Object._objectOfClassWithID(Firehose.Attachment, {
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.CannedResponse = (function(_super) {
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
    return Firehose.Object._objectOfClassWithID(Firehose.CannedResponse, {
      name: name,
      text: text,
      company: company
    });
  };

  CannedResponse._cannedResponseWithID = function(id, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.CannedResponse, {
      id: id,
      company: company
    });
  };

  /*
  Save the canned response to the server.
  @return [Promise] A jqXHR Promise.
  @note If it has never been saved, it creates it on the server. Otherwise it updates it.
  @example Creating and saving a canned response.
    cannedResponse = Firehose.CannedResponse.cannedResponseWithNameAndText "Name", "Canned Response", company
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
      return Firehose.client.put(this, params);
    } else {
      params = {
        route: "companies/" + this.company.id + "/canned_responses",
        body: this._toJSON()
      };
      return Firehose.client.post(this, params).done(function(data) {
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
    return Firehose.client["delete"](this, params).done(function() {
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.CreditCard = (function(_super) {
  __extends(CreditCard, _super);

  function CreditCard() {
    _ref = CreditCard.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  CreditCard._firehoseType = "CreditCard";

  /*
  @property [Company]
  */


  CreditCard.prototype.company = null;

  /*
  @property [string] Only ever populated when set locally in preparation for submitting to Stripe.
  */


  CreditCard.prototype.number = null;

  /*
  @property [string] Only ever populated when set locally in preparation for submitting to Stripe.
  */


  CreditCard.prototype.cvc = null;

  /*
  @property [string]
  */


  CreditCard.prototype.expirationMonth = null;

  /*
  @property [string]
  */


  CreditCard.prototype.expirationYear = null;

  /*
  @property [string]
  */


  CreditCard.prototype.lastFour = null;

  /*
  @property [string]
  */


  CreditCard.prototype.stripeToken = null;

  /*
  @property [string] The e-mail receipts will be sent to.
  */


  CreditCard.prototype.email = null;

  CreditCard.creditCardWithNumber = function(number, cvc, expMonth, expYear, email, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.CreditCard, {
      number: number,
      cvc: cvc,
      expirationMonth: expMonth,
      expirationYear: expYear,
      email: email,
      company: company
    });
  };

  CreditCard.creditCardWithID = function(id, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.CreditCard, {
      id: id,
      company: company
    });
  };

  CreditCard.prototype.submitToStripe = function(callback, ccEmail) {
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
        _this._setIfNotNull("email", ccEmail != null ? ccEmail : Firehose.Agent.loggedInAgent.email);
        return callback();
      } else {
        return callback(response.error);
      }
    });
  };

  CreditCard.prototype.save = function() {
    var params,
      _this = this;
    Firehose.client.billingAccessToken = this.company.token;
    params = {
      server: "billing",
      route: "entities/" + this.company.id + "/credit_card",
      body: this._toJSON()
    };
    return Firehose.client.put(this, params).done(function() {
      return _this.company.set('creditCard', _this);
    });
  };

  CreditCard.prototype.fetch = function() {
    var params,
      _this = this;
    Firehose.client.billingAccessToken = this.company.token;
    params = {
      server: "billing",
      route: "entities/" + this.company.id + "/credit_card"
    };
    return Firehose.client.get(this, params).done(function(data) {
      return _this._populateWithJSON(data);
    });
  };

  CreditCard.prototype.destroy = function() {
    var params,
      _this = this;
    Firehose.client.billingAccessToken = this.company.token;
    params = {
      server: "billing",
      route: "entities/" + this.company.id + "/credit_card"
    };
    return Firehose.client["delete"](this, params).done(function() {
      return _this.company.set('creditCard', null);
    });
  };

  CreditCard.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("expirationMonth", json.expiration_month);
    this._setIfNotNull("expirationYear", json.expiration_year);
    this._setIfNotNull("lastFour", json.last_four);
    this._setIfNotNull("email", json.email);
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.Customer = (function(_super) {
  __extends(Customer, _super);

  function Customer() {
    _ref = Customer.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Customer._firehoseType = "Customer";

  /*
  @property [Company]
  */


  Customer.prototype.company = null;

  /*
  @property [string]
  */


  Customer.prototype.name = null;

  /*
  @property [string]
  */


  Customer.prototype.location = null;

  /*
  @property [string]
  */


  Customer.prototype.timeZone = null;

  /*
  @property [integer]
  */


  Customer.prototype.newestInteractionId = null;

  /*
  @property [string]
  */


  Customer.prototype.newestInteractionExcerpt = null;

  /*
  @property [Date]
  */


  Customer.prototype.newestInteractionReceivedAt = null;

  /*
  @property [Agent]
  */


  Customer.prototype.agentWithDibs = null;

  /*
  @property [Array<CustomerAccount>]
  */


  Customer.prototype.customerAccounts = null;

  /*
  @property [Array<Agent>]
  */


  Customer.prototype.customerFlaggedAgents = null;

  Customer.prototype._interactions = null;

  Customer.prototype._setup = function() {
    this.customerAccounts = new Firehose.UniqueArray;
    this.customerFlaggedAgents = new Firehose.UniqueArray;
    return this.customerFlaggedAgents.sortOn("firstName");
  };

  /*
  If you have a customer's id, you can create a customer object and then call `fetch` to populate it.
  @param [number] The customer identifier.
  @param [Company] The company this customer belongs to.
  @return [Customer] A customer you can now call `fetch` on to populate.
  */


  Customer.customerWithID = function(id, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.Customer, {
      id: id,
      company: company
    });
  };

  /*
  In a customer list, sometimes a pusher event can send you customer json and you need a way to create a customer from it.
  @param [Object] JSON of the customer.
  @param [Company] The company this customer belongs to.
  @return [Customer] A customer populated with the JSON.
  */


  Customer.customerWithJSON = function(json, company) {
    var customer;
    customer = this.customerWithID(json.id, company);
    customer._populateWithJSON(json);
    return customer;
  };

  /*
  If the customer has a valid `id` this will fetch and populate this customer object with data on the server.
  @return [Promise] A jqXHR object.
  */


  Customer.prototype.fetch = function() {
    var params,
      _this = this;
    params = {
      route: "customers/" + this.id
    };
    return Firehose.client.get(this, params).done(function(data) {
      return _this._populateWithJSON(data);
    });
  };

  Customer.prototype.resolveAllInteractions = function() {
    var params;
    params = {
      route: "customers/" + this.id + "/resolve_all_interactions"
    };
    return Firehose.client.put(this, params);
  };

  Customer.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "customers/" + this.id
    };
    return Firehose.client["delete"](this, params).done(function() {
      var _ref1;
      return (_ref1 = _this.company._customers) != null ? _ref1.dropObject(_this) : void 0;
    });
  };

  Customer.prototype.interactions = function() {
    var _this = this;
    if (this._interactions == null) {
      this._setIfNotNull("_interactions", new Firehose.RemoteArray("customers/" + this.id + "/interactions", null, function(json) {
        return Firehose.Interaction._interactionWithJSON(json, _this);
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
    this._setIfNotNull("newestInteractionReceivedAt", this._date(json.newest_interaction_received_at));
    this._populateAssociatedObjects(this, "customerAccounts", json.customer_accounts, function(json) {
      return Firehose.CustomerAccount._customerAccountWithID(json.id, _this);
    });
    this._populateAssociatedObjects(this, "customerFlaggedAgents", json.interaction_flagged_agents, function(json) {
      return Firehose.Agent.agentWithID(json.id);
    });
    this._populateAssociatedObjectWithJSON(this, "agentWithDibs", json.agent_with_dibs, function(json) {
      return Firehose.Agent.agentWithID(json.id);
    });
    return Customer.__super__._populateWithJSON.call(this, json);
  };

  return Customer;

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.CustomerAccount = (function(_super) {
  __extends(CustomerAccount, _super);

  function CustomerAccount() {
    _ref = CustomerAccount.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  CustomerAccount._firehoseType = "CustomerAccount";

  /*
  @property [Customer]
  */


  CustomerAccount.prototype.customer = null;

  /*
  @property [string]
  */


  CustomerAccount.prototype.username = null;

  /*
  @property [boolean]
  */


  CustomerAccount.prototype.followingUs = null;

  /*
  @property [string]
  */


  CustomerAccount.prototype.imageURL = null;

  /*
  @property [string]
  */


  CustomerAccount.prototype.description = null;

  /*
  @property [integer]
  */


  CustomerAccount.prototype.followersCount = null;

  /*
  @property [string]
  */


  CustomerAccount.prototype.channel = null;

  CustomerAccount._customerAccountWithID = function(id, customer) {
    return Firehose.Object._objectOfClassWithID(Firehose.CustomerAccount, {
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.EmailAccount = (function(_super) {
  __extends(EmailAccount, _super);

  function EmailAccount() {
    _ref = EmailAccount.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  EmailAccount._firehoseType = "EmailAccount";

  /*
  @property [Company]
  */


  EmailAccount.prototype.company = null;

  /*
  @property [string]
  */


  EmailAccount.prototype.emailAddress = null;

  /*
  @property [boolean]
  */


  EmailAccount.prototype.isForwarding = false;

  /*
  @property [string]
  */


  EmailAccount.prototype.title = null;

  /*
  @property [string] Can be either `IMAP` or `POP`
  */


  EmailAccount.prototype.kind = 'IMAP';

  /*
  @property [string]
  */


  EmailAccount.prototype.server = null;

  /*
  @property [string]
  */


  EmailAccount.prototype.port = null;

  /*
  @property [string]
  */


  EmailAccount.prototype.username = null;

  /*
  @property [string]
  */


  EmailAccount.prototype.password = null;

  /*
  @property [boolean]
  */


  EmailAccount.prototype.SSL = true;

  /*
  @property [boolean]
  */


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
    return Firehose.Object._objectOfClassWithID(Firehose.EmailAccount, emailAccount);
  };

  EmailAccount._emailAccountWithID = function(id, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.EmailAccount, {
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
      return Firehose.client.put(this, params);
    } else {
      params = {
        route: "companies/" + this.company.id + "/email_accounts",
        body: this._toJSON()
      };
      return Firehose.client.post(this, params).done(function(data) {
        _this._populateWithJSON(data);
        return _this.company.emailAccounts().insertObject(_this);
      });
    }
  };

  EmailAccount.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "email_accounts/" + this.id
    };
    return Firehose.client["delete"](this, params).done(function() {
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
      domain: "live.com",
      kind: "POP",
      SSL: true,
      port: 995,
      server: "pop3.live.com"
    }, {
      domain: "outlook.com",
      kind: "IMAP",
      SSL: true,
      port: 993,
      server: "imap-mail.outlook.com"
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
    var domain, service, _i, _len, _ref1, _ref2;
    if ((_ref1 = this.username) != null ? _ref1.trim() : void 0) {
      _ref2 = this._popularServices;
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        service = _ref2[_i];
        domain = "@" + service.domain;
        if (this.username.indexOf(domain) !== -1) {
          this._setIfNotNull("kind", service.kind);
          this._setIfNotNull("SSL", service.SSL);
          this._setIfNotNull("port", service.port);
          this._setIfNotNull("server", service.server);
          this._setIfNotNull("isForwarding", false);
          this.errors = [];
          return true;
        }
      }
    }
    this.errors = ["More information needed"];
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
        email: this.emailAddress ? this.emailAddress : void 0,
        title: this.title ? this.title : void 0,
        forwarding: this.isForwarding ? this.isForwarding : void 0,
        incoming_server: this.server ? this.server : void 0,
        incoming_ssl: this.SSL ? this.SSL : void 0,
        incoming_port: this.port ? this.port : void 0,
        incoming_username: this.username ? this.username : void 0,
        incoming_password: this.password ? this.password : void 0,
        kind: this.kind ? this.kind : void 0,
        delete_from_server: this.deleteFromServer ? this.deleteFromServer : void 0
      }
    };
  };

  return EmailAccount;

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.EmailInteraction = (function(_super) {
  __extends(EmailInteraction, _super);

  function EmailInteraction() {
    _ref = EmailInteraction.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  EmailInteraction._firehoseType = "EmailInteraction";

  /*
  @property [EmailAccount]
  */


  EmailInteraction.prototype.emailAccount = null;

  /*
  @property [string]
  */


  EmailInteraction.prototype.emailSubject = null;

  /*
  @property [string]
  */


  EmailInteraction.prototype.replyTo = null;

  /*
  @property [string]
  */


  EmailInteraction.prototype.toEmail = null;

  /*
  @property [string]
  */


  EmailInteraction.prototype.fromEmail = null;

  /*
  @property [Array<Attachment>]
  */


  EmailInteraction.prototype.attachments = null;

  EmailInteraction.prototype._setup = function() {
    return this.attachments = new Firehose.UniqueArray;
  };

  EmailInteraction._emailInteractionWithID = function(id) {
    return Firehose.Object._objectOfClassWithID(Firehose.EmailInteraction, {
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
        return Firehose.Attachment._attachmentWithID(json.id, _this);
      });
      this._populateAssociatedObjectWithJSON(this, "emailAccount", emailJSON.email_account, function(json) {
        return Firehose.EmailAccount._emailAccountWithID(json.id);
      });
    }
    return EmailInteraction.__super__._populateWithJSON.call(this, json);
  };

  return EmailInteraction;

})(Firehose.Interaction);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.FacebookAccount = (function(_super) {
  __extends(FacebookAccount, _super);

  function FacebookAccount() {
    _ref = FacebookAccount.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  FacebookAccount._firehoseType = "FacebookAccount";

  /*
  @property [Company]
  */


  FacebookAccount.prototype.company = null;

  /*
  @property [string]
  */


  FacebookAccount.prototype.username = null;

  /*
  @property [string]
  */


  FacebookAccount.prototype.facebookUserId = null;

  /*
  @property [string]
  */


  FacebookAccount.prototype.imageURL = null;

  /*
  @property [string]
  */


  FacebookAccount.prototype.name = null;

  /*
  @property [Array<FacebookPage>]
  */


  FacebookAccount.prototype.facebookPages = null;

  FacebookAccount.prototype._setup = function() {
    return this.facebookPages = new Firehose.UniqueArray;
  };

  FacebookAccount._facebookAccountWithID = function(id, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.FacebookAccount, {
      id: id,
      company: company
    });
  };

  FacebookAccount.OAuthURLForCompanyWithCallback = function(company, callback) {
    return "" + (Firehose.baseURLFor('API')) + "/companies/" + company.id + "/oauth_facebook?url_token=" + Firehose.client.URLToken + "&callback_url=" + (encodeURIComponent(callback));
  };

  FacebookAccount.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "facebook_accounts/" + this.id
    };
    return Firehose.client["delete"](this, params).done(function() {
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
      return Firehose.FacebookPage._facebookPageWithID(json.id, _this);
    });
    return FacebookAccount.__super__._populateWithJSON.call(this, json);
  };

  return FacebookAccount;

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.FacebookInteraction = (function(_super) {
  __extends(FacebookInteraction, _super);

  function FacebookInteraction() {
    _ref = FacebookInteraction.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  FacebookInteraction._firehoseType = "FacebookInteraction";

  /*
  @property [FacebookAccount]
  */


  FacebookInteraction.prototype.facebookAccount = null;

  /*
  @property [string]
  */


  FacebookInteraction.prototype.fromUserId = null;

  /*
  @property [string]
  */


  FacebookInteraction.prototype.fromName = null;

  /*
  @property [string]
  */


  FacebookInteraction.prototype.toUserId = null;

  /*
  @property [string]
  */


  FacebookInteraction.prototype.toName = null;

  /*
  @property [string]
  */


  FacebookInteraction.prototype.postId = null;

  /*
  @property [string]
  */


  FacebookInteraction.prototype.commentId = null;

  /*
  @property [string] either `post`, `comment` or `message`
  */


  FacebookInteraction.prototype.postType = null;

  /*
  @property [string]
  */


  FacebookInteraction.prototype.postExcerpt = null;

  /*
  @property [integer]
  */


  FacebookInteraction.prototype.likeCount = 0;

  FacebookInteraction._facebookInteractionWithID = function(id) {
    return Firehose.Object._objectOfClassWithID(Firehose.FacebookInteraction, {
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
        return Firehose.FacebookAccount._facebookAccountWithID(json.id);
      });
    }
    return FacebookInteraction.__super__._populateWithJSON.call(this, json);
  };

  return FacebookInteraction;

})(Firehose.Interaction);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.FacebookPage = (function(_super) {
  __extends(FacebookPage, _super);

  function FacebookPage() {
    _ref = FacebookPage.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  FacebookPage._firehoseType = "FacebookPage";

  /*
  @property [FacebookAccount]
  */


  FacebookPage.prototype.facebookAccount = null;

  /*
  @property [string]
  */


  FacebookPage.prototype.name = null;

  /*
  @property [string]
  */


  FacebookPage.prototype.category = null;

  /*
  @property [string]
  */


  FacebookPage.prototype.pageId = null;

  /*
  @property [boolean]
  */


  FacebookPage.prototype.active = false;

  FacebookPage._facebookPageWithID = function(id, facebookAccount) {
    return Firehose.Object._objectOfClassWithID(Firehose.FacebookPage, {
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
    return Firehose.client.put(this, params);
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.Note = (function(_super) {
  __extends(Note, _super);

  function Note() {
    _ref = Note.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Note._firehoseType = "Note";

  /*
  @property [Interaction]
  */


  Note.prototype.interaction = null;

  /*
  @property [string]
  */


  Note.prototype.body = null;

  /*
  @property [Agent] The agent that authored the note.
  */


  Note.prototype.agent = null;

  Note.noteWithBody = function(body, interaction) {
    return Firehose.Object._objectOfClassWithID(Firehose.Note, {
      body: body,
      interaction: interaction
    });
  };

  Note._noteWithID = function(id, interaction) {
    return Firehose.Object._objectOfClassWithID(Firehose.Note, {
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
      return Firehose.client.put(this, params);
    } else {
      params = {
        route: "interactions/" + this.interaction.id + "/notes",
        body: this._toJSON()
      };
      return Firehose.client.post(this, params).done(function(data) {
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
    return Firehose.client["delete"](this, params).done(function() {
      return _this.interaction.notes.dropObject(_this);
    });
  };

  Note.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("body", json.body);
    this._populateAssociatedObjectWithJSON(this, "agent", json.agent, function(json) {
      return Firehose.Agent.agentWithID(json.id);
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.Notification = (function(_super) {
  __extends(Notification, _super);

  function Notification() {
    _ref = Notification.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Notification._firehoseType = "Notification";

  /*
  @property [Company]
  */


  Notification.prototype.company = null;

  /*
  @property [string]
  */


  Notification.prototype.title = null;

  /*
  @property [string]
  */


  Notification.prototype.text = null;

  /*
  @property [integer]
  */


  Notification.prototype.level = 0;

  Notification._notificationWithID = function(id, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.Notification, {
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.OutgoingAttachment = (function(_super) {
  __extends(OutgoingAttachment, _super);

  function OutgoingAttachment() {
    _ref = OutgoingAttachment.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  OutgoingAttachment._firehoseType = "OutgoingAttachment";

  /*
  @property [Company]
  */


  OutgoingAttachment.prototype.company = null;

  /*
  @property [string]
  */


  OutgoingAttachment.prototype.token = null;

  /*
  @property [string]
  */


  OutgoingAttachment.prototype.downloadURL = null;

  /*
  @property [string]
  */


  OutgoingAttachment.prototype.uploadURL = null;

  /*
  @property [boolean]
  */


  OutgoingAttachment.prototype.uploaded = false;

  /*
  @property [File]
  */


  OutgoingAttachment.prototype.file = null;

  OutgoingAttachment.outgoingAttachmentWithFile = function(file, company) {
    return new Firehose.OutgoingAttachment({
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
    return Firehose.client.post(this, params).done(function(data) {
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
          return Firehose.client.put(_this, params).done(function() {
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.Tag = (function(_super) {
  __extends(Tag, _super);

  function Tag() {
    _ref = Tag.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Tag._firehoseType = "Tag";

  /*
  @property [Company]
  */


  Tag.prototype.company = null;

  /*
  @property [string]
  */


  Tag.prototype.label = null;

  Tag.tagWithLabel = function(label, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.Tag, {
      label: label,
      company: company
    });
  };

  Tag._tagWithID = function(id, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.Tag, {
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
      return Firehose.client.put(this, params);
    } else {
      params = {
        route: "companies/" + this.company.id + "/tags",
        body: this._toJSON()
      };
      return Firehose.client.post(this, params).done(function(data) {
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
    return Firehose.client["delete"](this, params).done(function() {
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.TwitterAccount = (function(_super) {
  __extends(TwitterAccount, _super);

  function TwitterAccount() {
    _ref = TwitterAccount.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  TwitterAccount._firehoseType = "TwitterAccount";

  /*
  @property [Company]
  */


  TwitterAccount.prototype.company = null;

  /*
  @property [string]
  */


  TwitterAccount.prototype.screenName = null;

  /*
  @property [string]
  */


  TwitterAccount.prototype.twitterUserId = null;

  /*
  @property [string]
  */


  TwitterAccount.prototype.imageURL = null;

  TwitterAccount._twitterAccountWithID = function(id, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.TwitterAccount, {
      id: id,
      company: company
    });
  };

  TwitterAccount.OAuthURLForCompanyWithCallback = function(company, callback) {
    return "" + (Firehose.baseURLFor('API')) + "/companies/" + company.id + "/oauth_twitter?url_token=" + Firehose.client.URLToken + "&callback_url=" + (encodeURIComponent(callback));
  };

  TwitterAccount.prototype.destroy = function() {
    var params,
      _this = this;
    params = {
      route: "twitter_accounts/" + this.id
    };
    return Firehose.client["delete"](this, params).done(function() {
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

})(Firehose.Object);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.TwitterInteraction = (function(_super) {
  __extends(TwitterInteraction, _super);

  function TwitterInteraction() {
    _ref = TwitterInteraction.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  TwitterInteraction._firehoseType = "TwitterInteraction";

  /*
  @property [TwitterAccount]
  */


  TwitterInteraction.prototype.twitterAccount = null;

  /*
  @property [boolean]
  */


  TwitterInteraction.prototype.favorited = false;

  /*
  @property [string]
  */


  TwitterInteraction.prototype.tweetId = null;

  /*
  @property [string]
  */


  TwitterInteraction.prototype.inReplyToScreenName = null;

  /*
  @property [string]
  */


  TwitterInteraction.prototype.inReplyToStatusId = null;

  /*
  @property [number]
  */


  TwitterInteraction.prototype.retweetCount = 0;

  /*
  @property [string]
  */


  TwitterInteraction.prototype.tweetSource = null;

  /*
  @property [string]
  */


  TwitterInteraction.prototype.toUserId = null;

  /*
  @property [string]
  */


  TwitterInteraction.prototype.toScreenName = null;

  /*
  @property [string]
  */


  TwitterInteraction.prototype.fromUserId = null;

  TwitterInteraction._twitterInteractionWithID = function(id) {
    return Firehose.Object._objectOfClassWithID(Firehose.TwitterInteraction, {
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
        return Firehose.TwitterAccount._twitterAccountWithID(json.id);
      });
    }
    return TwitterInteraction.__super__._populateWithJSON.call(this, json);
  };

  return TwitterInteraction;

})(Firehose.Interaction);

var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Firehose.Article = (function(_super) {
  __extends(Article, _super);

  function Article() {
    _ref = Article.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Article._firehoseType = "Article";

  /*
  @property [Company]
  */


  Article.prototype.company = null;

  /*
  @property [string]
  */


  Article.prototype.slug = null;

  /*
  @property [string]
  */


  Article.prototype.title = null;

  /*
  @property [string]
  */


  Article.prototype.body = null;

  Article.articleWithTitleBodyAndCompany = function(title, body, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.Article, {
      title: title,
      body: body,
      company: company
    });
  };

  Article.articleWithID = function(id, company) {
    return Firehose.Object._objectOfClassWithID(Firehose.Article, {
      id: id,
      company: company
    });
  };

  Article.prototype.fetch = function() {
    var params,
      _this = this;
    params = {
      auth: false,
      route: "articles/" + this.id
    };
    return Firehose.client.get(this, params).done(function(data) {
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
      return Firehose.client.put(this, params);
    } else {
      params = {
        route: "companies/" + this.company.id + "/articles",
        body: this._toJSON()
      };
      return Firehose.client.post(this, params).done(function(data) {
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
    return Firehose.client["delete"](this, params).done(function() {
      return _this.company.articles().dropObject(_this);
    });
  };

  Article.prototype._populateWithJSON = function(json) {
    this._setIfNotNull("title", json.title);
    this._setIfNotNull("body", json.body);
    this._setIfNotNull("slug", json.slug);
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

})(Firehose.Object);
