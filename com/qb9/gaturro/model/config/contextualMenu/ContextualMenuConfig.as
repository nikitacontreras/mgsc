package com.qb9.gaturro.model.config.contextualMenu
{
   import com.qb9.gaturro.commons.model.config.BaseSettingsConfig;
   import flash.utils.Dictionary;
   
   public class ContextualMenuConfig extends BaseSettingsConfig
   {
       
      
      private var map:Dictionary;
      
      public function ContextualMenuConfig()
      {
         super();
      }
      
      override public function set settings(param1:Object) : void
      {
         super.settings = param1;
         this.setupMap();
      }
      
      private function setupMap() : void
      {
         var _loc1_:ContextualMenuDefinition = null;
         var _loc2_:Object = null;
         this.map = new Dictionary();
         for each(_loc2_ in _settings.definition)
         {
            _loc1_ = this.getMenuDefinition(_loc2_);
            this.map[_loc1_.name] = _loc1_;
         }
      }
      
      public function getDefinitionByName(param1:String) : ContextualMenuDefinition
      {
         var _loc2_:ContextualMenuDefinition = this.map[param1];
         if(!_loc2_)
         {
            throw new Error("There is no definition with the name: " + param1);
         }
         return _loc2_;
      }
      
      private function setupActionDefinition(param1:Object, param2:IActionButtonDefinitionHolder) : void
      {
         var _loc3_:ContextualMenuActionDefinition = null;
         var _loc4_:Object = null;
         for each(_loc4_ in param1.buttons)
         {
            _loc3_ = new ContextualMenuActionDefinition();
            _loc3_.name = _loc4_.name;
            _loc3_.action = _loc4_.action;
            _loc3_.tootltipText = _loc4_.tootltipText;
            _loc3_.tooltipAsset = _loc4_.tooltipAsset;
            _loc3_.data = _loc4_.data;
            param2.addAction(_loc3_);
            if(_loc4_.buttons)
            {
               this.setupActionDefinition(_loc4_,_loc3_);
            }
         }
      }
      
      private function getMenuDefinition(param1:Object) : ContextualMenuDefinition
      {
         var _loc2_:ContextualMenuDefinition = new ContextualMenuDefinition();
         _loc2_.name = param1.name;
         _loc2_.className = param1.className;
         _loc2_.assetName = param1.assetName;
         _loc2_.assetClass = param1.assetClass;
         _loc2_.buttonAssetClass = param1.buttonAssetClass;
         _loc2_.data = param1.data;
         this.setupActionDefinition(param1,_loc2_);
         return _loc2_;
      }
   }
}
