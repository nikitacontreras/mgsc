package com.qb9.gaturro.view.gui.contextual
{
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.model.config.contextualMenu.ContextualMenuConfig;
   import com.qb9.gaturro.model.config.contextualMenu.ContextualMenuDefinition;
   import com.qb9.gaturro.view.gui.contextual.implementation.BaseProposerContextualMenu;
   import com.qb9.gaturro.view.gui.contextual.implementation.BaseResponserContextualMenu;
   import com.qb9.gaturro.view.gui.contextual.implementation.hospital.HospitalDoctorContextualMenu;
   import com.qb9.gaturro.view.gui.contextual.implementation.hospital.HospitalPatientContextualMenu;
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   
   public class ContextualMenuFactory implements IConfigHolder
   {
       
      
      private var _config:ContextualMenuConfig;
      
      private var map:Dictionary;
      
      public function ContextualMenuFactory()
      {
         super();
         this.setupMap();
      }
      
      public function set config(param1:IConfig) : void
      {
         this._config = param1 as ContextualMenuConfig;
      }
      
      public function build(param1:String, param2:DisplayObject, param3:Object = null) : AbstractContextualMenu
      {
         var _loc4_:ContextualMenuDefinition = this._config.getDefinitionByName(param1);
         var _loc6_:AbstractContextualMenu;
         var _loc5_:Class;
         (_loc6_ = new (_loc5_ = this.map[_loc4_.className])(_loc4_,param2)).data = param3;
         return _loc6_;
      }
      
      private function setupMap() : void
      {
         this.map = new Dictionary();
         this.map["HospitalPatientContextualMenu"] = HospitalPatientContextualMenu;
         this.map["HospitalDoctorContextualMenu"] = HospitalDoctorContextualMenu;
         this.map["BaseProposerContextualMenu"] = BaseProposerContextualMenu;
         this.map["BaseResponserContextualMenu"] = BaseResponserContextualMenu;
      }
   }
}
