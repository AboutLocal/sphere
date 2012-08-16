fList = "";
function fontList(list) {
  fList = list;
}
(function ($) {

  // {{{ jquery.flash

  /**
  * Flash (http://jquery.lukelutman.com/plugins/flash)
  * A jQuery plugin for embedding Flash movies.
  * 
  * Version 1.0
  * November 9th, 2006
  *
  * Copyright (c) 2006 Luke Lutman (http://www.lukelutman.com)
  * Dual licensed under the MIT and GPL licenses.
  * http://www.opensource.org/licenses/mit-license.php
  * http://www.opensource.org/licenses/gpl-license.php
  * 
  * Inspired by:
  * SWFObject (http://blog.deconcept.com/swfobject/)
  * UFO (http://www.bobbyvandersluis.com/ufo/)
  * sIFR (http://www.mikeindustries.com/sifr/)
  * 
  * IMPORTANT: 
  * The packed version of jQuery breaks ActiveX control
  * activation in Internet Explorer. Use JSMin to minifiy
  * jQuery (see: http://jquery.lukelutman.com/plugins/flash#activex).
  *
  **/ 
  ;(function(){
      
  var $$;

  /**
  * 
  * @desc Replace matching elements with a flash movie.
  * @author Luke Lutman
  * @version 1.0.1
  *
  * @name flash
  * @param Hash htmlOptions Options for the embed/object tag.
  * @param Hash pluginOptions Options for detecting/updating the Flash plugin (optional).
  * @param Function replace Custom block called for each matched element if flash is installed (optional).
  * @param Function update Custom block called for each matched if flash isn't installed (optional).
  * @type jQuery
  *
  * @cat plugins/flash
  * 
  * @example $('#hello').flash({ src: 'hello.swf' });
  * @desc Embed a Flash movie.
  *
  * @example $('#hello').flash({ src: 'hello.swf' }, { version: 8 });
  * @desc Embed a Flash 8 movie.
  *
  * @example $('#hello').flash({ src: 'hello.swf' }, { expressInstall: true });
  * @desc Embed a Flash movie using Express Install if flash isn't installed.
  *
  * @example $('#hello').flash({ src: 'hello.swf' }, { update: false });
  * @desc Embed a Flash movie, don't show an update message if Flash isn't installed.
  *
  **/
  $$ = jQuery.fn.flash = function(htmlOptions, pluginOptions, replace, update) {
      
      // Set the default block.
      var block = replace || $$.replace;
      
      // Merge the default and passed plugin options.
      pluginOptions = $$.copy($$.pluginOptions, pluginOptions);
      
      // Detect Flash.
      if(!$$.hasFlash(pluginOptions.version)) {
          // Use Express Install (if specified and Flash plugin 6,0,65 or higher is installed).
          if(pluginOptions.expressInstall && $$.hasFlash(6,0,65)) {
              // Add the necessary flashvars (merged later).
              var expressInstallOptions = {
                  flashvars: {  	
                      MMredirectURL: location,
                      MMplayerType: 'PlugIn',
                      MMdoctitle: jQuery('title').text() 
                  }					
              };
          // Ask the user to update (if specified).
          } else if (pluginOptions.update) {
              // Change the block to insert the update message instead of the flash movie.
              block = update || $$.update;
          // Fail
          } else {
              // The required version of flash isn't installed.
              // Express Install is turned off, or flash 6,0,65 isn't installed.
              // Update is turned off.
              // Return without doing anything.
              return this;
          }
      }
      
      // Merge the default, express install and passed html options.
      htmlOptions = $$.copy($$.htmlOptions, expressInstallOptions, htmlOptions);
      
      // Invoke $block (with a copy of the merged html options) for each element.
      return this.each(function(){
          block.call(this, $$.copy(htmlOptions));
      });
      
  };
  /**
  *
  * @name flash.copy
  * @desc Copy an arbitrary number of objects into a new object.
  * @type Object
  * 
  * @example $$.copy({ foo: 1 }, { bar: 2 });
  * @result { foo: 1, bar: 2 };
  *
  **/
  $$.copy = function() {
      var options = {}, flashvars = {};
      for(var i = 0; i < arguments.length; i++) {
          var arg = arguments[i];
          if(arg == undefined) continue;
          jQuery.extend(options, arg);
          // don't clobber one flash vars object with another
          // merge them instead
          if(arg.flashvars == undefined) continue;
          jQuery.extend(flashvars, arg.flashvars);
      }
      options.flashvars = flashvars;
      return options;
  };
  /*
  * @name flash.hasFlash
  * @desc Check if a specific version of the Flash plugin is installed
  * @type Boolean
  *
  **/
  $$.hasFlash = function() {
      // look for a flag in the query string to bypass flash detection
      if(/hasFlash\=true/.test(location)) return true;
      if(/hasFlash\=false/.test(location)) return false;
      var pv = $$.hasFlash.playerVersion().match(/\d+/g);
      var rv = String([arguments[0], arguments[1], arguments[2]]).match(/\d+/g) || String($$.pluginOptions.version).match(/\d+/g);
      for(var i = 0; i < 3; i++) {
          pv[i] = parseInt(pv[i] || 0);
          rv[i] = parseInt(rv[i] || 0);
          // player is less than required
          if(pv[i] < rv[i]) return false;
          // player is greater than required
          if(pv[i] > rv[i]) return true;
      }
      // major version, minor version and revision match exactly
      return true;
  };
  /**
  *
  * @name flash.hasFlash.playerVersion
  * @desc Get the version of the installed Flash plugin.
  * @type String
  *
  **/
  $$.hasFlash.playerVersion = function() {
      // ie
      try {
          try {
              // avoid fp6 minor version lookup issues
              // see: http://blog.deconcept.com/2006/01/11/getvariable-setvariable-crash-internet-explorer-flash-6/
              var axo = new ActiveXObject('ShockwaveFlash.ShockwaveFlash.6');
              try { axo.AllowScriptAccess = 'always';	} 
              catch(e) { return '6,0,0'; }				
          } catch(e) {}
          return new ActiveXObject('ShockwaveFlash.ShockwaveFlash').GetVariable('$version').replace(/\D+/g, ',').match(/^,?(.+),?$/)[1];
      // other browsers
      } catch(e) {
          try {
              if(navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin){
                  return (navigator.plugins["Shockwave Flash 2.0"] || navigator.plugins["Shockwave Flash"]).description.replace(/\D+/g, ",").match(/^,?(.+),?$/)[1];
              }
          } catch(e) {}		
      }
      return '0,0,0';
  };
  /**
  *
  * @name flash.htmlOptions
  * @desc The default set of options for the object or embed tag.
  *
  **/
  $$.htmlOptions = {
      height: 240,
      flashvars: {},
      pluginspage: 'http://www.adobe.com/go/getflashplayer',
      src: '#',
      type: 'application/x-shockwave-flash',
      width: 320		
  };
  /**
  *
  * @name flash.pluginOptions
  * @desc The default set of options for checking/updating the flash Plugin.
  *
  **/
  $$.pluginOptions = {
      expressInstall: false,
      update: true,
      version: '6.0.65'
  };
  /**
  *
  * @name flash.replace
  * @desc The default method for replacing an element with a Flash movie.
  *
  **/
  $$.replace = function(htmlOptions) {
      this.innerHTML = '<div class="alt">'+this.innerHTML+'</div>';
      jQuery(this)
          .addClass('flash-replaced')
          .prepend($$.transform(htmlOptions));
  };
  /**
  *
  * @name flash.update
  * @desc The default method for replacing an element with an update message.
  *
  **/
  $$.update = function(htmlOptions) {
      var url = String(location).split('?');
      url.splice(1,0,'?hasFlash=true&');
      url = url.join('');
      var msg = '<p>This content requires the Flash Player. <a href="http://www.adobe.com/go/getflashplayer">Download Flash Player</a>. Already have Flash Player? <a href="'+url+'">Click here.</a></p>';
      this.innerHTML = '<span class="alt">'+this.innerHTML+'</span>';
      jQuery(this)
          .addClass('flash-update')
          .prepend(msg);
  };
  /**
  *
  * @desc Convert a hash of html options to a string of attributes, using Function.apply(). 
  * @example toAttributeString.apply(htmlOptions)
  * @result foo="bar" foo="bar"
  *
  **/
  function toAttributeString() {
      var s = '';
      for(var key in this)
          if(typeof this[key] != 'function')
              s += key+'="'+this[key]+'" ';
      return s;		
  };
  /**
  *
  * @desc Convert a hash of flashvars to a url-encoded string, using Function.apply(). 
  * @example toFlashvarsString.apply(flashvarsObject)
  * @result foo=bar&foo=bar
  *
  **/
  function toFlashvarsString() {
      var s = '';
      for(var key in this)
          if(typeof this[key] != 'function')
              s += key+'='+encodeURIComponent(this[key])+'&';
      return s.replace(/&$/, '');		
  };
  /**
  *
  * @name flash.transform
  * @desc Transform a set of html options into an embed tag.
  * @type String 
  *
  * @example $$.transform(htmlOptions)
  * @result <embed src="foo.swf" ... />
  *
  * Note: The embed tag is NOT standards-compliant, but it 
  * works in all current browsers. flash.transform can be
  * overwritten with a custom function to generate more 
  * standards-compliant markup.
  *
  **/
  $$.transform = function(htmlOptions) {
      htmlOptions.toString = toAttributeString;
      if(htmlOptions.flashvars) htmlOptions.flashvars.toString = toFlashvarsString;
      return '<embed ' + String(htmlOptions) + '/>';		
  };

  /**
  *
  * Flash Player 9 Fix (http://blog.deconcept.com/2006/07/28/swfobject-143-released/)
  *
  **/
  if (window.attachEvent) {
      window.attachEvent("onbeforeunload", function(){
          __flash_unloadHandler = function() {};
          __flash_savedUnloadHandler = function() {};
      });
  }
      
  })();

  // }}}

  function identify_plugins(){
    // fetch and serialize plugins
    var plugins = "";
    // in Mozilla and in fact most non-IE browsers, this is easy
    if (navigator.plugins) {
      var np = navigator.plugins;
      var plist = [];
      // sorting navigator.plugins is a right royal pain
      // but it seems to be necessary because their order
      // is non-constant in some browsers
      for (var i = 0; i < np.length; i++) {
        plist[i] = np[i].name + "; ";
        plist[i] += np[i].description + "; ";
        plist[i] += np[i].filename + ";";
        for (var n = 0; n < np[i].length; n++) {
          plist[i] += " (" + np[i][n].description +"; "+ np[i][n].type +
            "; "+ np[i][n].suffixes + ")";
        }
        plist[i] += ". ";
      }
      plist.sort(); 
      for (i = 0; i < np.length; i++)
        plugins+= "Plugin "+i+": " + plist[i];
    }
    // in IE, things are much harder; we use PluginDetect to get less
    // information (only the plugins listed below & their version numbers)
    if (plugins == "") {
      var pp = [];
      pp[0] = "Java"; pp[1] = "QuickTime"; pp[2] = "DevalVR"; pp[3] = "Shockwave";
      pp[4] = "Flash"; pp[5] = "WindowsMediaplayer"; pp[6] = "Silverlight"; 
      pp[7] = "VLC";
      var version;
      for ( p in pp ) {
        version = PluginDetect.getVersion(pp[p]);
        if (version) 
          plugins += pp[p] + " " + version + "; "
      }
      //plugins += ieAcrobatVersion(); // this takes horribly long
    }
    return plugins;
  }

  function ieAcrobatVersion() {
    // estimate the version of Acrobat on IE using horrible horrible hacks
    if (window.ActiveXObject) {
      for (var x = 2; x < 10; x++) {
        try {
          oAcro=eval("new ActiveXObject('PDF.PdfCtrl."+x+"');");
          if (oAcro) 
            return "Adobe Acrobat version" + x + ".?";
        } catch(ex) {}
      }
      try {
        oAcro4=new ActiveXObject('PDF.PdfCtrl.1');
        if (oAcro4)
          return "Adobe Acrobat version 4.?";
      } catch(ex) {}
      try {
        oAcro7=new ActiveXObject('AcroPDF.PDF.1');
        if (oAcro7)
          return "Adobe Acrobat version 7.?";
      } catch (ex) {}
      return "";
    }
  }

  function get_fonts() {
    // Try flash first
    var fonts = "";
    var obj = document.getElementById("flashfontshelper");
    if (obj && typeof(obj.GetVariable) != "undefined") {
      fonts = //obj.GetVariable("/:user_fonts");
      fonts = fList;
      fonts = fonts.replace(/,/g,", ");
      fonts += " (via Flash)";
    }/* else {
      // Try java fonts
      try {
        var javafontshelper = document.getElementById("javafontshelper");
        var jfonts = javafontshelper.getFontList();
        for (var n = 0; n < jfonts.length; n++) {
          fonts = fonts + jfonts[n] + ", ";
        }
        fonts += " (via Java)";
      } catch (ex) {}
    }*/
    if ("" == fonts)
      fonts = "No Flash or Java fonts detected";
    return fonts;
  }

  function set_dom_storage(){
    try { 
      localStorage.panopticlick = "yea";
      sessionStorage.panopticlick = "yea";
    } catch (ex) { }
  }

  function test_dom_storage(){
    var supported = "";
    try {
      if (localStorage.panopticlick == "yea") {
        supported += "DOM localStorage: Yes";
      } else {
        supported += "DOM localStorage: No";
      }
    } catch (ex) { supported += "DOM localStorage: No"; }

    try {
      if (sessionStorage.panopticlick == "yea") {
        supported += ", DOM sessionStorage: Yes";
      } else {
        supported += ", DOM sessionStorage: No";
      }
    } catch (ex) { supported += ", DOM sessionStorage: No"; }

    return supported;
  }

  function test_ie_userdata(){
    try {
      oPersistDiv.setAttribute("remember", "remember this value");
      oPersistDiv.save("oXMLStore");
      oPersistDiv.setAttribute("remember", "overwritten!");
      oPersistDiv.load("oXMLStore");
      if ("remember this value" == (oPersistDiv.getAttribute("remember"))) {
        return ", IE userData: Yes";
      } else { 
        return ", IE userData: No";
      }
    } catch (ex) {
      return ", IE userData: No";
    }
  }

  var success = 0;
  var retries = 20;

  function retry_post() {
    retries = retries -1;
    if (success || retries == 0)
      return 0;
    // no luck yet
    fetch_client_whorls()
  }

  function fetch_client_whorls(){
    // fetch client-side vars
    var whorls = {};

    // this is a backup plan
    setTimeout(retry_post,1100);

    try { 
      whorls['plugins'] = identify_plugins(); 
    } catch(ex) { 
      whorls['plugins'] = "permission denied";
    }

    // Do not catch exceptions here because the async Flash applet will raise
    // them until it is ready.  Instead, if Flash is present, the retry timeout
    // will cause us to try again until it returns something meaningful.

    whorls['fonts'] = get_fonts();

    try { 
      whorls['timezone'] = new Date().getTimezoneOffset();
    } catch(ex) {
      whorls['timezone'] = "permission denied";
    }

    try {
      whorls['video'] = screen.width+"x"+screen.height+"x"+screen.colorDepth;
    } catch(ex) {
      whorls['video'] = "permission denied";
    }

    whorls['supercookies'] = test_dom_storage() + test_ie_userdata();

    //console.log(whorls);

    var fingerprint = md5(whorls.plugins + whorls.fonts + whorls.timezone.toString() + whorls.video + whorls.supercookies);

    //console.log(fingerprint);
    success = 1;

    Session.set("fingerprint", fingerprint);

    var trackingCookie = "ABTLCLT";

    if (!$.cookie(trackingCookie)) {
      $.cookie(trackingCookie, Math.random().toString().replace(/\D/g, ""));
    }
    Session.set("trackingCookie", $.cookie(trackingCookie), {
      expires: 36500,
      path: "/"
    });
  }


  set_dom_storage();

  Meteor.startup(function(){

    if (!jQuery.browser.msie) {
      // XXX breaks Meteor.call in IE 8
      $("#flashcontent").flash(
        {
          "src": "fingerprint/fonts2.swf",
          "width": "1",
          "height": "1",
          "swliveconnect": "true",
          "id": "flashfontshelper",
          "name": "flashfontshelper"
        },
        { update: false }
      );
    }

    // wait some time for the flash font detection:
    setTimeout(fetch_client_whorls,1000);
  });

})(jQuery);
