package com.qb9.gaturro.view.gui.banner.properties
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.mambo.net.manager.NetworkManager;
   
   public interface IPropertyGetter
   {
       
      
      function get sceneAPI() : GaturroSceneObjectAPI;
      
      function get roomAPI() : GaturroRoomAPI;
      
      function get data() : Object;
      
      function get taskRunner() : TaskRunner;
      
      function get options() : String;
      
      function get networkManager() : NetworkManager;
   }
}
