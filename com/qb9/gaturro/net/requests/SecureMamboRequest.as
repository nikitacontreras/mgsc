package com.qb9.gaturro.net.requests
{
   import com.qb9.gaturro.GameData;
   import com.qb9.gaturro.net.security.SecurityMethod;
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public class SecureMamboRequest extends BaseMamboRequest
   {
       
      
      public function SecureMamboRequest(param1:String = null)
      {
         super(param1);
      }
      
      protected function applyValidationDigest(param1:Mobject) : void
      {
         var _loc2_:SecurityMethod = new SecurityMethod();
         var _loc3_:Object = _loc2_.createValidationDigest(GameData.securityRequestKey);
         param1.setString("digestNum",_loc3_.digestNum);
         param1.setString("digestHash",_loc3_.digestHash);
      }
   }
}
