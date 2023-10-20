package com.qb9.gaturro.service.composer
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.globals.api;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ObjectComposerSelector implements ICheckableDisposable
   {
       
      
      private var selectorView:Sprite;
      
      private var _disposed:Boolean;
      
      private var rightButton:Sprite;
      
      private var targetView:MovieClip;
      
      private var leftButton:Sprite;
      
      public function ObjectComposerSelector(param1:Sprite, param2:MovieClip)
      {
         super();
         this.selectorView = param1;
         this.targetView = param2;
         param2.stop();
         this.setup();
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      private function setupButtons() : void
      {
         this.rightButton = this.selectorView.getChildByName("btnNext") as Sprite;
         this.rightButton.buttonMode = true;
         this.rightButton.addEventListener(MouseEvent.CLICK,this.onClickRight);
         this.leftButton = this.selectorView.getChildByName("btnPrev") as Sprite;
         this.leftButton.buttonMode = true;
         this.leftButton.addEventListener(MouseEvent.CLICK,this.onClickLeft);
      }
      
      private function onClickLeft(param1:MouseEvent) : void
      {
         api.playSound("click");
         if(this.targetView.currentFrame == 1)
         {
            this.targetView.gotoAndStop(this.targetView.totalFrames);
         }
         else
         {
            this.targetView.prevFrame();
         }
      }
      
      public function getSelected() : int
      {
         return this.targetView.currentFrame;
      }
      
      private function onClickRight(param1:MouseEvent) : void
      {
         api.playSound("click");
         if(this.targetView.currentFrame == this.targetView.totalFrames)
         {
            this.targetView.gotoAndStop(1);
         }
         else
         {
            this.targetView.nextFrame();
         }
      }
      
      private function setup() : void
      {
         this.setupButtons();
      }
      
      public function dispose() : void
      {
         this.rightButton.removeEventListener(MouseEvent.CLICK,this.onClickRight);
         this.leftButton.removeEventListener(MouseEvent.CLICK,this.onClickLeft);
         this.rightButton = null;
         this.leftButton = null;
         this.targetView = null;
         this.selectorView = null;
         this._disposed = true;
      }
   }
}
