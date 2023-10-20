package com.qb9.gaturro.world.npc.struct.states.dialog
{
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.gaturro.world.npc.struct.NpcStatement;
   import com.qb9.gaturro.world.npc.struct.states.NpcState;
   
   public final class NpcDialogState extends NpcState
   {
       
      
      private var nextStates:NpcStatement;
      
      private var _options:Array;
      
      public function NpcDialogState(param1:String, param2:NpcStatement, param3:Array)
      {
         this._options = [];
         super(param1,param2,param3);
         foreach(param3,this.addStatement);
      }
      
      public function getMessage(param1:NpcContext) : String
      {
         return top.argumentAt(0,param1) as String;
      }
      
      public function get hasOptions() : Boolean
      {
         return this._options.length > 0;
      }
      
      public function get options() : Array
      {
         return this._options.concat();
      }
      
      override public function dispose() : void
      {
         var _loc1_:NpcDialogOption = null;
         for each(_loc1_ in this._options)
         {
            _loc1_.dispose();
         }
         this._options = null;
         super.dispose();
      }
      
      public function getNextState(param1:NpcContext) : String
      {
         return !!this.nextStates ? ArrayUtil.choice(this.nextStates.getArguments(param1)) as String : null;
      }
      
      private function addStatement(param1:NpcStatement) : void
      {
         switch(param1.reserved)
         {
            case "goto":
               this.nextStates = param1;
               break;
            case "option":
               this._options.push(new NpcDialogOption(param1));
         }
      }
   }
}
