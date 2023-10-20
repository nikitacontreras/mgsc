package com.qb9.gaturro.view.world.events
{
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.events.Event;
   
   public class CreateOwnedNpcEvent extends Event
   {
      
      public static const NAME:String = "CREATE_OWNED_NPC_EVENT";
       
      
      private var ownedNpcData:String;
      
      private var _avatar:Avatar;
      
      public function CreateOwnedNpcEvent(param1:String, param2:Avatar = null)
      {
         super(NAME);
         this.ownedNpcData = param1;
         this._avatar = param2;
      }
      
      public function get avatar() : Avatar
      {
         return this._avatar;
      }
      
      public function get data() : String
      {
         return this.ownedNpcData;
      }
      
      public function dispose() : void
      {
         this._avatar = null;
      }
   }
}
