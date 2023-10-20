package com.qb9.mambo.net.requests.room
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class DestroyRoomObjectActionRequest extends BaseMamboRequest
   {
       
      
      private var sceneObjectId:Number;
      
      public function DestroyRoomObjectActionRequest(param1:Number)
      {
         super("DestroyObjectActionRequest");
         this.sceneObjectId = param1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("sceneObjectId",String(this.sceneObjectId));
      }
   }
}
