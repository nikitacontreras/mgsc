package config
{
   import flash.utils.Dictionary;
   
   public class AttributeControl
   {
      
      public static const SYSTEM_OBJECT_SUFFIX:String = "_so";
      
      private static var prohibitedAttrs:Array = [];
      
      private static var dictionary:Dictionary;
      
      public static const AVATAR_CUSTOMIZER_SUFFIX:String = "_on";
      
      private static var freeAttrs:Array = [];
       
      
      public function AttributeControl()
      {
         super();
      }
      
      public static function isProhibitedInAction(param1:String) : Boolean
      {
         param1 = param1.toLowerCase();
         if(param1.indexOf(SYSTEM_OBJECT_SUFFIX) > 0)
         {
            return true;
         }
         if(param1.indexOf("carscolors") >= 0)
         {
            return true;
         }
         trace(param1);
         if(param1.indexOf("pisogorrorojo") >= 0)
         {
            return true;
         }
         if(param1.toLowerCase().indexOf("floor") >= 0)
         {
            return true;
         }
         if(param1.indexOf("guardiannieve") >= 0)
         {
            return true;
         }
         if(param1.indexOf("geocat") >= 0)
         {
            return true;
         }
         return false;
      }
      
      public static function isInitialized() : Boolean
      {
         return prohibitedAttrs.length >= 1;
      }
      
      public static function isUserProhibited(param1:String, param2:String) : Boolean
      {
         if(param2)
         {
            if(isProhibitedItem(param2))
            {
               if(!AdminControl.isAdminUser(param1))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function isFree(param1:String) : Boolean
      {
         var _loc2_:String = null;
         if(freeAttrs.length == 0)
         {
            return false;
         }
         for each(_loc2_ in freeAttrs)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function isProhibited(param1:String) : Boolean
      {
         var _loc2_:Array = param1.split(".");
         if(_loc2_.length != 2)
         {
            return true;
         }
         var _loc3_:String = String(_loc2_[1]);
         if(_loc3_.indexOf(AVATAR_CUSTOMIZER_SUFFIX) <= -1)
         {
            return true;
         }
         return dictionary[param1.toUpperCase()] != null;
      }
      
      public static function init(param1:Array) : void
      {
         prohibitedAttrs = param1;
         createDictionary();
         createFreeAttrs();
      }
      
      private static function createDictionary() : void
      {
         var _loc1_:String = null;
         dictionary = new Dictionary(true);
         for each(_loc1_ in prohibitedAttrs)
         {
            dictionary[_loc1_.toUpperCase()] = true;
         }
      }
      
      public static function isProhibitedAsPet(param1:String) : Boolean
      {
         var _loc2_:Array = ["pet.koala","pet.penguin","pet.mulita","pet.mono","pet.dragon","pet2.detective","presidentes2019/wears.yetiGuardaespaldas"];
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(param1 == _loc2_[_loc4_])
            {
               _loc3_ = true;
            }
            _loc4_++;
         }
         return !_loc3_;
      }
      
      public static function createFreeAttrs() : void
      {
         freeAttrs.push("balloons.dirigible_on");
         freeAttrs.push("carnival2.remeraCarnavalVaron2_on");
      }
      
      private static function isProhibitedItem(param1:String) : Boolean
      {
         if(param1.indexOf("gatubers/props") != -1)
         {
            return true;
         }
         if(param1.indexOf("cards.") != -1)
         {
            return true;
         }
         if(param1.indexOf("nik.sandiaNik") != -1)
         {
            return true;
         }
         if(param1.indexOf("nik.perroInflableNik") != -1)
         {
            return true;
         }
         if(param1.indexOf("nik.bananaNik") != -1)
         {
            return true;
         }
         if(param1.indexOf("nik.burgerNik") != -1)
         {
            return true;
         }
         if(param1.indexOf("nik.panchoNik") != -1)
         {
            return true;
         }
         if(param1.indexOf("nik.avionAzulNik") != -1)
         {
            return true;
         }
         if(param1.indexOf("nik.donaNik") != -1)
         {
            return true;
         }
         if(param1.indexOf("costumesVip.remeraQB9_1") != -1)
         {
            return true;
         }
         if(param1.indexOf("gatubers2018/props") != -1)
         {
            return true;
         }
         if(param1.indexOf("nik.dona") != -1)
         {
            return true;
         }
         if(param1.indexOf("nik.pancho") != -1)
         {
            return true;
         }
         if(param1.indexOf("nik.avionAzul") != -1)
         {
            return true;
         }
         return false;
      }
   }
}
