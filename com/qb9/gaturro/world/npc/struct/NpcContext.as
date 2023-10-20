package com.qb9.gaturro.world.npc.struct
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehavior;
   import com.qb9.gaturro.world.npc.struct.variables.NpcVariable;
   
   public final class NpcContext implements IDisposable
   {
      
      private static const STATE_SUFFIX:String = "_state";
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var _behavior:NpcBehavior;
      
      private var script:com.qb9.gaturro.world.npc.struct.NpcScript;
      
      private var _api:GaturroSceneObjectAPI;
      
      public function NpcContext(param1:com.qb9.gaturro.world.npc.struct.NpcScript, param2:GaturroSceneObjectAPI, param3:GaturroRoomAPI)
      {
         super();
         this.script = param1;
         this._api = param2;
         this._roomAPI = param3;
         this._behavior = new NpcBehavior(param1);
         this.init();
      }
      
      public function getVariable(param1:String) : Object
      {
         var _loc2_:Object = this.script.getVariable(param1,this);
         return _loc2_ == null ? "" : _loc2_;
      }
      
      private function log(param1:String, param2:Array) : *
      {
         var _loc3_:String = param2.join(" ");
         logger[param1](["NPC",this.name,this.behavior.state.name,_loc3_].join(" > "));
         return null;
      }
      
      public function hasVariable(param1:String) : Boolean
      {
         return this.script.hasVariable(param1);
      }
      
      public function get stateKey() : String
      {
         return this.privateKey + STATE_SUFFIX;
      }
      
      public function error(... rest) : *
      {
         return this.log("warning",rest);
      }
      
      public function get name() : String
      {
         return this.script.name;
      }
      
      public function info(... rest) : *
      {
         return this.log("info",rest);
      }
      
      private function init() : void
      {
         var _loc1_:NpcVariable = null;
         for each(_loc1_ in this.script.variables)
         {
            if(_loc1_.getValue(this) === null && _loc1_.defaultValue !== null)
            {
               _loc1_.setValue(_loc1_.defaultValue,this);
            }
         }
      }
      
      public function debug(... rest) : *
      {
         return this.log("debug",rest);
      }
      
      public function dispose() : void
      {
         this.behavior.dispose();
         this._behavior = null;
      }
      
      public function get behavior() : NpcBehavior
      {
         return this._behavior;
      }
      
      public function get api() : GaturroSceneObjectAPI
      {
         return this._api;
      }
      
      public function get privateKey() : String
      {
         return this.api.sceneObjectId + "_";
      }
      
      public function setVariable(param1:String, param2:Object) : void
      {
         this.script.setVariable(param1,param2,this);
      }
      
      public function get roomAPI() : GaturroRoomAPI
      {
         return this._roomAPI;
      }
   }
}
