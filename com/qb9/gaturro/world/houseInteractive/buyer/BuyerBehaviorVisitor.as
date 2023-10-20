package com.qb9.gaturro.world.houseInteractive.buyer
{
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import com.qb9.gaturro.world.houseInteractive.HomeBehavior;
   
   public class BuyerBehaviorVisitor extends HomeBehavior
   {
      
      private static const STATE_IDLE:int = 0;
      
      private static const STATE_BUYING:int = 1;
      
      private static const STATE_AWAY:int = 3;
      
      private static const STATE_HIDING:int = 2;
       
      
      private var granjaView:GaturroHomeGranjaView;
      
      private var buyerID:int;
      
      public function BuyerBehaviorVisitor()
      {
         super();
      }
      
      override public function activate() : void
      {
      }
      
      override protected function atStart() : void
      {
         super.atStart();
         this.granjaView = roomAPI.roomView as GaturroHomeGranjaView;
         asset.gotoAndStop(1);
      }
   }
}
