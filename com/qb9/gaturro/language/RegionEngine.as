package com.qb9.gaturro.language
{
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.locale;
   import com.qb9.gaturro.globals.logger;
   import config.RegionConfig;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class RegionEngine
   {
       
      
      private var NO_WORK_WITH_ADDED_LIST:Array;
      
      public var logTranslations:Boolean = false;
      
      public const SPANISH:String = "ESP";
      
      public const NO_WORK_WITH_ADDED:String = "NO_WORK_WITH_ADDED";
      
      private var language:String;
      
      private var collection:com.qb9.gaturro.language.LocaleCollection;
      
      public const ASTERISK:String = "AST";
      
      private var countryStr:String = "AR";
      
      protected var stage:Stage;
      
      public function RegionEngine(param1:Stage)
      {
         this.collection = new com.qb9.gaturro.language.LocaleCollection();
         this.language = this.SPANISH;
         this.NO_WORK_WITH_ADDED_LIST = ["username","price","coins",this.NO_WORK_WITH_ADDED];
         super();
         this.stage = param1;
      }
      
      public function stop() : void
      {
         if(!RegionConfig.data.enabled)
         {
            return;
         }
         this.stage.removeEventListener(Event.ADDED_TO_STAGE,this.apply,true);
         logger.debug("Region Engine > Stop");
      }
      
      private function removeFinalReturns(param1:String) : String
      {
         var _loc2_:String = null;
         if(param1 != null && param1.length > 0)
         {
            _loc2_ = param1.substr(param1.length - 1,1);
            if(_loc2_ == "\r")
            {
               return param1.substr(0,param1.length - 1);
            }
         }
         return param1;
      }
      
      public function get languageId() : String
      {
         return this.language;
      }
      
      public function get country() : String
      {
         return this.countryStr;
      }
      
      public function key(param1:String) : String
      {
         return this.getText(this.absoluteKey(param1));
      }
      
      public function addFileToLan(param1:String, param2:Settings) : void
      {
         this.collection.addFileToLan(param1,param2);
      }
      
      public function start() : void
      {
         if(!RegionConfig.data.enabled)
         {
            return;
         }
         this.stage.addEventListener(Event.ADDED_TO_STAGE,this.apply,true);
         logger.debug("Region Engine > Start");
      }
      
      public function getText(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.language == this.ASTERISK)
         {
            return "*";
         }
         _loc2_ = this.removeFinalReturns(param1);
         _loc2_ = StringUtil.trim(_loc2_);
         if(!param1 && param1 != _loc2_)
         {
            logger.debug("Region Engine > getText > source text = [" + param1 + "] || resultText = [" + _loc2_ + "]");
         }
         if(_loc2_ != "")
         {
            if(this.language != this.SPANISH)
            {
               return this.collection.keyByLan(this.language,_loc2_);
            }
         }
         return _loc2_;
      }
      
      public function set languageId(param1:String) : void
      {
         this.language = param1;
      }
      
      public function keyExists(param1:String) : Boolean
      {
         var _loc2_:String = String(locale[param1]);
         return _loc2_ != null;
      }
      
      public function set country(param1:String) : void
      {
         this.countryStr = param1;
      }
      
      public function setText(param1:TextField, param2:String) : void
      {
         param1.text = this.getText(param2);
      }
      
      private function apply(param1:Event) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         if(Boolean(_loc2_) && !ArrayUtil.contains(this.NO_WORK_WITH_ADDED_LIST,_loc2_.name))
         {
            this.setText(_loc2_,_loc2_.text);
         }
      }
      
      public function absoluteKey(param1:String) : String
      {
         return this.keyByFile(param1,locale);
      }
      
      private function keyByFile(param1:String, param2:Object) : String
      {
         var _loc3_:String = String(param2[param1]);
         if(_loc3_ == null)
         {
            return param1;
         }
         return _loc3_;
      }
   }
}
