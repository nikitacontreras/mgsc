package com.qb9.gaturro.world.hiddenObjects
{
   import flash.display.DisplayObjectContainer;
   
   public class HiddenObjects
   {
      
      private static var instance:com.qb9.gaturro.world.hiddenObjects.HiddenObjects;
       
      
      protected var hiddenLayer:DisplayObjectContainer;
      
      public function HiddenObjects()
      {
         super();
      }
      
      public static function create(param1:DisplayObjectContainer, param2:String) : com.qb9.gaturro.world.hiddenObjects.HiddenObjects
      {
         switch(param2)
         {
            case "animalesLocos":
               instance = new CrazyAnimals();
               instance.hiddenLayer = param1;
               instance.configure();
         }
         return instance;
      }
      
      protected function configure() : void
      {
      }
   }
}
