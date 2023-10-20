package com.qb9.gaturro.view.gui.contextual.implementation
{
   import com.qb9.gaturro.commons.loader.SWFLoaderWrapper;
   import com.qb9.gaturro.model.config.contextualMenu.ContextualMenuActionDefinition;
   import com.qb9.gaturro.view.components.repeater.item.BaseItemRenderer;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class BaseContextualMenuItemRenderer extends BaseItemRenderer
   {
      
      private static const UP_LABEL:String = "up";
      
      private static const DOWN_LABEL:String = "down";
      
      private static const OVER_LABEL:String = "over";
       
      
      private var loaderWarpper:SWFLoaderWrapper;
      
      private var iconHolder:DisplayObjectContainer;
      
      private var button:MovieClip;
      
      public function BaseContextualMenuItemRenderer(param1:Class, param2:SWFLoaderWrapper)
      {
         super(param1);
         this.loaderWarpper = param2;
         this.setupOwnView();
      }
      
      override protected function dataReady() : void
      {
         super.dataReady();
         this.setupIcon();
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this.button.gotoAndStop(UP_LABEL);
      }
      
      override public function dispose() : void
      {
         this.button.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.button.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.button.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         super.dispose();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.button.gotoAndStop(DOWN_LABEL);
      }
      
      private function setupOwnView() : void
      {
         this.setupButton();
         this.iconHolder = view.getChildByName("iconHolder") as DisplayObjectContainer;
         this.iconHolder.mouseEnabled = false;
         this.iconHolder.mouseChildren = false;
      }
      
      private function setupButton() : void
      {
         this.button = view.getChildByName("button") as MovieClip;
         this.button.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.button.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.button.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.button.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.button.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.button.buttonMode = true;
         this.button.stop();
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.button.gotoAndStop(OVER_LABEL);
      }
      
      private function setupIcon() : void
      {
         var _loc1_:DisplayObject = this.loaderWarpper.getInstanceByName(this.definition.data.iconAssetClass);
         this.iconHolder.addChild(_loc1_);
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         innerSelect();
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.button.gotoAndStop(UP_LABEL);
      }
      
      private function get definition() : ContextualMenuActionDefinition
      {
         return data as ContextualMenuActionDefinition;
      }
   }
}
