package com.qb9.gaturro.world.npc.struct
{
   import com.qb9.flashlib.interfaces.IDisposable;
   
   public final class NpcStatement implements IDisposable
   {
       
      
      private var cmd:com.qb9.gaturro.world.npc.struct.NpcToken;
      
      private var args:Array;
      
      public function NpcStatement(param1:Array)
      {
         super();
         this.cmd = param1.shift();
         this.args = param1;
      }
      
      public function getArguments(param1:NpcContext = null) : Array
      {
         var _loc3_:com.qb9.gaturro.world.npc.struct.NpcToken = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.args)
         {
            _loc2_.push(_loc3_.getValue(param1));
         }
         return _loc2_;
      }
      
      public function traslateArgument(param1:uint) : void
      {
         if(param1 in this.args)
         {
            NpcToken(this.args[param1]).traslate();
         }
      }
      
      public function get length() : uint
      {
         return this.args.length;
      }
      
      public function argumentAt(param1:uint, param2:NpcContext = null) : Object
      {
         return param1 in this.args ? NpcToken(this.args[param1]).getValue(param2) : null;
      }
      
      public function get reserved() : String
      {
         return this.cmd.getValue() as String;
      }
      
      public function dispose() : void
      {
         var _loc1_:com.qb9.gaturro.world.npc.struct.NpcToken = null;
         for each(_loc1_ in this.args.concat(this.cmd))
         {
            _loc1_.dispose();
         }
         this.cmd = null;
         this.args = null;
      }
   }
}
