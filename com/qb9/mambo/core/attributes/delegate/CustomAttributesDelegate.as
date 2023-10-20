package com.qb9.mambo.core.attributes.delegate
{
   import com.qb9.flashlib.lang.filter;
   import com.qb9.flashlib.lang.map;
   import com.qb9.flashlib.logs.Logger;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.attributes.CustomAttributeHolder;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   
   public class CustomAttributesDelegate extends CustomAttributes
   {
       
      
      private var host:CustomAttributeHolder;
      
      private var prefix:String;
      
      public function CustomAttributesDelegate(param1:String, param2:CustomAttributeHolder, param3:CustomAttributeHolder = null)
      {
         super(param3);
         this.prefix = param1;
         this.host = param2;
         this.init();
      }
      
      private function isOwnAttribute(param1:CustomAttribute) : Boolean
      {
         return param1.key.indexOf(this.prefix) === 0;
      }
      
      override public function dispose() : void
      {
         if(this.host)
         {
            this.host.removeEventListener(CustomAttributesEvent.CHANGED,this.dispatchOwnAttributes);
         }
         this.host = null;
         super.dispose();
      }
      
      private function dispatchOwnAttributes(param1:CustomAttributesEvent) : void
      {
         dispatch(this.convertArray(param1.attributes));
      }
      
      override public function toArray() : Array
      {
         return this.convertArray(this.attributes.toArray());
      }
      
      private function convertArray(param1:Array) : Array
      {
         return map(filter(param1,this.isOwnAttribute),this.fixAttribute);
      }
      
      private function fixAttribute(param1:CustomAttribute) : CustomAttribute
      {
         return new CustomAttribute(this.fixKey(param1.key),param1.value);
      }
      
      private function fixKey(param1:String) : String
      {
         return param1.replace(this.prefix,"");
      }
      
      override protected function getProperty(param1:String) : Object
      {
         return this.attributes[this.p(param1)];
      }
      
      private function addPrefixToAttribute(param1:CustomAttribute) : CustomAttribute
      {
         return new CustomAttribute(this.p(param1.key),param1.value);
      }
      
      override protected function hasProperty(param1:String) : Boolean
      {
         return this.p(param1) in this.attributes;
      }
      
      private function init() : void
      {
         this.host.addEventListener(CustomAttributesEvent.CHANGED,this.dispatchOwnAttributes);
      }
      
      override public function mergeAttributesArray(param1:Array, param2:Boolean = false) : void
      {
         this.attributes.mergeAttributesArray(map(param1,this.addPrefixToAttribute),param2);
      }
      
      private function get attributes() : CustomAttributes
      {
         if(Boolean(this.host) && Boolean(this.host.attributes))
         {
            return this.host.attributes;
         }
         Logger.getLogger("mambo").warning("CustomAttributesDelegate > found null or disposed host");
         return new CustomAttributes();
      }
      
      private function p(param1:Object) : String
      {
         return this.prefix + getKey(param1);
      }
      
      override protected function setProperty(param1:String, param2:Object) : void
      {
         this.attributes[this.p(param1)] = param2;
      }
   }
}
