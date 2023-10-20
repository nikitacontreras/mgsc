package com.qb9.gaturro.view.components.banner.dressingRoom
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.tutorial.TutorialManager;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.world.avatars.AvatarDresser;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class DressingBuildCanvas extends FrameCanvas
   {
       
      
      private var task:TaskRunner;
      
      private var bot:MovieClip;
      
      private var clean:SimpleButton;
      
      private var costumes:Array;
      
      private var trySetPage_interval:int;
      
      private var arms:PartSelector;
      
      private var cloths:PartSelector;
      
      private var trySetPageCount:int = 0;
      
      private var dresser:AvatarDresser;
      
      private var legs:PartSelector;
      
      private var action:MovieClip;
      
      private var close:SimpleButton;
      
      private var hats:PartSelector;
      
      public function DressingBuildCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:WearBuilderBanner)
      {
         this.costumes = [];
         super(param1,param2,param3,param4);
         this.task = new TaskRunner(this.view);
         this.task.start();
         this.dresser = new AvatarDresser();
         api.info(this,"constructor");
         api.setAvatarAttribute("action","dance");
      }
      
      private function onBotClick(param1:Event) : void
      {
         if(!api.user.isCitizen && !TutorialManager.isInProgress())
         {
            api.showBannerModal("pasaporte2");
            api.trackEvent("Experiments:wearBuilder","opens");
         }
         else
         {
            setTimeout(api.setAvatarAttribute,400,"action","amazed");
            setTimeout(this.dresser.dressUser,1450,this.bot.data as Object);
         }
         this.removeListeners();
         _owner.close();
      }
      
      private function trySetPage() : void
      {
         if((_owner as WearBuilderBanner).costumes.length > 0 || this.trySetPageCount > 5)
         {
            this.setPage();
            clearInterval(this.trySetPage_interval);
            return;
         }
         ++this.trySetPageCount;
      }
      
      private function setPage() : void
      {
         var _loc2_:Object = null;
         api.info(this,"setPage_1");
         this.dresser.undress(this.bot);
         var _loc1_:int = 0;
         while(_loc1_ < this.currentCostume.parts.length)
         {
            _loc2_ = this.currentCostume.parts[_loc1_];
            trace("{\"name\":\"" + _loc2_.name + "\",\"part\":\"" + _loc2_.part + "\",\"pack\":\"" + _loc2_.pack + "\"}");
            _loc1_++;
         }
         this.dresser.dress(this.bot,this.currentCostume);
         this.bot.buttonMode = true;
         this.bot.mouseChildren = true;
         this.bot.data = this.currentCostume;
      }
      
      private function removeListeners() : void
      {
         this.bot.removeEventListener(MouseEvent.CLICK,this.onBotClick);
         this.action.removeEventListener(MouseEvent.CLICK,this.onBotClick);
         this.clean.removeEventListener(MouseEvent.CLICK,this.onClean);
      }
      
      private function addListeners() : void
      {
         this.bot.addEventListener(MouseEvent.CLICK,this.onBotClick);
         this.action.addEventListener(MouseEvent.CLICK,this.onBotClick);
         this.clean.addEventListener(MouseEvent.CLICK,this.onClean);
         this.close.addEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      override protected function setupShowView() : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         this.arms = new PartSelector("arm");
         this.arms.setupButton(view,this.setPage);
         this.legs = new PartSelector("leg");
         this.legs.setupButton(view,this.setPage);
         this.cloths = new PartSelector("cloth");
         this.cloths.setupButton(view,this.setPage);
         this.hats = new PartSelector("mouths");
         this.hats.setupButton(view,this.setPage);
         this.costumes = (owner as WearBuilderBanner).costumes;
         var _loc1_:int = 1;
         while(_loc1_ < this.costumes.length)
         {
            if(this.costumes[_loc1_])
            {
               _loc2_ = this.costumes[_loc1_].parts;
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  switch(_loc2_[_loc3_].part)
                  {
                     case this.arms.part:
                        this.arms.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.legs.part:
                        this.legs.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.cloths.part:
                        this.cloths.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.hats.part:
                        this.hats.parts.push(_loc2_[_loc3_]);
                        break;
                  }
                  _loc3_++;
               }
            }
            _loc1_++;
         }
         this.arms.randomize();
         this.legs.randomize();
         this.cloths.randomize();
         this.hats.randomize();
         this.bot = view.getChildByName("bot") as MovieClip;
         this.action = view.getChildByName("action") as MovieClip;
         this.action.field.text = "ACEPTAR";
         this.clean = view.getChildByName("clean") as SimpleButton;
         this.close = view.getChildByName("close") as SimpleButton;
         this.addListeners();
         this.trySetPage_interval = setInterval(this.trySetPage,700);
         this.view.visible = true;
      }
      
      private function get currentCostume() : Object
      {
         return {"parts":[this.arms.currentCostume,this.legs.currentCostume,this.cloths.currentCostume,this.hats.currentCostume]};
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         if(TutorialManager.isInProgress())
         {
            this.onBotClick(param1);
         }
         else
         {
            _owner.close();
         }
      }
      
      private function onAccept(param1:MouseEvent) : void
      {
         WearBuilderBanner(_owner).close();
      }
      
      private function onClean(param1:MouseEvent) : void
      {
         this.arms.randomize();
         this.legs.randomize();
         this.cloths.randomize();
         this.hats.randomize();
         trace("======================================");
         trace(this.arms.currentCostume.name);
         trace(this.legs.currentCostume.name);
         trace(this.cloths.currentCostume.name);
         trace(this.hats.currentCostume.name);
         this.setPage();
      }
   }
}

import com.qb9.gaturro.globals.api;
import flash.display.DisplayObjectContainer;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

class PartSelector
{
    
   
   public var parts:Array;
   
   public var data:Object;
   
   public var prev:SimpleButton;
   
   private var setPage:Function;
   
   public var next:SimpleButton;
   
   private var currentIndex:int = 0;
   
   public var part:String;
   
   public function PartSelector(param1:String, param2:Object = null)
   {
      this.parts = new Array();
      super();
      this.part = param1;
      this.data = param2;
   }
   
   public function onNext(param1:MouseEvent) : void
   {
      ++this.currentIndex;
      if(this.currentIndex >= this.parts.length - 1)
      {
         this.currentIndex = 0;
      }
      api.info("VESTIDOR GATOONS " + this.part + "- INDEX: " + this.currentIndex);
      this.setPage();
   }
   
   public function get currentCostume() : Object
   {
      return this.parts[this.currentIndex];
   }
   
   public function setupButton(param1:DisplayObjectContainer, param2:Function) : void
   {
      this.next = param1.getChildByName("next_" + this.part) as SimpleButton;
      this.prev = param1.getChildByName("prev_" + this.part) as SimpleButton;
      this.next.addEventListener(MouseEvent.CLICK,this.onNext);
      this.prev.addEventListener(MouseEvent.CLICK,this.onPrevious);
      this.setPage = param2;
   }
   
   public function onPrevious(param1:MouseEvent) : void
   {
      --this.currentIndex;
      if(this.currentIndex < 0)
      {
         this.currentIndex = this.parts.length - 1;
      }
      api.info("VESTIDOR GATOONS " + this.part + "- INDEX: " + this.currentIndex);
      this.setPage();
   }
   
   public function randomize() : void
   {
      this.currentIndex = int(this.parts.length * Math.random());
      api.info(this.part + " index: " + this.currentIndex + " L: " + this.parts.length);
   }
}
