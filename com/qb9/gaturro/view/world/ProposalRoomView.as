package com.qb9.gaturro.view.world
{
   import com.qb9.gaturro.manager.proposal.constants.ProposalViewConst;
   import com.qb9.gaturro.manager.proposal.view.AbstractProposalRoomViewManager;
   import com.qb9.gaturro.manager.proposal.view.ProposalRoomViewManagerAdministrator;
   import com.qb9.gaturro.view.world.elements.HolderRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.HolderRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.core.events.GeneralEvent;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ProposalRoomView extends GaturroRoomView
   {
       
      
      private var tempNotifier:TempItem;
      
      private var proposalFeature:String;
      
      private var administrator:ProposalRoomViewManagerAdministrator;
      
      private var tempAdviser:TempItem;
      
      private var tempHolderList:Array;
      
      public function ProposalRoomView(param1:String, param2:GaturroRoom, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param2,param3,param4,param5);
         this.proposalFeature = param1;
         this.administrator = new ProposalRoomViewManagerAdministrator(param1);
      }
      
      private function addHolder(param1:String, param2:HolderRoomSceneObjectView, param3:String) : void
      {
         var _loc4_:AbstractProposalRoomViewManager = null;
         if(this.administrator.ready)
         {
            (_loc4_ = this.administrator.getManager(param1)).addHolder(param2,param3);
         }
         else
         {
            this.administrator.addEventListener(GeneralEvent.READY,this.onReadyHolder);
            if(!this.tempHolderList)
            {
               this.tempHolderList = new Array();
            }
            this.tempHolderList.push(new TempItem(param1,param2,param3));
         }
      }
      
      private function addNotifier(param1:String, param2:Sprite) : void
      {
         var _loc3_:AbstractProposalRoomViewManager = null;
         if(this.administrator.ready)
         {
            _loc3_ = this.administrator.getManager(param1);
            _loc3_.addNotifier(param2);
         }
         else
         {
            this.administrator.addEventListener(GeneralEvent.READY,this.onReadyNotifier);
            this.tempNotifier = new TempItem(param1,param2);
         }
      }
      
      private function addAdviser(param1:String, param2:Sprite) : void
      {
         var _loc3_:AbstractProposalRoomViewManager = null;
         if(this.administrator.ready)
         {
            _loc3_ = this.administrator.getManager(param1);
            _loc3_.addAdviser(param2);
         }
         else
         {
            this.administrator.addEventListener(GeneralEvent.READY,this.onReadyAdviser);
            this.tempAdviser = new TempItem(param1,param2);
         }
      }
      
      override protected function loadAsset(param1:Sprite, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         super.loadAsset(param1,param2);
         if(param2.object is NpcRoomSceneObject)
         {
            _loc3_ = String(param2.object.attributes[ProposalViewConst.PROPOSAL_FEATURE]);
            if(_loc3_)
            {
               if(_loc3_.indexOf(ProposalViewConst.PROPOSAL_FEATURE_NOTIFIER_VALUE) > -1)
               {
                  _loc4_ = this.getId(_loc3_);
                  this.addNotifier(_loc4_,param1);
               }
               else if(_loc3_.indexOf(ProposalViewConst.PROPOSAL_FEATURE_ADVISER_VALUE) > -1)
               {
                  _loc4_ = this.getId(_loc3_);
                  this.addAdviser(_loc4_,param1);
               }
            }
         }
      }
      
      private function onReadyHolder(param1:Event) : void
      {
         this.administrator.removeEventListener(GeneralEvent.READY,this.onReadyHolder);
         var _loc2_:TempItem = this.tempHolderList.shift();
         var _loc3_:AbstractProposalRoomViewManager = this.administrator.getManager(_loc2_.id);
         _loc3_.addHolder(_loc2_.item as HolderRoomSceneObjectView,_loc2_.arg[0] as String);
         if(!this.tempHolderList.length)
         {
            this.tempHolderList = null;
         }
      }
      
      private function onReadyNotifier(param1:Event) : void
      {
         this.administrator.removeEventListener(GeneralEvent.READY,this.onReadyNotifier);
         var _loc2_:AbstractProposalRoomViewManager = this.administrator.getManager(this.tempNotifier.id);
         _loc2_.addNotifier(this.tempNotifier.item as Sprite);
         this.tempNotifier = null;
      }
      
      private function onReadyAdviser(param1:Event) : void
      {
         this.administrator.removeEventListener(GeneralEvent.READY,this.onReadyAdviser);
         var _loc2_:AbstractProposalRoomViewManager = this.administrator.getManager(this.tempAdviser.id);
         _loc2_.addAdviser(this.tempAdviser.item as Sprite);
         this.tempAdviser = null;
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:HolderRoomSceneObjectView = null;
         var _loc6_:String = null;
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(param1 is HolderRoomSceneObject)
         {
            _loc5_ = _loc2_ as HolderRoomSceneObjectView;
            _loc3_ = String(param1.attributes[ProposalViewConst.PROPOSAL_HOLDER]);
            if(_loc3_)
            {
               _loc4_ = this.getId(_loc3_);
               _loc6_ = String(_loc3_.split("_")[0]);
               this.addHolder(_loc4_,_loc5_,_loc6_);
            }
         }
         return _loc2_;
      }
      
      private function getId(param1:String) : String
      {
         var _loc2_:Array = param1.split("_");
         return Boolean(_loc2_) && _loc2_.length > 1 ? String(_loc2_[1]) : "";
      }
      
      override public function dispose() : void
      {
         this.administrator.dispose();
         this.administrator = null;
         super.dispose();
      }
   }
}

class TempItem
{
    
   
   private var _item:Object;
   
   private var _arg:Array;
   
   private var _id:String;
   
   public function TempItem(param1:String, param2:Object, ... rest)
   {
      super();
      this._arg = rest;
      this._id = param1;
      this._item = param2;
   }
   
   public function get item() : Object
   {
      return this._item;
   }
   
   public function get arg() : Array
   {
      return this._arg;
   }
   
   public function get id() : String
   {
      return this._id;
   }
}
