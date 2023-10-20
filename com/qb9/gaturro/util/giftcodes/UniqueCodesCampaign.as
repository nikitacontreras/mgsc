package com.qb9.gaturro.util.giftcodes
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.region;
   import flash.utils.setTimeout;
   
   public class UniqueCodesCampaign extends Campaign
   {
       
      
      private const CHARACTER_BURNED:String = "x";
      
      private const CHARACTER_NOT_BURNED:String = "-";
      
      private const CODES_IN_ATTR:int = 250;
      
      public function UniqueCodesCampaign(param1:Object)
      {
         super(param1);
      }
      
      private function attrNameByPos(param1:int) : String
      {
         var _loc2_:int = Math.floor(param1 / this.CODES_IN_ATTR) + 1;
         return campaignData.data.customAttrName + _loc2_.toString();
      }
      
      protected function get usedCodeString() : String
      {
         return "<usedcode>";
      }
      
      override public function codeCheck(param1:Function, param2:String) : void
      {
         lastGiftCode = param2;
         callbackGiftCode = param1;
         var _loc3_:Object = this.searchForGiftData(param2);
         if(!_loc3_)
         {
            setTimeout(callbackGiftCode,2000,errorString);
            return;
         }
         var _loc4_:int = int(_loc3_.pos);
         var _loc5_:String = String(_loc3_.name);
         if(this.checkIfCodeUsed(_loc4_))
         {
            setTimeout(callbackGiftCode,2000,this.usedCodeString);
            return;
         }
         setTimeout(this.burnCode,2000,_loc4_,_loc5_);
      }
      
      private function fillPosition(param1:String, param2:int, param3:int) : String
      {
         if(param2 < param3)
         {
            if(param1.length < param2)
            {
               param1 += this.CHARACTER_NOT_BURNED;
            }
         }
         else if(param2 == param3)
         {
            if(param1.length < param2)
            {
               param1 += this.CHARACTER_BURNED;
            }
            else
            {
               param1 = param1.substr(0,param3 - 1) + this.CHARACTER_BURNED + param1.substr(param3);
            }
         }
         return param1;
      }
      
      private function saveAttr(param1:int) : void
      {
         var _loc2_:String = this.attrNameByPos(param1);
         var _loc3_:String = "";
         if(api.getProfileAttribute(_loc2_))
         {
            _loc3_ = api.getProfileAttribute(_loc2_) as String;
         }
         var _loc4_:int = 1;
         while(_loc4_ <= param1)
         {
            _loc3_ = this.fillPosition(_loc3_,_loc4_,param1);
            _loc4_++;
         }
         api.setProfileAttribute(_loc2_,_loc3_);
      }
      
      private function checkIfCodeUsed(param1:int) : Boolean
      {
         var _loc2_:String = this.attrNameByPos(param1);
         if(!api.getProfileAttribute(_loc2_))
         {
            return false;
         }
         var _loc3_:String = api.getProfileAttribute(_loc2_) as String;
         _loc3_ = StringUtil.trim(_loc3_);
         if(_loc3_.length < param1)
         {
            return false;
         }
         if(_loc3_.substr(param1 - 1,1) != this.CHARACTER_BURNED)
         {
            return false;
         }
         return true;
      }
      
      private function searchForGiftData(param1:String) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc2_:int = 1;
         for each(_loc3_ in campaignData.data.codes)
         {
            if(_loc3_.code.toUpperCase() == param1.toUpperCase())
            {
               _loc4_ = true;
               if(_loc3_.countries)
               {
                  _loc4_ = ArrayUtil.contains(_loc3_.countries,region.country);
               }
               if(_loc4_)
               {
                  return {
                     "name":_loc3_.gift,
                     "pos":_loc2_
                  };
               }
            }
            _loc2_++;
         }
         return null;
      }
      
      private function burnCode(param1:int, param2:String) : void
      {
         this.saveAttr(param1);
         deliverItem(param2);
      }
   }
}
