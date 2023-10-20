package com.qb9.mambo.net.requests.inventory
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mines.mobject.Mobject;
   
   public final class SwapToInventoryActionRequest extends BaseMamboRequest
   {
       
      
      private var inventory:String;
      
      private var sceneObjectId:Number;
      
      public function SwapToInventoryActionRequest(param1:Number, param2:String = null)
      {
         super();
         this.sceneObjectId = param1;
         this.inventory = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("sceneObjectId",String(this.sceneObjectId));
         if(Boolean(this.inventory) && this.inventory !== Inventory.DEFAULT)
         {
            param1.setString("name",this.inventory);
         }
      }
   }
}
