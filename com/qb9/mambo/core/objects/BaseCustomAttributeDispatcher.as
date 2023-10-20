package com.qb9.mambo.core.objects
{
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.attributes.CustomAttributeDispatcher;
   import com.qb9.mambo.core.attributes.CustomAttributeHolder;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   
   public class BaseCustomAttributeDispatcher extends MamboObject implements CustomAttributeDispatcher, CustomAttributeHolder
   {
       
      
      protected var _attributes:CustomAttributes;
      
      public function BaseCustomAttributeDispatcher()
      {
         super();
      }
      
      public function dispatchCustomAttributes(param1:Array) : void
      {
         var _loc2_:CustomAttribute = null;
         for each(_loc2_ in param1)
         {
            dispatchEvent(new CustomAttributeEvent(_loc2_));
         }
         dispatchEvent(new CustomAttributesEvent(CustomAttributesEvent.CHANGED,param1));
      }
      
      public function removeCustomAttributeListener(param1:String, param2:Function) : void
      {
         removeEventListener(param1,param2);
      }
      
      public function get attributes() : CustomAttributes
      {
         return this._attributes;
      }
      
      public function addCustomAttributeListener(param1:String, param2:Function) : void
      {
         addEventListener(param1,param2);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this.attributes) && this.attributes.owner === this)
         {
            this.attributes.dispose();
         }
         this._attributes = null;
         super.dispose();
      }
   }
}
