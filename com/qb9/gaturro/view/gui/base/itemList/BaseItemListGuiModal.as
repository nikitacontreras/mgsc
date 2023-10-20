package com.qb9.gaturro.view.gui.base.itemList
{
   import assets.ItemsInventoryMC;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.math.QMath;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.Parallel;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.itemList.items.BaseItemListItemView;
   import com.qb9.gaturro.view.gui.base.scroll.CatalogScrollDrag;
   import com.qb9.mambo.net.manager.NetworkManager;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BaseItemListGuiModal extends BaseGuiModal
   {
      
      public static const BAR_WIDTH:uint = 550;
      
      protected static const PAGES_PER_VIEW:uint = 2;
      
      protected static const SLIDE_TIME:uint = 700;
      
      protected static const MARGIN:uint = 3;
      
      protected static const COLS:uint = 5;
      
      protected static const ROWS:uint = 2;
      
      protected static const ITEMS_PER_PAGE:uint = COLS * ROWS / PAGES_PER_VIEW;
      
      protected static const ITEM_WIDTH:uint = 122 + MARGIN;
       
      
      protected var tasks:TaskContainer;
      
      protected var lastViewSelected:BaseItemListItemView;
      
      protected var net:NetworkManager;
      
      protected var scrollbar:CatalogScrollDrag;
      
      protected var confirmation:com.qb9.gaturro.view.gui.base.itemList.BaseItemListGuiModalConfirmation;
      
      protected var _isChristmas:Boolean;
      
      protected var items:Array;
      
      protected var initial:int;
      
      protected var destIndex:int = 0;
      
      protected var index:int = 0;
      
      protected var itemsPh:Sprite;
      
      protected var rows:uint = 0;
      
      protected var asset:MovieClip;
      
      protected var cols:uint = 0;
      
      protected var moveTask:ITask;
      
      public function BaseItemListGuiModal(param1:TaskContainer, param2:NetworkManager)
      {
         super();
         this._isChristmas = this.isChristmas;
         this.net = param2;
         this.tasks = param1;
      }
      
      private function updateFromBar(param1:MouseEvent) : void
      {
         var _loc2_:Number = param1.localX / BAR_WIDTH;
         var _loc3_:int = QMath.sign(_loc2_ - this.scrollbar.progress);
         this.moveBy(_loc3_ * COLS / PAGES_PER_VIEW,true);
      }
      
      private function itemConfirmed(param1:Event) : void
      {
         this.action(this.lastViewSelected);
      }
      
      private function moveBy(param1:int, param2:Boolean = true) : void
      {
         this.moveTo(this.index + param1,param2);
      }
      
      protected function init() : void
      {
         var _loc2_:BaseItemListItemView = null;
         this.initEvents();
         if(this._isChristmas)
         {
            this.asset = new ItemsInventoryMC();
         }
         else
         {
            this.asset = new ItemsInventoryMC();
         }
         addChild(this.asset);
         this.asset.gotoAndStop("list");
         this.asset.cancel.visible = false;
         this.itemsPh = new Sprite();
         this.contentPh.addChild(this.itemsPh);
         var _loc1_:int = 0;
         while(_loc1_ < this.items.length)
         {
            if(this.rows === ROWS)
            {
               ++this.cols;
               this.rows = 0;
            }
            _loc2_ = this.createItem(_loc1_);
            _loc2_.x = ITEM_WIDTH * this.cols;
            _loc2_.y = (_loc2_.height + MARGIN) * this.rows;
            libs.fetch(_loc2_.itemName,_loc2_.add);
            this.itemsPh.addChild(_loc2_);
            ++this.rows;
            _loc1_++;
         }
         if(!this.isChristmas)
         {
            this.setupScrolling();
            this.updatePagers();
         }
         this.confirmation = this.createConfirmation();
         this.confirmation.x = this.contentPh.x;
         this.confirmation.y = this.contentPh.y;
         this.confirmation.addEventListener(Event.SELECT,this.itemConfirmed);
         addChild(this.confirmation);
      }
      
      private function get bar() : Sprite
      {
         return this.asset.bar;
      }
      
      private function handleWheel(param1:MouseEvent) : void
      {
         this.moveBy(QMath.sign(param1.delta));
      }
      
      override public function dispose() : void
      {
         if(!this.items)
         {
            return;
         }
         this.disposeMoveTask();
         if(this.scrollbar)
         {
            this.scrollbar.dispose();
            this.scrollbar.removeEventListener(Event.CHANGE,this.updateFromScrollBar);
            this.scrollbar = null;
         }
         this.confirmation.removeEventListener(Event.SELECT,this.itemConfirmed);
         this.confirmation = null;
         if(this.bar)
         {
            this.bar.removeEventListener(MouseEvent.MOUSE_DOWN,this.updateFromBar);
         }
         this.tasks = null;
         this.asset = null;
         this.itemsPh = null;
         removeEventListener(MouseEvent.CLICK,this.checkClick);
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleWheel);
         this.items = null;
         this.net = null;
         super.dispose();
      }
      
      protected function createItem(param1:int) : BaseItemListItemView
      {
         return this.createItemView(null);
      }
      
      protected function action(param1:BaseItemListItemView) : void
      {
      }
      
      private function updateFromScrollBar(param1:Event) : void
      {
         this.moveToProgress(this.scrollbar.progress,false);
      }
      
      private function moveTo(param1:int, param2:Boolean = true) : void
      {
         param1 = QMath.clamp(param1,0,this.maxIndex);
         if(param1 === this.index)
         {
            return;
         }
         this.disposeMoveTask();
         var _loc3_:Number = param1 / this.maxIndex;
         this.moveTask = this.makeTween(this.itemsPh,-ITEM_WIDTH * param1);
         if(Boolean(this.scrollbar) && param2)
         {
            this.scrollbar.cancelDrag();
            this.moveTask = new Parallel(this.moveTask,this.makeTween(this.scrollbar,this.scrollbar.scrollingArea * _loc3_));
         }
         this.tasks.add(this.moveTask);
         this.index = param1;
         this.updatePagers();
      }
      
      private function get itemCount() : uint
      {
         return this.itemsPh.numChildren;
      }
      
      private function makeTween(param1:DisplayObject, param2:Number) : ITask
      {
         return new Tween(param1,SLIDE_TIME,{"x":param2},{"transition":"easeOut"});
      }
      
      private function updatePagers() : void
      {
         this.updatePager(this.asset.back,this.index > 0);
         this.updatePager(this.asset.next,this.index < this.maxIndex);
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.checkClick);
      }
      
      private function get pages() : uint
      {
         return Math.ceil(this.itemCount / ITEMS_PER_PAGE);
      }
      
      private function disposeMoveTask() : void
      {
         if(Boolean(this.moveTask) && this.moveTask.running)
         {
            this.tasks.remove(this.moveTask);
         }
         this.moveTask = null;
      }
      
      private function get maxIndex() : int
      {
         return this.cols - COLS + 1;
      }
      
      private function get contentPh() : Sprite
      {
         return this.asset.ph;
      }
      
      private function itemSelected(param1:BaseItemListItemView) : void
      {
         this.lastViewSelected = param1;
         this.confirmation.show(this.lastViewSelected);
      }
      
      private function checkClick(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            switch(_loc2_.name)
            {
               case "buy":
                  this.itemSelected(_loc2_.parent as BaseItemListItemView);
                  break;
               case "close":
                  close();
                  break;
               case "back":
                  this.moveBy(-1);
                  break;
               case "next":
                  this.moveBy(1);
                  break;
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      protected function createConfirmation() : com.qb9.gaturro.view.gui.base.itemList.BaseItemListGuiModalConfirmation
      {
         return new com.qb9.gaturro.view.gui.base.itemList.BaseItemListGuiModalConfirmation(false);
      }
      
      private function get views() : Array
      {
         return DisplayUtil.children(this.itemsPh);
      }
      
      protected function createItemView(param1:Object) : BaseItemListItemView
      {
         return new BaseItemListItemView(param1);
      }
      
      public function set isChristmas(param1:Boolean) : void
      {
         this._isChristmas = param1;
      }
      
      private function setupScrolling() : void
      {
         var _loc1_:Number = this.pages;
         if(_loc1_ <= 1)
         {
            return;
         }
         this.scrollbar = new CatalogScrollDrag(_loc1_,this.bar.height,BAR_WIDTH);
         this.scrollbar.addEventListener(Event.CHANGE,this.updateFromScrollBar);
         this.bar.addChild(this.scrollbar);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.handleWheel);
         this.bar.buttonMode = true;
         this.bar.addEventListener(MouseEvent.MOUSE_DOWN,this.updateFromBar);
      }
      
      private function moveToProgress(param1:Number, param2:Boolean) : void
      {
         var _loc3_:uint = param1 * this.cols;
         this.moveTo(_loc3_,param2);
      }
      
      private function updatePager(param1:InteractiveObject, param2:Boolean) : void
      {
         param1.mouseEnabled = param2;
         param1.alpha = param2 ? 1 : 0.5;
      }
      
      public function get isChristmas() : Boolean
      {
         return this._isChristmas;
      }
   }
}
