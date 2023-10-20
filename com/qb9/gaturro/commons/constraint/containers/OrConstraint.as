package com.qb9.gaturro.commons.constraint.containers
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   
   public class OrConstraint extends AbstractConstraintContainer
   {
       
      
      public function OrConstraint(param1:Boolean)
      {
         super(param1);
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:AbstractConstraint = null;
         for each(_loc3_ in constraintList)
         {
            _loc2_ = _loc3_.accomplish(param1);
            if(_loc2_)
            {
               break;
            }
         }
         return doInvert(_loc2_);
      }
   }
}
