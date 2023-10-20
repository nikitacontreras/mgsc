package com.qb9.mambo.net.requests.room
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mambo.world.core.RoomLink;
   import com.qb9.mines.mobject.Mobject;
   
   public class ChangeRoomActionRequest extends BaseMamboRequest
   {
       
      
      private var link:RoomLink;
      
      public function ChangeRoomActionRequest(param1:RoomLink)
      {
         super();
         this.link = param1;
      }
      
      override protected function build(param1:Mobject) : void
      {
         if(this.link.worldCoord)
         {
            param1.setIntegerArray("worldCoord",this.link.worldCoord.toArray());
         }
         if(this.link.roomId)
         {
            param1.setInteger("roomId",this.link.roomId);
         }
         if(this.link.owner)
         {
            param1.setString("ownerUsername",this.link.owner);
         }
         param1.setIntegerArray("coord",this.link.coord.toArray());
      }
   }
}
