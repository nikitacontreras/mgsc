package com.qb9.gaturro.view.gui.base.inventory
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.utils.MovieUtil;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModalOpener;
   import com.qb9.mambo.user.inventory.events.InventoryEvent;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BaseGuiInventoryButton extends BaseGuiModalOpener
   {
       
      
      protected var inventory:GaturroInventory;
      
      protected var tasks:TaskContainer;
      
      private var busy:Boolean = false;
      
      public function BaseGuiInventoryButton(param1:Gui, param2:Sprite, param3:TaskContainer, param4:GaturroInventory, param5:Number = 0, param6:Number = 390)
      {
         super(param1,param2,param5,param6);
         this.tasks = param3;
         this.inventory = param4;
         this.init();
      }
      
      protected function get counter() : MovieClip
      {
         return asset.getChildByName("counter") as MovieClip;
      }
      
      private function resetBusy() : void
      {
         this.busy = false;
      }
      
      protected function whenANewItemIsAdded(param1:InventoryEvent) : void
      {
         if(this.busy)
         {
            return;
         }
         this.busy = true;
         libs.fetch(param1.object.name,this.addItem,param1.object);
      }
      
      private function initCounter() : void
      {
         this.counter.visible = false;
      }
      
      protected function init() : void
      {
         this.inventory.addEventListener(InventoryEvent.ITEM_ADDED,this.whenANewItemIsAdded);
         if(this.counter)
         {
            this.initCounter();
         }
      }
      
      protected function addItem(param1:DisplayObject, param2:Object = null) : void
      {
         if(!this.tasks || !param1)
         {
            return this.resetBusy();
         }
         audio.addLazyPlay("popdown");
         param1.x = asset.width / 2;
         var _loc3_:Number = asset.height / 2;
         param1.y = _loc3_ - 40;
         param1.scaleX = param1.scaleY = 2;
         if(param2 != null && "refreshCustomAttributes" in param1 && "attributes" in param2)
         {
            param1["refreshCustomAttributes"](param2["attributes"]);
         }
         asset.addChild(param1);
         this.tasks.add(new Sequence(new Tween(param1,600,{
            "y":_loc3_,
            "scaleX":0.2,
            "scaleY":0.2
         },{"transition":"easeIn"}),new Func(asset.removeChild,param1),new Func(this.resetBusy)));
         if(Boolean(mc) && MovieUtil.hasLabel(mc,"on"))
         {
            mc.gotoAndPlay("on");
         }
      }
      
      private function updateCounter(param1:Event = null) : void
      {
         var _loc2_:Array = !!settings.inventory.stack ? this.inventory.itemsStacked : this.inventory.items;
         var _loc3_:int = int(_loc2_.length);
         this.counter.text.text = _loc3_.toString();
         this.counter.visible = _loc3_ > 0;
      }
      
      override public function dispose() : void
      {
         this.inventory.removeEventListener(InventoryEvent.ITEM_ADDED,this.updateCounter);
         this.inventory.removeEventListener(InventoryEvent.ITEM_REMOVED,this.updateCounter);
         this.inventory.removeEventListener(InventoryEvent.ITEM_ADDED,this.whenANewItemIsAdded);
         this.inventory = null;
         this.tasks = null;
         super.dispose();
      }
   }
}
