package com.qb9.mines.network
{
   import com.qb9.mines.io.MinesInputStream;
   import com.qb9.mines.mobject.Mobject;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   public class Message
   {
      
      public static const HEADER_TYPE:int = 3;
       
      
      private var buffer:ByteArray;
      
      private var payload:int = -1;
      
      public function Message()
      {
         super();
         this.buffer = new ByteArray();
      }
      
      public function needsPayload() : Boolean
      {
         return this.payload == -1;
      }
      
      public function read(param1:Socket) : void
      {
         var _loc2_:int = this.payload - this.buffer.length;
         var _loc3_:int = Math.max(0,Math.min(param1.bytesAvailable,_loc2_));
         param1.readBytes(this.buffer,this.buffer.length,_loc3_);
      }
      
      public function toMobject() : Mobject
      {
         this.buffer.position = 0;
         var _loc1_:MinesInputStream = new MinesInputStream(this.buffer);
         _loc1_.position = 0;
         return _loc1_.readMobject();
      }
      
      public function isComplete() : Boolean
      {
         if(this.payload < this.buffer.length)
         {
            trace("ERROR: payload is wrong!  payload: " + this.payload + ", buffer.length: " + this.buffer.length);
         }
         return this.payload == this.buffer.length;
      }
      
      public function setPayload(param1:int) : void
      {
         this.payload = param1;
      }
   }
}
