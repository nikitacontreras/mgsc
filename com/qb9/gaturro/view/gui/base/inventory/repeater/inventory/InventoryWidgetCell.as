package com.qb9.gaturro.view.gui.base.inventory.repeater.inventory
{
   import assets.InventoryButtonMC;
   import assets.InventoryCarButtonMC;
   import assets.MissingAssetMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import com.qb9.gaturro.world.core.avatar.ownednpc.OwnedNpcFactory;
   import com.qb9.gaturro.world.core.elements.GaturroRoomSceneObject;
   import com.qb9.mambo.core.objects.SceneObject;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public final class InventoryWidgetCell extends MovieClip implements IDisposable
   {
       
      
      private var items:Array;
      
      private var _buttonClip;
      
      private var count:Boolean = true;
      
      private var ph:MovieClip;
      
      private var _selected:Boolean;
      
      private var counter:MovieClip;
      
      public function InventoryWidgetCell(param1:Boolean = false, param2:* = null)
      {
         this.items = [];
         this._buttonClip = new InventoryButtonMC();
         super();
         if(param2 != null)
         {
            this._buttonClip = param2;
         }
         this.counter = this._buttonClip.counter;
         this.ph = this._buttonClip.ph;
         buttonMode = true;
         this.addChild(this._buttonClip);
         this.disable(this.ph);
         this.disable(this.counter);
         this.counter.visible = false;
      }
      
      private function delay(param1:DisplayObject) : void
      {
         this.add(param1);
      }
      
      private function update() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = this.items.length;
         visible = _loc1_ > 0;
         if(visible)
         {
            this.counter.text.text = _loc1_.toString();
            this.counter.visible = this.count && _loc1_ > 1;
         }
      }
      
      public function get item() : SceneObject
      {
         return !!this.items ? this.items[0] as SceneObject : null;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      private function reposition(param1:DisplayObject) : void
      {
         GuiUtil.fit(param1,35,35,10,4);
      }
      
      public function dispose() : void
      {
         this.items = null;
      }
      
      private function add(param1:DisplayObject) : void
      {
         if(this._buttonClip is InventoryCarButtonMC)
         {
            this.ph.scaleX = 5;
            this.ph.scaleY = 5;
         }
         DisplayUtil.empty(this.ph);
         param1 ||= new MissingAssetMC();
         this.reposition(param1);
         this.ph.addChild(param1);
         if(Boolean(this.item) && (OwnedNpcFactory.isOwnedNpcItem(this.item) || this.item.attributes && this.item.attributes["availableOnRoomId"] != null))
         {
            if("acquireAPI" in param1)
            {
               Object(param1).acquireAPI(api);
            }
            if("acquireObjectAPI" in param1)
            {
               Object(param1).acquireObjectAPI(new GaturroSceneObjectAPI(this.item,param1,api.room));
            }
         }
      }
      
      private function disable(param1:DisplayObjectContainer) : void
      {
         param1.mouseEnabled = false;
         param1.mouseChildren = false;
      }
      
      private function addToEmblem(param1:DisplayObject) : void
      {
         GuiUtil.fit(param1,20,20);
         this._buttonClip.emblemPh.addChild(param1);
      }
      
      public function dropOne(param1:Boolean = false) : void
      {
         this.items.shift();
         if(!param1 || this.items.length > 1)
         {
            this.update();
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         this._buttonClip.gotoAndStop(param1 ? 2 : 1);
      }
      
      public function setItems(param1:Array) : void
      {
         var _loc2_:GaturroRoomSceneObject = null;
         var _loc3_:GaturroInventorySceneObject = null;
         this.items = !!param1 ? param1.concat() : [];
         this.update();
         if(this.item)
         {
            libs.fetch(this.item.name,this.delay);
         }
         if(this.item is GaturroRoomSceneObject)
         {
            _loc2_ = this.item as GaturroRoomSceneObject;
            if(_loc2_.hasData && Boolean(_loc2_.dataByKey("emblema")))
            {
               libs.fetch(_loc2_.dataByKey("emblema"),this.addToEmblem);
            }
         }
         if(this.item is GaturroInventorySceneObject)
         {
            _loc3_ = this.item as GaturroInventorySceneObject;
            if(_loc3_.hasData && Boolean(_loc3_.dataByKey("emblema")))
            {
               libs.fetch(_loc3_.dataByKey("emblema"),this.addToEmblem);
            }
         }
      }
   }
}
