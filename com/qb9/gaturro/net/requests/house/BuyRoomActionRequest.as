package com.qb9.gaturro.net.requests.house
{
   import com.qb9.gaturro.net.requests.SecureMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class BuyRoomActionRequest extends SecureMamboRequest
   {
       
      
      private var roomNum:int;
      
      public function BuyRoomActionRequest(param1:int)
      {
         super();
         this.roomNum = param1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setInteger("num",this.roomNum);
         applyValidationDigest(param1);
      }
   }
}
