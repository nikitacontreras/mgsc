package com.qb9.gaturro.view.components.repeater.item
{
   import flash.display.Sprite;
   
   public class BaseItemRenderer extends AbstractItemRenderer
   {
       
      
      protected var view:Sprite;
      
      protected var _contentClass:Class;
      
      public function BaseItemRenderer(param1:Class)
      {
         super();
         this._contentClass = param1;
         this.setupView();
      }
      
      protected function setupView() : void
      {
         this.view = this.getView();
         addChild(this.view);
      }
      
      override public function refresh(param1:Object = null) : void
      {
         if(param1 != null)
         {
            data = param1;
         }
      }
      
      protected function getView() : Sprite
      {
         return new this._contentClass();
      }
   }
}
