package com.qb9.gaturro.net.requests.objects
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public class SwapObjectsActionRequest extends BaseMamboRequest
   {
       
      
      private var item1:String;
      
      private var user1:String;
      
      private var user2:String;
      
      private var inventory1:String;
      
      private var inventory2:String;
      
      private var item2:String;
      
      public function SwapObjectsActionRequest(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String)
      {
         super();
         this.user1 = param1;
         this.item1 = param2;
         this.inventory1 = param3;
         this.user2 = param4;
         this.item2 = param5;
         this.inventory2 = param6;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("offeredObjectIdA",this.item1);
         param1.setString("inventoryNameA",this.inventory1);
         param1.setString("receiverA",this.user1);
         param1.setString("offeredObjectIdB",this.item2);
         param1.setString("inventoryNameB",this.inventory2);
         param1.setString("receiverB",this.user2);
      }
   }
}
