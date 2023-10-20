package com.qb9.gaturro.world.gatucine.elements
{
   public class GatucineMovie extends GatucineHeader
   {
       
      
      protected var dataPlayId:String;
      
      public function GatucineMovie()
      {
         super();
      }
      
      public function set playId(param1:String) : void
      {
         this.dataPlayId = param1;
      }
      
      public function get playId() : String
      {
         return this.dataPlayId;
      }
   }
}
