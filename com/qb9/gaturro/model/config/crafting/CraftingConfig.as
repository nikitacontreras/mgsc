package com.qb9.gaturro.model.config.crafting
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.commons.model.config.BaseSettingsConfig;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.model.config.crafting.definition.CraftingBannerDefinition;
   import com.qb9.gaturro.model.config.crafting.definition.CraftingDefinition;
   import flash.utils.Dictionary;
   
   public class CraftingConfig extends BaseSettingsConfig
   {
       
      
      private var mapBannerView:Dictionary;
      
      private var map:Dictionary;
      
      public function CraftingConfig()
      {
         super();
         this.map = new Dictionary();
         this.mapBannerView = new Dictionary();
         this.mapBannerView = new Dictionary();
      }
      
      override public function set settings(param1:Object) : void
      {
         super.settings = param1;
         this.setupMap();
         this.setupBannerMapView();
      }
      
      override public function getIterator() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(this.map);
         return _loc1_;
      }
      
      public function getDefinitionByCode(param1:int) : CraftingDefinition
      {
         var _loc2_:CraftingDefinition = this.map[param1];
         if(!_loc2_)
         {
            logger.debug("Doesn\'t exist definition with the code= " + param1);
            throw new Error("Doesn\'t exist definition with the code= " + param1);
         }
         return _loc2_;
      }
      
      private function setupMap() : void
      {
         var _loc1_:CraftingDefinition = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         for each(_loc2_ in _settings.definition)
         {
            _loc1_ = new CraftingDefinition(_loc2_.code,_loc2_.name,_loc2_.reward);
            for each(_loc3_ in _loc2_.modules)
            {
               _loc1_.addCraftItem(_loc3_);
            }
            this.map[_loc1_.code] = _loc1_;
         }
      }
      
      public function getCraftingBannerDefinition(param1:int) : CraftingBannerDefinition
      {
         var _loc2_:CraftingBannerDefinition = this.mapBannerView[param1];
         if(!_loc2_)
         {
            logger.debug("Doesn\'t exist banner definition with the code= " + param1);
            throw new Error("Doesn\'t exist banner definition with the code= " + param1);
         }
         return _loc2_;
      }
      
      private function setupBannerMapView() : void
      {
         var _loc1_:CraftingBannerDefinition = null;
         var _loc2_:Object = null;
         for each(_loc2_ in _settings.banner)
         {
            _loc1_ = new CraftingBannerDefinition(_loc2_.name,_loc2_.code,_loc2_.banner,_loc2_.asset,_loc2_.itemRendererAsset);
            this.mapBannerView[_loc1_.code] = _loc1_;
         }
      }
   }
}
