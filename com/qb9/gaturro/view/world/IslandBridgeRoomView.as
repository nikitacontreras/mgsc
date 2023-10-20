package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   
   public class IslandBridgeRoomView extends GaturroRoomView
   {
       
      
      private var gaturroMask:MovieClip;
      
      private var tiburonBack:MovieClip;
      
      private var tiburonMask:MovieClip;
      
      private var someAssetOnGaturro:MovieClip;
      
      private var someAsset:MovieClip;
      
      private var tiburonFront:MovieClip;
      
      private var backgroundMask:MovieClip;
      
      public function IslandBridgeRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
      }
      
      private function get layer2() : MovieClip
      {
         return (background as MovieClip)["layer2"];
      }
      
      private function get layer3() : MovieClip
      {
         return (background as MovieClip)["layer3"];
      }
      
      private function get layer1() : MovieClip
      {
         return (background as MovieClip)["layer1"];
      }
      
      private function onAsset(param1:DisplayObject) : void
      {
         this.someAsset = param1 as MovieClip;
         this.someAsset.gotoAndStop(2);
      }
      
      private function onSomeAssetOnGaturro(param1:DisplayObject) : void
      {
         this.someAssetOnGaturro = param1 as MovieClip;
         this.someAssetOnGaturro.gotoAndStop(2);
         api.userView.clip.addChild(this.someAssetOnGaturro);
      }
      
      private function onGaturroMask(param1:DisplayObject) : void
      {
         this.gaturroMask = param1 as MovieClip;
         api.userView.clip.addChild(this.gaturroMask);
         api.userView.clip.mask = this.gaturroMask;
         this.gaturroMask.scaleY = 2;
         this.gaturroMask.scaleX = 2;
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         api.libraries.fetch("pascuas2018/props.huevo10",this.onAsset);
         api.libraries.fetch("pascuas2018/props.huevo12",this.onSomeAssetOnGaturro);
         api.libraries.fetch("pascuas2018/props.huevoChocoDeluxe",this.onGaturroMask);
         api.libraries.fetch("pascuas2018/props.bgMask",this.onBackgroundMask);
      }
      
      private function onEnterKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:Sequence = new Sequence();
         _loc2_.add(new Func(api.swimmingUserView.addChildAt,this.tiburonBack,0));
         _loc2_.add(new Func(api.swimmingUserView.addChild,this.tiburonFront));
         _loc2_.add(new Func(this.tiburonFront.gotoAndPlay,2));
         _loc2_.add(new Func(this.tiburonBack.gotoAndPlay,2));
         _loc2_.add(new Func(this.tiburonMask.gotoAndPlay,2));
         tasks.add(_loc2_);
      }
      
      override public function dispose() : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onEnterKeyDown);
         super.dispose();
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         return super.createAvatar(param1);
      }
      
      private function onBackgroundMask(param1:DisplayObject) : void
      {
         this.backgroundMask = param1 as MovieClip;
         addChild(this.backgroundMask);
         mask = this.backgroundMask;
         this.backgroundMask.gotoAndPlay(2);
      }
   }
}
