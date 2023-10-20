package com.qb9.gaturro.world.npc.struct.behavior
{
   import flash.events.Event;
   
   public final class NpcBehaviorEvent extends Event
   {
      
      public static const POP_UP_CLOSED:String = "closePopupNpc";
      
      public static const FINISHED_CHAT:String = "npcbeFinishedChat";
      
      public static const ARRIVED:String = "arrived";
      
      public static const AVATAR_ATTR_PREFFIX:String = "na_";
      
      public static const NPC_DEFEATED:String = "npcDefeated";
      
      public static const MULTIPLAYER_ACTIVATE:String = "multiplayerActivate";
      
      public static const NPC_CORRECT_ATTACK:String = "correctAttack";
      
      public static const NPC_ATTR_PREFFIX:String = "aa_";
      
      public static const MULTIPLAYER_HIDE:String = "multiplayerHide";
      
      public static const CLICK:String = "click";
      
      public static const AVATAR_MOVED:String = "avatarMoved";
      
      public static const OWNER_MOVED:String = "ownerMoved";
      
      public static const AVATAR_JOINED:String = "avatarJoined";
      
      public static const SPECIAL_ROOM_ACTIVATE:String = "specialRoomActivate";
      
      public static const ACTIVATE:String = "activate";
      
      public static const NPC_WRONG_ATTACK:String = "wrongAttack";
      
      public static const SHOW:String = "show";
      
      public static const STATE_CHANGE:String = "npcbeStateChange";
       
      
      public function NpcBehaviorEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         return new NpcBehaviorEvent(type);
      }
   }
}
