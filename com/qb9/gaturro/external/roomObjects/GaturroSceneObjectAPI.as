package com.qb9.gaturro.external.roomObjects
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.external.base.BaseGaturroAPI;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.view.minigames.QueueModalEvent;
   import com.qb9.gaturro.view.world.chat.ChatViewEvent;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.HolderRoomSceneObject;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.requests.customAttributes.BaseUpdateCustomAttributesRequest;
   import com.qb9.mambo.net.requests.room.DestroyRoomObjectActionRequest;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.elements.MovingRoomSceneObject;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public final class GaturroSceneObjectAPI extends BaseGaturroAPI implements IDisposable
   {
       
      
      private var _view:DisplayObject;
      
      private var room:GaturroRoom;
      
      private var _sceneObject:SceneObject;
      
      public function GaturroSceneObjectAPI(param1:SceneObject, param2:DisplayObject, param3:GaturroRoom)
      {
         super();
         this.room = param3;
         this._sceneObject = param1;
         this._view = param2;
      }
      
      public function get config() : Object
      {
         return settings;
      }
      
      public function giveUser(param1:String, param2:uint = 1, param3:String = null) : void
      {
         if(param3)
         {
            InventoryUtil.buyObject(this.userAvatar,param1,param3,param2,this.object.id);
         }
         else
         {
            InventoryUtil.acquireObject(this.userAvatar,param1,param2,this.object.id);
         }
      }
      
      public function get userAvatar() : UserAvatar
      {
         return this.room.userAvatar;
      }
      
      public function destroyItem() : void
      {
         net.sendAction(new DestroyRoomObjectActionRequest(this.object.id));
      }
      
      public function teleportTo(param1:Coord) : void
      {
         this.object.placeAt(param1);
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this.view.mouseEnabled = this.view.mouseChildren = param1;
      }
      
      public function setState(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = this.mc;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:String = param1 as String;
         var _loc5_:Sprite = _loc3_.getChildByName("ph") as Sprite;
         var _loc6_:int = !!_loc4_ ? _loc4_.indexOf(".") : -1;
         if(Boolean(_loc5_) && _loc6_ !== -1)
         {
            DisplayUtil.empty(_loc5_);
            libs.fetch(_loc4_.slice(_loc6_ + 1),this.addToPh,_loc5_);
            param1 = _loc4_.slice(0,_loc6_);
         }
         if(param2)
         {
            _loc3_.gotoAndPlay(param1);
         }
         else
         {
            _loc3_.gotoAndStop(param1);
         }
      }
      
      public function destroySceneObject(param1:Number) : void
      {
         net.sendAction(new DestroyRoomObjectActionRequest(param1));
      }
      
      private function addToPh(param1:DisplayObject, param2:Sprite) : void
      {
         if(param1)
         {
            param2.addChild(param1);
         }
      }
      
      private function matches(param1:InventorySceneObject, param2:String) : Boolean
      {
         return param2.slice(-1) === "*" ? param1.name.indexOf(param2.slice(0,-1)) === 0 : param1.name === param2;
      }
      
      private function get mc() : MovieClip
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in DisplayUtil.children(this.view))
         {
            if(_loc1_ is MovieClip)
            {
               break;
            }
         }
         return _loc1_ as MovieClip;
      }
      
      public function setAttribute(param1:String, param2:Object) : void
      {
         this._sceneObject.attributes[param1] = param2;
      }
      
      public function takeFromUserWithItem(param1:String, param2:int = 1) : InventorySceneObject
      {
         var _loc3_:GaturroInventory = null;
         var _loc4_:InventorySceneObject = null;
         for each(_loc3_ in user.inventories)
         {
            for each(_loc4_ in _loc3_.items)
            {
               if(this.matches(_loc4_,param1))
               {
                  _loc3_.remove(_loc4_.id);
                  if(--param2 === 0)
                  {
                     return _loc4_;
                  }
               }
            }
         }
         return null;
      }
      
      public function callFunction(param1:String, param2:Object = null) : void
      {
         if(param1 in this.mc)
         {
            if(param2)
            {
               this.mc[param1](param2);
            }
            else
            {
               this.mc[param1]();
            }
         }
      }
      
      public function dispose() : void
      {
         this._sceneObject = null;
         this._view = null;
      }
      
      public function setAttributePersist(param1:String, param2:Object) : void
      {
         this.setAttribute(param1,param2);
         net.sendAction(new BaseUpdateCustomAttributesRequest("sceneObjectId",this.sceneObjectId,[new CustomAttribute(param1,param2)]));
      }
      
      public function hasAttribute(param1:String) : Boolean
      {
         if(this._sceneObject.attributes[param1] == null)
         {
            return false;
         }
         return true;
      }
      
      public function get view() : Sprite
      {
         return this._view as Sprite;
      }
      
      public function getAttribute(param1:String) : Object
      {
         return this._sceneObject.attributes[param1];
      }
      
      public function openQueue(param1:String, param2:String = null, param3:int = 0) : void
      {
         this.view.dispatchEvent(new QueueModalEvent(QueueModalEvent.OPEN,param1,param2,param3));
      }
      
      public function getState() : String
      {
         var _loc1_:MovieClip = this.mc;
         return !!_loc1_ ? _loc1_.currentLabel : "";
      }
      
      public function say(param1:String) : void
      {
         this.view.dispatchEvent(new ChatViewEvent(ChatViewEvent.SAY,region.getText(param1)));
      }
      
      public function get sceneObjectId() : int
      {
         return this.object.id;
      }
      
      public function flop() : void
      {
         this.view.scaleY *= -1;
      }
      
      public function stopMoving() : void
      {
         if(this.object is MovingRoomSceneObject)
         {
            MovingRoomSceneObject(this.object).stopMoving();
         }
         else
         {
            warning("Cannot stop sceneObject",this.object.name);
         }
      }
      
      public function userHasItems(param1:String, param2:int = 1) : Boolean
      {
         var _loc3_:InventorySceneObject = null;
         for each(_loc3_ in user.allItems)
         {
            if(this.matches(_loc3_,param1) && --param2 === 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function moveTo(param1:Coord) : void
      {
         if(this.object is MovingRoomSceneObject)
         {
            MovingRoomSceneObject(this.object).moveTo(param1);
         }
         else
         {
            warning("Cannot move sceneObject",this.object.name);
         }
      }
      
      public function flip() : void
      {
         this.view.scaleX *= -1;
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.view.visible = param1;
      }
      
      public function takeFromUser(param1:String, param2:int = 1) : void
      {
         var _loc3_:GaturroInventory = null;
         var _loc4_:InventorySceneObject = null;
         for each(_loc3_ in user.inventories)
         {
            for each(_loc4_ in _loc3_.items)
            {
               if(this.matches(_loc4_,param1))
               {
                  _loc3_.remove(_loc4_.id);
                  if(--param2 === 0)
                  {
                     return;
                  }
               }
            }
         }
      }
      
      public function holderFull() : Boolean
      {
         if(!this.object is HolderRoomSceneObject)
         {
            return false;
         }
         return (this.object as HolderRoomSceneObject).full;
      }
      
      public function get object() : RoomSceneObject
      {
         return this._sceneObject as RoomSceneObject;
      }
   }
}
