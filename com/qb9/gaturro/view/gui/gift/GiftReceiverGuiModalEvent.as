package com.qb9.gaturro.view.gui.gift
{
   import flash.events.Event;
   
   public final class GiftReceiverGuiModalEvent extends Event
   {
      
      public static const OPEN:String = "grgmeOpen";
       
      
      public function GiftReceiverGuiModalEvent(param1:String)
      {
         super(param1,true);
      }
      
      override public function clone() : Event
      {
         return new GiftReceiverGuiModalEvent(type);
      }
   }
}
