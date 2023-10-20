package com.qb9.mambo.net.requests.inventory
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class DestroyInventoryObjectActionRequest extends BaseMamboRequest
   {
       
      
      private var sceneObjectId:Number;
      
      public function DestroyInventoryObjectActionRequest(param1:Number)
      {
         super();
         this.sceneObjectId = param1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("sceneObjectId",String(this.sceneObjectId));
      }
   }
}
