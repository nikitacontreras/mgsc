package com.qb9.gaturro.util
{
   import com.qb9.mambo.core.attributes.CustomAttributeHolder;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.objects.BaseCustomAttributeDispatcher;
   
   public final class StubAttributeHolder extends BaseCustomAttributeDispatcher
   {
       
      
      public function StubAttributeHolder(param1:CustomAttributes)
      {
         super();
         _attributes = param1;
         param1.assignTo(this);
      }
      
      public static function fromHolder(param1:CustomAttributeHolder) : StubAttributeHolder
      {
         return new StubAttributeHolder(param1.attributes.clone());
      }
   }
}
