package com.qb9.gaturro.commons.constraint.containers
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.constraint.IConstraintContainer;
   
   public class AbstractConstraintContainer extends AbstractConstraint implements IConstraintContainer
   {
       
      
      protected var constraintList:Array;
      
      public function AbstractConstraintContainer(param1:Boolean)
      {
         super(param1);
         this.constraintList = new Array();
      }
      
      public function addConstraint(param1:AbstractConstraint) : void
      {
         this.constraintList.push(param1);
      }
      
      override public function unobserve() : void
      {
         var _loc1_:AbstractConstraint = null;
         for each(_loc1_ in this.constraintList)
         {
            _loc1_.unobserve();
         }
      }
      
      override public function observe(param1:Function) : void
      {
         var _loc2_:AbstractConstraint = null;
         for each(_loc2_ in this.constraintList)
         {
            _loc2_.observe(param1);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:AbstractConstraint = null;
         for each(_loc1_ in this.constraintList)
         {
            _loc1_.dispose();
         }
         this.constraintList = null;
         super.dispose();
      }
   }
}
