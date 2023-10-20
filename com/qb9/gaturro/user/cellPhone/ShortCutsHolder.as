package com.qb9.gaturro.user.cellPhone
{
   import assets.PagerEmpty;
   import assets.PagerFilled;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ShortCutsHolder extends Sprite
   {
       
      
      private var _innerArea:Rectangle;
      
      private var _cellWidth:uint;
      
      private var _shortCutMask:Sprite;
      
      private var _shortCutsContainer:Sprite;
      
      private var _pagerHolder:Sprite;
      
      private var _shortCutsCount:uint;
      
      private var _filledPagersPool:Array;
      
      private var _swipeVelocity:int = 200;
      
      private var _areaMargin:uint;
      
      private var _swipe:TaskRunner;
      
      private var _dragArea:Sprite;
      
      private var _emptyPagersPool:Array;
      
      private var _touch:Boolean;
      
      private var _cellHeight:uint;
      
      private var _screenGap:uint;
      
      private const ROWS:uint = 2;
      
      private var _pagerItemsGap:uint = 10;
      
      private var _startDragPosX:int;
      
      private var _gridCount:uint;
      
      private var _gridGap:uint = 10;
      
      private var _totalArea:Rectangle;
      
      private const COLS:uint = 3;
      
      public function ShortCutsHolder(param1:Rectangle, param2:Rectangle)
      {
         this._dragArea = new Sprite();
         this._shortCutsContainer = new Sprite();
         this._shortCutMask = new Sprite();
         this._filledPagersPool = new Array();
         this._emptyPagersPool = new Array();
         super();
         this._totalArea = param1;
         this._innerArea = param2;
         this._cellWidth = Math.floor(this._innerArea.width / this.COLS);
         this._cellHeight = Math.floor(this._innerArea.height / this.ROWS);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onStage);
         this._areaMargin = this._totalArea.width / 3;
      }
      
      private function touchEnd(param1:MouseEvent) : void
      {
         this.removeEventListener(MouseEvent.MOUSE_MOVE,this.touchMove);
         if(this._touch)
         {
            this.snaptoFrame();
            this._touch = false;
         }
         this._shortCutsContainer.stopDrag();
      }
      
      private function dispose(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.touchBegan);
         if(this.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            this.removeEventListener(MouseEvent.MOUSE_MOVE,this.touchMove);
         }
      }
      
      public function add(param1:MovieClip) : void
      {
         this._gridCount = this.COLS * this.ROWS % this._shortCutsCount;
         this._gridCount = Math.floor(this._shortCutsCount / (this.COLS * this.ROWS));
         param1.x = this._gridCount * this._totalArea.width + this._cellWidth * (this._shortCutsCount % this.COLS);
         param1.y = this._cellHeight * (Math.floor(this._shortCutsCount / this.COLS) % this.ROWS);
         this._shortCutsContainer.addChild(param1);
         ++this._shortCutsCount;
      }
      
      private function snaptoFrame() : void
      {
         var _loc1_:int = 0;
         if(this._startDragPosX == 32)
         {
            if(this._shortCutsContainer.x < 32 - 72)
            {
               _loc1_ = -409;
            }
            else
            {
               _loc1_ = 32;
            }
         }
         else if(this._startDragPosX == -409)
         {
            if(this._shortCutsContainer.x > -409 + 72)
            {
               _loc1_ = 32;
            }
            else
            {
               _loc1_ = -409;
            }
         }
         if(this._pagerHolder.numChildren == 1)
         {
            _loc1_ = 32;
         }
         this._swipe = new TaskRunner(this);
         this._swipe.add(new Sequence(new Tween(this._shortCutsContainer,this._swipeVelocity,{"x":_loc1_})));
         this.updatePager();
         this._swipe.start();
      }
      
      private function touchMove(param1:MouseEvent) : void
      {
      }
      
      private function touchBegan(param1:MouseEvent) : void
      {
         this._touch = true;
         this._shortCutsContainer.startDrag(false,new Rectangle(this._innerArea.x - Math.floor(this._totalArea.width * this._gridCount) - this._areaMargin,this._innerArea.y,this._areaMargin * 2 + Math.floor(this._totalArea.width * this._gridCount),0));
         this.dispatchEvent(new Event("STARTDRAG"));
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.touchMove);
         this._startDragPosX = this._innerArea.x + Math.round(this._shortCutsContainer.x / this._totalArea.width) * this._totalArea.width;
      }
      
      public function reset() : void
      {
         this._shortCutsCount = 0;
         this._gridCount = 0;
      }
      
      private function onStage(param1:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onStage);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.touchBegan);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.touchEnd);
         this._pagerHolder = new Sprite();
         this._dragArea.graphics.beginFill(0,0);
         this._dragArea.graphics.drawRect(0,0,this._totalArea.width,this._totalArea.height);
         this._dragArea.graphics.endFill();
         this._dragArea.x = this._totalArea.x;
         this._dragArea.y = this._totalArea.y;
         this.addChild(this._dragArea);
         this._shortCutsContainer.x = this._innerArea.x;
         this._shortCutsContainer.y = this._innerArea.y;
         this.addChild(this._shortCutsContainer);
         this._shortCutMask.graphics.beginFill(0);
         this._shortCutMask.graphics.drawRect(0,0,this._totalArea.width,this._totalArea.height);
         this._shortCutMask.graphics.endFill();
         this._shortCutMask.x = this._totalArea.x;
         this._shortCutMask.y = this._totalArea.y;
         this.addChild(this._shortCutMask);
         this._shortCutsContainer.mask = this._shortCutMask;
         this.addChild(this._pagerHolder);
         this.updatePager();
      }
      
      private function updatePager() : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         while(this._pagerHolder.numChildren > 0)
         {
            _loc3_ = this._pagerHolder.getChildAt(0) as MovieClip;
            this._pagerHolder.removeChild(_loc3_);
            if(_loc3_ is PagerEmpty)
            {
               this._emptyPagersPool.push(_loc3_);
            }
            else
            {
               this._filledPagersPool.push(_loc3_);
            }
         }
         var _loc1_:uint = Math.round(Math.abs(this._shortCutsContainer.x) / this._totalArea.width);
         var _loc2_:int = 0;
         while(_loc2_ < this._gridCount + 1)
         {
            if(_loc2_ == _loc1_)
            {
               if(this._filledPagersPool.length > 0)
               {
                  _loc4_ = this._filledPagersPool.shift() as MovieClip;
               }
               else
               {
                  _loc4_ = new PagerFilled();
               }
            }
            else if(this._emptyPagersPool.length > 0)
            {
               _loc4_ = this._emptyPagersPool.shift() as MovieClip;
            }
            else
            {
               _loc4_ = new PagerEmpty();
            }
            _loc4_.x = (_loc4_.width + this._gridGap) * _loc2_;
            this._pagerHolder.addChild(_loc4_);
            _loc2_++;
         }
         this._pagerHolder.x = this._innerArea.x + this._innerArea.width / 2 - this._pagerHolder.width / 2;
         this._pagerHolder.y = this._innerArea.y + this._innerArea.height;
      }
   }
}
