package com.qb9.gaturro.crypto.customsha256
{
   import com.adobe.crypto.HMAC;
   import com.adobe.crypto.SHA256;
   
   public class HMCACustomSHA256
   {
       
      
      private var _encryptedByteArray:String;
      
      private var _encryptedString:String;
      
      private var _message:String;
      
      private var _secret:String;
      
      public function HMCACustomSHA256(param1:String, param2:String)
      {
         super();
         this._secret = param1;
         this._message = param2;
      }
      
      public function calculate() : String
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         _loc1_ = SHA256;
         return HMAC.hash(this._secret,this._message,_loc1_);
      }
   }
}
