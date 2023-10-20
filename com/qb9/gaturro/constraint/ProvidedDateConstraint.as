package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   
   public class ProvidedDateConstraint extends AbstractConstraint
   {
      
      private static const GREAT_THAN:String = "gt";
      
      private static const EQUAL:String = "eq";
      
      private static const LESS_THAN:String = "lt";
       
      
      private var configuredDate:Date;
      
      private var comparer:String;
      
      public function ProvidedDateConstraint(param1:Boolean)
      {
         super(param1);
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc3_:* = false;
         var _loc2_:Date = param1 is Date ? param1 as Date : this.convertToDate(param1.toString());
         switch(this.comparer)
         {
            case LESS_THAN:
               _loc3_ = _loc2_.time < this.configuredDate.time;
               break;
            case GREAT_THAN:
               _loc3_ = _loc2_.time > this.configuredDate.time;
               break;
            case EQUAL:
               _loc3_ = _loc2_.time == this.configuredDate.time;
         }
         return doInvert(_loc3_);
      }
      
      override public function setData(param1:*) : void
      {
         this.configuredDate = this.convertToDate(param1.date.toString());
         this.comparer = param1.comparer;
      }
      
      private function convertToDate(param1:String) : Date
      {
         var _loc2_:Number = Date.parse(param1);
         return new Date(_loc2_);
      }
   }
}
