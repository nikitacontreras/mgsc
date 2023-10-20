package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.gaturro.globals.net;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   
   public class GiveObjectAchiev extends Achievement
   {
       
      
      protected var quantityNeeds:int;
      
      protected var quantityExecuted:int = 0;
      
      public function GiveObjectAchiev(param1:Object)
      {
         super(param1);
         this.quantityNeeds = param1.data.quantity;
      }
      
      override public function init(param1:String, param2:Boolean) : void
      {
         super.init(param1,param2);
         if(param1 == Achievement.ACHIEVEMENT_SUCCESS)
         {
            achieved = true;
         }
         else
         {
            this.quantityExecuted = int(param1);
            this.activate();
         }
      }
      
      override protected function activate() : void
      {
         if(!monitor)
         {
            return;
         }
         net.addEventListener(NetworkManagerEvent.UNIQUE_ACTION_SENT,this.sendGift);
      }
      
      private function sendGift(param1:NetworkManagerEvent) : void
      {
         var _loc2_:String = param1.mobject.getString("request");
         if(_loc2_ != "GiveObjectActionRequest")
         {
            return;
         }
         ++this.quantityExecuted;
         if(this.quantityExecuted < this.quantityNeeds)
         {
            save(this.quantityExecuted.toString());
         }
         else
         {
            achieve();
         }
      }
      
      override protected function deactivate() : void
      {
         net.removeEventListener(NetworkManagerEvent.UNIQUE_ACTION_SENT,this.sendGift);
      }
      
      override public function dispose() : void
      {
         this.deactivate();
         super.dispose();
      }
   }
}
