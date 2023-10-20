package com.qb9.gaturro.user
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.user.club.ClubName;
   import com.qb9.gaturro.user.club.MeritContest;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class GaturroClub
   {
       
      
      private var _name:String;
      
      private var _hasClub:Boolean;
      
      private var _contest:MeritContest;
      
      private var _insignia:DisplayObject;
      
      public function GaturroClub()
      {
         super();
      }
      
      public function set meritos(param1:uint) : void
      {
         api.setProfileAttribute("clubMeritPoints",param1);
      }
      
      public function get name() : String
      {
         var _loc1_:String = api.getProfileAttribute("clubPertenencia") as String;
         if(_loc1_ != null && _loc1_ != "null" && _loc1_ != "")
         {
            this._name = _loc1_;
         }
         return this._name;
      }
      
      public function getInsignia(param1:DisplayObjectContainer) : void
      {
         var container:DisplayObjectContainer = param1;
         this.getClubName();
         if(this._name != null)
         {
            api.libraries.fetch("club." + this._name + "Insignia",function(param1:DisplayObject):void
            {
               container.addChild(param1);
            });
         }
      }
      
      private function getClubName() : void
      {
      }
      
      public function get meritos() : uint
      {
         return api.getProfileAttribute("clubMeritPoints") as uint;
      }
      
      public function getInsigniaFromAvatar(param1:Avatar, param2:DisplayObjectContainer) : void
      {
         var avatar:Avatar = param1;
         var container:DisplayObjectContainer = param2;
         var avatarClub:String = String(avatar.attributes.clubPertenencia);
         if(avatarClub != null && avatarClub != "null" && avatarClub != "")
         {
            api.libraries.fetch("club." + avatarClub + "Insignia",function(param1:DisplayObject):void
            {
               container.addChild(param1);
            });
         }
      }
      
      public function get contest() : MeritContest
      {
         if(this._contest == null)
         {
            this._contest = new MeritContest();
         }
         return this._contest;
      }
      
      public function get hasClub() : Boolean
      {
         if(api.getProfileAttribute("clubPertenencia") != ClubName.DEPORTISTAS && api.getProfileAttribute("clubPertenencia") != ClubName.GEEKS && api.getProfileAttribute("clubPertenencia") != ClubName.MUSICOS && api.getProfileAttribute("clubPertenencia") != ClubName.MONSTRUOS)
         {
            return false;
         }
         return true;
      }
   }
}
