package com.qb9.gaturro.view.components.banner.river
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.gui.banner.properties.IHasOptions;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class RiverCups extends InstantiableGuiModal implements IHasOptions
   {
       
      
      private var currentDescription:Object;
      
      private var prevButton:MovieClip;
      
      private var subtitleTF:TextField;
      
      private var nextButton:MovieClip;
      
      private var titleTF:TextField;
      
      private var breakdown:Array;
      
      private var imageHolder:DisplayObjectContainer;
      
      private var model:Object;
      
      private var _options:String;
      
      private var currentId:int = 0;
      
      private var messageTF:TextField;
      
      public function RiverCups(param1:String = "", param2:String = "")
      {
         super("RiverCups","RiverCupsAsset");
      }
      
      private function disableButton(param1:MovieClip) : void
      {
         param1.gotoAndStop("disable");
         param1.mouseEnabled = false;
      }
      
      private function next() : void
      {
         this.enableButton(this.prevButton);
         ++this.currentId;
         if(this.currentId >= this.breakdown.length - 1)
         {
            this.disableButton(this.nextButton);
         }
         this.changePage();
      }
      
      private function enableButton(param1:MovieClip) : void
      {
         param1.gotoAndStop("idle");
         param1.mouseEnabled = true;
      }
      
      private function onClickNext(param1:MouseEvent) : void
      {
         this.next();
      }
      
      override public function dispose() : void
      {
         if(this.nextButton)
         {
            this.nextButton.addEventListener(MouseEvent.CLICK,this.onClickNext);
         }
         if(this.prevButton)
         {
            this.prevButton.addEventListener(MouseEvent.CLICK,this.onClickPrev);
         }
         super.dispose();
      }
      
      private function prev() : void
      {
         this.enableButton(this.nextButton);
         --this.currentId;
         if(this.currentId <= 0)
         {
            this.disableButton(this.prevButton);
         }
         this.changePage();
      }
      
      override protected function ready() : void
      {
         this.titleTF = view.getChildByName("titleTF") as TextField;
         this.titleTF.text = String(this.model.title).toUpperCase();
         this.subtitleTF = view.getChildByName("subtitleTF") as TextField;
         this.messageTF = view.getChildByName("messageTF") as TextField;
         this.setDescription();
         this.setupNavigation();
         this.setupImage(this.model.image);
      }
      
      private function setupImage(param1:String) : void
      {
         api.fetch(param1,this.onImageLoaded);
      }
      
      private function onImageLoaded(param1:DisplayObject) : void
      {
         this.imageHolder = view.getChildByName("imageHolder") as DisplayObjectContainer;
         var _loc2_:DisplayObject = view.getChildByName("sizeRef");
         this.imageHolder.addChild(param1);
         GuiUtil.fit(param1,_loc2_.width,_loc2_.height);
      }
      
      private function setupNavigation() : void
      {
         this.prevButton = view.getChildByName("prevBtn") as MovieClip;
         this.prevButton.buttonMode = true;
         this.prevButton.addEventListener(MouseEvent.CLICK,this.onClickPrev);
         this.prevButton.stop();
         this.prevButton.mouseChildren = false;
         this.disableButton(this.prevButton);
         this.nextButton = view.getChildByName("nextBtn") as MovieClip;
         this.nextButton.buttonMode = true;
         this.nextButton.addEventListener(MouseEvent.CLICK,this.onClickNext);
         this.nextButton.stop();
         this.nextButton.mouseChildren = false;
         if(this.breakdown.length > 1)
         {
            this.enableButton(this.nextButton);
         }
         else
         {
            this.disableButton(this.nextButton);
         }
      }
      
      private function onClickPrev(param1:MouseEvent) : void
      {
         this.prev();
      }
      
      private function changePage() : void
      {
         this.currentDescription = this.breakdown[this.currentId];
         this.setDescription();
      }
      
      private function setDescription() : void
      {
         this.subtitleTF.text = this.currentDescription.subtitle.toUpperCase();
         this.messageTF.text = this.currentDescription.message.toUpperCase();
      }
      
      public function set options(param1:String) : void
      {
         this._options = param1;
         this.model = settings.riverCups[this._options];
         this.breakdown = this.model.breakdown;
         this.currentDescription = this.breakdown[this.currentId];
      }
   }
}
