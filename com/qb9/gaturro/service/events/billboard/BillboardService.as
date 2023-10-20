package com.qb9.gaturro.service.events.billboard
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.net.requests.customAttributes.BaseUpdateCustomAttributesRequest;
   
   public class BillboardService
   {
       
      
      private var soContainer:String = "";
      
      private var attributeKeyPrefix:String = "party_";
      
      private const MAX_SLOTS:int = 24;
      
      private var slots:Array;
      
      private var containerDefinitions:Array;
      
      public function BillboardService()
      {
         this.containerDefinitions = ["fiesta.tablon_so","gatubers/props.tablon_so"];
         super();
         this.slots = [];
         var _loc1_:int = 0;
         while(_loc1_ < this.MAX_SLOTS)
         {
            this.slots[_loc1_] = {};
            _loc1_++;
         }
      }
      
      private function debug() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.MAX_SLOTS)
         {
            if(this.slots[_loc1_].pd)
            {
               logger.info(this,_loc1_,(this.slots[_loc1_].pd as EventData).asJSONString());
            }
            else
            {
               logger.info(this,_loc1_,"is null");
            }
            _loc1_++;
         }
      }
      
      private function dbwrite(param1:EventData, param2:int, param3:GaturroRoom) : void
      {
         var _loc4_:SceneObject = null;
         var _loc5_:CustomAttribute = null;
         this.searchForContainer(param3);
         for each(_loc4_ in param3.sceneObjects)
         {
            if(_loc4_.name == this.soContainer)
            {
               _loc5_ = new CustomAttribute(this.attributeKeyPrefix + param2.toString(),param1.asJSONString());
               _loc4_.attributes.mergeAttributesArray([_loc5_]);
               net.sendAction(new BaseUpdateCustomAttributesRequest("sceneObjectId",_loc4_.id,_loc4_.attributes.toArray()));
            }
         }
      }
      
      private function addEventAtSlot(param1:Object, param2:int, param3:GaturroRoom) : void
      {
         var _loc4_:EventData = EventData.fromObject(param1);
         this.slots[param2].pd = _loc4_;
         logger.debug(this,"addEventAtSlot",param1,param2,param3);
         this.dbwrite(_loc4_,this.slots[param2].idx,param3);
      }
      
      public function getActiveEvents() : Array
      {
         var _loc2_:Object = null;
         this.retrieveDataFromBillboard(api.room);
         this.disposeFinishedEvents();
         this.sortSlots();
         var _loc1_:Array = [];
         for each(_loc2_ in this.slots)
         {
            if(_loc2_.pd)
            {
               logger.debug(this,"getActiveEvents",_loc2_.pd);
               _loc1_.push(_loc2_.pd);
            }
         }
         return _loc1_;
      }
      
      private function searchForContainer(param1:GaturroRoom) : void
      {
         var _loc2_:SceneObject = null;
         for each(_loc2_ in param1.sceneObjects)
         {
            if(this.containerDefinitions.indexOf(_loc2_.name) != -1)
            {
               this.soContainer = _loc2_.name;
               return;
            }
         }
      }
      
      private function addPartyAtEmptySlot(param1:Object, param2:GaturroRoom) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.MAX_SLOTS)
         {
            if(!this.slots[_loc3_].pd)
            {
               this.addEventAtSlot(param1,this.slots[_loc3_].idx,param2);
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function disposeFinishedEvents() : void
      {
         var _loc2_:EventData = null;
         logger.debug(this,"disposeFinishedEvents()");
         var _loc1_:int = 0;
         while(_loc1_ < this.slots.length)
         {
            if(this.slots[_loc1_].pd)
            {
               _loc2_ = this.slots[_loc1_].pd as EventData;
               if(_loc2_.calculateRemainingTime() < 0 || _loc2_.calculateRemainingTime() > 1000000)
               {
                  this.slots[_loc1_].pd = null;
               }
            }
            _loc1_++;
         }
      }
      
      private function dbread(param1:int, param2:GaturroRoom) : String
      {
         var _loc3_:SceneObject = null;
         var _loc4_:String = null;
         this.searchForContainer(param2);
         for each(_loc3_ in param2.sceneObjects)
         {
            if(_loc3_.name == this.soContainer)
            {
               return String(_loc3_.attributes[this.attributeKeyPrefix + param1]);
            }
         }
         return null;
      }
      
      private function retrieveDataFromBillboard(param1:GaturroRoom) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.MAX_SLOTS)
         {
            _loc3_ = this.dbread(_loc2_,param1);
            this.slots[_loc2_].pd = !!_loc3_ ? EventData.fromString(_loc3_) : null;
            this.slots[_loc2_].idx = _loc2_;
            _loc2_++;
         }
      }
      
      private function dbclear(param1:int, param2:GaturroRoom) : void
      {
         var _loc3_:SceneObject = null;
         var _loc4_:CustomAttribute = null;
         this.searchForContainer(param2);
         for each(_loc3_ in param2.sceneObjects)
         {
            if(_loc3_.name == this.soContainer)
            {
               _loc4_ = new CustomAttribute(this.attributeKeyPrefix + param1.toString(),"");
               _loc3_.attributes.mergeAttributesArray([_loc4_]);
               net.sendAction(new BaseUpdateCustomAttributesRequest("sceneObjectId",_loc3_.id,_loc3_.attributes.toArray()));
            }
         }
      }
      
      private function sortSlots() : void
      {
         this.slots.sortOn("pd.remainingTime");
      }
      
      public function addEvent(param1:Object, param2:GaturroRoom) : void
      {
         var _loc3_:EventData = EventData.fromObject(param1);
         if(!_loc3_.isPublic)
         {
            return;
         }
         this.retrieveDataFromBillboard(param2);
         this.disposeFinishedEvents();
         if(!this.addPartyAtEmptySlot(param1,param2))
         {
            this.sortSlots();
            this.addEventAtSlot(param1,this.slots[0].idx,param2);
         }
      }
      
      private function clearAll(param1:GaturroRoom) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.MAX_SLOTS)
         {
            this.dbclear(_loc2_,param1);
            _loc2_++;
         }
      }
   }
}
