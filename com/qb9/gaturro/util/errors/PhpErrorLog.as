package com.qb9.gaturro.util.errors
{
   import com.dynamicflash.util.Base64;
   import com.qb9.gaturro.globals.clientData;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.util.security.Rijndael;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   
   public class PhpErrorLog
   {
       
      
      public function PhpErrorLog()
      {
         super();
      }
      
      private static function requestError(param1:Event) : void
      {
         logger.debug("LOGGER ERROR: " + param1.toString());
      }
      
      private static function requestDone(param1:Event) : void
      {
         logger.debug("LOGGER COMPLETADO");
      }
      
      private static function replaceSpaces(param1:String) : String
      {
         while(param1.indexOf(" ") > 0)
         {
            param1 = param1.replace(" ","%20");
         }
         return param1;
      }
      
      public static function registry(param1:ErrorOccurred) : void
      {
         var req:URLRequest = null;
         var loader:URLLoader = null;
         var urlGETFinal:String = null;
         var variables:URLVariables = null;
         var algorit:Rijndael = null;
         var authData:String = null;
         var credsHeader:URLRequestHeader = null;
         var errorOcurred:ErrorOccurred = param1;
         var mainURL:String = String(settings.connection.url_error_logger);
         var m:String = "m=" + replaceSpaces(settings.connection.serverName) + "_" + settings.connection.address;
         var u:String = "u=" + replaceSpaces(user != null ? String(user.username) : "");
         var t:String = "t=" + Math.round(clientData.actualSessionTime / 1000).toString();
         var c:String = "c=" + replaceSpaces(errorOcurred.data);
         var paramURL:String = m + "&" + u + "&" + t + "&" + c;
         logger.debug("REPORT ERROR: " + paramURL);
         if(mainURL == "")
         {
            return;
         }
         try
         {
            if(!settings.connection.url_error_logger_method || settings.connection.url_error_logger_method == "GET")
            {
               urlGETFinal = mainURL + "?" + paramURL;
               req = new URLRequest(urlGETFinal);
               req.method = URLRequestMethod.GET;
            }
            else
            {
               req = new URLRequest(mainURL);
               req.method = URLRequestMethod.POST;
               variables = new URLVariables(m + "&" + u + "&" + t + "&" + c);
               req.data = variables;
            }
            if(settings.connection.url_error_logger_userpass)
            {
               algorit = new Rijndael();
               authData = algorit.decrypt("5dc8e4fd14e8f1656aee8ce85e48eeeb7387e3ad24f2a95a0b563afc1cb0f6ec14097270cbd1f188eb59578872e0a4c0","ABDpIUDlKDABDpIU","CBC");
               authData = Base64.encode(authData);
               credsHeader = new URLRequestHeader("Authorization","Basic " + authData);
               req.requestHeaders.push(credsHeader);
            }
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE,requestDone);
            loader.addEventListener(IOErrorEvent.IO_ERROR,requestError);
            loader.addEventListener(IOErrorEvent.NETWORK_ERROR,requestError);
            loader.addEventListener(IOErrorEvent.VERIFY_ERROR,requestError);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,requestError);
            loader.load(req);
         }
         catch(e:Error)
         {
            logger.debug("FALLO EL LOGGER PHP DE ERRORES: " + e.message);
         }
      }
   }
}
