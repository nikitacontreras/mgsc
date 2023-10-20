package com.qb9.mambo.user.buddies
{
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.utils.ObjectUtil;
   import com.qb9.mambo.core.objects.MamboObject;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mambo.net.requests.buddies.*;
   import com.qb9.mines.mobject.Mobject;
   
   public final class BuddyList extends MamboObject implements MobjectBuildable
   {
       
      
      private var net:NetworkManager;
      
      private var list:Object;
      
      public function BuddyList(param1:NetworkManager)
      {
         this.list = {};
         super();
         this.net = param1;
         this.init();
      }
      
      private function assert(param1:NetworkManagerEvent, param2:Boolean) : Boolean
      {
         if(!param1.success)
         {
            return false;
         }
         var _loc3_:String = this.getUsername(param1);
         var _loc4_:*;
         if((_loc4_ = this.getBuddy(_loc3_) !== null) === param2)
         {
            return true;
         }
         warning(_loc3_,"was " + (param2 ? "" : "not ") + "expected to be in the list");
         return false;
      }
      
      private function initEvents() : void
      {
         this.net.addEventListener(NetworkManagerEvent.BUDDY_ADDED,this.buddyAdded);
         this.net.addEventListener(NetworkManagerEvent.BUDDY_REMOVED,this.buddyRemoved);
         this.net.addEventListener(NetworkManagerEvent.BUDDY_BLOCKED,this.buddyBlockedStateChanged);
         this.net.addEventListener(NetworkManagerEvent.BUDDY_UNBLOCKED,this.buddyBlockedStateChanged);
         this.net.addEventListener(NetworkManagerEvent.BUDDY_STATUS_CHANGED,this.buddyStateChanged);
      }
      
      public function hasBuddy(param1:String) : Boolean
      {
         return this.getBuddy(param1) !== null;
      }
      
      private function init() : void
      {
         this.initEvents();
      }
      
      private function getUsername(param1:NetworkManagerEvent) : String
      {
         return param1.mobject.getString("username");
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         foreach(param1.getMobjectArray("buddies"),this.addBuddyFromMobject);
      }
      
      public function getBuddy(param1:String) : Buddy
      {
         return this.list[param1.toUpperCase()] as Buddy;
      }
      
      private function buddyStateChanged(param1:NetworkManagerEvent) : void
      {
         if(!this.assert(param1,true))
         {
            return;
         }
         var _loc2_:Buddy = this.getBuddyFromEvent(param1);
         _loc2_.setStatus(param1.mobject.getString("status"));
         this.changed();
         this.event(BuddyListEvent.STATUS_CHANGED,_loc2_);
      }
      
      private function buddyAdded(param1:NetworkManagerEvent) : void
      {
         if(!this.assert(param1,false))
         {
            return this.event(BuddyListEvent.ADDED);
         }
         var _loc2_:Buddy = new Buddy(this.getUsername(param1));
         this.add(_loc2_);
         this.changed();
         this.event(BuddyListEvent.ADDED,_loc2_);
      }
      
      override public function dispose() : void
      {
         this.net.removeEventListener(NetworkManagerEvent.BUDDY_ADDED,this.buddyAdded);
         this.net.removeEventListener(NetworkManagerEvent.BUDDY_REMOVED,this.buddyRemoved);
         this.net.removeEventListener(NetworkManagerEvent.BUDDY_BLOCKED,this.buddyBlockedStateChanged);
         this.net.removeEventListener(NetworkManagerEvent.BUDDY_UNBLOCKED,this.buddyBlockedStateChanged);
         this.net.removeEventListener(NetworkManagerEvent.BUDDY_STATUS_CHANGED,this.buddyStateChanged);
         this.net = null;
         this.list = null;
         super.dispose();
      }
      
      private function getBuddyFromEvent(param1:NetworkManagerEvent) : Buddy
      {
         return this.getBuddy(this.getUsername(param1));
      }
      
      private function add(param1:Buddy) : void
      {
         this.list[param1.username.toUpperCase()] = param1;
      }
      
      public function removeBuddy(param1:String) : void
      {
         this.net.sendAction(new RemoveBuddyActionRequest(param1));
      }
      
      public function get buddies() : Array
      {
         return ObjectUtil.values(this.list);
      }
      
      public function addBuddy(param1:String) : void
      {
         this.net.sendAction(new AddBuddyActionRequest(param1));
      }
      
      private function event(param1:String, param2:Buddy = null) : void
      {
         dispatchEvent(new BuddyListEvent(param1,param2));
      }
      
      private function buddyBlockedStateChanged(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Boolean = param1.mobject.getBoolean("success");
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Buddy = this.getBuddyFromEvent(param1);
         if(_loc3_)
         {
            _loc3_.setBlocked(param1.type === NetworkManagerEvent.BUDDY_BLOCKED);
         }
         this.changed();
         this.event(BuddyListEvent.BLOCK_CHANGED,_loc3_ || new Buddy(this.getUsername(param1)));
      }
      
      private function changed() : void
      {
         this.event(BuddyListEvent.CHANGED);
      }
      
      private function buddyRemoved(param1:NetworkManagerEvent) : void
      {
         if(!this.assert(param1,true))
         {
            return this.event(BuddyListEvent.REMOVED);
         }
         var _loc2_:Buddy = this.getBuddyFromEvent(param1);
         delete this.list[this.getUsername(param1)];
         this.changed();
         this.event(BuddyListEvent.REMOVED,_loc2_);
      }
      
      private function addBuddyFromMobject(param1:Mobject) : void
      {
         var _loc2_:Buddy = new Buddy();
         _loc2_.buildFromMobject(param1);
         this.add(_loc2_);
      }
   }
}
