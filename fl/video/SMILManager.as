package fl.video
{
   import flash.events.*;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class SMILManager
   {
      
      public static const VERSION:String = "2.1.0.23";
      
      public static const SHORT_VERSION:String = "2.1";
       
      
      private var _owner:fl.video.INCManager;
      
      flvplayback_internal var xml:XML;
      
      flvplayback_internal var xmlLoader:URLLoader;
      
      flvplayback_internal var baseURLAttr:Array;
      
      flvplayback_internal var width:int;
      
      flvplayback_internal var height:int;
      
      flvplayback_internal var videoTags:Array;
      
      private var _url:String;
      
      public function SMILManager(param1:fl.video.INCManager)
      {
         super();
         this._owner = param1;
         this.flvplayback_internal::width = -1;
         this.flvplayback_internal::height = -1;
      }
      
      flvplayback_internal function connectXML(param1:String) : Boolean
      {
         this._url = this.flvplayback_internal::fixURL(param1);
         this.flvplayback_internal::xmlLoader = new URLLoader();
         this.flvplayback_internal::xmlLoader.addEventListener(Event.COMPLETE,this.flvplayback_internal::xmlLoadEventHandler);
         this.flvplayback_internal::xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.flvplayback_internal::xmlLoadEventHandler);
         this.flvplayback_internal::xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.flvplayback_internal::xmlLoadEventHandler);
         this.flvplayback_internal::xmlLoader.load(new URLRequest(this._url));
         return false;
      }
      
      flvplayback_internal function fixURL(param1:String) : String
      {
         var _loc2_:String = null;
         if(/^(http:|https:)/i.test(param1))
         {
            _loc2_ = param1.indexOf("?") >= 0 ? "&" : "?";
            return param1 + _loc2_ + "FLVPlaybackVersion=" + SHORT_VERSION;
         }
         return param1;
      }
      
      flvplayback_internal function xmlLoadEventHandler(param1:Event) : void
      {
         var e:Event = param1;
         try
         {
            if(e.type != Event.COMPLETE)
            {
               this._owner.helperDone(this,false);
            }
            else
            {
               this.flvplayback_internal::baseURLAttr = new Array();
               this.flvplayback_internal::videoTags = new Array();
               this.flvplayback_internal::xml = new XML(this.flvplayback_internal::xmlLoader.data);
               default xml namespace = this.flvplayback_internal::xml.namespace();
               if(this.flvplayback_internal::xml == null || this.flvplayback_internal::xml.localName() == null)
               {
                  throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this._url + "\" No root node found; if url is for an flv it must have .flv extension and take no parameters");
               }
               if(this.flvplayback_internal::xml.localName() != "smil")
               {
                  throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this._url + "\" Root node not smil");
               }
               this.flvplayback_internal::checkForIllegalNodes(this.flvplayback_internal::xml,"element",["head","body"]);
               if(this.flvplayback_internal::xml.head.length() > 0)
               {
                  this.flvplayback_internal::parseHead(this.flvplayback_internal::xml.head[0]);
               }
               if(this.flvplayback_internal::xml.body.length() < 1)
               {
                  throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this._url + "\" Tag body is required.");
               }
               this.flvplayback_internal::parseBody(this.flvplayback_internal::xml.body[0]);
               this._owner.helperDone(this,true);
            }
         }
         catch(err:Error)
         {
            _owner.helperDone(this,false);
            throw err;
         }
         finally
         {
            this.flvplayback_internal::xmlLoader.removeEventListener(Event.COMPLETE,this.flvplayback_internal::xmlLoadEventHandler);
            this.flvplayback_internal::xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.flvplayback_internal::xmlLoadEventHandler);
            this.flvplayback_internal::xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.flvplayback_internal::xmlLoadEventHandler);
            this.flvplayback_internal::xmlLoader = null;
         }
      }
      
      flvplayback_internal function parseHead(param1:XML) : void
      {
         default xml namespace = this.flvplayback_internal::xml.namespace();
         this.flvplayback_internal::checkForIllegalNodes(param1,"element",["meta","layout"]);
         if(param1.meta.length() > 0)
         {
            this.flvplayback_internal::checkForIllegalNodes(param1.meta[0],"element",[]);
            this.flvplayback_internal::checkForIllegalNodes(param1.meta[0],"attribute",["base"]);
            if(param1.meta.@base.length() > 0)
            {
               this.flvplayback_internal::baseURLAttr.push(param1.meta.@base.toString());
            }
         }
         if(param1.layout.length() > 0)
         {
            this.flvplayback_internal::parseLayout(param1.layout[0]);
         }
      }
      
      flvplayback_internal function parseLayout(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         default xml namespace = this.flvplayback_internal::xml.namespace();
         this.flvplayback_internal::checkForIllegalNodes(param1,"element",["root-layout"]);
         if(param1["root-layout"].length() > 1)
         {
            throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this._url + "\" Only one base attribute supported in meta tag.");
         }
         if(param1["root-layout"].length() > 0)
         {
            _loc2_ = param1["root-layout"][0];
            if(_loc2_.@width.length() > 0)
            {
               _loc3_ = Number(_loc2_.@width[0]);
            }
            if(_loc2_.@height.length() > 0)
            {
               _loc4_ = Number(_loc2_.@height[0]);
            }
            if(isNaN(_loc3_) || _loc3_ < 0 || isNaN(_loc4_) || _loc4_ < 0)
            {
               throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this._url + "\" Tag " + param1.localName() + " requires attributes width and height.  Width and height must be numbers greater than or equal to 0.");
            }
            this.flvplayback_internal::width = Math.round(_loc3_);
            this.flvplayback_internal::height = Math.round(_loc4_);
         }
      }
      
      flvplayback_internal function parseBody(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc4_:Object = null;
         default xml namespace = this.flvplayback_internal::xml.namespace();
         if(param1.*.length() != 1 || param1.*[0].nodeKind() != "element")
         {
            throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this._url + "\" Tag " + param1.localName() + " is required to contain exactly one tag.");
         }
         _loc2_ = param1.*[0];
         var _loc3_:String = String(_loc2_.localName());
         switch(_loc3_)
         {
            case "switch":
               this.flvplayback_internal::parseSwitch(_loc2_);
               break;
            case "video":
            case "ref":
               _loc4_ = this.flvplayback_internal::parseVideo(_loc2_);
               this.flvplayback_internal::videoTags.push(_loc4_);
               break;
            default:
               throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this._url + "\" Tag " + _loc3_ + " not supported in " + param1.localName() + " tag.");
         }
         if(this.flvplayback_internal::videoTags.length < 1)
         {
            throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this._url + "\" At least one video of ref tag is required.");
         }
      }
      
      flvplayback_internal function parseSwitch(param1:XML) : void
      {
         var _loc2_:String = null;
         var _loc3_:XML = null;
         default xml namespace = this.flvplayback_internal::xml.namespace();
         for(_loc2_ in param1.*)
         {
            _loc3_ = param1.*[_loc2_];
            if(_loc3_.nodeKind() != "element")
            {
               continue;
            }
            switch(_loc3_.localName())
            {
               case "video":
               case "ref":
                  this.flvplayback_internal::videoTags.push(this.flvplayback_internal::parseVideo(_loc3_));
                  break;
            }
         }
      }
      
      flvplayback_internal function parseVideo(param1:XML) : Object
      {
         default xml namespace = this.flvplayback_internal::xml.namespace();
         var _loc2_:Object = new Object();
         if(param1.@src.length() > 0)
         {
            _loc2_.src = param1.@src.toString();
         }
         if(param1["system-bitrate"].length() > 0)
         {
            _loc2_.bitrate = int(param1["system-bitrate"].toString());
         }
         if(param1.@dur.length() > 0)
         {
            _loc2_.dur = this.flvplayback_internal::parseTime(param1.@dur.toString());
         }
         return _loc2_;
      }
      
      flvplayback_internal function parseTime(param1:String) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         default xml namespace = this.flvplayback_internal::xml.namespace();
         var _loc2_:Object = /^((\d+):)?(\d+):((\d+)(.\d+)?)$/.exec(param1);
         if(_loc2_ == null)
         {
            _loc3_ = Number(param1);
            if(isNaN(_loc3_) || _loc3_ < 0)
            {
               throw new VideoError(VideoError.INVALID_XML,"Invalid dur value: " + param1);
            }
            return _loc3_;
         }
         return (_loc4_ = (_loc4_ = (_loc4_ = 0) + uint(_loc2_[2]) * 60 * 60) + uint(_loc2_[3]) * 60) + Number(_loc2_[4]);
      }
      
      flvplayback_internal function checkForIllegalNodes(param1:XML, param2:String, param3:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         default xml namespace = this.flvplayback_internal::xml.namespace();
         var _loc9_:int = 0;
         var _loc10_:* = param1.*;
         while(true)
         {
            for(_loc4_ in _loc10_)
            {
               _loc5_ = false;
               if((_loc6_ = param1.*[_loc4_]).nodeKind() == param2)
               {
                  _loc7_ = String(_loc6_.localName());
                  for(_loc8_ in param3)
                  {
                     if(param3[_loc8_] == _loc7_)
                     {
                        _loc5_ = true;
                        break;
                     }
                  }
                  if(!_loc5_)
                  {
                     break;
                  }
               }
            }
            return;
         }
         throw new VideoError(VideoError.INVALID_XML,"URL: \"" + this._url + "\" " + param2 + " " + _loc7_ + " not supported in " + param1.localName() + " tag.");
      }
   }
}
