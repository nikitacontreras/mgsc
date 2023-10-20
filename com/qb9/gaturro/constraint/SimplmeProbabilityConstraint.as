package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.globals.logger;
   
   public class SimplmeProbabilityConstraint extends AbstractConstraint
   {
       
      
      private var probability:int;
      
      public function SimplmeProbabilityConstraint(param1:Boolean)
      {
         super(param1);
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Number = Math.random();
         var _loc3_:int = _loc2_ * 100;
         var _loc4_:* = this.probability > _loc3_;
         return doInvert(_loc4_);
      }
      
      override public function setData(param1:*) : void
      {
         this.probability = parseInt(param1.probability.toString());
         if(this.probability < 1 && this.probability > 99)
         {
            logger.debug("The probability data is out of range. It should be between 1 to 99 and setted " + this.probability);
            throw new Error("The probability data is out of range. It should be between 1 to 99 and setted " + this.probability);
         }
      }
   }
}
