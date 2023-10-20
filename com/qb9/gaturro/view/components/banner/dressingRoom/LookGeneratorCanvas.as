package com.qb9.gaturro.view.components.banner.dressingRoom
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.world.avatars.AvatarDresser;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LookGeneratorCanvas extends FrameCanvas
   {
       
      
      private var task:TaskRunner;
      
      private var bot:MovieClip;
      
      private var costumes:Array;
      
      private var up:SimpleButton;
      
      private var parts:Array;
      
      private var down:SimpleButton;
      
      private var dresser:AvatarDresser;
      
      private var partIndex:int = 0;
      
      private var action:MovieClip;
      
      public function LookGeneratorCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:LookGeneratorBanner)
      {
         this.costumes = [];
         this.parts = [{"name":"hats"},{"name":"hairs"},{"name":"mouths"},{"name":"neck"},{"name":"accesories"},{"name":"cloth"},{"name":"leg"},{"name":"foot"},{"name":"arm"},{"name":"glove"},{"name":"grip"},{"name":"armFore"},{"name":"armBack"},{"name":"gloveFore"},{"name":"gloveBack"},{"name":"gripFore"},{"name":"gripBack"}];
         super(param1,param2,param3,param4);
         this.view.visible = false;
         this.task = new TaskRunner(this.view);
         this.task.start();
         this.dresser = new AvatarDresser();
      }
      
      private function onBotClick(param1:Event = null) : void
      {
         if(!api.user.isCitizen && param1.currentTarget.data && param1.currentTarget.data.vip == true)
         {
            api.showBannerModal("pasaporte2");
         }
         else
         {
            this.dresser.dressUser(param1.currentTarget.data as Object);
         }
         this.removeListeners();
         _owner.close();
      }
      
      private function randomizeAllParts() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.parts)
         {
            _loc1_.partSelector.randomize();
         }
      }
      
      private function setPage() : void
      {
         this.dresser.undress(this.bot);
         this.dresser.dress(this.bot,this.currentCostume);
         this.bot.buttonMode = true;
         this.bot.mouseChildren = true;
         this.bot.data = this.currentCostume;
      }
      
      private function onAccept(param1:MouseEvent) : void
      {
         this.onBotClick();
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         this.parts[this.partIndex].partSelector.deactivate();
         --this.partIndex;
         if(this.partIndex < 0)
         {
            this.partIndex = this.parts.length - 1;
         }
         this.parts[this.partIndex].partSelector.activate();
      }
      
      private function assignToPart(param1:Object) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.parts)
         {
            if(_loc2_.partSelector.part == param1.part)
            {
               _loc2_.partSelector.parts.push(param1);
               return;
            }
         }
      }
      
      private function addListeners() : void
      {
         this.bot.addEventListener(MouseEvent.CLICK,this.onBotClick);
         this.action.addEventListener(MouseEvent.CLICK,this.onAccept);
         this.up.addEventListener(MouseEvent.CLICK,this.onUp);
         this.down.addEventListener(MouseEvent.CLICK,this.onDown);
      }
      
      override protected function setupShowView() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         for each(_loc1_ in this.parts)
         {
            _loc1_.partSelector = new PartSelector(_loc1_.name);
            _loc1_.partSelector.setupButton(view,this.setPage);
            _loc1_.partSelector.posRef = this.getPositionReference(_loc1_.name);
            _loc1_.partSelector.nameIndicator = view.getChildByName("partName");
         }
         this.costumes = (owner as LookGeneratorBanner).costumes;
         _loc2_ = 1;
         while(_loc2_ < this.costumes.length)
         {
            if(this.costumes[_loc2_])
            {
               _loc3_ = this.costumes[_loc2_].parts;
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  this.assignToPart(_loc3_[_loc4_]);
                  _loc4_++;
               }
            }
            _loc2_++;
         }
         this.bot = view.getChildByName("bot") as MovieClip;
         this.action = view.getChildByName("action") as MovieClip;
         this.up = view.getChildByName("up") as SimpleButton;
         this.down = view.getChildByName("down") as SimpleButton;
         this.addListeners();
         _loc2_ = 0;
         while(_loc2_ < this.parts.length)
         {
            if(this.parts[_loc2_].partSelector.parts.length > 1)
            {
               this.parts.splice(_loc2_,1);
            }
            _loc2_++;
         }
         this.parts[this.partIndex].partSelector.activate();
         this.setPage();
         this.view.visible = true;
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         this.parts[this.partIndex].partSelector.deactivate();
         ++this.partIndex;
         if(this.partIndex >= this.parts.length - 1)
         {
            this.partIndex = 0;
         }
         this.parts[this.partIndex].partSelector.activate();
      }
      
      private function get currentCostume() : Object
      {
         var _loc2_:Object = null;
         var _loc1_:Object = {"parts":[]};
         for each(_loc2_ in this.parts)
         {
            _loc1_.parts.push(_loc2_.partSelector.currentCostume);
         }
         return _loc1_;
      }
      
      private function removeListeners() : void
      {
         this.bot.removeEventListener(MouseEvent.CLICK,this.onBotClick);
         this.action.removeEventListener(MouseEvent.CLICK,this.onAccept);
         this.up.removeEventListener(MouseEvent.CLICK,this.onUp);
         this.down.removeEventListener(MouseEvent.CLICK,this.onDown);
      }
      
      private function onClean(param1:MouseEvent) : void
      {
         this.randomizeAllParts();
         this.setPage();
      }
      
      private function getPositionReference(param1:String) : DisplayObject
      {
         var _loc2_:int = param1.indexOf("Fore");
         var _loc3_:int = param1.indexOf("Back");
         if(_loc2_ == -1 && _loc3_ == -1)
         {
            return view.getChildByName(param1);
         }
         return _loc2_ == -1 ? view.getChildByName(param1.substr(0,_loc3_)) : view.getChildByName(param1.substr(0,_loc2_));
      }
   }
}

import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

class PartSelector
{
    
   
   public var nameIndicator:TextField;
   
   public var hasItems:Boolean = false;
   
   public var part:String;
   
   private var active:Boolean;
   
   private var setPage:Function;
   
   private var currentIndex:int = 0;
   
   public var posRef:MovieClip;
   
   public var parts:Array;
   
   public var data:Object;
   
   public var prev:SimpleButton;
   
   public var next:SimpleButton;
   
   public function PartSelector(param1:String, param2:Object = null)
   {
      this.parts = new Array();
      super();
      this.part = param1;
      this.data = param2;
   }
   
   public function setupButton(param1:DisplayObjectContainer, param2:Function) : void
   {
      this.next = param1.getChildByName("next") as SimpleButton;
      this.prev = param1.getChildByName("prev") as SimpleButton;
      this.next.addEventListener(MouseEvent.CLICK,this.onNext);
      this.prev.addEventListener(MouseEvent.CLICK,this.onPrevious);
      this.setPage = param2;
   }
   
   public function activate() : void
   {
      this.next.y = this.posRef.y;
      this.prev.y = this.posRef.y;
      this.nameIndicator.text = this.part;
      this.active = true;
   }
   
   public function get currentCostume() : Object
   {
      return this.parts[this.currentIndex];
   }
   
   public function randomize() : void
   {
      this.currentIndex = int(this.parts.length * Math.random());
   }
   
   public function deactivate() : void
   {
      this.active = false;
   }
   
   public function onPrevious(param1:MouseEvent) : void
   {
      if(!this.active)
      {
         return;
      }
      --this.currentIndex;
      if(this.currentIndex < 0)
      {
         this.currentIndex = this.parts.length - 1;
      }
      this.setPage();
   }
   
   public function onNext(param1:MouseEvent) : void
   {
      if(!this.active)
      {
         return;
      }
      ++this.currentIndex;
      if(this.currentIndex >= this.parts.length - 1)
      {
         this.currentIndex = 0;
      }
      this.setPage();
   }
}
