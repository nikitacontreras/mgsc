package com.qb9.gaturro.world.core.elements
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.world.collection.NpcScriptList;
   import com.qb9.gaturro.world.core.elements.events.GaturroRoomSceneObjectEvent;
   import com.qb9.gaturro.world.npc.interpreter.NpcInterpeter;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.gaturro.world.npc.struct.NpcScript;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.world.core.events.GeneralEvent;
   import com.qb9.mambo.world.elements.MovingRoomSceneObject;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public class NpcRoomSceneObject extends MovingRoomSceneObject
   {
       
      
      private var _loading:Boolean = false;
      
      private var _showing:Boolean = false;
      
      private var scripts:NpcScriptList;
      
      private var selfAPI:GaturroSceneObjectAPI;
      
      private var _interpreter:NpcInterpeter;
      
      private var roomAPI:GaturroRoomAPI;
      
      public function NpcRoomSceneObject(param1:CustomAttributes, param2:TileGrid, param3:NpcScriptList)
      {
         super(param1,param2);
         this.scripts = param3;
         this.initEvents();
      }
      
      override protected function get dumpVars() : Array
      {
         return super.dumpVars.concat("behaviorName");
      }
      
      public function get showing() : Boolean
      {
         return this._showing;
      }
      
      private function initEvents() : void
      {
         addEventListener(GaturroRoomSceneObjectEvent.NOT_SHOWING,this.changeShowing);
         addEventListener(GaturroRoomSceneObjectEvent.SHOWING,this.changeShowing);
      }
      
      override public function get monitorAttributes() : Boolean
      {
         return "monitorAttributes" in attributes && Boolean(attributes.monitorAttributes);
      }
      
      public function get behaviorState() : String
      {
         return this._interpreter.stateName;
      }
      
      private function processBehavior(param1:NpcScript) : void
      {
         if(param1 === null)
         {
            return;
         }
         var _loc2_:NpcContext = new NpcContext(param1,this.selfAPI,this.roomAPI);
         this._interpreter = new NpcInterpeter(_loc2_);
         this._loading = false;
         dispatchEvent(new GeneralEvent(GeneralEvent.READY));
      }
      
      public function get ready() : Boolean
      {
         return this.interpreter !== null;
      }
      
      public function load(param1:GaturroRoomAPI, param2:GaturroSceneObjectAPI) : void
      {
         if(this.loading || this.ready)
         {
            return;
         }
         this.roomAPI = param1;
         this.selfAPI = param2;
         this._loading = true;
         this.scripts.fetch(this.behaviorName,this.processBehavior);
      }
      
      private function changeShowing(param1:GaturroRoomSceneObjectEvent) : void
      {
         this._showing = param1.type === GaturroRoomSceneObjectEvent.SHOWING;
      }
      
      override public function dispose() : void
      {
         removeEventListener(GaturroRoomSceneObjectEvent.NOT_SHOWING,this.changeShowing);
         removeEventListener(GaturroRoomSceneObjectEvent.SHOWING,this.changeShowing);
         if(this.interpreter)
         {
            this._interpreter.dispose();
         }
         this._interpreter = null;
         super.dispose();
      }
      
      public function get interpreter() : NpcInterpeter
      {
         return this._interpreter;
      }
      
      public function get loading() : Boolean
      {
         return this._loading;
      }
      
      public function get behaviorName() : String
      {
         return attributes.behavior;
      }
   }
}
