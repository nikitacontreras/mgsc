package com.qb9.gaturro.world.core.avatar.ownednpc
{
   import com.qb9.flashlib.math.Random;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.mambo.core.attributes.CustomAttributeHolder;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mines.mobject.Mobject;
   import config.AttributeControl;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class OwnedNpcFactory
   {
      
      private static const SEPARATOR:String = ";";
      
      public static const OWNED_NPC_BEHAVIOR_ATTR:String = "behaviorOwnedNpc";
      
      private static const ASIGNATION:String = "=";
      
      public static const OWNED_NPC_ID_ATTR:String = "ownedNpcId";
      
      private static const CA_SEPARATOR:String = ",";
      
      public static const OWNED_NPC_NAME_ATTR:String = "nameOwnedNpc";
       
      
      public function OwnedNpcFactory()
      {
         super();
      }
      
      public static function addAssetByItem(param1:GaturroInventorySceneObject, param2:DisplayObjectContainer) : void
      {
         libs.fetch(param1.attributes[OWNED_NPC_NAME_ATTR],addOwnedNpc,{
            "item":param1,
            "parent":param2
         });
      }
      
      private static function get nameIndex() : int
      {
         return 1;
      }
      
      private static function isValidPet(param1:Array) : Boolean
      {
         var _loc2_:String = String(param1[nameIndex]);
         var _loc3_:String = String(param1[behaviorIndex]);
         var _loc4_:String = String(param1[attrIndex]);
         if(AttributeControl.isProhibitedAsPet(_loc2_))
         {
            return false;
         }
         return true;
      }
      
      public static function emptyOwnedNpcToHolder(param1:CustomAttributeHolder) : void
      {
         param1.attributes[Gaturro.OWNED_NPC_USER_ATTR] = "";
      }
      
      private static function get magicIdIndex() : int
      {
         return 0;
      }
      
      private static function get behaviorIndex() : int
      {
         return 2;
      }
      
      private static function get attrIndex() : int
      {
         return 3;
      }
      
      public static function emptyOwnedNpc() : void
      {
         emptyOwnedNpcToHolder(api.userAvatar);
      }
      
      public static function isThisOwnedNpcActive(param1:CustomAttributeHolder, param2:InventorySceneObject) : Boolean
      {
         var _loc3_:String = String(param1.attributes[Gaturro.OWNED_NPC_USER_ATTR]);
         if(!_loc3_)
         {
            return false;
         }
         var _loc4_:Array = _loc3_.split(SEPARATOR);
         var _loc5_:String = String(_loc4_[magicIdIndex]);
         var _loc6_:Number = Number(param2.attributes[OWNED_NPC_ID_ATTR]);
         if(_loc5_ == _loc6_.toString())
         {
            return true;
         }
         return false;
      }
      
      public static function getItemActive() : GaturroInventorySceneObject
      {
         var _loc4_:GaturroInventorySceneObject = null;
         var _loc5_:Number = NaN;
         var _loc1_:String = String(api.userAvatar.attributes[Gaturro.OWNED_NPC_USER_ATTR]);
         if(!_loc1_ || StringUtil.trim(_loc1_) == "")
         {
            return null;
         }
         var _loc2_:Array = _loc1_.split(SEPARATOR);
         var _loc3_:String = String(_loc2_[magicIdIndex]);
         for each(_loc4_ in user.house.items)
         {
            if((_loc5_ = Number(_loc4_.attributes[OWNED_NPC_ID_ATTR])).toString() == _loc3_)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public static function activeOwnedNpc(param1:CustomAttributeHolder, param2:GaturroInventorySceneObject) : void
      {
         var _loc6_:Object = null;
         var _loc3_:Number = Number(param2.attributes[OWNED_NPC_ID_ATTR]);
         var _loc4_:String = _loc3_.toString() + SEPARATOR + param2.attributes[OWNED_NPC_NAME_ATTR] + SEPARATOR + param2.attributes[OWNED_NPC_BEHAVIOR_ATTR] + SEPARATOR;
         var _loc5_:int = 0;
         for each(_loc6_ in param2.attributes.toArray())
         {
            if(!(_loc6_.key == "monitorAttributes" || _loc6_.key == OWNED_NPC_ID_ATTR || _loc6_.key == OWNED_NPC_NAME_ATTR || _loc6_.key == OWNED_NPC_BEHAVIOR_ATTR))
            {
               if(_loc5_ > 0)
               {
                  _loc4_ += CA_SEPARATOR;
               }
               _loc4_ += _loc6_.key + ASIGNATION + _loc6_.value;
               _loc5_++;
            }
         }
         param1.attributes[Gaturro.OWNED_NPC_USER_ATTR] = _loc4_;
      }
      
      public static function createOwnedNpcMo(param1:String, param2:Avatar) : Mobject
      {
         var _loc10_:Mobject = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         if(!param1 || StringUtil.trim(param1) == "")
         {
            return null;
         }
         var _loc3_:Array = param1.split(SEPARATOR);
         if(!isValidPet(_loc3_))
         {
            return null;
         }
         var _loc4_:String = String(_loc3_[magicIdIndex]);
         var _loc5_:String = String(_loc3_[nameIndex]);
         var _loc6_:String = String(_loc3_[behaviorIndex]);
         var _loc7_:String = String(_loc3_[attrIndex]);
         var _loc8_:Mobject = new Mobject();
         var _loc9_:Array = new Array();
         (_loc10_ = new Mobject()).setString("type","behavior");
         _loc10_.setString("data",_loc6_);
         _loc9_.push(_loc10_);
         (_loc10_ = new Mobject()).setString("type","type");
         _loc10_.setString("data",_loc5_);
         _loc9_.push(_loc10_);
         for each(_loc11_ in _loc7_.split(CA_SEPARATOR))
         {
            if(_loc11_.indexOf(ASIGNATION) > -1)
            {
               _loc12_ = String(_loc11_.split(ASIGNATION)[0]);
               _loc13_ = String(_loc11_.split(ASIGNATION)[1]);
               if(!(_loc12_ == "monitorAttributes" || _loc12_ == "behavior" || _loc12_ == OWNED_NPC_NAME_ATTR || _loc12_ == OWNED_NPC_BEHAVIOR_ATTR))
               {
                  if(Boolean(_loc12_) && _loc12_ != "")
                  {
                     _loc13_ = !_loc13_ ? "" : _loc13_;
                     (_loc10_ = new Mobject()).setString("type",_loc12_);
                     _loc10_.setString("data",_loc13_);
                     _loc9_.push(_loc10_);
                  }
               }
            }
         }
         _loc8_.setBoolean("ownedNPC",true);
         _loc8_.setString("owner",param2.username);
         _loc8_.setString("id",String(-param2.id - Random.randint(1,2000)));
         _loc8_.setBoolean("blockingHint",false);
         _loc8_.setInteger("direction",0);
         _loc8_.setString("name",_loc5_);
         _loc8_.setIntegerArray("size",[1,1]);
         _loc8_.setIntegerArray("coord",[param2.coord.x,param2.coord.y,0]);
         _loc8_.setMobjectArray("customAttributes",_loc9_);
         return _loc8_;
      }
      
      public static function isOwnedNpcItem(param1:CustomAttributeHolder) : Boolean
      {
         if(!param1.attributes)
         {
            return false;
         }
         var _loc2_:String = String(param1.attributes[OWNED_NPC_NAME_ATTR]);
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            return true;
         }
         return false;
      }
      
      private static function addOwnedNpc(param1:DisplayObject, param2:Object) : void
      {
         var _loc5_:Object = null;
         var _loc3_:GaturroInventorySceneObject = param2.item;
         var _loc4_:DisplayObjectContainer = param2.parent;
         param1["acquireAPI"](api);
         for each(_loc5_ in _loc3_.attributes.toArray())
         {
            if(_loc5_.key == "pet_hats" || _loc5_.key == "pet_accesories" || _loc5_.key == "pet_neck" || _loc5_.key == "pet_color" || _loc5_.key == "color1" || _loc5_.key == "color2" || _loc5_.key == "color3" || _loc5_.key == "color4" || _loc5_.key == "pet_arm" || _loc5_.key == "pet_leg" || _loc5_.key == "pet_cloth")
            {
               if(Boolean(_loc5_.value) && _loc5_.value != "")
               {
                  param1["changeObject"](_loc5_.key,_loc5_.value);
               }
            }
         }
         _loc4_.addChild(param1);
      }
   }
}
