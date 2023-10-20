package com.qb9.gaturro.user.inventory
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.requests.objects.AcquireObjectActionRequest;
   import com.qb9.gaturro.net.requests.objects.BuyObjectActionRequest;
   import com.qb9.gaturro.net.requests.objects.SellObjectActionRequest;
   import com.qb9.gaturro.net.requests.objects.SwapObjectsActionRequest;
   import com.qb9.gaturro.world.core.avatar.pet.AvatarPet;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.net.requests.inventory.DestroyInventoryObjectActionRequest;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mines.mobject.Mobject;
   import config.ItemControl;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public final class InventoryUtil
   {
      
      private static const SESSION_ITEM_ID_BASE:Number = -1;
      
      private static var sessionId:Number = SESSION_ITEM_ID_BASE;
       
      
      public function InventoryUtil()
      {
         super();
      }
      
      public static function swapObjects(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         param1 = InventoryUtil.compressItemId(param1);
         param4 = InventoryUtil.compressItemId(param4);
         var _loc6_:SwapObjectsActionRequest = new SwapObjectsActionRequest(user.username,param1,param2,param3,param4,param5);
         net.sendAction(_loc6_);
      }
      
      public static function buyObject(param1:UserAvatar, param2:String, param3:String, param4:uint = 1, param5:Number = 0) : void
      {
         if(GaturroInventory.isPocketExclusive(param2))
         {
            return;
         }
         libs.fetch(param2,doAcquireObject,{
            "t":param2,
            "c":param3,
            "a":param4,
            "i":param5,
            "av":param1
         });
      }
      
      public static function getInventory(param1:SceneObject) : GaturroInventory
      {
         return getInventoryFromAttributes(param1.attributes);
      }
      
      public static function getInventoryFromAttributes(param1:Object) : GaturroInventory
      {
         var _loc2_:String = null;
         if(param1.vehicle)
         {
            return user.visualizer;
         }
         for(_loc2_ in param1)
         {
            if(_loc2_.indexOf(ClothInventorySceneObject.PREFIX) === 0)
            {
               return user.visualizer;
            }
         }
         if(Boolean(param1.grabbable) || Boolean(param1.questItem))
         {
            return user.bag;
         }
         return user.house;
      }
      
      private static function doAcquireObject(param1:DisplayObject, param2:Object) : void
      {
         if(ItemControl.isProhibitedInAcquire(param2.t))
         {
            return;
         }
         var _loc3_:String = String(param2.t);
         if(!param1)
         {
            return logger.warning("Could not load an asset \"" + _loc3_ + "\" to give it to the user");
         }
         var _loc4_:MovieClip;
         if((_loc4_ = param1 as MovieClip).adds)
         {
            cleanAdds(param1);
         }
         if("process" in param1)
         {
            _loc4_.process();
         }
         if("created" in param1)
         {
            _loc4_.created(param2.av);
         }
         var _loc5_:CustomAttributes = new CustomAttributes();
         if("attributes" in param1)
         {
            _loc5_.mergeObject(_loc4_.attributes);
         }
         if("mergeAttrs" in param2 && param2.mergeAttrs != null)
         {
            _loc5_.mergeObject(param2.mergeAttrs);
         }
         var _loc6_:GaturroInventory;
         if(!(_loc6_ = getInventoryFromAttributes(_loc5_)).hasRoomFor(_loc3_))
         {
            return logger.warning("There is no room for a",_loc3_,"on",_loc6_.name);
         }
         var _loc7_:Boolean = "blocks" in param1 && Boolean(_loc4_.blocks);
         var _loc8_:Number = Number(Number(param2.i) || Number(user.sceneObjectId));
         if(_loc5_.session)
         {
            return _loc6_.sessionAdd(fakeInventoryObject(getNewSessionId(),_loc3_,_loc4_.sizeW,_loc4_.sizeH,_loc5_));
         }
         if("c" in param2)
         {
            net.sendAction(new BuyObjectActionRequest(_loc8_,_loc3_,param2.c,_loc7_,_loc5_.toArray(),_loc6_.name));
         }
         else
         {
            net.sendAction(new AcquireObjectActionRequest(_loc8_,_loc3_,_loc7_,_loc5_.toArray(),_loc6_.name,param2.a,""));
         }
      }
      
      public static function fakeInventoryObject(param1:Number, param2:String, param3:int, param4:int, param5:CustomAttributes) : GaturroInventorySceneObject
      {
         var _loc6_:GaturroInventorySceneObject = createInventoryObject(param5);
         var _loc7_:Mobject;
         (_loc7_ = new Mobject()).setString("id",String(param1));
         _loc7_.setString("name",param2);
         _loc7_.setIntegerArray("size",[param3,param4]);
         _loc6_.buildFromMobject(_loc7_);
         return _loc6_;
      }
      
      private static function getNewSessionId() : Number
      {
         return sessionId--;
      }
      
      public static function explodeItemId(param1:String, param2:int) : String
      {
         return (Number(param1) * 1000 + param2).toString();
      }
      
      public static function compressItemId(param1:String) : String
      {
         var _loc2_:int = int(param1.substr(param1.length - 3));
         return ((Number(param1) - _loc2_) / 1000).toString();
      }
      
      public static function acquireObject(param1:UserAvatar, param2:String, param3:uint = 1, param4:Number = 0, param5:String = "", param6:Object = null) : void
      {
         if(GaturroInventory.isPocketExclusive(param2))
         {
            return;
         }
         libs.fetch(param2,doAcquireObject,{
            "t":param2,
            "a":param3,
            "i":param4,
            "av":param1,
            "gc":param5,
            "mergeAttrs":param6
         });
      }
      
      public static function sellObject(param1:String, param2:int) : void
      {
         var _loc3_:String = InventoryUtil.compressItemId(param1);
         net.sendAction(new SellObjectActionRequest(Number(_loc3_),param2));
      }
      
      public static function removeQuestItems(param1:Array) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:GaturroInventorySceneObject = null;
         var _loc2_:int = int(param1.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = param1[_loc2_] as Array;
            if(_loc3_)
            {
               removeQuestItems(_loc3_);
               if(!_loc3_.length)
               {
                  param1.splice(_loc2_,1);
               }
            }
            else if((Boolean(_loc4_ = param1[_loc2_] as GaturroInventorySceneObject)) && _loc4_.questItem)
            {
               param1.splice(_loc2_,1);
            }
            _loc2_--;
         }
         return param1;
      }
      
      private static function cleanAdds(param1:Object) : void
      {
         var _loc3_:String = null;
         for(_loc3_ in param1.adds)
         {
            api.trackEvent("DEBUG:CONSUMABLE:ADDS_1",_loc3_);
         }
      }
      
      public static function removeAll(param1:String = "") : int
      {
         var _loc3_:InventorySceneObject = null;
         var _loc4_:Number = NaN;
         var _loc2_:uint = 0;
         for each(_loc3_ in user.allItems)
         {
            if(!(param1 != "" && _loc3_.name !== param1))
            {
               _loc2_++;
               _loc4_ = Number(InventoryUtil.compressItemId(_loc3_.id.toString()));
               net.sendAction(new DestroyInventoryObjectActionRequest(_loc4_));
            }
         }
         return _loc2_;
      }
      
      public static function createInventoryObject(param1:CustomAttributes) : GaturroInventorySceneObject
      {
         var _loc2_:String = null;
         if("petLove" in param1)
         {
            return new PetToySceneObject(param1);
         }
         if("petCleanliness" in param1)
         {
            return new PetCareSceneObject(param1);
         }
         if("petEnergy" in param1)
         {
            return new PetFoodSceneObject(param1);
         }
         if(param1.vehicle)
         {
            return new TransportInventorySceneObject(param1);
         }
         if("attr_pet_petType" in param1)
         {
            return new PetInventorySceneObject(param1);
         }
         for(_loc2_ in param1)
         {
            if(_loc2_.indexOf(ClothInventorySceneObject.PREFIX) === 0)
            {
               return new ClothInventorySceneObject(param1);
            }
            if(_loc2_.indexOf(UsableInventorySceneObject.PREFIX) === 0)
            {
               if(_loc2_.indexOf(AvatarPet.PREFIX) !== -1)
               {
                  return new PetInventorySceneObject(param1);
               }
               if(param1.uses)
               {
                  return new ConsumableInventorySceneObject(param1);
               }
               return new UsableInventorySceneObject(param1);
            }
         }
         return new GaturroInventorySceneObject(param1);
      }
   }
}
