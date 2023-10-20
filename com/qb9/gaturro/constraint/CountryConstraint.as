package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.globals.api;
   
   public class CountryConstraint extends AbstractConstraint
   {
       
      
      private var country:String;
      
      public function CountryConstraint(param1:Boolean)
      {
         super(param1);
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:* = false;
         if(api)
         {
            _loc2_ = this.country == api.country;
            return doInvert(_loc2_);
         }
         return false;
      }
      
      override public function setData(param1:*) : void
      {
         this.country = param1.country;
      }
   }
}
