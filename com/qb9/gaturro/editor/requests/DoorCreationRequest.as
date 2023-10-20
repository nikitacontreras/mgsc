package com.qb9.gaturro.editor.requests
{
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.world.core.RoomLink;
   import com.qb9.mines.mobject.Mobject;
   
   public final class DoorCreationRequest extends ObjectCreationRequest
   {
       
      
      private var link:RoomLink;
      
      public function DoorCreationRequest(param1:Coord = null, param2:RoomLink = null)
      {
         super("door",param1,true);
         this.link = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         super.build(param1);
         param1.setMobject("link",this.link.toMobject());
      }
   }
}
