package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   
   public class GaturroGatoonsRoomView extends GaturroRoomView
   {
       
      
      private var npcFactory:NPCFactory;
      
      public function GaturroGatoonsRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this.npcFactory = new NPCFactory();
      }
      
      override protected function whenReady() : void
      {
         super.whenReady();
         this.npcFactory.dressWithCostume();
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc3_:NpcRoomSceneObjectView = null;
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(_loc2_ is NpcRoomSceneObjectView)
         {
            _loc3_ = _loc2_ as NpcRoomSceneObjectView;
            if(this.npcFactory.isEditable(_loc3_.object.name))
            {
               this.npcFactory.addToData(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}

import com.qb9.flashlib.utils.DisplayUtil;
import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

class NPCFactory
{
    
   
   private var allDataLoaded:Boolean = false;
   
   private const COSTUME_PACK_NAME:String = "gatoonsClothes.";
   
   private const NPC_PACK_NAME:String = "gatoonsNPC.";
   
   private var mapClass:Dictionary;
   
   public function NPCFactory()
   {
      super();
      this.mapClass = new Dictionary();
      this.mapClass[this.NPC_PACK_NAME + "bot1_so"] = new NPCData(this.NPC_PACK_NAME + "bot1_so",this.COSTUME_PACK_NAME + "costumeRocker");
      this.mapClass[this.NPC_PACK_NAME + "bot2_so"] = new NPCData(this.NPC_PACK_NAME + "bot2_so",this.COSTUME_PACK_NAME + "costumeAgustin");
      this.mapClass[this.NPC_PACK_NAME + "bot3_so"] = new NPCData(this.NPC_PACK_NAME + "bot3_so",this.COSTUME_PACK_NAME + "costumeSupercat");
   }
   
   private static function gatherPlaceholders(param1:Sprite) : Array
   {
      var _loc3_:DisplayObject = null;
      var _loc2_:Array = [];
      for each(_loc3_ in DisplayUtil.children(param1,true))
      {
         if(_loc3_.name && _loc3_ is MovieClip && MovieClip(_loc3_).numChildren === 0)
         {
            _loc2_.push(_loc3_);
         }
      }
      return _loc2_;
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
   
   public function dressWithCostume() : void
   {
      var _loc1_:NPCData = null;
      for each(_loc1_ in this.mapClass)
      {
         api.libraries.fetch(_loc1_.costume,this.onCostumeDataFetch,_loc1_);
      }
   }
   
   private function onClothesIndividualAssetFetch(param1:DisplayObject, param2:Object) : void
   {
      param2.addChild(param1);
   }
   
   public function addToData(param1:NpcRoomSceneObjectView) : void
   {
      var _loc2_:NPCData = this.mapClass[param1.object.name];
      if(_loc2_)
      {
         _loc2_.npc = param1;
         param1.addEventListener(Event.ADDED,this.getGaturroPlaceholders);
      }
   }
   
   public function isEditable(param1:String) : Boolean
   {
      return Boolean(this.mapClass[param1]);
   }
   
   private function onCostumeDataFetch(param1:DisplayObject, param2:NPCData) : void
   {
      var _loc3_:MovieClip = param1 as MovieClip;
      param2.clothes = _loc3_.clothes;
      this.fixClothes(param2.clothes);
      this.checkDataLoaded();
   }
   
   private function allNPCDataLoaded() : void
   {
      var _loc1_:NPCData = null;
      var _loc2_:ClothPH = null;
      var _loc3_:String = null;
      this.allDataLoaded = true;
      for each(_loc1_ in this.mapClass)
      {
         for each(_loc2_ in _loc1_.clothPHs)
         {
            if(_loc1_.clothes[_loc2_.key])
            {
               _loc3_ = String(this.COSTUME_PACK_NAME + _loc1_.clothes[_loc2_.key]);
               api.libraries.fetch(_loc3_,this.onClothesIndividualAssetFetch,_loc2_.ph);
            }
         }
      }
   }
   
   private function checkDataLoaded() : void
   {
      var _loc1_:NPCData = null;
      if(this.allDataLoaded)
      {
         return;
      }
      for each(_loc1_ in this.mapClass)
      {
         if(!_loc1_.clothPHs || !_loc1_.clothes || !_loc1_.npc)
         {
            return;
         }
      }
      this.allNPCDataLoaded();
   }
   
   private function getGaturroPlaceholders(param1:Event) : void
   {
      var _loc2_:MovieClip = null;
      var _loc3_:String = null;
      var _loc4_:NPCData = null;
      var _loc5_:Array = null;
      var _loc6_:Array = null;
      var _loc7_:int = 0;
      var _loc8_:ClothPH = null;
      if(param1.currentTarget.numChildren > 0)
      {
         _loc2_ = param1.currentTarget.getChildByName(param1.target.name);
         if(_loc2_)
         {
            param1.currentTarget.removeEventListener(Event.ADDED,this.getGaturroPlaceholders);
            _loc3_ = this.NPC_PACK_NAME + getQualifiedClassName(_loc2_);
            _loc4_ = this.mapClass[_loc3_];
            _loc5_ = gatherPlaceholders(_loc2_);
            _loc6_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length)
            {
               if(_loc5_[_loc7_].name)
               {
                  _loc8_ = new ClothPH(_loc5_[_loc7_].name,_loc5_[_loc7_]);
                  _loc6_.push(_loc8_);
               }
               _loc7_++;
            }
            _loc4_.clothPHs = _loc6_;
            this.checkDataLoaded();
         }
      }
   }
}

import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;

class NPCData
{
    
   
   public var costume:String;
   
   public var npc:NpcRoomSceneObjectView;
   
   public var clothes:Object;
   
   public var clothPHs:Array;
   
   public var name:String;
   
   public function NPCData(param1:String, param2:String)
   {
      super();
      this.name = param1;
      this.costume = param2;
   }
}

import flash.display.MovieClip;

class ClothPH
{
    
   
   public var ph:MovieClip;
   
   public var key:String;
   
   public function ClothPH(param1:String, param2:MovieClip)
   {
      super();
      this.key = param1;
      this.ph = param2;
   }
}
