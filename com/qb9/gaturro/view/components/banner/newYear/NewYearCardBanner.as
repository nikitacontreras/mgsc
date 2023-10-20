package com.qb9.gaturro.view.components.banner.newYear
{
   import com.qb9.gaturro.commons.view.component.canvas.switcher.FrameCanvasSwitcher;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   public class NewYearCardBanner extends InstantiableGuiModal implements IHasRoomAPI
   {
      
      public static const EXPLANATION:String = "explanation";
      
      public static const ELEMNT_SELECTOR:String = "ELEMNT_SELECTOR";
      
      public static const CARD_SHOWCASE:String = "CARD_SHOWCASE";
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var closeBtn:SimpleButton;
      
      private var canvasSwitcher:FrameCanvasSwitcher;
      
      public function NewYearCardBanner()
      {
         super("NewYearCardBanner","NewYearCardBannerAsset");
      }
      
      public function start() : void
      {
         this.canvasSwitcher.switchCanvas(ELEMNT_SELECTOR);
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupCanvas();
      }
      
      override public function dispose() : void
      {
         this.canvasSwitcher.dispose();
         this.canvasSwitcher = null;
         super.dispose();
      }
      
      public function toShowcase(param1:Array) : void
      {
         this.canvasSwitcher.switchCanvas(CARD_SHOWCASE,param1);
      }
      
      private function setupCanvas() : void
      {
         var _loc1_:MovieClip = view.getChildByName("canvasContainer") as MovieClip;
         this.canvasSwitcher = new FrameCanvasSwitcher(_loc1_);
         this.canvasSwitcher.addCanvas(new ElementSelectorCanvas(ELEMNT_SELECTOR,"selector",_loc1_,this));
         this.canvasSwitcher.addCanvas(new CardShowcaseCanvas(CARD_SHOWCASE,"showcase",_loc1_,this));
         this.canvasSwitcher.addCanvas(new ExplanationCanvas(EXPLANATION,"explanation",_loc1_,this));
         this.canvasSwitcher.switchCanvas(EXPLANATION);
      }
      
      public function toSelector() : void
      {
         this.canvasSwitcher.switchCanvas(ELEMNT_SELECTOR);
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
   }
}

import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.util.StubAttributeHolder;
import com.qb9.gaturro.view.components.banner.newYear.NewYearCardBanner;
import com.qb9.gaturro.view.components.banner.newYear.NewYearCardRepeater;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import com.qb9.gaturro.view.world.avatars.Gaturro;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

class ElementSelectorCanvas extends FrameCanvas
{
   
   private static const REPEATER_SET_CONTAINER_NAME:String = "repeaterSetContainer";
   
   private static const REPEATER_CONTAINER_PREFIX:String = "repeaterContainer_";
    
   
   private var gaturroHolder:Sprite;
   
   private var repeaterList:Array;
   
   private var repeaterSetContainer:DisplayObjectContainer;
   
   private var elemntList:Array;
   
   private var toShowcaseBtn:Sprite;
   
   private var gaturro:Gaturro;
   
   public function ElementSelectorCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
   {
      this.elemntList = new Array("goblinSuit_head","goblinSuit_cloth","goblinSuit_leg","goblinSuit_foot");
      super(param1,param2,param3,param4);
   }
   
   override public function dispose() : void
   {
      var _loc1_:NewYearCardRepeater = null;
      for each(_loc1_ in this.repeaterList)
      {
         _loc1_.dispose();
      }
      _loc1_ = null;
      if(this.toShowcaseBtn)
      {
         this.toShowcaseBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      super.dispose();
   }
   
   private function onClick(param1:MouseEvent) : void
   {
      var _loc3_:int = 0;
      var _loc4_:NewYearCardRepeater = null;
      var _loc2_:Array = new Array();
      for each(_loc4_ in this.repeaterList)
      {
         _loc3_ = int(_loc4_.currentItem);
         _loc2_.push(_loc3_);
      }
      NewYearCardBanner(owner).toShowcase(_loc2_);
   }
   
   private function setupButton() : void
   {
      this.toShowcaseBtn = view.getChildByName("toShowcaseBtn") as Sprite;
      this.toShowcaseBtn.addEventListener(MouseEvent.CLICK,this.onClick);
      var _loc1_:TextField = this.toShowcaseBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("¡BUENO!");
   }
   
   private function setupGaturro() : void
   {
      this.gaturroHolder = this.repeaterSetContainer.getChildByName("gaturroHolder") as Sprite;
      var _loc1_:StubAttributeHolder = StubAttributeHolder.fromHolder(api.userAvatar);
      _loc1_.attributes.transport = "";
      this.gaturro = new Gaturro(_loc1_);
      this.gaturroHolder.addChild(this.gaturro);
      this.gaturro.scaleY = 2;
      this.gaturro.scaleX = 2;
   }
   
   private function setupCatalogs() : void
   {
      var _loc1_:NewYearCardRepeater = null;
      var _loc2_:MovieClip = null;
      var _loc3_:String = null;
      this.repeaterList = new Array();
      var _loc4_:int = 0;
      while(_loc4_ < 3)
      {
         _loc3_ = String(REPEATER_CONTAINER_PREFIX + _loc4_);
         _loc2_ = this.repeaterSetContainer.getChildByName(_loc3_) as MovieClip;
         _loc1_ = new NewYearCardRepeater(owner as NewYearCardBanner,_loc2_);
         this.repeaterList.push(_loc1_);
         _loc1_.setupEditor();
         _loc4_++;
      }
   }
   
   override protected function setupShowView() : void
   {
      this.repeaterSetContainer = view.getChildByName(REPEATER_SET_CONTAINER_NAME) as DisplayObjectContainer;
      this.setupButton();
      this.setupCatalogs();
      this.setupGaturro();
   }
}

import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.view.components.banner.newYear.NewYearCardBanner;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import com.qb9.gaturro.view.world.avatars.Gaturro;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

class ExplanationCanvas extends FrameCanvas
{
    
   
   private var gaturro:Gaturro;
   
   private var retrytBtn:Sprite;
   
   private var acceptBtn:Sprite;
   
   public function ExplanationCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
   {
      super(param1,param2,param3,param4);
   }
   
   private function onClickAccept(param1:MouseEvent) : void
   {
      NewYearCardBanner(owner).start();
   }
   
   override protected function setupShowView() : void
   {
      this.setupButton();
   }
   
   override public function dispose() : void
   {
      if(this.acceptBtn)
      {
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
      }
      super.dispose();
   }
   
   private function setupButton() : void
   {
      this.acceptBtn = view.getChildByName("acceptBtn") as Sprite;
      this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onClickAccept);
      var _loc1_:TextField = this.acceptBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("LISTO");
   }
}

import com.qb9.gaturro.commons.view.image.ImageCapture;
import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.util.StubAttributeHolder;
import com.qb9.gaturro.view.components.banner.newYear.NewYearCardBanner;
import com.qb9.gaturro.view.components.banner.newYear.NewYearCardRepeater;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import com.qb9.gaturro.view.world.avatars.Gaturro;
import flash.display.Bitmap;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;

class CardShowcaseCanvas extends FrameCanvas
{
   
   private static const REPEATER_SET_CONTAINER_NAME:String = "elementContainer";
   
   private static const REPEATER_CONTAINER_PREFIX:String = "itemContainer_";
    
   
   private var pictureHeight:int;
   
   private var repeaterList:Array;
   
   private var gaturroHolder:Sprite;
   
   private var selectedItem:Array;
   
   private var repeaterSetContainer:Sprite;
   
   private var pictureWidth:int;
   
   private var retrytBtn:Sprite;
   
   private var acceptBtn:Sprite;
   
   private var gaturro:Gaturro;
   
   public function CardShowcaseCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
   {
      super(param1,param2,param3,param4);
   }
   
   private function doCapture() : void
   {
      var _loc1_:int = int(this.repeaterSetContainer.x);
      var _loc2_:int = int(this.repeaterSetContainer.y);
      this.repeaterSetContainer.x = 0;
      this.repeaterSetContainer.y = 0;
      var _loc3_:ImageCapture = new ImageCapture();
      var _loc4_:Bitmap = _loc3_.capture(this.repeaterSetContainer,new Rectangle(0,0,this.pictureWidth,this.pictureHeight));
      this.repeaterSetContainer.x = _loc1_;
      this.repeaterSetContainer.y = _loc2_;
      var _loc5_:MovieClip;
      (_loc5_ = new MovieClip()).addChild(_loc4_);
      api.printClip(_loc5_);
   }
   
   private function setupButton() : void
   {
      this.repeaterSetContainer = view.getChildByName(REPEATER_SET_CONTAINER_NAME) as Sprite;
      this.seupButtonAccept();
      this.setupButtonRetry();
      this.setupPictureDimension();
   }
   
   private function onClickAccept(param1:MouseEvent) : void
   {
      this.doCapture();
   }
   
   private function setupCatalogs() : void
   {
      var _loc1_:NewYearCardRepeater = null;
      var _loc2_:MovieClip = null;
      var _loc3_:String = null;
      this.repeaterList = new Array();
      var _loc4_:int = 0;
      while(_loc4_ < this.selectedItem.length)
      {
         _loc3_ = String(REPEATER_CONTAINER_PREFIX + _loc4_);
         _loc2_ = this.repeaterSetContainer.getChildByName(_loc3_) as MovieClip;
         _loc1_ = new NewYearCardRepeater(owner as NewYearCardBanner,_loc2_);
         this.repeaterList.push(_loc1_);
         _loc1_.setupShowcase(this.selectedItem[_loc4_]);
         _loc4_++;
      }
   }
   
   private function setupButtonRetry() : void
   {
      this.retrytBtn = view.getChildByName("retrytBtn") as Sprite;
      this.retrytBtn.addEventListener(MouseEvent.CLICK,this.onClickRetry);
      var _loc1_:TextField = this.retrytBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("ARMA OTRO");
   }
   
   override protected function setupShowView() : void
   {
      this.setupButton();
      this.setupCatalogs();
      this.setupGaturro();
   }
   
   private function setupPictureDimension() : void
   {
      this.pictureWidth = this.repeaterSetContainer.width;
      this.pictureHeight = this.repeaterSetContainer.height;
   }
   
   override public function dispose() : void
   {
      var _loc1_:NewYearCardRepeater = null;
      if(this.acceptBtn)
      {
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
      }
      if(this.retrytBtn)
      {
         this.retrytBtn.addEventListener(MouseEvent.CLICK,this.onClickRetry);
      }
      for each(_loc1_ in this.repeaterList)
      {
         _loc1_.dispose();
      }
      this.repeaterList = null;
      super.dispose();
   }
   
   private function seupButtonAccept() : void
   {
      this.acceptBtn = view.getChildByName("acceptBtn") as Sprite;
      this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onClickAccept);
      var _loc1_:TextField = this.acceptBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("IMPRIMIR");
   }
   
   override public function show(param1:Object = null) : void
   {
      this.selectedItem = param1 as Array;
      super.show(param1);
   }
   
   private function setupGaturro() : void
   {
      this.gaturroHolder = this.repeaterSetContainer.getChildByName("gaturroHolder") as Sprite;
      var _loc1_:StubAttributeHolder = StubAttributeHolder.fromHolder(api.userAvatar);
      _loc1_.attributes.transport = "";
      this.gaturro = new Gaturro(_loc1_);
      this.gaturroHolder.addChild(this.gaturro);
      this.gaturro.scaleY = 2;
      this.gaturro.scaleX = 2;
   }
   
   private function onClickRetry(param1:MouseEvent) : void
   {
      NewYearCardBanner(owner).toSelector();
   }
}
