package com.qb9.gaturro.constraint
{
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.user;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   
   public class HasProfileAttrConstraint extends AbstractConstraint
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var attributeName:String;
      
      private var isJSON:Boolean;
      
      public function HasProfileAttrConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Boolean = Boolean(this.getProfileAttribute(this.attributeName));
         return doInvert(_loc2_);
      }
      
      override public function dispose() : void
      {
         user.profile.removeEventListener(CustomAttributesEvent.CHANGED,this.onChanged);
         super.dispose();
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
      
      private function checkChangedJSON(param1:Array) : void
      {
         var _loc3_:CustomAttribute = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc2_:int = this.attributeName.indexOf(StringUtil.JPathSeparator);
         for each(_loc3_ in param1)
         {
            _loc4_ = this.attributeName.substr(0,_loc2_);
            if(_loc3_.key == _loc4_)
            {
               _loc5_ = this.attributeName.substr(_loc2_ + 1);
               _loc6_ = api.JSONDecode(_loc3_.value as String);
               _loc7_ = _loc5_.split(StringUtil.JPathSeparator);
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  if(_loc6_[_loc7_[_loc8_]])
                  {
                     _loc6_ = _loc6_[_loc7_[_loc8_]];
                     if(_loc7_.length - 1 == _loc8_)
                     {
                        changed();
                     }
                  }
                  _loc8_++;
               }
            }
         }
      }
      
      private function onChanged(param1:CustomAttributesEvent) : void
      {
         if(this.isJSON)
         {
            this.checkChangedJSON(param1.attributes);
         }
         else
         {
            this.checkChanged(param1.attributes);
         }
      }
      
      private function checkChanged(param1:Array) : void
      {
         var _loc2_:CustomAttribute = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_.key == this.attributeName)
            {
               changed();
               return;
            }
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.attributeName = param1.attributeName;
         this.isJSON = this.attributeName.indexOf(StringUtil.JPathSeparator) != -1;
      }
      
      private function setup() : void
      {
         if(!weak)
         {
            user.profile.addEventListener(CustomAttributesEvent.CHANGED,this.onChanged);
         }
      }
   }
}
