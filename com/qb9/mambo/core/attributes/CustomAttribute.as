package com.qb9.mambo.core.attributes
{
   import com.qb9.flashlib.logs.Logger;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.mambo.core.attributes.values.CustomAttributeValue;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mambo.net.mobject.Mobjectable;
   import com.qb9.mines.mobject.Mobject;
   
   public class CustomAttribute implements Mobjectable, MobjectBuildable
   {
      
      public static const SYSTEM_PREFIX:String = "system_";
       
      
      private var _key:String;
      
      private var _value:CustomAttributeValue;
      
      public function CustomAttribute(param1:String = null, param2:Object = null)
      {
         super();
         this._key = param1;
         this._value = new CustomAttributeValue(param2);
      }
      
      public static function serialize(param1:Object) : String
      {
         if(param1 is Number || param1 is Boolean)
         {
            return param1.toString();
         }
         if(param1 is String)
         {
            return "\"" + param1 + "\"";
         }
         Logger.getLogger("mambo").warning("CustomAttribute > Could not serialize:",param1);
         return "";
      }
      
      public static function deserialize(param1:String) : Object
      {
         if(param1.charAt(0) === "\"")
         {
            return param1.slice(1,-1);
         }
         if(param1 === "true")
         {
            return true;
         }
         if(param1 === "false")
         {
            return false;
         }
         var _loc2_:Number = Number(param1);
         return isNaN(_loc2_) ? param1 : _loc2_;
      }
      
      public function get readOnly() : Boolean
      {
         return this._key.indexOf(SYSTEM_PREFIX) === 0;
      }
      
      public function get key() : String
      {
         if(this._key == "system_packs")
         {
            return this._key;
         }
         return this.readOnly ? this._key.slice(SYSTEM_PREFIX.length) : this._key;
      }
      
      public function toString() : String
      {
         var _loc1_:Object = this.value;
         if(_loc1_ is String)
         {
            _loc1_ = "\"" + StringUtil.truncate(_loc1_.toString(),100) + "\"";
         }
         return this.key + "=" + _loc1_;
      }
      
      public function get value() : Object
      {
         return this._value.extract;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._key = param1.getString("type");
         var _loc2_:Object = deserialize(param1.getString("data"));
         this._value = new CustomAttributeValue(_loc2_);
      }
      
      public function toMobject() : Mobject
      {
         var _loc1_:Mobject = new Mobject();
         _loc1_.setString("type",this._key);
         _loc1_.setString("data",serialize(this.value));
         return _loc1_;
      }
      
      public function equals(param1:CustomAttribute) : Boolean
      {
         return param1 !== null && this.key === param1.key && this.value === param1.value;
      }
   }
}
