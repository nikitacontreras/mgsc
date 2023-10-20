package com.qb9.flashlib.movieclip
{
   import com.qb9.flashlib.movieclip.actions.IAction;
   import com.qb9.flashlib.movieclip.conditions.ICondition;
   
   public class Trigger
   {
       
      
      private var _action:IAction;
      
      private var _condition:ICondition;
      
      public function Trigger(param1:ICondition, param2:IAction)
      {
         super();
         this._condition = param1;
         this._action = param2;
      }
      
      public function get action() : IAction
      {
         return this._action;
      }
      
      public function get condition() : ICondition
      {
         return this._condition;
      }
   }
}
