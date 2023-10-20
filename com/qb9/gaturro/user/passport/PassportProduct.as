package com.qb9.gaturro.user.passport
{
   public class PassportProduct
   {
       
      
      private var _name:String;
      
      private var _passportId:int;
      
      private var _alias:String;
      
      public function PassportProduct(param1:Object)
      {
         super();
         this.parse(param1);
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get passportId() : int
      {
         return this._passportId;
      }
      
      public function get alias() : String
      {
         return this._alias;
      }
      
      private function parse(param1:Object) : void
      {
         this._passportId = parseInt(param1.passportId);
         this._name = param1.name;
         this._alias = param1.alias;
      }
      
      public function hasPassport() : Boolean
      {
         return this._passportId > 0;
      }
   }
}
