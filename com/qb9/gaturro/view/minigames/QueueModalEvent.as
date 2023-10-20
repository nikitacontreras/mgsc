package com.qb9.gaturro.view.minigames
{
   import com.qb9.mambo.queue.ServerLoginData;
   import flash.events.Event;
   
   public final class QueueModalEvent extends Event
   {
      
      public static const OPEN:String = "qmeOpenModal";
      
      public static const QUEUE_IS_READY:String = "qmeQueueIsReady";
      
      public static const SINGLE_PLAYER:String = "qmeSinglePlayer";
       
      
      private var _id:Number;
      
      private var data:Object;
      
      private var _singlePlayerGame:String;
      
      public function QueueModalEvent(param1:String, param2:Object, param3:String = null, param4:Number = 0)
      {
         super(param1,true);
         this._id = param4;
         this._singlePlayerGame = param3;
         this.data = param2;
      }
      
      public function get login() : ServerLoginData
      {
         return this.data as ServerLoginData;
      }
      
      public function get singlePlayerGame() : String
      {
         return this._singlePlayerGame;
      }
      
      override public function clone() : Event
      {
         return new QueueModalEvent(type,this.data,this.singlePlayerGame,this.id);
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this.data as String;
      }
   }
}
