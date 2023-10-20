package com.qb9.gaturro.view.components.banner.dressingRoom
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.globals.api;
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
   
   public class LooksColegioCanvas extends FrameCanvas
   {
       
      
      private var task:TaskRunner;
      
      private var bot:MovieClip;
      
      private var clean:SimpleButton;
      
      private var costumes:Array;
      
      private var trySetPage_interval:int;
      
      private var trySetPageCount:int = 0;
      
      private var dresser:AvatarDresser;
      
      private var action:MovieClip;
      
      public function LooksColegioCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:LooksColegioBanner)
      {
         this.costumes = [];
         super(param1,param2,param3,param4);
      }
      
      private function onBotClick(param1:Event) : void
      {
         if(!api.user.isCitizen && Boolean(this.currentCostume.vip))
         {
            api.setAvatarAttribute("action","sad");
            api.showBannerModal("pasaporte2");
            api.trackEvent("Experiments:LooksColegioBanner","opens");
         }
         else
         {
            setTimeout(api.setAvatarAttribute,400,"action","amazed");
            setTimeout(this.dresser.dressUser,1450,this.bot.data as Object);
         }
         this.removeListeners();
         _owner.close();
      }
      
      private function setPage() : void
      {
         this.dresser.undress(this.bot);
         api.info(this,"currentCostume",this.currentCostume);
         var _loc1_:int = 0;
         while(_loc1_ < this.currentCostume.parts.length)
         {
            api.info(this,"currentCostume",this.currentCostume.parts[_loc1_].name);
            _loc1_++;
         }
         this.dresser.dress(this.bot,this.currentCostume);
         var _loc2_:Tween = new Tween(view,400,{"alpha":1});
         this.task.add(_loc2_);
         this.bot.buttonMode = true;
         this.bot.mouseChildren = true;
         this.bot.data = this.currentCostume;
      }
      
      private function trySetPage() : void
      {
         if((_owner as LooksColegioBanner).costumes.length > 0 || this.trySetPageCount > 5)
         {
            this.setPage();
            clearInterval(this.trySetPage_interval);
            return;
         }
         ++this.trySetPageCount;
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
      }
      
      override protected function setupShowView() : void
      {
         this.bot = view.getChildByName("bot") as MovieClip;
         view.visible = true;
         view.alpha = 0;
         this.task = (owner as LooksColegioBanner).taskRunner;
         this.dresser = (owner as LooksColegioBanner).dresser;
         var _loc1_:int = 0;
         while(_loc1_ < (owner as LooksColegioBanner).partSelector.length)
         {
            (owner as LooksColegioBanner).partSelector[_loc1_].setupButton(view,this.setPage);
            _loc1_++;
         }
         this.action = view.getChildByName("action") as MovieClip;
         this.action.field.text = "ACEPTAR";
         this.clean = view.getChildByName("clean") as SimpleButton;
         this.addListeners();
         this.trySetPage_interval = setInterval(this.trySetPage,700);
      }
      
      private function get currentCostume() : Object
      {
         return (owner as LooksColegioBanner).currentCostume;
      }
      
      private function onAccept(param1:MouseEvent) : void
      {
         LooksColegioBanner(_owner).close();
      }
      
      private function onClean(param1:MouseEvent) : void
      {
         (owner as LooksColegioBanner).randomizeAll();
         this.setPage();
      }
   }
}
