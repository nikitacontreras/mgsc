package com.qb9.gaturro.language
{
   import com.qb9.flashlib.config.Settings;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.region;
   import flash.utils.Dictionary;
   
   public class LocaleCollection
   {
       
      
      private var languages:Dictionary;
      
      public function LocaleCollection()
      {
         super();
         this.languages = new Dictionary(true);
      }
      
      public function addFileToLan(param1:String, param2:Settings) : void
      {
         var _loc3_:Array = this.languages[param1];
         if(!_loc3_)
         {
            _loc3_ = new Array();
            this.languages[param1] = _loc3_;
         }
         _loc3_.push(param2);
      }
      
      public function keyByLan(param1:String, param2:String) : String
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc3_:Array = this.languages[param1];
         if(!_loc3_)
         {
            return param2;
         }
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = String(_loc4_[param2]);
            if(region.logTranslations)
            {
               logger.debug("Region Engine > TranslationsLog > " + param2 + " > " + _loc5_);
            }
            if(_loc5_ != null && _loc5_ != "")
            {
               return _loc5_;
            }
         }
         return param2;
      }
   }
}
