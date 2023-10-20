package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import flash.utils.setTimeout;
   
   public class GaturroHomeRoofView extends GaturroHomeView
   {
       
      
      public var santa:SceneObject;
      
      private var houseInv:GaturroInventory;
      
      private const SANTA:String = "navidad2015.SantaPrueba";
      
      public function GaturroHomeRoofView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this.houseInv = param1.userAvatar.user.inventory("house") as GaturroInventory;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      override protected function addSceneObjects() : void
      {
         super.addSceneObjects();
         this.checkSantaAndRemove();
      }
      
      private function removeSanta(param1:int) : void
      {
         this.houseInv.grab(param1);
      }
      
      private function checkSantaAndRemove() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.roomObjects.length)
         {
            if(this.roomObjects[_loc1_].name == this.SANTA)
            {
               setTimeout(this.removeSanta,500,this.roomObjects[_loc1_].id);
            }
            _loc1_++;
         }
      }
      
      public function get roomObjects() : Array
      {
         return room.sceneObjects;
      }
   }
}
