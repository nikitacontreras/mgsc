package com.qb9.gaturro.view.components.banner.dressingRoom
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.flashlib.tasks.Wait;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.metrics.Telemetry;
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
   
   public class DressingBabosasCanvas extends FrameCanvas
   {
       
      
      private var next:SimpleButton;
      
      private var pages:int = 1;
      
      private var task:TaskRunner;
      
      private var medalButton:MovieClip;
      
      private var trySetPage_interval:int;
      
      private var costumes:Array;
      
      private var trySetPageCount:int = 0;
      
      private var bots:Array;
      
      private var dresser:AvatarDresser;
      
      private var currentPage:int = 0;
      
      private var action:MovieClip;
      
      private var prev:SimpleButton;
      
      public function DressingBabosasCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:Babosas2018Banner)
      {
         this.costumes = [];
         this.bots = [];
         super(param1,param2,param3,param4);
         this.task = new TaskRunner(this.view);
         this.task.start();
         this.dresser = new AvatarDresser();
      }
      
      private function onPrev(param1:MouseEvent) : void
      {
         this.currentPage = this.currentPage - 1 < 0 ? this.pages - 1 : this.currentPage - 1;
         this.hideBots();
      }
      
      private function onAccept(param1:MouseEvent) : void
      {
         Babosas2018Banner(_owner).close();
      }
      
      private function get isVillano() : Boolean
      {
         return (owner as Babosas2018Banner).dresserType == "villanos";
      }
      
      private function cleanBots() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this.bots)
         {
            this.dresser.undress(_loc1_);
            _loc1_.visible = false;
            _loc1_.data = null;
         }
      }
      
      private function setPage(param1:int) : void
      {
         this.cleanBots();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.bots.length)
         {
            if(this.costumes[param1 * 4 + _loc3_])
            {
               this.dresser.dress(this.bots[_loc2_],this.costumes[param1 * 4 + _loc3_]);
               this.bots[_loc2_].buttonMode = true;
               this.bots[_loc2_].mouseChildren = true;
               this.bots[_loc2_].data = this.costumes[param1 * 4 + _loc3_];
               _loc2_++;
            }
            _loc3_++;
         }
         this.showBots();
      }
      
      private function trySetPage() : void
      {
         if((_owner as Babosas2018Banner).costumes.length > 0 || this.trySetPageCount > 5)
         {
            this.setPage(this.currentPage);
            clearInterval(this.trySetPage_interval);
         }
         ++this.trySetPageCount;
      }
      
      private function addListeners() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this.bots)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.onClick);
         }
         this.action.addEventListener(MouseEvent.CLICK,this.onAccept);
         this.next.addEventListener(MouseEvent.CLICK,this.onNext);
         this.prev.addEventListener(MouseEvent.CLICK,this.onPrev);
         this.medalButton.addEventListener(MouseEvent.CLICK,this.onMedal);
      }
      
      override protected function setupShowView() : void
      {
         var _loc4_:MovieClip = null;
         this.view.visible = false;
         this.costumes = (owner as Babosas2018Banner).costumes.slice();
         var _loc1_:int = int(Math.random() * this.costumes.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.costumes.push(this.costumes.shift());
            _loc2_++;
         }
         this.pages = Math.ceil(this.costumes.length / 4);
         this.next = view.getChildByName("next") as SimpleButton;
         this.prev = view.getChildByName("prev") as SimpleButton;
         this.action = view.getChildByName("action") as MovieClip;
         this.medalButton = view.getChildByName("typeDresser") as MovieClip;
         if(this.isVillano)
         {
            (view.getChildByName("typeDresser") as MovieClip).gotoAndStop(2);
         }
         if(this.pages < 2)
         {
            this.next.visible = false;
            this.prev.visible = false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc4_ = view.getChildByName("bot_" + (_loc3_ + 1).toString()) as MovieClip;
            this.bots.push(_loc4_);
            _loc3_++;
         }
         this.addListeners();
         this.trySetPage_interval = setInterval(this.trySetPage,700);
         this.view.visible = true;
      }
      
      private function removeListeners() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this.bots)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onClick);
         }
         this.action.removeEventListener(MouseEvent.CLICK,this.onAccept);
         this.next.removeEventListener(MouseEvent.CLICK,this.onNext);
         this.prev.removeEventListener(MouseEvent.CLICK,this.onPrev);
         this.medalButton.removeEventListener(MouseEvent.CLICK,this.onMedal);
      }
      
      private function onMedal(param1:MouseEvent) : void
      {
         if(param1.target.name.indexOf("medal") != -1)
         {
            this.setMedal();
            this.onAccept(param1);
         }
      }
      
      private function showBots() : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Tween = null;
         var _loc5_:Wait = null;
         var _loc1_:Sequence = new Sequence();
         var _loc2_:Wait = new Wait(250);
         _loc1_.add(_loc2_);
         for each(_loc3_ in this.bots)
         {
            _loc3_.alpha = 0;
            _loc4_ = new Tween(_loc3_,125,{"alpha":1});
            _loc5_ = new Wait(25);
            _loc1_.add(_loc4_);
            _loc1_.add(_loc5_);
            if(_loc3_.data)
            {
               _loc3_.visible = true;
            }
         }
         this.task.add(_loc1_);
      }
      
      private function hideBots() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Tween = null;
         var _loc4_:Wait = null;
         var _loc1_:Sequence = new Sequence();
         for each(_loc2_ in this.bots)
         {
            _loc3_ = new Tween(_loc2_,125,{"alpha":0});
            _loc4_ = new Wait(25);
            _loc1_.add(_loc3_);
            _loc1_.add(_loc4_);
         }
         _loc1_.addEventListener(TaskEvent.COMPLETE,this.showNextPage);
         this.task.add(_loc1_);
      }
      
      private function onClick(param1:Event) : void
      {
         Telemetry.getInstance().trackEvent("FEATURES:BABOSAS2018:VESTIDOR:TRAJE" + (owner as Babosas2018Banner).options,param1.currentTarget.name);
         setTimeout(api.setAvatarAttribute,400,"action","amazed");
         setTimeout(this.dresser.dressUser,1450,param1.currentTarget.data as Object);
         this.setMedal();
         this.removeListeners();
         _owner.close();
      }
      
      private function onNext(param1:MouseEvent) : void
      {
         this.currentPage = (this.currentPage + 1) % this.pages;
         this.hideBots();
      }
      
      private function setMedal() : void
      {
         if(this.isVillano)
         {
            api.trackEvent("FEATURES:BABOSAS2018:VESTIDOR:MEDAL","villano");
            api.setAvatarAttribute("medal","villano");
         }
         else
         {
            api.trackEvent("FEATURES:BABOSAS2018:VESTIDOR:MEDAL","heroe");
            api.setAvatarAttribute("medal","heroe");
         }
         api.setAvatarAttribute("effect"," ");
      }
      
      private function showNextPage(param1:Event) : void
      {
         this.setPage(this.currentPage);
         logger.debug(this,"page: ",this.currentPage,"/" + this.pages);
      }
   }
}
