package fl.video
{
   import flash.events.*;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class FPADManager
   {
      
      public static const VERSION:String = "2.1.0.23";
      
      public static const SHORT_VERSION:String = "2.1";
       
      
      private var _owner:fl.video.INCManager;
      
      flvplayback_internal var xml:XML;
      
      flvplayback_internal var xmlLoader:URLLoader;
      
      flvplayback_internal var rtmpURL:String;
      
      flvplayback_internal var _url:String;
      
      flvplayback_internal var _uriParam:String;
      
      flvplayback_internal var _parseResults:fl.video.ParseResults;
      
      public function FPADManager(param1:fl.video.INCManager)
      {
         super();
         this._owner = param1;
      }
      
      flvplayback_internal function connectXML(param1:String, param2:String, param3:String, param4:fl.video.ParseResults) : Boolean
      {
         this.flvplayback_internal::_uriParam = param2;
         this.flvplayback_internal::_parseResults = param4;
         this.flvplayback_internal::_url = param1 + "uri=" + this.flvplayback_internal::_parseResults.protocol;
         if(this.flvplayback_internal::_parseResults.serverName != null)
         {
            this.flvplayback_internal::_url += "/" + this.flvplayback_internal::_parseResults.serverName;
         }
         if(this.flvplayback_internal::_parseResults.portNumber != null)
         {
            this.flvplayback_internal::_url += ":" + this.flvplayback_internal::_parseResults.portNumber;
         }
         if(this.flvplayback_internal::_parseResults.wrappedURL != null)
         {
            this.flvplayback_internal::_url += "/?" + this.flvplayback_internal::_parseResults.wrappedURL;
         }
         this.flvplayback_internal::_url += "/" + this.flvplayback_internal::_parseResults.appName;
         this.flvplayback_internal::_url += param3;
         this.flvplayback_internal::xml = new XML();
         this.flvplayback_internal::xmlLoader = new URLLoader();
         this.flvplayback_internal::xmlLoader.addEventListener(Event.COMPLETE,this.flvplayback_internal::xmlLoadEventHandler);
         this.flvplayback_internal::xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.flvplayback_internal::xmlLoadEventHandler);
         this.flvplayback_internal::xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.flvplayback_internal::xmlLoadEventHandler);
         this.flvplayback_internal::xmlLoader.load(new URLRequest(this.flvplayback_internal::_url));
         return false;
      }
      
      flvplayback_internal function xmlLoadEventHandler(param1:Event) : void
      {
         var proxy:String = null;
         var e:Event = param1;
         try
         {
            if(e.type != Event.COMPLETE)
            {
               this._owner.helperDone(this,false);
            }
            else
            {
               this.flvplayback_internal::xml = new XML(this.flvplayback_internal::xmlLoader.data);
               if(this.flvplayback_internal::xml == null || this.flvplayback_internal::xml.localName() == null)
               {
                  throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this.flvplayback_internal::_url + "\" No root node found; if url is for an flv it must have .flv extension and take no parameters");
               }
               if(this.flvplayback_internal::xml.localName() != "fpad")
               {
                  throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this.flvplayback_internal::_url + "\" Root node not fpad");
               }
               proxy = null;
               if(this.flvplayback_internal::xml.proxy.length() > 0 && this.flvplayback_internal::xml.proxy.hasSimpleContent() && this.flvplayback_internal::xml.proxy.*[0].nodeKind() == "text")
               {
                  proxy = String(this.flvplayback_internal::xml.proxy.*[0].toString());
               }
               if(proxy == null)
               {
                  throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this.flvplayback_internal::_url + "\" fpad xml requires proxy tag.");
               }
               this.flvplayback_internal::rtmpURL = this.flvplayback_internal::_parseResults.protocol + "/" + proxy + "/?" + this.flvplayback_internal::_uriParam;
               this._owner.helperDone(this,true);
            }
         }
         catch(err:Error)
         {
            _owner.helperDone(this,false);
            throw err;
         }
      }
   }
}
