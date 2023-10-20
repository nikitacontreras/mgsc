package com.qb9.gaturro.view.gui.actions
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.combat.CombatGUIEvent;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class GatoonFightButtons extends MovieClip implements IDisposable
   {
       
      
      private var fireButton:MovieClip;
      
      private const MODEL:String = "combatGUI";
      
      private var tasks:TaskRunner;
      
      private var plasmaButton:MovieClip;
      
      private var avatar:UserAvatar;
      
      private var room:GaturroRoom;
      
      private var iceButton:MovieClip;
      
      private var bubbleButton:MovieClip;
      
      private var laserButton:MovieClip;
      
      private const ASSET_PACK:String = "gatoonsClothes.";
      
      private var asset:MovieClip;
      
      private var availableButtons:Array;
      
      private var gui:Gui;
      
      private var buttonList:Dictionary;
      
      public function GatoonFightButtons(param1:Gui, param2:GaturroRoom, param3:UserAvatar, param4:TaskRunner)
      {
         super();
         this.gui = param1;
         this.room = param2;
         this.avatar = param3;
         this.tasks = param4;
         this.setup();
      }
      
      private function disableAllButtons() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.asset.numChildren)
         {
            this.disableButton(this.asset.getChildAt(_loc1_) as MovieClip);
            _loc1_++;
         }
      }
      
      private function setup() : void
      {
         this.gui.dance_ph.addChild(this);
         x = -20;
         y = -25;
         gotoAndStop("glow");
         buttonMode = true;
         api.libraries.fetch(this.ASSET_PACK + this.MODEL,this.onModelFetch);
      }
      
      private function eventTypeByButton(param1:MovieClip) : String
      {
         switch(getQualifiedClassName(param1))
         {
            case "fireEmblem":
               return CombatGUIEvent.TYPE_FIRE;
            case "laserEmblem":
               return CombatGUIEvent.TYPE_LASER;
            case "iceEmblem":
               return CombatGUIEvent.TYPE_ICE;
            case "bubbleEmblem":
               return CombatGUIEvent.TYPE_BUBBLE;
            case "plasmaEmblem":
               return CombatGUIEvent.TYPE_PLASMA;
            default:
               return null;
         }
      }
      
      private function setupButtonList() : void
      {
         this.buttonList = new Dictionary();
         this.buttonList[this.asset.fire] = this.asset.fire;
         this.buttonList[this.asset.laser] = this.asset.laser;
         this.buttonList[this.asset.ice] = this.asset.ice;
         this.buttonList[this.asset.bubble] = this.asset.bubble;
         this.buttonList[this.asset.plasma] = this.asset.plasma;
      }
      
      private function enableButton(param1:MovieClip) : void
      {
         param1.filters = [];
         param1.buttonMode = true;
      }
      
      public function shakeButton(param1:String) : void
      {
         var _loc2_:MovieClip = this.asset[param1];
         var _loc3_:int = _loc2_.x;
         this.tasks.add(new Sequence(new Tween(_loc2_,150,{"x":_loc3_ - 5},{"transition":"easeIn"}),new Tween(_loc2_,150,{"x":_loc3_ + 5},{"transition":"easeIn"}),new Tween(_loc2_,150,{"x":_loc3_ - 5},{"transition":"easeIn"}),new Tween(_loc2_,150,{"x":_loc3_ + 5},{"transition":"easeIn"}),new Tween(_loc2_,150,{"x":_loc3_},{"transition":"easeIn"})));
      }
      
      private function onModelFetch(param1:DisplayObject) : void
      {
         this.asset = param1 as MovieClip;
         this.asset.fire.addEventListener(MouseEvent.CLICK,this.onEmblemClick);
         this.asset.laser.addEventListener(MouseEvent.CLICK,this.onEmblemClick);
         this.asset.ice.addEventListener(MouseEvent.CLICK,this.onEmblemClick);
         this.asset.bubble.addEventListener(MouseEvent.CLICK,this.onEmblemClick);
         this.asset.plasma.addEventListener(MouseEvent.CLICK,this.onEmblemClick);
         this.addChild(this.asset);
         this.setupButtonList();
         dispatchEvent(new CombatGUIEvent(CombatGUIEvent.GUI_READY));
      }
      
      public function dispose() : void
      {
         trace("GatoonFightButtons disposed");
         this.asset.fire.removeEventListener(MouseEvent.CLICK,this.onEmblemClick);
         this.asset.laser.removeEventListener(MouseEvent.CLICK,this.onEmblemClick);
         this.asset.ice.removeEventListener(MouseEvent.CLICK,this.onEmblemClick);
         this.asset.bubble.removeEventListener(MouseEvent.CLICK,this.onEmblemClick);
         this.asset.plasma.removeEventListener(MouseEvent.CLICK,this.onEmblemClick);
         this.gui = null;
         this.room = null;
         this.avatar = null;
         this.fireButton = null;
         this.laserButton = null;
         this.iceButton = null;
         this.bubbleButton = null;
         this.plasmaButton = null;
      }
      
      private function disableButton(param1:MovieClip) : void
      {
         if(this.buttonList[param1])
         {
            param1.filters = [new ColorMatrixFilter([0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0,0,0,1,0])];
            param1.buttonMode = false;
         }
      }
      
      private function isButtonAvailable(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.availableButtons.length)
         {
            if(param1 == this.availableButtons[_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function setAvailablePowers(param1:Array) : void
      {
         this.disableAllButtons();
         this.availableButtons = [];
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.enableButton(this.asset[param1[_loc2_]]);
            this.availableButtons.push(this.asset[param1[_loc2_]]);
            _loc2_++;
         }
      }
      
      private function onEmblemClick(param1:MouseEvent) : void
      {
         if(!this.isButtonAvailable(param1.target))
         {
            return;
         }
         var _loc2_:String = this.eventTypeByButton(param1.target as MovieClip);
         dispatchEvent(new CombatGUIEvent(CombatGUIEvent.GUI_PRESSED,_loc2_));
      }
   }
}
