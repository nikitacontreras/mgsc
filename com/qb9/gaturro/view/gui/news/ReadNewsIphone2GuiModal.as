package com.qb9.gaturro.view.gui.news
{
   import assets.Iphone2NewsMC;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.view.gui.iphone2.GuiIPhone2Button;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.view.gui.iphone2.screens.BaseIPhone2Screen;
   import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2Screens;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public final class ReadNewsIphone2GuiModal extends BaseIPhone2Screen
   {
      
      private static const BASE:String = "content/";
      
      private static const URI:String = "news/";
       
      
      private var celButton:GuiIPhone2Button;
      
      private var closeTime:Number;
      
      private var factory:com.qb9.gaturro.view.gui.news.NewsPageFactory;
      
      private var suffix:String;
      
      private var loader:Loader;
      
      private var openTime:Number;
      
      private var openInPage:String;
      
      public function ReadNewsIphone2GuiModal(param1:IPhone2Modal, param2:GuiIPhone2Button)
      {
         super(param1,new Iphone2NewsMC(),{});
         this.openTime = api.serverTime;
         this.celButton = param2;
         this.suffix = this.profile.newsRevision;
         this.factory = new com.qb9.gaturro.view.gui.news.NewsPageFactory(api.country);
         this.factory.addEventListener(com.qb9.gaturro.view.gui.news.NewsPageFactory.ALL_NEWS_READY,this.onAllReady);
         this.openInPage = api.getSession(com.qb9.gaturro.view.gui.news.NewsPageFactory.NEWS_PROFILE_KEY) as String;
         this.init();
      }
      
      private function onBackToMenu(param1:MouseEvent) : void
      {
         back(IPhone2Screens.MENU);
      }
      
      private function onAllReady(param1:Event) : void
      {
         this.setupPage();
         this.factory.removeEventListener(com.qb9.gaturro.view.gui.news.NewsPageFactory.ALL_NEWS_READY,this.onAllReady);
      }
      
      private function get profile() : GaturroProfile
      {
         return user.profile as GaturroProfile;
      }
      
      private function setupPage() : void
      {
         if(this.openInPage != "")
         {
            this.factory.setCurrentPageByKey(this.openInPage);
            this.openInPage = "";
            api.setSession(com.qb9.gaturro.view.gui.news.NewsPageFactory.NEWS_PROFILE_KEY,"");
         }
         var _loc1_:int = 0;
         while(_loc1_ < asset.ph.numChildren)
         {
            asset.ph.removeChildAt(_loc1_);
            _loc1_++;
         }
         asset.ph.addChild(this.factory.currentPage);
         asset.long_text.text = api.getText(this.factory.currentConfig.long_text);
         asset.corner_text.text = api.getText(this.factory.currentConfig.corner_text);
         asset.goToRoom.visible = this.factory.currentConfig.room != 0 || this.factory.currentConfig.banner || this.factory.currentConfig.instanceBanner;
      }
      
      private function init() : void
      {
         if(!this.profile.hasReadNews)
         {
            this.profile.readNews();
            this.celButton.updateNewsIcon();
         }
         asset.goToRoom.addEventListener(MouseEvent.CLICK,this.onGoToRoom);
         asset.backToMenu.addEventListener(MouseEvent.CLICK,this.onBackToMenu);
         asset.arrows.left.addEventListener(MouseEvent.CLICK,this.onLeftPage);
         asset.arrows.right.addEventListener(MouseEvent.CLICK,this.onRightPage);
         setTimeout(function():void
         {
            onRightPage(null);
            onLeftPage(null);
         },600);
      }
      
      private function onLeftPage(param1:MouseEvent) : void
      {
         this.factory.previousPage();
         this.setupPage();
      }
      
      private function onRightPage(param1:MouseEvent) : void
      {
         this.factory.nextPage();
         this.setupPage();
      }
      
      private function onGoToRoom(param1:MouseEvent) : void
      {
         if(this.factory.currentConfig.banner)
         {
            api.showBannerModal(this.factory.currentConfig.banner);
         }
         else if(this.factory.currentConfig.instanceBanner)
         {
            api.instantiateBannerModal(this.factory.currentConfig.instanceBanner);
         }
         else
         {
            api.changeRoomXY(this.factory.currentConfig.room,this.factory.currentConfig.gotoX,this.factory.currentConfig.gotoY);
         }
      }
      
      override public function dispose() : void
      {
         this.closeTime = api.serverTime;
         api.trackEvent("NOVEDAD:OPEN_TIME",(this.closeTime - this.openTime).toString());
         asset.goToRoom.removeEventListener(MouseEvent.CLICK,this.onGoToRoom);
         asset.backToMenu.removeEventListener(MouseEvent.CLICK,this.onBackToMenu);
         asset.arrows.left.removeEventListener(MouseEvent.CLICK,this.onLeftPage);
         asset.arrows.right.removeEventListener(MouseEvent.CLICK,this.onRightPage);
         this.factory.removeEventListener(com.qb9.gaturro.view.gui.news.NewsPageFactory.FIRST_NEWS_READY,this.onAllReady);
         this.factory.dispose();
      }
   }
}
