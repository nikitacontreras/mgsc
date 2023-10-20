package com.qb9.gaturro.service.composer
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class ObjectComposerDisplay
   {
       
      
      private var _disposed:Boolean;
      
      private var targetView:DisplayObjectContainer;
      
      private var partDisplaySet:Array;
      
      public function ObjectComposerDisplay(param1:DisplayObjectContainer)
      {
         super();
         this.targetView = param1;
         this.setupView();
      }
      
      public function getCurrrent(param1:int) : int
      {
         var _loc2_:MovieClip = null;
         if(this.checkID(param1))
         {
            _loc2_ = this.partDisplaySet[param1];
            return _loc2_.currentFrame - 1;
         }
         return -1;
      }
      
      public function getAmountOfFlavor(param1:int) : int
      {
         var _loc2_:MovieClip = null;
         if(this.checkID(param1))
         {
            _loc2_ = this.partDisplaySet[param1];
            return _loc2_.totalFrames;
         }
         return -1;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      private function setupView() : void
      {
         this.setupDisplaySet();
      }
      
      public function goto(param1:int, param2:int) : void
      {
         var _loc3_:MovieClip = null;
         if(this.checkID(param1))
         {
            _loc3_ = this.partDisplaySet[param1];
            if(param2 <= _loc3_.totalFrames)
            {
               _loc3_.gotoAndStop(param2);
            }
         }
      }
      
      public function next(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         if(this.checkID(param1))
         {
            _loc2_ = this.partDisplaySet[param1];
            _loc2_.nextFrame();
         }
      }
      
      private function checkID(param1:int) : Boolean
      {
         if(param1 >= this.partDisplaySet.length)
         {
            throw new Error("The given ID ( " + param1 + " ) is out of range");
         }
         return true;
      }
      
      public function prev(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         if(this.checkID(param1))
         {
            _loc2_ = this.partDisplaySet[param1];
            _loc2_.prevFrame();
         }
      }
      
      public function getFlavorVarietyAmount() : int
      {
         return this.partDisplaySet.length;
      }
      
      private function setupDisplaySet() : void
      {
         var _loc2_:MovieClip = null;
         this.partDisplaySet = new Array();
         var _loc1_:int = this.targetView.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.targetView.getChildAt(_loc3_) as MovieClip;
            this.partDisplaySet.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         this.targetView = null;
         this.partDisplaySet.length = 0;
         this.partDisplaySet = null;
         this._disposed = true;
      }
   }
}
