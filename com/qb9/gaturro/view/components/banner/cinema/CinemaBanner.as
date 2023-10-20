package com.qb9.gaturro.view.components.banner.cinema
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.NavigatorEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.cinema.CinemaManager;
   import com.qb9.gaturro.model.config.cinema.CinemaMovieDefinition;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasOptions;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import fl.video.FLVPlayback;
   import fl.video.VideoEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   
   public class CinemaBanner extends InstantiableGuiModal implements IHasOptions, IHasData
   {
       
      
      private var container:Sprite;
      
      private var currentVideo:CinemaMovieDefinition;
      
      private var gate:String;
      
      private var viewAsset:DisplayObjectContainer;
      
      private var fullScreen:Boolean;
      
      private var flvPlayback:FLVPlayback;
      
      private var optionsReady:Boolean;
      
      private var manager:CinemaManager;
      
      private var data_Ready:Boolean;
      
      private var button:DisplayObjectContainer;
      
      private var exitButton:Sprite;
      
      private var ph:DisplayObjectContainer;
      
      public function CinemaBanner()
      {
         super("CinemaBanner","CinemaBannerAsset");
      }
      
      public function set options(param1:String) : void
      {
         this.gate = param1;
         this.optionsReady = true;
         this.checkSetup();
      }
      
      private function click(param1:MouseEvent) : void
      {
         this.changeVideo();
         this.flvPlayback.skinBackgroundColor = 0;
         this.flvPlayback.skinBackgroundAlpha = 1;
         this.button.visible = false;
      }
      
      override protected function setupCloseButton() : void
      {
      }
      
      private function setupViewAsset() : void
      {
         this.viewAsset = getInstanceByName("ViewerAsset") as DisplayObjectContainer;
         this.ph.addChild(this.viewAsset);
      }
      
      private function setupButton() : void
      {
         this.button = this.viewAsset.getChildByName("button") as DisplayObjectContainer;
         this.button.alpha = 0.6;
         this.button.addEventListener(MouseEvent.CLICK,this.click);
         this.button.addEventListener(MouseEvent.ROLL_OVER,this.over);
         this.button.addEventListener(MouseEvent.ROLL_OUT,this.out);
         var _loc1_:TextField = this.button.getChildByName("label") as TextField;
         _loc1_.text = api.getText("VER");
      }
      
      private function setupView() : void
      {
         this.setupHolders();
         this.setupPlayBack();
         this.setupButton();
         this.setupExitButton();
         if(this.fullScreen)
         {
            this.setFullScreen();
         }
      }
      
      private function checkSetup() : void
      {
         if(this.optionsReady && this.data_Ready)
         {
            this.setup();
         }
      }
      
      private function setupPlayBack() : void
      {
         this.flvPlayback = new FLVPlayback();
         this.flvPlayback.skin = makeFinalURL("SkinUnderPlayStopSeekMuteVol");
         var _loc1_:DisplayObjectContainer = this.viewAsset.getChildByName("ph") as DisplayObjectContainer;
         _loc1_.addChild(this.flvPlayback);
         this.flvPlayback.visible = false;
         this.flvPlayback.addEventListener(VideoEvent.STATE_CHANGE,this.onStateChanged);
      }
      
      private function setupHolders() : void
      {
         view.getChildByName("banner").visible = false;
         this.ph = view.getChildByName("ph") as DisplayObjectContainer;
         this.setupViewAsset();
      }
      
      public function set data(param1:Object) : void
      {
         this.fullScreen = param1;
         this.data_Ready = true;
         this.checkSetup();
      }
      
      override public function dispose() : void
      {
         this.button.removeEventListener(MouseEvent.CLICK,this.click);
         this.button.removeEventListener(MouseEvent.ROLL_OVER,this.over);
         this.button.removeEventListener(MouseEvent.ROLL_OUT,this.out);
         this.flvPlayback.removeEventListener(VideoEvent.STATE_CHANGE,this.onStateChanged);
         this.exitButton.removeEventListener(MouseEvent.CLICK,this.onClickExit);
         super.dispose();
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupView();
      }
      
      private function onClickExit(param1:MouseEvent) : void
      {
         this.close();
      }
      
      private function over(param1:MouseEvent) : void
      {
         this.ph.filters = [new GlowFilter(16776960)];
         this.button.alpha = 1;
      }
      
      private function onStateChanged(param1:VideoEvent) : void
      {
         trace("CinemaBanner > onStateChanged > e.state = [" + param1.state + "]");
      }
      
      private function setupExitButton() : void
      {
         this.exitButton = view.getChildByName("exit") as Sprite;
         this.exitButton.addEventListener(MouseEvent.CLICK,this.onClickExit);
         var _loc1_:TextField = this.exitButton.getChildByName("label") as TextField;
         _loc1_.text = api.getText("SALIR");
      }
      
      private function setFullScreen() : void
      {
         view.addChild(this.ph);
         this.ph.x -= 180;
         this.ph.y -= 70;
         this.ph.scaleY = 1.7;
         this.ph.scaleX = 1.7;
         view.addChild(this.exitButton);
         this.exitButton.x = 665;
         this.exitButton.y = 434;
         this.click(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function changeVideo() : void
      {
         this.flvPlayback.visible = true;
         this.flvPlayback.source = this.currentVideo.url;
         this.flvPlayback.play();
      }
      
      private function out(param1:MouseEvent) : void
      {
         this.ph.filters = [];
         this.button.alpha = 0.6;
      }
      
      private function setup() : void
      {
         this.manager = Context.instance.getByType(CinemaManager) as CinemaManager;
         this.currentVideo = this.manager.getDefinition(this.gate);
      }
      
      private function onChanged(param1:NavigatorEvent) : void
      {
         this.currentVideo = param1.current as CinemaMovieDefinition;
      }
      
      override public function close() : void
      {
         this.flvPlayback.stop();
         super.close();
      }
   }
}
