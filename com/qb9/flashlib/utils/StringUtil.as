package com.qb9.flashlib.utils
{
   import com.adobe.serialization.json.JSON;
   
   public class StringUtil
   {
      
      private static var formatData:Object;
      
      public static const JPathSeparator:String = "/";
       
      
      public function StringUtil()
      {
         super();
      }
      
      public static function numberSeparator(param1:Number, param2:String = ",", param3:uint = 3) : String
      {
         var _loc4_:Array = [];
         var _loc5_:uint = Math.pow(10,param3);
         while(Math.abs(param1) >= _loc5_)
         {
            _loc4_.unshift(padLeft(param1 % _loc5_,param3));
            param1 = Math.floor(param1 / _loc5_);
         }
         _loc4_.unshift(param1);
         return _loc4_.join(param2);
      }
      
      public static function truncate(param1:String, param2:uint, param3:String = "...") : String
      {
         if(param1.length > param2)
         {
            param1 = param1.slice(0,Math.max(param2 - param3.length,0)) + param3;
         }
         return param1;
      }
      
      public static function capitalize(param1:String) : String
      {
         return param1.charAt(0).toUpperCase() + param1.slice(1);
      }
      
      public static function getJsonVar(param1:String, param2:String) : Object
      {
         var tokens:Array;
         var i:int;
         var obj:Object = null;
         var key:String = null;
         var path:String = param1;
         var serializedJson:String = param2;
         try
         {
            obj = com.adobe.serialization.json.JSON.decode(serializedJson);
         }
         catch(e:Error)
         {
            return null;
         }
         tokens = path.split(JPathSeparator);
         i = 1;
         while(i < tokens.length)
         {
            key = String(tokens[i]);
            if(!obj.hasOwnProperty(key))
            {
               return null;
            }
            obj = obj[key];
            i++;
         }
         return obj;
      }
      
      public static function trim(param1:String) : String
      {
         return param1.replace(/^\s+|\s+$/g,"");
      }
      
      private static function replace(param1:String, param2:String, param3:uint, param4:String) : String
      {
         var _loc6_:String = null;
         var _loc5_:Object = formatData;
         for each(_loc6_ in param2.split("."))
         {
            if(!_loc5_)
            {
               break;
            }
            _loc5_ = _loc5_[_loc6_];
         }
         return _loc5_ == null ? param1 : String(_loc5_.toString());
      }
      
      public static function format(param1:String, ... rest) : String
      {
         formatData = rest.length == 1 && typeof rest[0] == "object" ? rest[0] : rest;
         return param1.replace(/\{(\S+?)\}/g,replace);
      }
      
      public static function padLeft(param1:Object, param2:uint = 2, param3:String = "0") : String
      {
         var _loc4_:String = String(param1);
         while(_loc4_.length < param2)
         {
            _loc4_ = param3 + _loc4_;
         }
         return _loc4_;
      }
      
      public static function icompare(param1:String, param2:String) : Boolean
      {
         if(param1 === param2)
         {
            return true;
         }
         if(param1 === null || param2 === null)
         {
            return false;
         }
         return param1.toUpperCase() === param2.toUpperCase();
      }
      
      public static function setJsonVar(param1:String, param2:String, param3:Object) : Object
      {
         var i:int;
         var objetos:Array;
         var tokens:Array;
         var obj:Object = null;
         var key:String = null;
         var path:String = param1;
         var serializedJson:String = param2;
         var value:Object = param3;
         try
         {
            obj = com.adobe.serialization.json.JSON.decode(serializedJson);
         }
         catch(e:Error)
         {
            obj = {};
         }
         tokens = path.split(JPathSeparator);
         objetos = [obj];
         i = 1;
         while(i < tokens.length)
         {
            key = String(tokens[i]);
            if(objetos[objetos.length - 1].hasOwnProperty(key))
            {
               objetos.push(objetos[objetos.length - 1][key]);
            }
            else
            {
               objetos.push({});
            }
            i++;
         }
         objetos[objetos.length - 1] = value;
         i = int(tokens.length - 1);
         while(i >= 1)
         {
            if(typeof objetos[i - 1] != "object")
            {
               objetos[i - 1] = {};
            }
            objetos[i - 1][tokens[i]] = objetos[i];
            i--;
         }
         return com.adobe.serialization.json.JSON.encode(objetos[0]);
      }
   }
}
