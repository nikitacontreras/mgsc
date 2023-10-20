package com.qb9.gaturro.world.tiling
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.view.world.elements.GaturroRoomSceneObjectView;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.mambo.net.requests.customAttributes.UpdateSceneObjectCustomAttributesRequest;
   import com.qb9.mambo.view.world.elements.RoomSceneObjectView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import config.HouseConfig;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class StackingHomeObjects
   {
       
      
      private const SEPARATOR:String = ";";
      
      public function StackingHomeObjects()
      {
         super();
      }
      
      private function isStackeableObject(param1:RoomSceneObject, param2:RoomSceneObjectView) : Boolean
      {
         if(!(param1 is RoomSceneObject) && !(param1 is NpcRoomSceneObject))
         {
            return false;
         }
         if(!this.checkSize(param2))
         {
            return false;
         }
         if(!this.checkHolder(param2))
         {
            return false;
         }
         return true;
      }
      
      public function checkObjectStacking(param1:Object) : Boolean
      {
         if(!this.isStackeableObject(param1.item,param1.itemView))
         {
            return false;
         }
         if(!param1.container)
         {
            return false;
         }
         if(param1.container.attributes.slots == null)
         {
            return false;
         }
         var _loc2_:int = this.getEmptySlotNum(param1.container.attributes.slots);
         if(_loc2_ <= 0)
         {
            return false;
         }
         if(!this.getSlot(param1.containerView,_loc2_))
         {
            return false;
         }
         return true;
      }
      
      private function saveSlotsAttribute(param1:RoomSceneObject, param2:String) : void
      {
         if(param1.id < 50)
         {
            return;
         }
         param1.attributes.slots = param2;
         net.sendAction(new UpdateSceneObjectCustomAttributesRequest(param1.id,param1.attributes.toArray()));
      }
      
      private function stackObject(param1:DisplayObject, param2:DisplayObject, param3:int, param4:DisplayObject) : void
      {
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         DisplayObjectContainer(param4).addChild(param1);
         param2.parent.setChildIndex(param2,0);
      }
      
      private function checkSize(param1:RoomSceneObjectView) : Boolean
      {
         var _loc2_:GaturroRoomSceneObjectView = null;
         var _loc3_:NpcRoomSceneObjectView = null;
         if(param1 is GaturroRoomSceneObjectView)
         {
            _loc2_ = GaturroRoomSceneObjectView(param1);
            return _loc2_.assetSize.x == 1 && _loc2_.assetSize.y == 1;
         }
         if(param1 is NpcRoomSceneObjectView)
         {
            _loc3_ = NpcRoomSceneObjectView(param1);
            return _loc3_.assetSize.x == 1 && _loc3_.assetSize.y == 1;
         }
         return false;
      }
      
      private function getObjectKey(param1:RoomSceneObject) : String
      {
         var _loc2_:String = "";
         var _loc3_:String = String(param1.name.split(".")[0]);
         var _loc4_:String;
         if((_loc4_ = String(param1.name.split(".")[1])) == null)
         {
            return "";
         }
         _loc2_ += _loc3_.substr(0,2);
         _loc2_ += _loc4_.substr(0,2);
         if(_loc4_.length >= 18)
         {
            _loc2_ += _loc4_.substr(int(_loc4_.length / 2) - 1,2);
         }
         var _loc5_:int = _loc4_.length >= 10 ? _loc4_.length - 8 : 2;
         return _loc2_ + _loc4_.substr(_loc5_,8);
      }
      
      public function checkSlotsAttribute(param1:RoomSceneObject, param2:DisplayObject) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         if(!(param2 is GaturroRoomSceneObjectView))
         {
            return;
         }
         var _loc3_:DisplayObjectContainer = GaturroRoomSceneObjectView(param2).mc;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:int = 0;
         while(_loc3_.getChildByName("slot" + (_loc4_ + 1).toString()))
         {
            _loc4_++;
         }
         if(_loc4_ == 0)
         {
            return;
         }
         if(param1 && param1.attributes.slots == null || _loc4_ > 1 && param1.attributes.slots == "")
         {
            _loc5_ = "";
            _loc6_ = 0;
            while(_loc6_ < _loc4_ - 1)
            {
               _loc5_ += this.SEPARATOR;
               _loc6_++;
            }
            this.saveSlotsAttribute(param1,_loc5_);
         }
      }
      
      private function getEmptySlotNum(param1:String) : int
      {
         var _loc2_:Array = param1.split(this.SEPARATOR);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] == "" || _loc2_[_loc3_] == "0")
            {
               return _loc3_ + 1;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function checkHolder(param1:RoomSceneObjectView) : Boolean
      {
         var _loc2_:GaturroRoomSceneObjectView = null;
         if(param1 is GaturroRoomSceneObjectView)
         {
            _loc2_ = GaturroRoomSceneObjectView(param1);
            if(_loc2_.mc != null && _loc2_.mc.container != null)
            {
               return false;
            }
         }
         return true;
      }
      
      public function updateStackObjects(param1:TwoWayLink, param2:GaturroTile, param3:Boolean = false) : void
      {
         var _loc8_:String = null;
         var _loc12_:RoomSceneObject = null;
         var _loc13_:Boolean = false;
         var _loc14_:RoomSceneObject = null;
         var _loc15_:String = null;
         var _loc16_:DisplayObject = null;
         var _loc17_:int = 0;
         var _loc18_:DisplayObject = null;
         var _loc19_:int = 0;
         if(!HouseConfig.data.enabled)
         {
            return;
         }
         var _loc4_:RoomSceneObject = param2.container;
         var _loc5_:RoomSceneObjectView = param1.getItem(_loc4_) as RoomSceneObjectView;
         if(!_loc4_ || !_loc5_)
         {
            return;
         }
         var _loc6_:String = String(_loc4_.attributes.slots);
         var _loc7_:Array = _loc4_.attributes.slots.split(this.SEPARATOR);
         var _loc9_:Array = param2.children.slice();
         var _loc10_:int = 0;
         while(_loc10_ < _loc7_.length)
         {
            _loc13_ = false;
            for each(_loc14_ in _loc9_)
            {
               if((_loc8_ = this.getObjectKey(_loc14_)) != "")
               {
                  if(_loc7_[_loc10_] == this.getObjectKey(_loc14_))
                  {
                     if((_loc15_ = DisplayObject(param1.getItem(_loc14_)).parent.name).substr(0,4) != "slot" || _loc15_ == "slot" + (_loc10_ + 1).toString())
                     {
                        _loc13_ = true;
                        break;
                     }
                  }
               }
            }
            if(_loc13_)
            {
               ArrayUtil.removeElement(_loc9_,_loc14_);
            }
            else
            {
               _loc7_[_loc10_] = "";
            }
            _loc10_++;
         }
         var _loc11_:Array = new Array();
         for each(_loc12_ in param2.children)
         {
            if(_loc12_ != _loc4_)
            {
               if((_loc8_ = this.getObjectKey(_loc12_)) != "")
               {
                  if(_loc16_ = param1.getItem(_loc12_) as DisplayObject)
                  {
                     if(this.isStackeableObject(_loc12_,RoomSceneObjectView(_loc16_)))
                     {
                        _loc16_.y = 0;
                        _loc16_.x = 0;
                        _loc18_ = null;
                        _loc19_ = 0;
                        while(_loc19_ < _loc7_.length)
                        {
                           if(_loc7_[_loc19_] == _loc8_ && ArrayUtil.contains(_loc11_,_loc19_ + 1) == false)
                           {
                              _loc17_ = _loc19_ + 1;
                              _loc11_.push(_loc17_);
                              _loc18_ = this.getSlot(_loc5_,_loc17_);
                              break;
                           }
                           _loc19_++;
                        }
                        if(!_loc18_)
                        {
                           _loc17_ = this.getEmptySlotNum(this.getSlotsInString(_loc7_));
                           if(_loc18_ = this.getSlot(_loc5_,_loc17_))
                           {
                              _loc7_[_loc17_ - 1] = this.getObjectKey(_loc12_);
                           }
                        }
                        if(_loc18_)
                        {
                           this.stackObject(_loc16_,_loc5_,_loc17_,_loc18_);
                        }
                     }
                  }
               }
            }
         }
         if(param3 && _loc6_ != this.getSlotsInString(_loc7_))
         {
            this.saveSlotsAttribute(_loc4_,this.getSlotsInString(_loc7_));
         }
      }
      
      private function getSlot(param1:Object, param2:int) : DisplayObject
      {
         if(!(param1 is GaturroRoomSceneObjectView))
         {
            return null;
         }
         var _loc3_:DisplayObjectContainer = GaturroRoomSceneObjectView(param1).mc;
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:DisplayObject;
         if(!(_loc4_ = _loc3_.getChildByName("slot" + param2.toString())))
         {
            return null;
         }
         return _loc4_;
      }
      
      private function getSlotsInString(param1:Array) : String
      {
         var _loc4_:String = null;
         var _loc2_:String = "";
         var _loc3_:int = 0;
         for each(_loc4_ in param1)
         {
            if(_loc3_ > 0)
            {
               _loc2_ += this.SEPARATOR;
            }
            _loc2_ += _loc4_;
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
