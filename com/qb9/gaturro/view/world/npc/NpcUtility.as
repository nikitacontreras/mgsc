package com.qb9.gaturro.view.world.npc
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import flash.utils.Dictionary;
   
   public class NpcUtility
   {
      
      public static const CHANGE_DRESS:String = "changeDress";
       
      
      private var currentNPCs:Array;
      
      private var mapClass:Dictionary;
      
      public function NpcUtility()
      {
         super();
         this.setup();
      }
      
      public function roomDisposed() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.currentNPCs.length)
         {
            this.currentNPCs[_loc1_].dispose();
            _loc1_++;
         }
         this.currentNPCs = [];
      }
      
      public function tryModify(param1:NpcRoomSceneObjectView, param2:int) : void
      {
         var _loc3_:Object = this.getConfig(param1.object.name,param2);
         if(_loc3_)
         {
            this.currentNPCs.push(new this.mapClass[_loc3_.className](param1,_loc3_));
         }
      }
      
      private function setup() : void
      {
         this.mapClass = new Dictionary();
         this.mapClass["DressBot"] = DressBot;
         this.currentNPCs = [];
      }
      
      private function getConfig(param1:String, param2:int) : Object
      {
         var _loc3_:int = 0;
         while(_loc3_ < settings.NpcUtility.length)
         {
            if(settings.NpcUtility[_loc3_].sceneObject == param1 && ArrayUtil.contains(settings.NpcUtility[_loc3_].roomIDs,param2))
            {
               return settings.NpcUtility[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
   }
}
