package com.qb9.gaturro.view.world
{
   import com.qb9.gaturro.manager.proposal.view.HospitalManager;
   import com.qb9.gaturro.view.world.elements.HolderRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.HolderRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class HospitalRoomView extends GaturroRoomView
   {
       
      
      private var administrator:HospitalManagerAdministrator;
      
      public function HospitalRoomView(param1:GaturroRoom, param2:InfoReportQueue, param3:Mailer, param4:WhiteListNode)
      {
         super(param1,param2,param3,param4);
         this.administrator = new HospitalManagerAdministrator();
      }
      
      private function getId(param1:String) : String
      {
         var _loc2_:Array = param1.split("_");
         return Boolean(_loc2_) && _loc2_.length > 1 ? String(_loc2_[1]) : "";
      }
      
      override protected function loadAsset(param1:Sprite, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:HospitalManager = null;
         super.loadAsset(param1,param2);
         if(param2.object is NpcRoomSceneObject)
         {
            _loc3_ = String(param2.object.attributes[HospitalManager.HOSPITAL_FEATURE]);
            if(_loc3_)
            {
               if(_loc3_.indexOf(HospitalManager.HOSPITAL_FEATURE_MACHINE) > -1)
               {
                  _loc4_ = this.getId(_loc3_);
                  (_loc5_ = this.administrator.getManager(_loc4_)).addNotifier(param1);
               }
               else if(_loc3_.indexOf(HospitalManager.HOSPITAL_FEATURE_NURSE) > -1)
               {
                  _loc4_ = this.getId(_loc3_);
                  (_loc5_ = this.administrator.getManager(_loc4_)).addAdviser(param1);
               }
            }
         }
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:HospitalManager = null;
         var _loc6_:HolderRoomSceneObjectView = null;
         var _loc7_:String = null;
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(param1 is HolderRoomSceneObject)
         {
            _loc6_ = _loc2_ as HolderRoomSceneObjectView;
            _loc3_ = String(param1.attributes[HospitalManager.HOSPITAL_HOLDER]);
            if(_loc3_)
            {
               _loc4_ = this.getId(_loc3_);
               _loc7_ = String(_loc3_.split("_")[0]);
               (_loc5_ = this.administrator.getManager(_loc4_)).addHolder(_loc6_,_loc7_);
            }
         }
         return _loc2_;
      }
   }
}

import com.qb9.gaturro.manager.proposal.view.HospitalManager;
import com.qb9.gaturro.manager.proposal.view.TimedHospitalManager;
import flash.utils.Dictionary;

class HospitalManagerAdministrator
{
    
   
   private var map:Dictionary;
   
   public function HospitalManagerAdministrator()
   {
      super();
      this.map = new Dictionary();
   }
   
   public function getManager(param1:String) : HospitalManager
   {
      var _loc2_:HospitalManager = this.map[param1];
      if(!_loc2_)
      {
         _loc2_ = !!param1 ? new TimedHospitalManager() : new HospitalManager();
         this.map[param1] = _loc2_;
      }
      return _loc2_;
   }
}
