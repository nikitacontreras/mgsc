package com.qb9.gaturro.view.gui.sell
{
   import flash.events.Event;
   
   public final class SellItemGuiModalEvent extends Event
   {
      
      public static const OPEN:String = "sigmeOpenSellItem";
       
      
      private var _receiver:String;
      
      public function SellItemGuiModalEvent(param1:String)
      {
         super(param1,true);
      }
      
      override public function clone() : Event
      {
         return new SellItemGuiModalEvent(type);
      }
   }
}
