package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.globals.api;
   
   public class IsVipConstraint extends AbstractConstraint
   {
       
      
      private var isVip:Boolean;
      
      public function IsVipConstraint(param1:Boolean)
      {
         super(param1);
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         if(api)
         {
            return doInvert(api.isCitizen);
         }
         return false;
      }
   }
}
