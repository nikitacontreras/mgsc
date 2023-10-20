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
   
   public class TematicaBuilderCanvas extends FrameCanvas
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
      
      private var hint_btn:MovieClip;
      
      private var foot:PartSelector;
      
      private var action:MovieClip;
      
      private var hats:PartSelector;
      
      private var hintVisible:Boolean = true;
      
      private var close:SimpleButton;
      
      public function TematicaBuilderCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:VestidorTematicoBanner)
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
         setTimeout(api.setAvatarAttribute,400,"action","amazed");
         if((_owner as VestidorTematicoBanner).dresserGlobalEffect)
         {
            setTimeout(api.setAvatarAttribute,600,"effect",(_owner as VestidorTematicoBanner).dresserGlobalEffect);
         }
         setTimeout(this.dresser.dressUser,1450,this.bot.data as Object);
         this.removeListeners();
         _owner.close();
      }
      
      override public function dispose() : void
      {
         this.dresser.dispose();
         this.dresser = null;
         this.costumes = null;
         this.action = null;
         this.hint_btn = null;
         this.clean = null;
         this.task.dispose();
         this.task = null;
         if(this.hats)
         {
            this.hats.dispose();
            this.hats = null;
         }
         if(this.cloths)
         {
            this.cloths.dispose();
            this.cloths = null;
         }
         if(this.arms)
         {
            this.arms.dispose();
            this.arms = null;
         }
         if(this.legs)
         {
            this.legs.dispose();
            this.legs = null;
         }
         if(this.foot)
         {
            this.foot.dispose();
            this.foot = null;
         }
         this.bot = null;
         super.dispose();
      }
      
      private function onHint(param1:MouseEvent) : void
      {
         if(this.hint_btn.currentLabel == "on")
         {
            this.hint_btn.gotoAndStop("off");
            this.hintVisible = false;
         }
         else
         {
            this.hint_btn.gotoAndStop("on");
            this.hintVisible = true;
         }
         this.toggleHints();
      }
      
      override protected function setupShowView() : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         this.hats = new PartSelector("hats");
         this.hats.setupButton(view,this.setPage);
         this.cloths = new PartSelector("cloth");
         this.cloths.setupButton(view,this.setPage);
         this.arms = new PartSelector("arm");
         this.arms.setupButton(view,this.setPage);
         this.legs = new PartSelector("leg");
         this.legs.setupButton(view,this.setPage);
         this.foot = new PartSelector("foot");
         this.foot.setupButton(view,this.setPage);
         this.costumes = (owner as VestidorTematicoBanner).costumes;
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
                     case this.hats.part:
                        this.hats.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.cloths.part:
                        this.cloths.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.arms.part:
                        this.arms.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.legs.part:
                        this.legs.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.foot.part:
                        this.foot.parts.push(_loc2_[_loc3_]);
                        break;
                  }
                  _loc3_++;
               }
            }
            _loc1_++;
         }
         this.hats.randomize();
         this.cloths.randomize();
         this.arms.randomize();
         this.legs.randomize();
         this.foot.randomize();
         this.bot = view.getChildByName("bot") as MovieClip;
         this.action = view.getChildByName("action") as MovieClip;
         this.clean = view.getChildByName("clean") as SimpleButton;
         this.hint_btn = view.getChildByName("hint_btn") as MovieClip;
         this.addListeners();
         this.trySetPage_interval = setInterval(this.trySetPage,700);
         this.view.visible = true;
      }
      
      private function trySetPage() : void
      {
         if(disposed)
         {
            clearInterval(this.trySetPage_interval);
            return;
         }
         if((_owner as VestidorTematicoBanner).costumes.length > 0 || this.trySetPageCount > 5)
         {
            this.setPage();
            clearInterval(this.trySetPage_interval);
            return;
         }
         ++this.trySetPageCount;
      }
      
      private function setPage() : void
      {
         var _loc3_:Object = null;
         this.dresser.undress(this.bot);
         var _loc1_:Object = this.currentCostume;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.parts.length)
         {
            _loc3_ = _loc1_.parts[_loc2_];
            trace("{\"name\":\"" + _loc3_.name + "\",\"part\":\"" + _loc3_.part + "\",\"pack\":\"" + _loc3_.pack + "\"}");
            _loc2_++;
         }
         this.dresser.dress(this.bot,_loc1_);
         this.bot.buttonMode = true;
         this.bot.mouseChildren = true;
         this.bot.data = _loc1_;
      }
      
      private function removeListeners() : void
      {
         this.bot.removeEventListener(MouseEvent.CLICK,this.onBotClick);
         this.action.removeEventListener(MouseEvent.CLICK,this.onBotClick);
         this.clean.removeEventListener(MouseEvent.CLICK,this.onClean);
         this.hint_btn.removeEventListener(MouseEvent.CLICK,this.onHint);
      }
      
      private function addListeners() : void
      {
         this.bot.addEventListener(MouseEvent.CLICK,this.onBotClick);
         this.action.addEventListener(MouseEvent.CLICK,this.onBotClick);
         this.clean.addEventListener(MouseEvent.CLICK,this.onClean);
         this.hint_btn.addEventListener(MouseEvent.CLICK,this.onHint);
      }
      
      private function get currentCostume() : Object
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc1_:Object = {"parts":[this.hats.currentCostume,this.arms.currentCostume,this.legs.currentCostume,this.cloths.currentCostume,this.foot.currentCostume]};
         var _loc2_:Array = ["hairs","mouths","neck","accesories","armFore","armBack","glove","gloveFore","gloveBack","grip","gripFore","gripBack","customization"];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if((Boolean(_loc4_ = String(api.userAvatar.attributes[_loc2_[_loc3_]]))) && _loc4_ != " ")
            {
               trace("EL AVATAR TIENE avatarOtherParts[i]:" + _loc2_[_loc3_] + " VALOR: " + _loc4_);
               _loc5_ = String(String(_loc4_.split(".")[1]) || "");
               _loc6_ = String(String(_loc4_.split(".")[0]) || "");
               _loc7_ = {
                  "name":_loc5_,
                  "pack":_loc6_,
                  "part":_loc2_[_loc3_]
               };
               _loc1_.parts.push(_loc7_);
            }
            _loc3_++;
         }
         return _loc1_;
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
         VestidorTematicoBanner(_owner).close();
      }
      
      private function onClean(param1:MouseEvent) : void
      {
         this.hats.randomize();
         this.cloths.randomize();
         this.arms.randomize();
         this.legs.randomize();
         this.foot.randomize();
         this.setPage();
      }
      
      private function toggleHints() : void
      {
         var _loc1_:Array = ["txt_cloth","prev_cloth","next_cloth","next_foot","prev_foot","txt_foot","next_hats","prev_hats","txt_hats","next_arm","prev_arm","txt_arm","prev_leg","next_leg","txt_leg"];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            view.getChildByName(_loc1_[_loc2_]).visible = this.hintVisible;
            _loc2_++;
         }
      }
   }
}

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
      if(this.currentIndex >= this.parts.length)
      {
         this.currentIndex = 0;
      }
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
      this.setPage();
   }
   
   public function randomize() : void
   {
      this.currentIndex = int(this.parts.length * Math.random());
   }
   
   public function dispose() : void
   {
      this.part = null;
      this.data = null;
      this.parts = null;
      this.next = null;
      this.prev = null;
      this.setPage = null;
   }
}
