package com.qb9.mambo.user.profile
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.objects.BaseCustomAttributeDispatcher;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mines.mobject.Mobject;
   
   public class Profile extends BaseCustomAttributeDispatcher implements MobjectBuildable
   {
       
      
      private var passportDate:Number;
      
      private var _chatType:int;
      
      private var _id:Number;
      
      public function Profile()
      {
         super();
      }
      
      public function get chatType() : int
      {
         return this._chatType;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._id = param1.getInteger("id");
         this._chatType = param1.getInteger("chatType");
         _attributes = new CustomAttributes(this);
         attributes.buildFromMobject(param1);
      }
      
      public function get id() : int
      {
         return this._id;
      }
   }
}
