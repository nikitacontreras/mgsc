package com.qb9.mambo.core.attributes.events
{
   import flash.events.Event;
   
   public final class CustomAttributesEvent extends Event
   {
      
      public static const CHANGED:String = "customAttributesChanged";
       
      
      protected var _attributes:Array;
      
      public function CustomAttributesEvent(param1:String, param2:Array)
      {
         super(param1);
         this._attributes = param2;
      }
      
      override public function clone() : Event
      {
         return new CustomAttributesEvent(type,this.attributes);
      }
      
      public function get attributes() : Array
      {
         return this._attributes;
      }
   }
}
