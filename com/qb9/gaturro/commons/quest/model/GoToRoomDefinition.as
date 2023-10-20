package com.qb9.gaturro.commons.quest.model
{
   public class GoToRoomDefinition
   {
       
      
      public var gotoX:int;
      
      public var room:int;
      
      public var gotoY:int;
      
      public function GoToRoomDefinition(param1:Object)
      {
         super();
         this.gotoX = param1.gotoX;
         this.gotoY = param1.gotoY;
         this.room = param1.room;
      }
   }
}
