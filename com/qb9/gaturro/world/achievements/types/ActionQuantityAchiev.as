package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   import flash.utils.setTimeout;
   
   public class ActionQuantityAchiev extends Achievement
   {
       
      
      protected var actionName:String;
      
      protected var quantityExecuted:int;
      
      protected var quantityNeeds:int;
      
      public function ActionQuantityAchiev(param1:Object)
      {
         super(param1);
         this.actionName = param1.data.action;
         this.quantityNeeds = param1.data.quantity;
      }
      
      override public function changeRoom(param1:GaturroRoom) : void
      {
         this.deactivate();
         super.changeRoom(param1);
         if(!achieved)
         {
            this.activate();
         }
      }
      
      protected function computeAction(param1:String) : void
      {
         ++this.quantityExecuted;
         if(this.quantityExecuted >= this.quantityNeeds)
         {
            setTimeout(achieve,5000);
         }
         else
         {
            save(this.quantityExecuted.toString());
         }
      }
      
      override public function init(param1:String, param2:Boolean) : void
      {
         super.init(param1,param2);
         if(param1 == Achievement.ACHIEVEMENT_SUCCESS)
         {
            achieved = true;
         }
         else if(param1 == "")
         {
            this.quantityExecuted = 0;
         }
         else
         {
            this.quantityExecuted = int(param1) || int(param1.split(";").length);
         }
      }
      
      override protected function activate() : void
      {
         if(!monitor)
         {
            return;
         }
         if(!room || !room.userAvatar)
         {
            return;
         }
         room.userAvatar.addEventListener(CustomAttributesEvent.CHANGED,this.checkAction);
      }
      
      override protected function deactivate() : void
      {
         if(!room || !room.userAvatar)
         {
            return;
         }
         room.userAvatar.removeEventListener(CustomAttributesEvent.CHANGED,this.checkAction);
      }
      
      protected function checkAction(param1:CustomAttributesEvent) : void
      {
         var _loc2_:CustomAttribute = null;
         var _loc3_:String = null;
         for each(_loc2_ in param1.attributes)
         {
            if(_loc2_.value)
            {
               _loc3_ = String(String(_loc2_.value).split(".")[0]);
               if(_loc2_.key == "action" && _loc3_ == this.actionName)
               {
                  this.computeAction(String(_loc2_.value));
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         this.deactivate();
         super.dispose();
      }
   }
}
