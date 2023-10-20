package com.qb9.mambo.world.avatars
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.world.elements.MovingRoomSceneObject;
   import com.qb9.mambo.world.tiling.TileGrid;
   import com.qb9.mines.mobject.Mobject;
   
   public class Avatar extends MovingRoomSceneObject
   {
      
      private static const DUMP_VARS:Array = ["id","avatarId","username","coord","accountId"];
       
      
      protected var passportDate:Number;
      
      protected var _accountId:String;
      
      protected var _avatarId:int;
      
      protected var _username:String;
      
      public function Avatar(param1:CustomAttributes, param2:TileGrid)
      {
         super(param1,param2);
      }
      
      public function get avatarId() : int
      {
         return this._avatarId;
      }
      
      public function get accountId() : String
      {
         return this._accountId;
      }
      
      override protected function get dumpVars() : Array
      {
         return DUMP_VARS;
      }
      
      override public function buildFromMobject(param1:Mobject) : void
      {
         super.buildFromMobject(param1);
         param1 = param1.getMobject("avatar");
         this._accountId = param1.getString("accountId");
         trace("==================================================== avatar account id: " + this._accountId);
         this._avatarId = param1.getInteger("id");
         this._username = param1.getString("username");
         this.passportDate = Number(param1.getString("passportDate")) || 0;
      }
      
      public function get username() : String
      {
         return this._username;
      }
      
      public function get isCitizen() : Boolean
      {
         return this.passportDate > new Date().getTime();
      }
      
      public function get passDate() : String
      {
         return new Date(this.passportDate).toString();
      }
   }
}
