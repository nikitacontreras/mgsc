package com.qb9.gaturro.view.components.repeater.item.implementation.partyElite
{
   import com.qb9.gaturro.view.components.repeater.item.BaseItemRenderer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CandidateItemRenderer extends BaseItemRenderer
   {
       
      
      public function CandidateItemRenderer(param1:Class)
      {
         super(param1);
      }
      
      override protected function dataReady() : void
      {
         super.dataReady();
         this.setField();
      }
      
      override protected function setupView() : void
      {
         super.setupView();
         mouseChildren = false;
         buttonMode = true;
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      override public function deselect() : void
      {
         MovieClip(view).gotoAndStop("unselected");
         super.deselect();
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onClick);
         super.dispose();
      }
      
      private function setField() : void
      {
         var _loc1_:TextField = view.getChildByName("labelText") as TextField;
         _loc1_.text = String(data);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         innerSelect();
         MovieClip(view).gotoAndStop("selected");
      }
      
      override public function refresh(param1:Object = null) : void
      {
         super.refresh(param1);
         this.setField();
      }
   }
}
