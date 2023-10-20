package com.qb9.gaturro.net.requests.objects
{
   import com.qb9.gaturro.net.requests.SecureMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class SellObjectActionRequest extends SecureMamboRequest
   {
       
      
      private var resellPrice:int = 0;
      
      private var sceneObjectId:Number;
      
      public function SellObjectActionRequest(param1:Number, param2:int)
      {
         super();
         this.sceneObjectId = param1;
         this.resellPrice = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("sceneObjectId",String(this.sceneObjectId));
         param1.setString("resellPrice",String(this.resellPrice));
         applyValidationDigest(param1);
      }
   }
}
