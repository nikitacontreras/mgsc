package com.qb9.gaturro.service.composer
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ObjectComposer implements ICheckableDisposable
   {
       
      
      private var _disposed:Boolean;
      
      private var repeaterList:Array;
      
      private var navigationHolder:DisplayObjectContainer;
      
      private var asset:DisplayObjectContainer;
      
      private var target:DisplayObjectContainer;
      
      private var partHolder:DisplayObjectContainer;
      
      public function ObjectComposer(param1:DisplayObjectContainer)
      {
         super();
         this.asset = param1;
         this.setup();
      }
      
      private function setupDisplay() : void
      {
         this.navigationHolder = this.asset.getChildByName("navigationHolder") as DisplayObjectContainer;
         this.target = this.asset.getChildByName("target") as DisplayObjectContainer;
         this.partHolder = this.target.getChildByName("partHolder") as DisplayObjectContainer;
      }
      
      public function dispose() : void
      {
         var _loc1_:ObjectComposerSelector = null;
         for each(_loc1_ in this.repeaterList)
         {
            _loc1_.dispose();
         }
         this.repeaterList = null;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      private function setupRepeater() : void
      {
         var _loc1_:ObjectComposerSelector = null;
         this.repeaterList = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.partHolder.numChildren)
         {
            _loc1_ = new ObjectComposerSelector(this.navigationHolder.getChildAt(_loc2_) as Sprite,this.partHolder.getChildAt(_loc2_) as MovieClip);
            this.repeaterList.push(_loc1_);
            _loc2_++;
         }
      }
      
      public function getResult() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:ObjectComposerSelector = null;
         var _loc1_:Array = new Array();
         for each(_loc3_ in this.repeaterList)
         {
            _loc2_ = _loc3_.getSelected();
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      private function setup() : void
      {
         this.setupDisplay();
         this.setupRepeater();
      }
   }
}
