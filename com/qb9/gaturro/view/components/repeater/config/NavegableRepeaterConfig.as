package com.qb9.gaturro.view.components.repeater.config
{
   import flash.display.Sprite;
   
   public class NavegableRepeaterConfig extends RepeaterConfig
   {
       
      
      private var _menuContainer:Sprite;
      
      public function NavegableRepeaterConfig(param1:String, param2:Object, param3:Sprite, param4:Sprite, param5:int)
      {
         super(param1,param2,param3,param5);
         this._menuContainer = param4;
      }
      
      public function get menuContainer() : Sprite
      {
         return this._menuContainer;
      }
      
      public function set menuContainer(param1:Sprite) : void
      {
         this._menuContainer = param1;
      }
   }
}
