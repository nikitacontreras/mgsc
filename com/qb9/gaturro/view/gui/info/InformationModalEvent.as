package com.qb9.gaturro.view.gui.info
{
   import flash.events.Event;
   
   public final class InformationModalEvent extends Event
   {
      
      public static const SHOW:String = "imeShowInformationModal";
       
      
      private var _imageName:String;
      
      private var _message:String;
      
      public function InformationModalEvent(param1:String, param2:String, param3:String)
      {
         super(param1,true);
         this._message = param2;
         this._imageName = param3;
      }
      
      override public function clone() : Event
      {
         return new InformationModalEvent(type,this.message,this.imageName);
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function get imageName() : String
      {
         return this._imageName;
      }
   }
}
