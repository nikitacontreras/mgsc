package com.qb9.mambo.core.objects
{
   import com.qb9.flashlib.geom.Size;
   import com.qb9.flashlib.security.SafeString;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.objects.events.SceneObjectEvent;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mines.mobject.Mobject;
   
   public class SceneObject extends BaseCustomAttributeDispatcher implements MobjectBuildable
   {
      
      private static const DUMP_VARS:Array = ["id","name","size"];
       
      
      protected var _size:Size;
      
      protected var _name:SafeString;
      
      protected var _id:Number;
      
      public function SceneObject(param1:CustomAttributes)
      {
         super();
         _attributes = param1;
      }
      
      public function get size() : Size
      {
         return this._size;
      }
      
      public function activate(param1:UserAvatar) : void
      {
         dispatchEvent(new SceneObjectEvent(SceneObjectEvent.ACTIVATED,param1));
      }
      
      public function get name() : String
      {
         return this._name.toString();
      }
      
      override protected function get dumpVars() : Array
      {
         return DUMP_VARS;
      }
      
      public function get monitorAttributes() : Boolean
      {
         return false;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._id = Number(param1.getString("id"));
         this._name = new SafeString(param1.getString("name"));
         this._size = Size.fromArray(param1.getIntegerArray("size"));
      }
      
      public function get id() : Number
      {
         return this._id;
      }
      
      override public function dispose() : void
      {
         this._size = null;
         super.dispose();
      }
   }
}
