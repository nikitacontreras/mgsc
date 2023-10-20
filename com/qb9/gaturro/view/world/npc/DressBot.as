package com.qb9.gaturro.view.world.npc
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.catalog.Catalog;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class DressBot
   {
       
      
      private var gaturroPHs:Array;
      
      private var config:Object;
      
      private var packName:String;
      
      private var randomCatalog:String;
      
      private var randomCloth:CatalogItem;
      
      private var npc:NpcRoomSceneObjectView;
      
      private var isClothDataReady:Boolean;
      
      private var fetchedMC:MovieClip;
      
      private var asset:MovieClip;
      
      private var isNpcAdded:Boolean;
      
      public function DressBot(param1:NpcRoomSceneObjectView, param2:Object)
      {
         super();
         this.npc = param1;
         this.config = param2;
         this.isClothDataReady = false;
         this.isNpcAdded = false;
         param1.addEventListener(Event.ADDED,this.onAddedToScene);
         this.randomCatalog = this.randomFromArray(param2.catalogs) as String;
         api.room.getCatalogData(this.randomCatalog,this.onCatalogFetch);
      }
      
      private function randomFromArray(param1:Array) : Object
      {
         var _loc2_:int = int(Math.random() * param1.length);
         return param1[_loc2_];
      }
      
      private function onIndividualClothFetched(param1:DisplayObject, param2:Object) : void
      {
         param2.addChild(param1);
      }
      
      private function getPHByKey(param1:String) : MovieClip
      {
         var _loc3_:String = null;
         if(!this.gaturroPHs)
         {
            this.gaturroPHs = this.gatherPlaceholders();
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.gaturroPHs.length)
         {
            _loc3_ = String(this.gaturroPHs[_loc2_].name);
            if(_loc3_.indexOf(param1) != -1)
            {
               return this.gaturroPHs[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function dispose() : void
      {
         this.randomCatalog = null;
         this.randomCloth = null;
         this.packName = null;
         this.fetchedMC = null;
         this.asset = null;
         this.isClothDataReady = false;
         this.isNpcAdded = false;
         this.gaturroPHs = null;
         this.npc = null;
      }
      
      public function ready() : void
      {
      }
      
      private function onCatalogFetch(param1:Catalog, param2:Object = null) : void
      {
         this.randomCloth = this.randomFromArray(param1.items) as CatalogItem;
         if(this.randomCloth)
         {
            logger.debug(this,">>>>>>>>>>",this.randomCloth.name);
            this.packName = this.randomCloth.name.split(".")[0];
            api.libraries.fetch(this.randomCloth.name,this.onClothFetch);
            logger.debug(this,this.packName);
            logger.debug(this,this.randomCloth.name);
         }
      }
      
      private function checkAllDataLoaded() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         if(this.isClothDataReady && this.isNpcAdded)
         {
            if(!this.gaturroPHs)
            {
               this.gaturroPHs = this.gatherPlaceholders();
            }
            _loc1_ = 0;
            while(_loc1_ < this.gaturroPHs.length)
            {
               _loc2_ = this.gaturroPHs[_loc1_];
               if(_loc2_.name in this.fetchedMC.clothes)
               {
                  _loc3_ = String(this.fetchedMC.clothes[_loc2_.name]);
                  if(_loc3_ != "")
                  {
                     api.libraries.fetch(this.packName + "." + _loc3_,this.onIndividualClothFetched,_loc2_);
                  }
               }
               _loc1_++;
            }
         }
      }
      
      private function onAddedToScene(param1:Event) : void
      {
         var _loc2_:MovieClip = null;
         if(param1.currentTarget.numChildren > 0)
         {
            _loc2_ = param1.currentTarget.getChildByName(param1.target.name);
            if(!_loc2_)
            {
               return;
            }
            this.asset = _loc2_;
            _loc2_.removeEventListener(Event.ADDED,this.onAddedToScene);
            this.isNpcAdded = true;
            this.checkAllDataLoaded();
         }
      }
      
      private function fixClothes(param1:Object) : void
      {
         if(param1.arm)
         {
            param1.armFore = param1.arm;
            param1.armBack = param1.arm;
         }
         if(param1.gloves)
         {
            param1.gloveFore = param1.gloves;
            param1.gloveBack = param1.gloves;
         }
         if(param1.grip)
         {
            param1.grip = param1.gripFore;
            param1.grip = param1.gripBack;
         }
      }
      
      private function gatherPlaceholders() : Array
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:Array = [];
         for each(_loc2_ in DisplayUtil.children(this.asset,true))
         {
            if(_loc2_.name && _loc2_ is MovieClip && MovieClip(_loc2_).numChildren === 0)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      private function onClothFetch(param1:DisplayObject) : void
      {
         this.fetchedMC = param1 as MovieClip;
         if(this.fetchedMC.clothes)
         {
            this.fixClothes(this.fetchedMC.clothes);
         }
         this.isClothDataReady = true;
         this.checkAllDataLoaded();
      }
   }
}
