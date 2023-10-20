package com.qb9.mambo.core.attributes.events
{
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import flash.events.Event;
   
   public final class CustomAttributeEvent extends Event
   {
       
      
      protected var _attribute:CustomAttribute;
      
      public function CustomAttributeEvent(param1:CustomAttribute, param2:String = null)
      {
         super(param2 || param1.key);
         this._attribute = param1;
      }
      
      public function get attribute() : CustomAttribute
      {
         return this._attribute;
      }
      
      override public function clone() : Event
      {
         return new CustomAttributeEvent(this.attribute);
      }
   }
}
