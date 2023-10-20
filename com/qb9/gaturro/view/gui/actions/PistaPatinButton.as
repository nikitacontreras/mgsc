package com.qb9.gaturro.view.gui.actions
{
   import assets.ActionsButtonPatinMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class PistaPatinButton extends PistaPatinButtons implements IDisposable
   {
      
      private static const KEYS:Array = [Keyboard.NUMPAD_1,Keyboard.NUMPAD_2,Keyboard.NUMPAD_3,Keyboard.NUMPAD_4,Keyboard.NUMPAD_5];
       
      
      private var config:Array;
      
      private var _buttons:Array;
      
      private var _stageRef:DisplayObject;
      
      private var avatar:UserAvatar;
      
      private var _timeoutId:uint;
      
      private var room:GaturroRoom;
      
      private var _kick:Function;
      
      private var instanceNames:Array;
      
      private var _allowedKey:Boolean;
      
      public function PistaPatinButton(param1:GaturroRoom, param2:UserAvatar, param3:Function, param4:DisplayObject)
      {
         super();
         this.room = param1;
         this.avatar = param2;
         this._kick = param3;
         this.config = settings.celebrations.inviernoButtons;
         this._stageRef = param4;
         this.init();
      }
      
      private function clearBlock() : void
      {
         this._allowedKey = true;
         clearTimeout(this._timeoutId);
      }
      
      private function init() : void
      {
         var _loc2_:ActionsButtonPatinMC = null;
         var _loc3_:Object = null;
         this.instanceNames = new Array();
         this._buttons = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < 1)
         {
            _loc2_ = this["button" + _loc1_] as ActionsButtonPatinMC;
            _loc3_ = this.config[_loc1_];
            _loc2_.gotoAndStop("on");
            this._buttons.push(_loc2_);
            if(Boolean(_loc2_) && Boolean(_loc3_))
            {
               api.libraries.fetch(_loc3_.icon,this.onButtonFetch,_loc2_.ph);
            }
            _loc2_.buttonMode = true;
            _loc2_.mouseChildren = false;
            _loc2_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc1_++;
         }
         this._allowedKey = true;
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(this._allowedKey)
         {
            switch(param1.keyCode)
            {
               case Keyboard.NUMPAD_0:
                  this.keyBlocker();
                  this._kick();
                  break;
               case 48:
                  this.keyBlocker();
                  this._kick();
            }
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var button:ActionsButtonPatinMC = this.getButton(e.target as DisplayObject);
         var name:String = String(e.target.name);
         var index:int = this.getIndex(name);
         var action:String = String(this.config[index].action);
         var effect:String = String(this.config[index].effect);
         (e.target as MovieClip).gotoAndStop("over");
         if(action == "kick")
         {
            this._kick();
         }
         if(Boolean(this.config[index].isVip) && !api.user.isCitizen)
         {
            api.showBannerModal("pasaporte2");
         }
         else
         {
            this.avatar.attributes.action = action;
            if(this.config[index].soundFx)
            {
               api.playSound(this.config[index].soundFx);
            }
         }
         setTimeout(function():void
         {
            (e.target as MovieClip).gotoAndStop("on");
         },80);
      }
      
      private function onButtonFetch(param1:DisplayObject, param2:Object) : void
      {
         param2.addChild(param1);
         this.instanceNames.push(param1.name);
      }
      
      private function keyBlocker() : void
      {
         this._allowedKey = false;
         this._timeoutId = setTimeout(this.clearBlock,1000);
      }
      
      private function getIndex(param1:String) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._buttons.length)
         {
            if(param1 == this._buttons[_loc2_].name)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function dispose() : void
      {
         var _loc2_:ActionsButtonPatinMC = null;
         this.room = null;
         this.avatar = null;
         this.instanceNames = null;
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_) as ActionsButtonPatinMC;
            _loc2_.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc1_++;
         }
      }
      
      private function getButton(param1:DisplayObject) : ActionsButtonPatinMC
      {
         var _loc2_:DisplayObject = param1;
         while(Boolean(_loc2_) && _loc2_ is ActionsButtonPatinMC === false)
         {
            _loc2_ = _loc2_.parent;
         }
         return _loc2_ as ActionsButtonPatinMC;
      }
   }
}
