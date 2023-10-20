package com.qb9.mambo.net.manager
{
   import com.qb9.mines.mobject.Mobject;
   import com.qb9.mines.network.event.MinesEvent;
   import flash.events.Event;
   
   public class NetworkManagerEvent extends Event
   {
      
      public static const BUDDY_STATUS_CHANGED:String = "BuddyStatusChanged";
      
      public static const ACTION_SENT:String = "ActionSent";
      
      public static const AVATAR_JOINS:String = "AvatarJoinsRoom";
      
      public static const OBJECT_LEFT:String = "ObjectLeavesRoom";
      
      public static const SCENE_OBJECTS_DATA:String = "SceneObjectsListDataResponse";
      
      public static const CHANGE_ROOM:String = "ChangeRoomActionResponse";
      
      public static const ROOM_DATA:String = "RoomDataResponse";
      
      public static const LOGOUT:String = MinesEvent.LOGOUT;
      
      public static const UNIQUE_ACTION_SENT:String = "UniqueActionSent";
      
      public static const MAIL_READ:String = "MarkMailAsReadActionResponse";
      
      public static const BUDDY_ADDED:String = "AddBuddyActionResponse";
      
      public static const MAIL_SENT:String = "MailMessageActionResponse";
      
      public static const WORLD_DATA_CHANGED:String = "WorldDataChanged";
      
      public static const AVATAR_LEFT:String = "AvatarLeftRoom";
      
      public static const BUDDY_REMOVED:String = "RemoveBuddyActionResponse";
      
      public static const USER_ADDED_TO_QUEUE:String = "UserJoinsToQueue";
      
      public static const MAIL_DATA:String = "MailsDataResponse";
      
      public static const BUDDY_BLOCKED:String = "BlockBuddyActionResponse";
      
      public static const SERVER_DATA:String = "ServerDataResponse";
      
      public static const MESSAGE_RECEIVED:String = "MessageReceived";
      
      public static const CUSTOM_ATTRIBUTES_CHANGED:String = "CustomAttributesChanged";
      
      public static const TIMEOUT:String = MinesEvent.TIMEOUT;
      
      public static const PLAYER_WARNED:String = "WarnPlayer";
      
      public static const QUEUE_READY:String = "GameLaunched";
      
      public static const REMOVED_FROM_INVENTORY:String = "RemovedFromInventory";
      
      public static const LOGIN:String = MinesEvent.LOGIN;
      
      public static const QUEUE_FAILED:String = "GameLaunchFailed";
      
      public static const AVATARS_WHO_ADDED_ME_DATA:String = "AvatarsWhoAddedMeDataResponse";
      
      public static const INVENTORY_DATA:String = "InventoryDataResponse";
      
      public static const AVATAR_DATA:String = "AvatarDataResponse";
      
      public static const CONNECT:String = MinesEvent.CONNECT;
      
      public static const BUDDY_UNBLOCKED:String = "UnblockBuddyActionResponse";
      
      public static const PLAYER_SUSPENDED:String = "SuspendPlayer";
      
      public static const CONNECTION_LOST:String = MinesEvent.CONNECTION_LOST;
      
      public static const OBJECT_JOINS:String = "ObjectJoinsRoom";
      
      public static const SERVER_MESSAGE:String = "ServerMessage";
      
      public static const USER_REMOVED_FROM_QUEUE:String = "UserLeavesFromQueue";
      
      public static const MAIL_RECEIVED:String = "MailReceived";
      
      public static const MAIL_DELETED:String = "DeleteMailActionResponse";
      
      public static const WHITE_LIST_DATA:String = "WhiteListDataResponse";
      
      public static const AVATAR_MOVE:String = "MoveActionResponse";
      
      public static const QUEUE_CREATED:String = "JoinQueueActionResponse";
      
      public static const ADDED_TO_INVENTORY:String = "AddedToInventory";
       
      
      private var _success:Boolean;
      
      private var _errorCode:String;
      
      private var _mobject:Mobject;
      
      public function NetworkManagerEvent(param1:String, param2:Mobject, param3:Boolean = true, param4:String = "")
      {
         super(param1,false,true);
         this._mobject = param2;
         this._success = param3;
         this._errorCode = param4;
      }
      
      public function get success() : Boolean
      {
         return this._success;
      }
      
      public function get errorCode() : String
      {
         return this._errorCode;
      }
      
      public function get mobject() : Mobject
      {
         return this._mobject;
      }
      
      override public function clone() : Event
      {
         return new NetworkManagerEvent(type,this.mobject,this.success,this.errorCode);
      }
   }
}
