package com.qb9.gaturro.editor.requests
{
   import com.qb9.flashlib.lang.map;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class UpdateRoomTileActionRequest extends BaseMamboRequest
   {
       
      
      private var coords:Array;
      
      private var blocks:Boolean;
      
      public function UpdateRoomTileActionRequest(param1:Boolean, param2:Array = null)
      {
         super("UpdateRoomTileActionRequest");
         this.blocks = param1;
         this.coords = param2;
      }
      
      private function coordToMobject(param1:Coord) : Mobject
      {
         var _loc2_:Mobject = new Mobject();
         _loc2_.setIntegerArray("coord",param1.toArray());
         return _loc2_;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setBoolean("blockingHint",this.blocks);
         if(this.coords)
         {
            param1.setMobjectArray("coords",map(this.coords,this.coordToMobject));
         }
      }
   }
}
