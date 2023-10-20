package com.qb9.gaturro.constraint
{
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.globals.user;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   
   public class ProfileAttrValueConstraint extends AbstractConstraint
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var attributeName:String;
      
      private var attributeValue;
      
      public function ProfileAttrValueConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Object = this.getProfileAttribute(this.attributeName);
         var _loc3_:* = _loc2_ == this.attributeValue;
         return doInvert(_loc3_);
      }
      
      private function getProfileAttribute(param1:String) : Object
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:int = param1.indexOf(StringUtil.JPathSeparator);
         if(_loc2_ > 0)
         {
            _loc3_ = param1.substring(0,_loc2_);
            _loc4_ = String(user.profile.attributes[_loc3_]);
            return StringUtil.getJsonVar(param1,_loc4_);
         }
         return user.profile.attributes[param1];
      }
      
      override public function setData(param1:*) : void
      {
         this.attributeName = param1.attributeName;
         this.attributeValue = param1.attributeValue;
      }
      
      private function onChanged(param1:CustomAttributesEvent) : void
      {
         var _loc2_:CustomAttribute = null;
         for each(_loc2_ in param1.attributes)
         {
            if(_loc2_.key == this.attributeName)
            {
               changed();
               return;
            }
         }
      }
      
      private function setup() : void
      {
         if(!weak)
         {
            user.profile.addEventListener(CustomAttributesEvent.CHANGED,this.onChanged);
         }
      }
      
      override public function dispose() : void
      {
         user.profile.removeEventListener(CustomAttributesEvent.CHANGED,this.onChanged);
         super.dispose();
      }
   }
}
