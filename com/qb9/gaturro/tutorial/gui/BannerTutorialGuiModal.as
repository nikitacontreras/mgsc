package com.qb9.gaturro.tutorial.gui
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.view.gui.banner.BannerGuiModal;
   
   public class BannerTutorialGuiModal extends BannerGuiModal
   {
       
      
      public function BannerTutorialGuiModal(param1:String, param2:GaturroSceneObjectAPI, param3:GaturroRoomAPI)
      {
         super(param1,param2,param3);
      }
      
      override protected function pressEscKey() : void
      {
      }
   }
}
