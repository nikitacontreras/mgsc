package com.qb9.gaturro.view.gui.iphone2.screens
{
   import assets.Iphone2ListMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.AbstractMethodError;
   import com.qb9.flashlib.math.QMath;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   internal class InternalListScreen extends InternalTitledScreen
   {
      
      private static const MARGIN:uint = 1;
       
      
      protected var originals:Dictionary;
      
      private var columnsQty:uint;
      
      private var title:String;
      
      private var itemsPerColumns:uint;
      
      private var firstElement:int = 0;
      
      private var visibleItems:uint;
      
      protected var views:Array;
      
      public function InternalListScreen(param1:IPhone2Modal, param2:String, param3:uint, param4:uint = 1)
      {
         super(param1,"",new Iphone2ListMC(),{
            "up":this.up,
            "down":this.down
         });
         this.title = param2;
         this.visibleItems = param3;
         this.columnsQty = param4;
         this.init();
      }
      
      protected function get items() : Array
      {
         throw new AbstractMethodError();
      }
      
      private function get maxIndex() : int
      {
         return Math.max(0,this.items.length - this.visibleItems);
      }
      
      protected function updateTitle() : void
      {
         return setTitle(region.getText(this.title) + " (" + this.items.length + ")");
      }
      
      private function init() : void
      {
         addEventListener(MouseEvent.CLICK,this.checkClick);
         this.asset.loading.visible = false;
         setVisible("remove",false);
         setVisible("removeAll",false);
      }
      
      protected function selected(param1:Object) : void
      {
         throw new AbstractMethodError();
      }
      
      private function disposeItems() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this.views)
         {
            if(_loc1_ is IDisposable)
            {
               IDisposable(_loc1_).dispose();
            }
         }
         this.originals = null;
         this.views = null;
      }
      
      protected function up() : void
      {
         this.showSince(this.firstElement - this.visibleItems);
      }
      
      protected function map(param1:Object) : DisplayObject
      {
         throw new AbstractMethodError();
      }
      
      override public function dispose() : void
      {
         this.disposeItems();
         removeEventListener(MouseEvent.CLICK,this.checkClick);
         super.dispose();
      }
      
      private function checkClick(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(_loc2_)
         {
            if(_loc2_ in this.originals)
            {
               iphoneSound();
               this.selected(this.originals[_loc2_]);
               break;
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      protected function regenerate(param1:Event = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:DisplayObject = null;
         this.disposeItems();
         this.originals = new Dictionary(true);
         this.views = [];
         for each(_loc3_ in this.items)
         {
            _loc4_ = this.map(_loc3_);
            this.views.push(_loc4_);
            this.originals[_loc4_] = _loc3_;
         }
         this.updateTitle();
         this.showSince(this.firstElement);
      }
      
      protected function down() : void
      {
         this.showSince(this.firstElement + this.visibleItems);
      }
      
      private function get ph() : Sprite
      {
         return asset.ph;
      }
      
      private function updatePagers() : void
      {
         setEnabled("arrows.up",this.firstElement > 0);
         setEnabled("arrows.down",this.firstElement < this.maxIndex);
      }
      
      private function showSince(param1:int) : void
      {
         var _loc7_:DisplayObject = null;
         this.firstElement = QMath.clamp(param1,0,this.items.length);
         DisplayUtil.empty(this.ph);
         var _loc2_:Array = this.views.slice(this.firstElement);
         var _loc3_:int = Math.min(_loc2_.length,this.visibleItems);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ <= _loc3_ - 1)
         {
            _loc4_ = _loc6_ % this.columnsQty;
            _loc5_ = int(_loc6_ / this.columnsQty);
            _loc7_ = _loc2_[_loc6_];
            _loc7_.x = (_loc7_.width + MARGIN) * _loc4_;
            _loc7_.y = (_loc7_.height + MARGIN) * _loc5_;
            this.ph.addChild(_loc7_);
            _loc6_++;
         }
         this.updatePagers();
      }
   }
}
