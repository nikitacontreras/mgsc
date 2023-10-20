package com.qb9.gaturro.view.components.banner.globe
{
   import com.qb9.gaturro.commons.view.component.canvas.display.Canvas;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas;
   import com.qb9.gaturro.view.components.canvas.common.ISwitchPostExplanation;
   import com.qb9.gaturro.view.gui.base.modal.AbstractCanvasFrameBanner;
   
   public class GlobeSelectorBanner extends AbstractCanvasFrameBanner implements ISwitchPostExplanation
   {
       
      
      private const PATTERN_SELECTOR:String = "PATTERN_SELECTOR";
      
      private var canvasOrderList:Array;
      
      private var arrangedItemName:String;
      
      private var canvasCount:int = 0;
      
      private var selected:Array;
      
      private const SHAPE_SELECTOR:String = "SHAPE_SELECTOR";
      
      private const COLOR_SELECTOR:String = "COLOR_SELECTOR";
      
      private const SHOWCASE:String = "SHOWCASE";
      
      private const EXPLANATION:String = "EXPLANATION";
      
      private const ITEM_PREFIX:String = "parqueDiversiones/wears.";
      
      public function GlobeSelectorBanner(param1:String = "", param2:String = "")
      {
         super("GlobeSelectorBanner","GlobeSelectorBannerAsset");
         this.canvasOrderList = new Array();
         this.selected = new Array();
      }
      
      public function switchNext(param1:String = null) : void
      {
         var _loc2_:String = null;
         if(param1)
         {
            this.selected.push(param1);
         }
         if(this.canvasOrderList.length > this.canvasCount)
         {
            _loc2_ = String(this.canvasOrderList[this.canvasCount]);
            ++this.canvasCount;
            switchTo(_loc2_);
         }
         else
         {
            this.arrangeName();
            switchTo(this.SHOWCASE,this.arrangedItemName);
         }
      }
      
      public function accept() : void
      {
         api.giveUser(this.arrangedItemName);
         api.takeFromUser("parqueDiversiones/props.ticket");
         close();
      }
      
      public function switchToPostExplanation() : void
      {
         this.switchNext();
      }
      
      public function startAgain() : void
      {
         this.canvasCount = 0;
         this.selected.length = 0;
         this.switchNext();
      }
      
      private function addAndEnlist(param1:Canvas) : void
      {
         this.canvasOrderList.push(param1.id);
         addCanvas(param1);
      }
      
      override protected function setInitialCanvasName() : void
      {
         initialCanvasName = this.EXPLANATION;
      }
      
      private function arrangeName() : void
      {
         this.arrangedItemName = this.ITEM_PREFIX + this.selected[0] + this.selected[1] + this.selected[2];
      }
      
      override protected function setupCanvas() : void
      {
         addCanvas(new com.qb9.gaturro.view.components.canvas.common.ExplanationCanvas(this.EXPLANATION,"explanation",canvasContainer,this));
         this.addAndEnlist(new GlobeSelectorCanvas(this.SHAPE_SELECTOR,"shape",canvasContainer,this));
         this.addAndEnlist(new GlobeSelectorCanvas(this.COLOR_SELECTOR,"color",canvasContainer,this));
         this.addAndEnlist(new GlobeSelectorCanvas(this.PATTERN_SELECTOR,"pattern",canvasContainer,this));
         addCanvas(new ShowcaseGlobeCanvas(this.SHOWCASE,"showcase",canvasContainer,this));
      }
   }
}

import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.view.components.banner.globe.GlobeSelectorBanner;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;

class GlobeSelectorCanvas extends FrameCanvas
{
    
   
   private var nextButton:Sprite;
   
   private var selectedCheck:Sprite;
   
   private var selected:String;
   
   private var itemSetHolder:Sprite;
   
   public function GlobeSelectorCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:GlobeSelectorBanner)
   {
      super(param1,param2,param3,param4);
   }
   
   override public function hide() : void
   {
      var _loc1_:Sprite = null;
      var _loc2_:int = 0;
      while(_loc2_ < this.itemSetHolder.numChildren)
      {
         _loc1_ = this.itemSetHolder.getChildAt(_loc2_) as Sprite;
         _loc1_.removeEventListener(MouseEvent.CLICK,this.onClick);
         _loc2_++;
      }
      this.nextButton.removeEventListener(MouseEvent.CLICK,this.onClickNext);
      this.selected = "";
      super.hide();
   }
   
   override public function show(param1:Object = null) : void
   {
      super.show(param1);
   }
   
   override public function dispose() : void
   {
      var _loc1_:Sprite = null;
      var _loc2_:int = 0;
      if(this.itemSetHolder)
      {
         _loc2_ = 0;
         while(_loc2_ < this.itemSetHolder.numChildren)
         {
            _loc1_ = this.itemSetHolder.getChildAt(_loc2_) as Sprite;
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onClick);
            _loc2_++;
         }
      }
      if(this.nextButton)
      {
         this.nextButton.removeEventListener(MouseEvent.CLICK,this.onClickNext);
      }
      super.dispose();
   }
   
   private function setupNextButton() : void
   {
      this.nextButton = view.getChildByName("nextButton") as Sprite;
      this.nextButton.addEventListener(MouseEvent.CLICK,this.onClickNext);
      this.nextButton.mouseChildren = false;
      this.nextButton.buttonMode = true;
   }
   
   private function setupButton(param1:Sprite) : void
   {
      param1.addEventListener(MouseEvent.CLICK,this.onClick);
      param1.buttonMode = true;
      param1.mouseChildren = false;
   }
   
   private function onClick(param1:MouseEvent) : void
   {
      var _loc2_:Sprite = param1.currentTarget as Sprite;
      if(!this.selectedCheck)
      {
         this.selectedCheck = (owner as InstantiableGuiModal).getInstanceByName("check") as Sprite;
      }
      var _loc3_:Sprite = _loc2_.getChildByName("checkHolder") as Sprite;
      _loc3_.addChild(this.selectedCheck);
      this.selected = _loc2_.name;
      api.playSound("globos/soplar");
   }
   
   private function setupItemButtons() : void
   {
      var _loc1_:Sprite = null;
      var _loc2_:Sprite = null;
      var _loc3_:DisplayObjectContainer = null;
      this.itemSetHolder = view.getChildByName("itemContainer") as Sprite;
      var _loc4_:int = 0;
      while(_loc4_ < this.itemSetHolder.numChildren)
      {
         _loc2_ = (owner as InstantiableGuiModal).getInstanceByName("completeHolder") as Sprite;
         _loc3_ = _loc2_.getChildByName("itemHolder") as DisplayObjectContainer;
         _loc1_ = this.itemSetHolder.getChildAt(_loc4_) as Sprite;
         this.itemSetHolder.addChildAt(_loc2_,_loc4_);
         _loc2_.x = _loc1_.x;
         _loc2_.y = _loc1_.y;
         _loc2_.name = _loc1_.name;
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc3_.addChild(_loc1_);
         this.setupButton(_loc2_);
         _loc4_++;
      }
   }
   
   override protected function setupShowView() : void
   {
      this.setupNextButton();
      this.setupItemButtons();
   }
   
   private function onClickNext(param1:MouseEvent) : void
   {
      GlobeSelectorBanner(owner).switchNext(this.selected);
   }
}

import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.view.components.banner.globe.GlobeSelectorBanner;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

class ShowcaseGlobeCanvas extends FrameCanvas
{
    
   
   private var selectedItem:String;
   
   private var retrytBtn:Sprite;
   
   private var acceptBtn:Sprite;
   
   private var itemHolder:Sprite;
   
   public function ShowcaseGlobeCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:GlobeSelectorBanner)
   {
      super(param1,param2,param3,param4);
   }
   
   override protected function setupShowView() : void
   {
      this.setupItem();
      this.setupAcceptButton();
      this.setupRetryButtons();
   }
   
   override public function dispose() : void
   {
      if(this.acceptBtn)
      {
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
      }
      if(this.retrytBtn)
      {
         this.retrytBtn.removeEventListener(MouseEvent.CLICK,this.onClickRetry);
      }
      super.dispose();
   }
   
   protected function onFetchCompleted(param1:DisplayObject) : void
   {
      this.itemHolder.addChild(param1);
   }
   
   private function onClickRetry(param1:MouseEvent) : void
   {
      GlobeSelectorBanner(owner).startAgain();
   }
   
   private function setupAcceptButton() : void
   {
      this.acceptBtn = view.getChildByName("acceptBtn") as Sprite;
      this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onClickAccept);
      var _loc1_:TextField = this.acceptBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("HECHO");
   }
   
   private function onClickAccept(param1:MouseEvent) : void
   {
      GlobeSelectorBanner(owner).accept();
      api.playSound("globos/listo");
   }
   
   private function setupItem() : void
   {
      trace("ShowcaseGlobeCanvas >> setupItem >> selectedItem = " + this.selectedItem);
      this.itemHolder = view.getChildByName("itemHolder") as Sprite;
      api.libraries.fetch(this.selectedItem,this.onFetchCompleted);
   }
   
   private function setupRetryButtons() : void
   {
      this.retrytBtn = view.getChildByName("retrytBtn") as Sprite;
      this.retrytBtn.addEventListener(MouseEvent.CLICK,this.onClickRetry);
      var _loc1_:TextField = this.retrytBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("ARMA OTRO");
   }
   
   override public function show(param1:Object = null) : void
   {
      this.selectedItem = param1 as String;
      super.show(param1);
   }
}
