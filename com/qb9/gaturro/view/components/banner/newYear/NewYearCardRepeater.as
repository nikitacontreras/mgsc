package com.qb9.gaturro.view.components.banner.newYear
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class NewYearCardRepeater implements ICheckableDisposable
   {
       
      
      private var owner:InstantiableGuiModal;
      
      private var _disposed:Boolean;
      
      private var view:Sprite;
      
      private var showcase:Showcase;
      
      private var selector:EditableTargetSelector;
      
      public function NewYearCardRepeater(param1:InstantiableGuiModal, param2:Sprite)
      {
         super();
         this.owner = param1;
         this.view = param2;
         this.setup();
      }
      
      public function setupEditor() : void
      {
         this.selector = new EditableTargetSelector(this.view);
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         this.owner = null;
         this.view = null;
         if(this.selector)
         {
            this.selector.dispose();
            this.selector = null;
         }
         this._disposed = true;
      }
      
      public function setupShowcase(param1:int) : void
      {
         this.showcase = new Showcase(this.view as MovieClip,param1);
      }
      
      public function get currentItem() : int
      {
         return this.selector.getCurrentItem();
      }
      
      private function setup() : void
      {
      }
   }
}

import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;

class EditableTargetSelector implements ICheckableDisposable
{
   
   private static const ITEM_CONTAINER_NAME:String = "itemContainer";
    
   
   private var container:MovieClip;
   
   private var _disposed:Boolean;
   
   private var view:Sprite;
   
   private var nextBtn:InteractiveObject;
   
   private var prevBtn:InteractiveObject;
   
   public function EditableTargetSelector(param1:Sprite)
   {
      super();
      this.view = param1;
      this.setup();
   }
   
   public function get disposed() : Boolean
   {
      return this._disposed;
   }
   
   protected function onPrevBtnClick(param1:MouseEvent) : void
   {
      if(this.container.currentFrame == 1)
      {
         this.container.gotoAndStop(this.container.totalFrames);
      }
      else
      {
         this.container.prevFrame();
      }
   }
   
   public function getCurrentItem() : int
   {
      return this.container.currentFrame;
   }
   
   protected function setupSingleButtons() : void
   {
      this.prevBtn = this.view.getChildByName("prev") as InteractiveObject;
      if(this.prevBtn)
      {
         this.prevBtn.addEventListener(MouseEvent.CLICK,this.onPrevBtnClick);
         this.nextBtn = this.view.getChildByName("next") as InteractiveObject;
         if(this.nextBtn)
         {
            this.nextBtn.addEventListener(MouseEvent.CLICK,this.onNextBtnClick);
            return;
         }
         throw new Error("Could\'t find Next Button");
      }
      throw new Error("Could\'t find Prev Button");
   }
   
   private function setup() : void
   {
      this.container = this.view.getChildByName(ITEM_CONTAINER_NAME) as MovieClip;
      this.setupSingleButtons();
   }
   
   protected function onNextBtnClick(param1:MouseEvent) : void
   {
      if(this.container.currentFrame == this.container.totalFrames)
      {
         this.container.gotoAndStop(1);
      }
      else
      {
         this.container.nextFrame();
      }
   }
   
   public function dispose() : void
   {
      this.nextBtn.removeEventListener(MouseEvent.CLICK,this.onNextBtnClick);
      this.nextBtn = null;
      this.prevBtn.removeEventListener(MouseEvent.CLICK,this.onPrevBtnClick);
      this.prevBtn = null;
      this.view = null;
      this._disposed = true;
   }
}

import flash.display.MovieClip;

class Showcase
{
    
   
   private var currentItem:int;
   
   private var view:MovieClip;
   
   public function Showcase(param1:MovieClip, param2:int)
   {
      super();
      this.view = param1;
      this.currentItem = param2;
      this.setup();
   }
   
   private function setup() : void
   {
      this.view.gotoAndStop(this.currentItem);
   }
}
