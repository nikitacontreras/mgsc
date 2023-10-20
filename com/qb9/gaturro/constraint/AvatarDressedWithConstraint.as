package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   
   public class AvatarDressedWithConstraint extends AbstractConstraint
   {
       
      
      private var wearKey:String;
      
      private var wearName:String;
      
      public function AvatarDressedWithConstraint(param1:Boolean)
      {
         super(param1);
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:GaturroAvatarView = param1 as GaturroAvatarView;
         var _loc3_:String = _loc2_.avatar.attributes[this.wearKey] as String;
         var _loc4_:Boolean = Boolean(_loc3_) && _loc3_.indexOf(this.wearName) > -1;
         trace(_loc3_,this.wearKey,this.wearName);
         return doInvert(_loc4_);
      }
      
      override public function setData(param1:*) : void
      {
         this.wearKey = param1.wearKey;
         this.wearName = param1.wearName;
      }
   }
}
