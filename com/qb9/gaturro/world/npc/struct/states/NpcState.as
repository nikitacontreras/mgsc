package com.qb9.gaturro.world.npc.struct.states
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.world.npc.struct.NpcStatement;
   
   public class NpcState implements IDisposable
   {
       
      
      private var _name:String;
      
      protected var statements:Array;
      
      protected var top:NpcStatement;
      
      public function NpcState(param1:String, param2:NpcStatement, param3:Array)
      {
         super();
         this.top = param2;
         this.statements = param3;
         this._name = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function dispose() : void
      {
         var _loc1_:NpcStatement = null;
         for each(_loc1_ in this.statements.concat(this.top))
         {
            _loc1_.dispose();
         }
         this.top = null;
         this.statements = null;
      }
   }
}
