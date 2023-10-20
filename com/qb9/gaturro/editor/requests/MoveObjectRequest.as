package com.qb9.gaturro.editor.requests
{
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class MoveObjectRequest extends BaseMamboRequest
   {
       
      
      private var id:Number;
      
      private var coord:Coord;
      
      public function MoveObjectRequest(param1:Number, param2:Coord)
      {
         super("ObjectCreateOrUpdateRequest");
         this.id = param1;
         this.coord = param2;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("id",String(this.id));
         param1.setIntegerArray("coord",this.coord.toArray());
      }
   }
}
