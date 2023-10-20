package com.qb9.gaturro.world.gatucine
{
   public class UIResponse
   {
       
      
      private var responseDesc:Object;
      
      private var responseSuccess:Boolean = false;
      
      public function UIResponse(param1:Boolean, param2:String = "")
      {
         super();
         this.responseSuccess = param1;
         this.responseDesc = param2;
      }
      
      public function get success() : Boolean
      {
         return this.responseSuccess;
      }
      
      public function get description() : Object
      {
         return this.responseDesc;
      }
   }
}
