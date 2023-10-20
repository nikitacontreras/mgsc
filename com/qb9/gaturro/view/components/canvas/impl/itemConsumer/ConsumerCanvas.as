package com.qb9.gaturro.view.components.canvas.impl.itemConsumer
{
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.view.components.banner.itemConsumer.ItemConsumerBanner;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRenderer;
   import com.qb9.gaturro.view.gui.catalog.utils.CatalogUtils;
   import com.qb9.mambo.net.requests.inventory.DestroyInventoryObjectActionRequest;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class ConsumerCanvas extends FrameCanvas
   {
       
      
      private var widget:com.qb9.gaturro.view.components.canvas.impl.itemConsumer.ItemConsumerWidget;
      
      private var items:Array;
      
      private var panDulceHolder:MovieClip;
      
      private var pdPressed:Boolean = false;
      
      private var selectedItems:Dictionary;
      
      private var holder:MovieClip;
      
      private var acceptBtn:MovieClip;
      
      private var amountTxt:TextField;
      
      private var muerdagos:int = 0;
      
      private var itemsToRemove:Array;
      
      public function ConsumerCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:ItemConsumerBanner)
      {
         super(param1,param2,param3,param4);
         this.itemsToRemove = [];
      }
      
      private function removeAllItems() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:int = 0;
         while(_loc1_ < this.itemsToRemove.length)
         {
            _loc2_ = Number(InventoryUtil.compressItemId(this.itemsToRemove[_loc1_]));
            net.sendAction(new DestroyInventoryObjectActionRequest(_loc2_));
            _loc1_++;
         }
         if(ItemToMuerdagos.userHasPanDulce())
         {
            api.setAvatarAttribute("effect2","");
         }
      }
      
      private function onItemSelected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.target as InventoryWidgetItemRenderer;
         if(_loc2_)
         {
            trace(_loc2_.cell.item);
            this.addToRemoveList(_loc2_.cell.item.id.toString());
            this.muerdagos += ItemToMuerdagos.convert(_loc2_.cell.item.name);
            this.amountTxt.text = this.muerdagos.toString();
         }
      }
      
      private function onItemDeselected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.target as InventoryWidgetItemRenderer;
         if(_loc2_)
         {
            this.removeFromRemoveList(_loc2_.cell.item.id.toString());
            this.muerdagos -= ItemToMuerdagos.convert(_loc2_.cell.item.name);
            this.amountTxt.text = this.muerdagos.toString();
         }
      }
      
      private function onClickAccept(param1:MouseEvent) : void
      {
         var _loc2_:ItemConsumerBanner = owner as ItemConsumerBanner;
         if(this.muerdagos > 0)
         {
            this.removeAllItems();
            CatalogUtils.giveCoins("navidad",this.muerdagos);
            _loc2_.switchCanvas(_loc2_.REWARDS,this.muerdagos);
         }
         else
         {
            _loc2_.switchCanvas(_loc2_.DISABLE);
         }
      }
      
      private function removeFromRemoveList(param1:String) : void
      {
         var _loc3_:Array = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.itemsToRemove.length)
         {
            if(param1 == this.itemsToRemove[_loc2_])
            {
               _loc3_ = this.itemsToRemove.splice(_loc2_,1);
               this.itemsToRemove = _loc3_;
            }
            _loc2_++;
         }
      }
      
      private function setupPanDulce() : void
      {
         this.panDulceHolder = view.getChildByName("panDulceHolder") as MovieClip;
         if(ItemToMuerdagos.userHasPanDulce())
         {
            this.panDulceHolder.gotoAndStop("on");
            this.panDulceHolder.addEventListener(MouseEvent.CLICK,this.onPandulceHolder);
            api.libraries.fetch("navidad2017/props.PandulceComp",ItemToMuerdagos.getPandulceWithParams,this.panDulceHolder);
         }
         else
         {
            this.panDulceHolder.gotoAndStop("empty");
         }
      }
      
      private function addToRemoveList(param1:String) : void
      {
         this.itemsToRemove.push(param1);
      }
      
      override protected function setupShowView() : void
      {
         this.widget = new com.qb9.gaturro.view.components.canvas.impl.itemConsumer.ItemConsumerWidget(6,4,true);
         this.widget.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
         this.widget.addEventListener(ItemRendererEvent.ITEM_DESELECTED,this.onItemDeselected);
         this.selectedItems = new Dictionary();
         this.acceptBtn = view.getChildByName("recycleBtn") as MovieClip;
         this.acceptBtn.buttonMode = true;
         this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onClickAccept);
         this.amountTxt = view.getChildByName("amount") as TextField;
         this.amountTxt.text = "0";
         this.holder = view.getChildByName("ph") as MovieClip;
         this.setupPanDulce();
         this.updateItems();
         this.holder.addChild(this.widget);
      }
      
      override public function dispose() : void
      {
         this.widget = null;
         this.selectedItems = null;
         this.items = null;
         this.holder = null;
      }
      
      private function onPandulceHolder(param1:MouseEvent) : void
      {
         if(this.pdPressed)
         {
            this.panDulceHolder.gotoAndStop("on");
            this.pdPressed = false;
            this.muerdagos -= 40;
         }
         else
         {
            this.panDulceHolder.gotoAndStop("over");
            this.pdPressed = true;
            this.muerdagos += 40;
         }
         this.amountTxt.text = this.muerdagos.toString();
      }
      
      private function updateItems(param1:Event = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.items)
         {
            this.addToList(_loc2_,_loc3_);
         }
         trace("LISTA TIENE: " + _loc2_.length + " ELEMENTOS");
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_] is Array)
            {
               trace("ELEMENTO " + _loc4_ + " is Array. And is of length " + _loc2_[_loc4_].length);
            }
            trace(_loc2_[_loc4_]);
            _loc4_++;
         }
         this.widget.elements = _loc2_;
      }
      
      private function addToList(param1:Array, param2:Object) : void
      {
         var _loc5_:GaturroInventorySceneObject = null;
         var _loc3_:Array = [param2];
         var _loc4_:GaturroInventorySceneObject;
         if(_loc4_ = _loc3_[0] as GaturroInventorySceneObject)
         {
            for each(_loc5_ in _loc3_)
            {
               param1.push([_loc5_]);
            }
         }
         else
         {
            param1.push(param2);
         }
      }
      
      override public function show(param1:Object = null) : void
      {
         this.items = param1 as Array;
         super.show();
      }
   }
}
