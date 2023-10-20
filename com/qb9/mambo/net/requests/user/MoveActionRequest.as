package com.qb9.mambo.net.requests.user
{
   import com.qb9.flashlib.lang.map;
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class MoveActionRequest extends BaseMamboRequest
   {
       
      
      private var path:Array;
      
      public function MoveActionRequest(param1:Array)
      {
         super();
         this.path = param1;
      }
      
      private function coordToMobject(param1:Object) : Mobject
      {
         var _loc2_:Mobject = new Mobject();
         _loc2_.setInteger("x",param1.x);
         _loc2_.setInteger("y",param1.y);
         return _loc2_;
      }
      
      override protected function build(param1:Mobject) : void
      {
         var _loc2_:Array = map(this.path,this.coordToMobject);
         param1.setMobjectArray("path",_loc2_);
      }
   }
}
