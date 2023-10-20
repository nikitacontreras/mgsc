package com.qb9.gaturro.model.config.passport
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.commons.model.config.IConfigSettings;
   import flash.utils.Dictionary;
   
   public class BetterWithPassportConfig implements IConfigSettings
   {
       
      
      private var _settings:Object;
      
      private var mapByType:Dictionary;
      
      private var itemObj:Object;
      
      public function BetterWithPassportConfig()
      {
         super();
      }
      
      public function getIterator() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(this._settings);
         return _loc1_;
      }
      
      private function createDefinition(param1:Object) : BetterWithPassportDefinition
      {
         var _loc2_:BetterWithPassportDefinition = new BetterWithPassportDefinition();
         _loc2_.type = param1.type;
         _loc2_.date = param1.date;
         _loc2_.image = param1.image;
         _loc2_.message = param1.message;
         _loc2_.dateObject = new Date(Date.parse(param1.date));
         return _loc2_;
      }
      
      public function getDefinition(param1:String) : Object
      {
         return this._settings[param1];
      }
      
      public function set settings(param1:Object) : void
      {
         this._settings = param1.passport;
         this.setupMap();
      }
      
      public function getDefinitionByType(param1:String) : BetterWithPassportDefinition
      {
         return this.mapByType[param1];
      }
      
      private function setupMap() : void
      {
         var _loc1_:BetterWithPassportDefinition = null;
         var _loc2_:Object = null;
         this.mapByType = new Dictionary();
         for each(_loc2_ in this._settings)
         {
            _loc1_ = this.createDefinition(_loc2_);
            this.mapByType[_loc1_.type] = _loc1_;
         }
      }
   }
}
