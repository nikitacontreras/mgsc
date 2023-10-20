package com.qb9.gaturro.view.gui.gift
{
   import flash.events.Event;
   
   public final class GiftGuiModalEvent extends Event
   {
      
      public static const OPEN:String = "ggmeOpenGift";
       
      
      private var _receiver:String;
      
      public function GiftGuiModalEvent(param1:String, param2:String)
      {
         super(param1,true);
         this._receiver = param2;
      }
      
      override public function clone() : Event
      {
         return new GiftGuiModalEvent(type,this.receiver);
      }
      
      public function get receiver() : String
      {
         return this._receiver;
      }
   }
}
