package com.qb9.gaturro.world.houseInteractive.buyer
{
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import com.qb9.gaturro.world.houseInteractive.HomeBehavior;
   import flash.utils.setTimeout;
   
   public class BuyerBehavior extends HomeBehavior
   {
      
      private static const STATE_IDLE:int = 0;
      
      private static const STATE_BUYING:int = 1;
      
      private static const STATE_AWAY:int = 3;
      
      private static const STATE_HIDING:int = 2;
       
      
      private var granjaView:GaturroHomeGranjaView;
      
      private var buyerID:int;
      
      public function BuyerBehavior()
      {
         super();
      }
      
      override public function set currentState(param1:int) : void
      {
         if(!objectAPI)
         {
            return;
         }
         _currentState = param1;
         objectAPI.setAttribute("state",param1);
      }
      
      private function makeVisibleTimed() : void
      {
         if(!objectAPI && !roomAPI && !asset)
         {
            return;
         }
         objectAPI.view.visible = true;
         roomAPI.playSound("granja/NPC_aparece");
         asset.gotoAndStop(1);
         this.currentState = STATE_IDLE;
      }
      
      override public function activate() : void
      {
         if(_currentState == STATE_IDLE)
         {
            this.granjaView.buyingManager.generateRequest(this.buyerID);
            this.currentState = STATE_BUYING;
            asset.gotoAndStop(2);
            return;
         }
         if(_currentState == STATE_BUYING)
         {
            this.granjaView.buyingManager.openPedido(this.buyerID);
            return;
         }
         if(_currentState == STATE_HIDING)
         {
            objectAPI.view.visible = false;
            roomAPI.playSound("granja/NPC_desaparece");
            this.currentState = STATE_AWAY;
            return;
         }
         if(_currentState == STATE_AWAY)
         {
            this.makeVisible();
         }
      }
      
      public function makeVisible() : void
      {
         setTimeout(this.makeVisibleTimed,20000 + Math.random() * 90000);
      }
      
      override protected function atStart() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         super.atStart();
         this.granjaView = roomAPI.roomView as GaturroHomeGranjaView;
         if(objectAPI.getAttribute("buyerID"))
         {
            this.buyerID = objectAPI.getAttribute("buyerID") as int;
         }
         else
         {
            _loc1_ = objectAPI.object.name;
            _loc2_ = int(_loc1_.substring(_loc1_.length - 1,_loc1_.length));
            objectAPI.setAttribute("buyerID",_loc2_);
            this.buyerID = _loc2_;
         }
         if(objectAPI.getAttribute("state"))
         {
            _currentState = objectAPI.getAttribute("state") as int;
         }
         else
         {
            objectAPI.setAttribute("state",STATE_IDLE);
            _currentState = STATE_IDLE;
         }
         switch(_currentState)
         {
            case STATE_IDLE:
               asset.gotoAndStop(1);
               break;
            case STATE_BUYING:
               asset.gotoAndStop(2);
               break;
            case STATE_HIDING:
               objectAPI.view.visible = false;
               this.makeVisible();
               break;
            case STATE_AWAY:
               this.makeVisibleTimed();
         }
      }
   }
}
