package com.qb9.gaturro.world.npc.struct
{
   import com.qb9.flashlib.config.Evaluator;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.security.SafeString;
   import com.qb9.gaturro.globals.region;
   
   public final class NpcToken implements IDisposable
   {
      
      public static const VARIABLE_REGEX:RegExp = /\$\(([^)]+)\)/g;
       
      
      private var cached:Object;
      
      private var ready:Boolean = false;
      
      private var codeToken:SafeString;
      
      private var context:com.qb9.gaturro.world.npc.struct.NpcContext;
      
      private var isDynamic:Boolean;
      
      public function NpcToken(param1:String)
      {
         super();
         this.codeToken = new SafeString(param1);
      }
      
      private function init() : void
      {
         this.ready = true;
         this.isDynamic = VARIABLE_REGEX.test(this.codeToken.value);
         if(!this.isDynamic)
         {
            this.cached = Evaluator.parse(this.codeToken.value);
         }
      }
      
      private function replaceVariables(param1:com.qb9.gaturro.world.npc.struct.NpcContext) : String
      {
         this.context = param1;
         VARIABLE_REGEX.lastIndex = 0;
         var _loc2_:String = this.codeToken.value.replace(VARIABLE_REGEX,this.fetchVariable);
         this.context = null;
         return _loc2_;
      }
      
      private function fetchVariable(param1:String, param2:String, param3:uint, param4:String) : Object
      {
         return this.context.getVariable(param2);
      }
      
      public function getValue(param1:com.qb9.gaturro.world.npc.struct.NpcContext = null) : Object
      {
         if(!this.ready)
         {
            this.init();
         }
         if(!this.isDynamic)
         {
            return this.cached;
         }
         var _loc2_:String = this.codeToken.value;
         if(param1)
         {
            _loc2_ = this.replaceVariables(param1);
         }
         return Evaluator.parse(_loc2_);
      }
      
      public function traslate() : void
      {
         this.codeToken = new SafeString(region.getText(this.codeToken.value));
      }
      
      public function dispose() : void
      {
         this.context = null;
         this.codeToken = null;
         this.cached = null;
      }
   }
}
