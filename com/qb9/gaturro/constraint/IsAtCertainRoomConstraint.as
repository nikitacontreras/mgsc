package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   
   public class IsAtCertainRoomConstraint extends AbstractConstraint
   {
       
      
      private var roomAPI:GaturroRoomAPI;
      
      private var roomId:int;
      
      public function IsAtCertainRoomConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Boolean = api != null && api.room.id == this.roomId;
         return doInvert(_loc2_);
      }
      
      private function onApiAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroRoomAPI)
         {
            changed();
         }
      }
      
      override public function dispose() : void
      {
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onApiAdded);
         super.dispose();
      }
      
      override public function setData(param1:*) : void
      {
         this.roomId = parseInt(param1.roomId.toString());
      }
      
      private function setup() : void
      {
         if(!weak)
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onApiAdded);
         }
      }
   }
}
