package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import farm.GranjeroTutorialMC;
   import flash.events.MouseEvent;
   
   public class GranjeroTutorial extends GranjeroTutorialMC
   {
       
      
      private var params:Object;
      
      private var api:GaturroRoomAPI;
      
      public function GranjeroTutorial(param1:Object)
      {
         super();
         this.api = param1.api;
         this.params = param1;
         buttonMode = true;
         glow.visible = false;
         var _loc2_:int = this.api.getProfileAttribute(GaturroHomeGranjaView.TUTORIAL_NAME) as int;
         if(_loc2_ != 2)
         {
            if(_loc2_ == 1)
            {
               helpText.text = this.api.getText("¡CONSTRUYE TU GRANJA!");
            }
            else
            {
               helpText.visible = false;
               helpTextBG.visible = false;
            }
            addEventListener(MouseEvent.CLICK,this.onClick);
         }
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.glow.visible = true;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.glow.visible = false;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.api.showBannerModal("construyeGranja");
      }
   }
}
