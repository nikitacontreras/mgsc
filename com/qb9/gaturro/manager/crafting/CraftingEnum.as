package com.qb9.gaturro.manager.crafting
{
   import com.qb9.gaturro.globals.logger;
   import flash.utils.Dictionary;
   
   public class CraftingEnum
   {
      
      public static const UNAVAILABLE_STR:String = "unavailable";
      
      public static const AVAILABLE_CODE:int = 2;
      
      public static const GRANTED_CODE:int = 3;
      
      public static const UNAVAILABLE_CODE:int = 1;
      
      private static var _rewardStatusMapByStr:Dictionary;
      
      private static var _rewardStatusMapByCode:Dictionary;
      
      public static const NON_EXISTENT_CODE:int = 4;
      
      public static const GRANTED_STR:String = "granted";
      
      public static const CRAFTING_PREFIX:String = "crafting";
      
      public static const AVAILABLE_STR:String = "avalable";
      
      public static const NON_EXISTENT_STR:String = "nonExistent";
       
      
      public function CraftingEnum()
      {
         super();
         logger.debug("This class shouldn\'t be  instantiated");
         throw new Error("This class shouldn\'t be  instantiated");
      }
      
      public static function getRewardStatusCode(param1:String) : int
      {
         if(!_rewardStatusMapByStr)
         {
            setupRewardStatusMapByStr();
         }
         var _loc2_:int = int(_rewardStatusMapByStr[param1]);
         if(!_loc2_)
         {
            logger.debug(param1 + " is not a valid status.");
            throw new Error(param1 + " is not a valid status.");
         }
         return _loc2_;
      }
      
      public static function isValidStatusCode(param1:int) : Boolean
      {
         return getRewardStatusLabel(param1) as Boolean;
      }
      
      private static function setupRewardStatusMapByStr() : void
      {
         _rewardStatusMapByStr = new Dictionary();
         _rewardStatusMapByStr[UNAVAILABLE_STR] = UNAVAILABLE_CODE;
         _rewardStatusMapByStr[AVAILABLE_STR] = AVAILABLE_CODE;
         _rewardStatusMapByStr[GRANTED_STR] = GRANTED_CODE;
         _rewardStatusMapByStr[NON_EXISTENT_STR] = NON_EXISTENT_CODE;
      }
      
      private static function setupRewardStatusMapByCode() : void
      {
         _rewardStatusMapByCode = new Dictionary();
         _rewardStatusMapByCode[UNAVAILABLE_CODE] = UNAVAILABLE_STR;
         _rewardStatusMapByCode[AVAILABLE_CODE] = AVAILABLE_STR;
         _rewardStatusMapByCode[GRANTED_CODE] = GRANTED_STR;
         _rewardStatusMapByCode[NON_EXISTENT_CODE] = NON_EXISTENT_STR;
      }
      
      public static function getRewardStatusLabel(param1:int) : String
      {
         if(!_rewardStatusMapByCode)
         {
            setupRewardStatusMapByCode();
         }
         var _loc2_:String = String(_rewardStatusMapByCode[param1]);
         if(!_loc2_)
         {
            logger.debug(param1 + " is not a valid status.");
            throw new Error(param1 + " is not a valid status.");
         }
         return _loc2_;
      }
   }
}
