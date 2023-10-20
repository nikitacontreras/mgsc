package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   
   public class ProyectoGatuberRoomView extends GaturroRoomView
   {
      
      public static const gatubersOficiales:Array = ["sien99","tomatita143","MatiiasDeMhg","donisuspendido","Rodri2112","erikferco","Warriorartist","luciacpmg","Sweetsrrow","milalva","benjademgyt","tomi4424","candemhg","xkatiademgx","antowestcool","cieluuwu","gatumarfinck","yokila","franchusdemg","GIANROYALE","marmax1000","Francescafpmg","qb9mod","mrovere"];
       
      
      public function ProyectoGatuberRoomView(param1:GaturroRoom, param2:TaskRunner, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc2_:Avatar = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(param1 is Avatar)
         {
            _loc2_ = param1 as Avatar;
            _loc3_ = false;
            _loc4_ = 0;
            while(_loc4_ < gatubersOficiales.length)
            {
               if(_loc2_.username.toUpperCase() == gatubersOficiales[_loc4_].toUpperCase())
               {
                  _loc3_ = true;
               }
               _loc4_++;
            }
            if(!_loc3_)
            {
               return;
            }
         }
         super.addSceneObject(param1);
      }
   }
}
