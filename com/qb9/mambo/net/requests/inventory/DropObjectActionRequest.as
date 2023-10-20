package com.qb9.mambo.net.requests.inventory
{
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class DropObjectActionRequest extends BaseMamboRequest
   {
       
      
      private var id:Number;
      
      private var coord:Coord;
      
      public function DropObjectActionRequest(param1:Number, param2:Coord)
      {
         super();
         this.id = param1;
         this.coord = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("sceneObjectId",String(this.id));
         param1.setIntegerArray("coord",this.coord.toArray());
      }
   }
}
