package com.qb9.gaturro.view.gui.actions
{
   import assets.ActionsButtonMC;
   import assets.actions.*;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class GuiDancingModal extends ClubDanceButtons implements IDisposable
   {
       
      
      private var avatar:UserAvatar;
      
      private var instanceNames:Array;
      
      private var room:GaturroRoom;
      
      private const ACTIONS:Array = [{
         "n":"dance",
         "a":danceMC,
         "s":"acc3"
      },{
         "n":"dance2",
         "a":dance2MC,
         "s":"acc13"
      },{
         "n":"dance3",
         "a":dance3MC,
         "s":"acc14"
      },{
         "n":"dance4",
         "a":dance4MC,
         "s":"acc15"
      },{
         "n":"dance5",
         "a":dance5MC,
         "s":"acc16"
      }];
      
      public function GuiDancingModal(param1:GaturroRoom, param2:UserAvatar)
      {
         this.room = param1;
         this.avatar = param2;
         super();
         this.init();
      }
      
      private function getButton(param1:DisplayObject) : ActionsButtonMC
      {
         var _loc2_:DisplayObject = param1;
         while(Boolean(_loc2_) && _loc2_ is ActionsButtonMC === false)
         {
            _loc2_ = _loc2_.parent;
         }
         return _loc2_ as ActionsButtonMC;
      }
      
      private function init() : void
      {
         var _loc2_:ActionsButtonMC = null;
         var _loc3_:Object = null;
         this.instanceNames = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_) as ActionsButtonMC;
            _loc3_ = this.ACTIONS[_loc1_];
            _loc2_.ph.addChild(new _loc3_.a());
            _loc2_.buttonMode = true;
            _loc2_.gotoAndStop("glow");
            _loc2_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            this.instanceNames.push(_loc2_.ph.getChildAt(0).name);
            _loc1_++;
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:ActionsButtonMC = this.getButton(param1.target as DisplayObject);
         var _loc3_:String = _loc2_.ph.getChildAt(0).name;
         var _loc4_:int = this.getIndex(_loc3_);
         var _loc5_:String = String(this.ACTIONS[_loc4_].n);
         this.avatar.attributes.action = _loc5_;
      }
      
      private function getIndex(param1:String) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.instanceNames.length)
         {
            if(param1 == this.instanceNames[_loc2_])
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function dispose() : void
      {
         var _loc2_:ActionsButtonMC = null;
         this.room = null;
         this.avatar = null;
         this.instanceNames = null;
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_) as ActionsButtonMC;
            _loc2_.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc1_++;
         }
      }
   }
}
