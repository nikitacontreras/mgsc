package com.qb9.gaturro.view.world.whitelist
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.map;
   import com.qb9.flashlib.math.QMath;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.stageData;
   import com.qb9.gaturro.view.world.whitelist.items.BaseWhiteListItemView;
   import com.qb9.gaturro.view.world.whitelist.items.WhiteListCategoryView;
   import com.qb9.gaturro.view.world.whitelist.items.WhiteListMessageView;
   import com.qb9.gaturro.whitelist.WhiteListVariableReplacer;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.view.MamboView;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public final class WhiteListScreen extends MamboView implements IDisposable
   {
      
      private static const MIN_TEXT_LENGTH_TO_CROP:uint = 14;
      
      private static const TIMEOUT:uint = 250;
      
      private static const CROPPED_ITEMS_START:String = "...";
      
      private static const RE_NOT_CHARS:RegExp = /^[^\wá-úÁ-Ú]+|[^\wá-úÁ-Ú]+$/g;
      
      private static const TOP_LIMIT_DELTA:uint = 115;
      
      private static const ITEM_MARGIN:uint = 3;
       
      
      private var items:Dictionary;
      
      private var lastSelected:BaseWhiteListItemView;
      
      private var pos:int;
      
      private var timeout:int;
      
      private var lastHovered:DisplayObject;
      
      private var words:Array;
      
      private var variables:WhiteListVariableReplacer;
      
      private var children:Array;
      
      public function WhiteListScreen(param1:WhiteListNode, param2:WhiteListVariableReplacer, param3:int = 0)
      {
         this.items = new Dictionary(true);
         super();
         this.children = param1.children;
         this.pos = param3;
         this.variables = param2;
         if(param1.text)
         {
            this.words = map(param1.text.split(" "),this.trim);
         }
      }
      
      private function getSelectedItem(param1:Event) : DisplayObject
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_ in this.items)
            {
               return _loc2_;
            }
            _loc2_ = _loc2_.parent;
         }
         return null;
      }
      
      private function unselectLast() : void
      {
         if(this.lastSelected)
         {
            this.lastSelected.unselect();
         }
         this.lastSelected = null;
      }
      
      private function abortTimeout() : void
      {
         clearTimeout(this.timeout);
      }
      
      private function scheduleExpand(param1:Event) : void
      {
         var _loc2_:DisplayObject = this.getSelectedItem(param1);
         if(_loc2_ === this.lastHovered || _loc2_ is BaseWhiteListItemView === false)
         {
            return;
         }
         this.abortTimeout();
         this.lastHovered = _loc2_;
         if(_loc2_ is WhiteListCategoryView)
         {
            this.timeout = setTimeout(this.expand,TIMEOUT,_loc2_);
         }
         else
         {
            this.unselectLast();
            dispatchEvent(new WhiteListViewEvent(WhiteListViewEvent.CROP));
         }
      }
      
      private function expand(param1:BaseWhiteListItemView) : void
      {
         this.abortTimeout();
         if(param1 === this.lastSelected)
         {
            return;
         }
         this.unselectLast();
         this.lastSelected = param1;
         this.lastSelected.select();
         var _loc2_:int = DisplayUtil.offsetY(param1,parent) + param1.height / 2;
         dispatchEvent(new WhiteListViewEvent(WhiteListViewEvent.CATEGORY_SELECTED,this.items[param1],_loc2_));
      }
      
      override public function dispose() : void
      {
         this.abortTimeout();
         removeEventListener(MouseEvent.MOUSE_OUT,this.abortExpand);
         removeEventListener(MouseEvent.MOUSE_OVER,this.scheduleExpand);
         removeEventListener(MouseEvent.CLICK,this.selectItem);
         this.items = null;
         this.variables = null;
         this.children = null;
         super.dispose();
      }
      
      private function trimStart(param1:String) : String
      {
         if(param1.length < MIN_TEXT_LENGTH_TO_CROP)
         {
            return param1;
         }
         var _loc2_:Array = param1.split(" ");
         var _loc3_:int = 0;
         while(_loc3_ < this.words.length)
         {
            if(this.words[_loc3_] !== this.trim(_loc2_[_loc3_]))
            {
               break;
            }
            _loc3_++;
         }
         if(!_loc3_)
         {
            return param1;
         }
         _loc2_ = _loc2_.slice(_loc3_);
         _loc2_[0] = CROPPED_ITEMS_START + _loc2_[0];
         return _loc2_.join(" ");
      }
      
      private function addItemAt(param1:WhiteListNode, param2:int) : Boolean
      {
         var _loc3_:String = this.variables.replaceForUser(region.getText(param1.text));
         if(!_loc3_)
         {
            return false;
         }
         if(this.words)
         {
            _loc3_ = this.trimStart(_loc3_);
         }
         var _loc4_:BaseWhiteListItemView;
         (_loc4_ = param1.isLeaf ? new WhiteListMessageView(_loc3_) : new WhiteListCategoryView(_loc3_)).y = param2 * (_loc4_.height + ITEM_MARGIN) + settings.gui.overlay.margin;
         addChild(_loc4_);
         this.items[_loc4_] = param1;
         return true;
      }
      
      private function abortExpand(param1:Event) : void
      {
         var _loc2_:DisplayObject = this.getSelectedItem(param1);
         if(_loc2_ === this.lastHovered)
         {
            this.abortTimeout();
            this.lastHovered = null;
         }
      }
      
      private function addOverlay() : void
      {
         var data:Object = settings.gui.overlay;
         var margin:int = int(data.margin);
         with(graphics)
         {
            beginFill(0,data.alpha);
            drawRoundRect(-margin,0,width + margin * 2,height + margin * 2,data.rounding);
            endFill();
         }
      }
      
      private function trim(param1:String) : String
      {
         return param1.replace(RE_NOT_CHARS,"");
      }
      
      private function selectItem(param1:Event) : void
      {
         param1.stopPropagation();
         var _loc2_:BaseWhiteListItemView = this.getSelectedItem(param1) as BaseWhiteListItemView;
         if(Boolean(_loc2_) && !_loc2_.disabled)
         {
            this.select(_loc2_);
         }
      }
      
      private function select(param1:BaseWhiteListItemView) : void
      {
         dispatchEvent(new WhiteListViewEvent(WhiteListViewEvent.MESSAGE_SELECTED,this.items[param1]));
      }
      
      override protected function whenAddedToStage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc1_ < this.children.length)
         {
            if(this.addItemAt(this.children[_loc1_],_loc2_))
            {
               _loc2_++;
            }
            _loc1_++;
         }
         addEventListener(MouseEvent.MOUSE_OUT,this.abortExpand);
         addEventListener(MouseEvent.MOUSE_OVER,this.scheduleExpand);
         addEventListener(MouseEvent.CLICK,this.selectItem);
         this.addOverlay();
         var _loc3_:Number = this.pos - height / 2;
         var _loc4_:Number = -stageData.height + TOP_LIMIT_DELTA;
         var _loc5_:Number = -height;
         y = QMath.clamp(_loc3_,_loc4_,_loc5_);
      }
   }
}
