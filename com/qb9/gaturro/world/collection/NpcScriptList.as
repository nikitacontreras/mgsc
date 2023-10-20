package com.qb9.gaturro.world.collection
{
   import com.dynamicflash.util.Base64;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.world.npc.struct.NpcScript;
   import com.qb9.gaturro.world.npc.tokenizer.NpcTokenizer;
   import com.qb9.mambo.net.library.BaseLoadedItemCollection;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   
   public final class NpcScriptList extends BaseLoadedItemCollection
   {
      
      private static const EXT:String = ".npc";
      
      private static const BASE:String = "npc/";
       
      
      private var names:Dictionary;
      
      public function NpcScriptList()
      {
         this.names = new Dictionary(true);
         super(this.execute);
      }
      
      private function handleError(param1:Event) : void
      {
         logger.warning("Failed to load NPC script named",this.names[param1.target]);
         api.trackEvent("DEBUG:NPC:LOAD_FAIL",this.names[param1.target]);
         this.disposeLoader(param1);
      }
      
      override protected function load(param1:String) : void
      {
         var _loc2_:String = this.makeRelativeURL(param1);
         var _loc3_:String = this.makeFinalURL(_loc2_);
         logger.debug("Loading NPC file",_loc3_);
         var _loc4_:URLRequest = new URLRequest(_loc3_);
         var _loc5_:URLRequestHeader = new URLRequestHeader("pragma","no-cache");
         _loc4_.data = new URLVariables("cache=no+cache");
         _loc4_.requestHeaders.push(_loc5_);
         _loc4_.method = URLRequestMethod.POST;
         var _loc6_:URLLoader;
         (_loc6_ = new URLLoader(_loc4_)).addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleError);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,this.handleError);
         _loc6_.addEventListener(Event.COMPLETE,this.whenTheScriptIsLoaded);
         this.names[_loc6_] = param1;
      }
      
      protected function makeFinalURL(param1:String) : String
      {
         var _loc2_:String = URLUtil.getUrl(param1);
         return URLUtil.versionedPath(_loc2_);
      }
      
      public function loadNow(param1:String) : void
      {
         this.load(param1);
      }
      
      private function whenTheScriptIsLoaded(param1:Event) : void
      {
         var data:String;
         var tokenizer:NpcTokenizer;
         var name:String = null;
         var cleanData:String = null;
         var script:NpcScript = null;
         var e:Event = param1;
         var loader:URLLoader = e.target as URLLoader;
         name = String(this.names[loader]);
         var relativeUrl:String = this.makeRelativeURL(name);
         var url:String = this.makeFinalURL(relativeUrl);
         logger.info("Successfully loaded NPC file",name);
         data = "";
         if(api.isDebug)
         {
            data = loader.data;
         }
         else
         {
            cleanData = String(loader.data.split("\n").join("").split("\t").join("").split("\r").join());
            data = Base64.decode(cleanData);
         }
         tokenizer = new NpcTokenizer(data);
         try
         {
            script = tokenizer.readScript(name);
         }
         catch(err:Error)
         {
            logger.warning("Tokenizing failed for",name,">",err.message);
            api.trackEvent("DEBUG:NPC:TOKENIZING_FAIL_2",name + "_" + api.room.id);
            return;
         }
         tokenizer.dispose();
         loaded(name,script);
         this.disposeLoader(e);
      }
      
      private function disposeLoader(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         _loc2_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleError);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.handleError);
         _loc2_.removeEventListener(Event.COMPLETE,this.whenTheScriptIsLoaded);
         delete this.names[_loc2_];
      }
      
      protected function makeRelativeURL(param1:String) : String
      {
         return BASE + param1 + EXT;
      }
      
      private function execute(param1:Function, param2:NpcScript) : void
      {
         param1(param2);
      }
      
      override public function dispose() : void
      {
         this.names = null;
         super.dispose();
      }
   }
}
