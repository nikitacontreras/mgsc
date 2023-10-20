package com.qb9.gaturro.view.gui.actions
{
   import assets.ActionsButtonMC;
   import assets.actions.*;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class CelebrateButton extends CelebrateButtons implements IDisposable
   {
       
      
      private var config:Array;
      
      private var instanceNames:Array;
      
      private var avatar:UserAvatar;
      
      private var room:GaturroRoom;
      
      public function CelebrateButton(param1:GaturroRoom, param2:UserAvatar)
      {
         super();
         this.room = param1;
         this.avatar = param2;
         this.config = settings.celebrations.config;
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
      
      private function onButtonFetch(param1:DisplayObject, param2:Object) : void
      {
         param2.addChild(param1);
         this.instanceNames.push(param1.name);
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
            _loc3_ = this.config[_loc1_];
            if(Boolean(_loc2_) && Boolean(_loc3_))
            {
               api.libraries.fetch(_loc3_.icon,this.onButtonFetch,_loc2_.ph);
            }
            _loc2_.buttonMode = true;
            _loc2_.gotoAndStop("glow");
            _loc2_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc1_++;
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc5_:String = null;
         var _loc2_:ActionsButtonMC = this.getButton(param1.target as DisplayObject);
         var _loc3_:String = _loc2_.ph.getChildAt(0).name;
         var _loc4_:int = this.getIndex(_loc3_);
         if(Boolean(this.config[_loc4_].isVip) && !api.user.isCitizen)
         {
            api.showBannerModal("pasaporte2");
         }
         else
         {
            _loc5_ = String(this.config[_loc4_].action);
            this.avatar.attributes.action = _loc5_;
            if(this.config[_loc4_].soundFx)
            {
               api.playSound(this.config[_loc4_].soundFx);
            }
         }
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
