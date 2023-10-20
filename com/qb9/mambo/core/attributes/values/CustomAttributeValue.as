package com.qb9.mambo.core.attributes.values
{
   import com.qb9.flashlib.security.SafeString;
   
   public class CustomAttributeValue
   {
       
      
      private var _safeValue:Object;
      
      public function CustomAttributeValue(param1:Object)
      {
         super();
         if(param1 is String)
         {
            this._safeValue = new SafeString(String(param1));
         }
         else
         {
            this._safeValue = param1;
         }
      }
      
      public function get extract() : Object
      {
         if(this._safeValue is SafeString)
         {
            return SafeString(this._safeValue).value;
         }
         return this._safeValue;
      }
   }
}
