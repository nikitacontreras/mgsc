package com.qb9.flashlib.movieclip.conditions
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import flash.display.MovieClip;
   
   public class ChildDefinedCondition implements ICondition
   {
       
      
      private var path:String;
      
      public function ChildDefinedCondition(param1:String)
      {
         super();
         this.path = param1;
      }
      
      public function fulfilled(param1:MovieClip) : Boolean
      {
         return DisplayUtil.getByPath(param1,this.path) !== null;
      }
   }
}
