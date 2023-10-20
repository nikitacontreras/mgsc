package com.qb9.gaturro.world.npc.struct
{
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.utils.ObjectUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.world.npc.struct.states.NpcState;
   import com.qb9.gaturro.world.npc.struct.variables.NpcSessionVariable;
   import com.qb9.gaturro.world.npc.struct.variables.NpcVariable;
   import com.qb9.gaturro.world.npc.struct.variables.providers.*;
   
   public final class NpcScript
   {
      
      public static const LAST_FIND:String = "_LAST_ID_";
      
      private static const PROVIDERS:Object = {
         "time":new NpcVariableProviderTime(),
         "user":new NpcVariableProviderUser(),
         "owner":new NpcVariableProviderOwner(),
         "self":new NpcVariableProviderSelf(),
         "last":new NpcVariableProviderLast(),
         "rand":new NpcVariableProviderRand(),
         "avatars":new NpcVariableProviderAvatars(),
         "room":new NpcVariableProviderRoom(),
         "region":new NpcVariableProviderRegion(),
         "pet":new NpcVariableProviderPet()
      };
       
      
      private var states:Object;
      
      private const JPathSeparator:String = "/";
      
      private var _name:String;
      
      private var _initialState:String;
      
      private var vars:Object;
      
      public function NpcScript(param1:String, param2:Array, param3:Array)
      {
         this.states = {};
         this.vars = {};
         super();
         this._name = param1;
         foreach(param2,this.addState);
         foreach(param3,this.addVariable);
         this.addVariable(new NpcSessionVariable(LAST_FIND));
      }
      
      public function setVariable(param1:String, param2:Object, param3:NpcContext) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc4_:int;
         if((_loc4_ = param1.indexOf(StringUtil.JPathSeparator)) > 0)
         {
            if((_loc5_ = param1.substring(0,_loc4_)) in this.vars)
            {
               _loc6_ = String(this.vars[_loc5_].getValue(param3));
               NpcVariable(this.vars[_loc5_]).setValue(StringUtil.setJsonVar(param1,_loc6_,param2),param3);
            }
            else
            {
               this.error("Cannot set the variable",param1,"to",param2,"because it is not defined");
            }
         }
         else if(param1 in this.vars)
         {
            NpcVariable(this.vars[param1]).setValue(param2,param3);
         }
         else
         {
            this.error("Cannot set the variable",param1,"to",param2,"because it is not defined");
         }
      }
      
      private function getJsonPath(param1:String, param2:Object) : Object
      {
         var _loc5_:String = null;
         var _loc3_:Array = param1.split(this.JPathSeparator);
         var _loc4_:int = 1;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = String(_loc3_[_loc4_]);
            if(!param2.hasOwnProperty(_loc5_))
            {
               return null;
            }
            param2 = param2[_loc5_];
            _loc4_++;
         }
         return param2;
      }
      
      private function setJsonPath(param1:String, param2:Object, param3:Object) : Object
      {
         var _loc7_:String = null;
         var _loc4_:Array = param1.split(this.JPathSeparator);
         var _loc5_:Array = [param2];
         var _loc6_:int = 1;
         while(_loc6_ < _loc4_.length)
         {
            _loc7_ = String(_loc4_[_loc6_]);
            if(_loc5_[_loc5_.length - 1].hasOwnProperty(_loc7_))
            {
               _loc5_.push(_loc5_[_loc5_.length - 1][_loc7_]);
            }
            else
            {
               _loc5_.push({});
            }
            _loc6_++;
         }
         _loc5_[_loc5_.length - 1] = param3;
         _loc6_ = int(_loc4_.length - 1);
         while(_loc6_ >= 1)
         {
            _loc5_[_loc6_ - 1][_loc4_[_loc6_]] = _loc5_[_loc6_];
            _loc6_--;
         }
         return _loc5_[0];
      }
      
      public function getState(param1:String) : NpcState
      {
         return this.states[param1] as NpcState;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get initialState() : String
      {
         return this._initialState;
      }
      
      private function error(... rest) : void
      {
         logger.warning(["NpcScript",this.name,rest.join(" ")].join(" > "));
      }
      
      private function addState(param1:NpcState) : void
      {
         if(this.states[param1.name] is NpcState)
         {
            return this.error("The state",param1.name,"was already registered");
         }
         this.states[param1.name] = param1;
         this._initialState = this._initialState || param1.name;
      }
      
      public function getVariable(param1:String, param2:NpcContext) : Object
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:NpcVariableProvider = null;
         var _loc3_:int = param1.indexOf(StringUtil.JPathSeparator);
         if(_loc3_ > 0)
         {
            if((_loc4_ = param1.substring(0,_loc3_)) in this.vars)
            {
               _loc5_ = String(this.vars[_loc4_].getValue(param2));
               return StringUtil.getJsonVar(param1,_loc5_);
            }
            return null;
         }
         if(this.hasVariable(param1))
         {
            return NpcVariable(this.vars[param1]).getValue(param2);
         }
         if((_loc6_ = param1.indexOf(".")) !== -1)
         {
            _loc7_ = param1.slice(0,_loc6_);
            _loc8_ = param1.slice(_loc6_ + 1);
            if((_loc9_ = PROVIDERS[_loc7_] as NpcVariableProvider).has(_loc8_,param2))
            {
               return _loc9_.getValue(_loc8_,param2);
            }
         }
         this.error("The variable",param1,"is not defined");
         return null;
      }
      
      public function hasVariable(param1:String) : Boolean
      {
         return param1 in this.vars;
      }
      
      public function get variables() : Array
      {
         return ObjectUtil.values(this.vars);
      }
      
      private function addVariable(param1:NpcVariable) : void
      {
         if(param1)
         {
            this.vars[param1.name] = param1;
         }
      }
      
      public function hasState(param1:String) : Boolean
      {
         return param1 in this.states;
      }
   }
}
