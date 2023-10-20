package com.qb9.gaturro.user.profile
{
   import com.qb9.gaturro.globals.server;
   import com.qb9.mambo.user.profile.Profile;
   
   public final class GaturroProfile extends Profile
   {
      
      public static const COINS:String = "coins";
       
      
      private var lastModifiedNews:Number;
      
      public function GaturroProfile(param1:Number)
      {
         super();
         this.lastModifiedNews = param1;
      }
      
      public function get canBuyPremium() : Boolean
      {
         if(this.amountAcquired < server.maxPremiumItems)
         {
            return true;
         }
         var _loc1_:Date = server.date;
         var _loc2_:Date = this.lastAcquired;
         return _loc1_.fullYear !== _loc2_.fullYear || _loc1_.month !== _loc2_.month || _loc1_.date !== _loc2_.date;
      }
      
      public function get coins() : Number
      {
         return attributes[COINS] as Number;
      }
      
      public function get hasReadNews() : Boolean
      {
         trace(this,attributes.lastReadNews,this.lastModifiedNews);
         return attributes.lastReadNews >= this.lastModifiedNews;
      }
      
      private function get amountAcquired() : int
      {
         return attributes.amount_acquire;
      }
      
      public function readNews() : void
      {
         attributes.lastReadNews = this.lastModifiedNews;
      }
      
      public function increaseSessionCount() : void
      {
         attributes.sessionCount = this.sessionCount + 1;
      }
      
      private function get lastAcquired() : Date
      {
         var _loc1_:Number = Number(attributes.last_acquire);
         if(isNaN(_loc1_))
         {
            _loc1_ = 0;
         }
         return new Date(_loc1_);
      }
      
      public function get newsRevision() : String
      {
         return this.lastModifiedNews.toString();
      }
      
      public function set lastTipRead(param1:int) : void
      {
         attributes.lastTipRead = param1;
      }
      
      public function get sessionCount() : int
      {
         return int(attributes.sessionCount) || 0;
      }
      
      public function get lastTipRead() : int
      {
         var _loc1_:Object = attributes.lastTipRead;
         return _loc1_ is Number ? int(_loc1_) : -1;
      }
   }
}
