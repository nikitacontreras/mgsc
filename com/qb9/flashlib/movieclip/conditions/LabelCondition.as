package com.qb9.flashlib.movieclip.conditions
{
   import flash.display.MovieClip;
   
   public class LabelCondition implements ICondition
   {
       
      
      private var label:String;
      
      public function LabelCondition(param1:String)
      {
         super();
         this.label = param1;
      }
      
      public function fulfilled(param1:MovieClip) : Boolean
      {
         return param1.currentLabel == this.label;
      }
   }
}
