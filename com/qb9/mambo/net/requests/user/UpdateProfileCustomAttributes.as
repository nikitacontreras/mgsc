package com.qb9.mambo.net.requests.user
{
   import com.qb9.mambo.net.requests.customAttributes.BaseUpdateCustomAttributesRequest;
   
   public final class UpdateProfileCustomAttributes extends BaseUpdateCustomAttributesRequest
   {
       
      
      public function UpdateProfileCustomAttributes(param1:Number, param2:Array)
      {
         super("profileId",param1,param2);
      }
   }
}
