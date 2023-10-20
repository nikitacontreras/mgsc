package com.qb9.gaturro.world.houseInteractive
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.view.world.elements.HomeInteractiveRoomSceneObjectView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class HomeBehavior implements IDisposable
   {
       
      
      protected var states:Array;
      
      protected var _isOwner:Boolean;
      
      protected var asset:MovieClip;
      
      protected var _currentState:int;
      
      protected var objectAPI:GaturroSceneObjectAPI;
      
      protected var roomAPI:GaturroRoomAPI;
      
      public function HomeBehavior()
      {
         super();
         this.currentState = 0;
         this.states = new Array();
      }
      
      public function dispose() : void
      {
         this.roomAPI = null;
         this.objectAPI = null;
         this.asset = null;
         this.states = null;
      }
      
      public function set currentState(param1:int) : void
      {
         this._currentState = param1;
      }
      
      public function start(param1:DisplayObject, param2:GaturroRoomAPI, param3:GaturroSceneObjectAPI) : void
      {
         var _loc4_:int = 0;
         var _loc5_:HomeInteractiveRoomSceneObjectView = null;
         if(param2)
         {
            this.roomAPI = param2;
         }
         if(param3)
         {
            this.objectAPI = param3;
         }
         if(param1)
         {
            this.asset = param1 as MovieClip;
            _loc4_ = 0;
            while(_loc4_ < this.asset.currentLabels.length)
            {
               this.states.push(this.asset.currentLabels[_loc4_].name);
               _loc4_++;
            }
            this.asset.gotoAndStop(this.states[this.currentState]);
         }
         if(param2 && param3 && Boolean(param1))
         {
            if((_loc5_ = param2.getView(param3.object) as HomeInteractiveRoomSceneObjectView).getChildAt(0) != this.asset)
            {
               _loc5_.removeChildAt(0);
            }
         }
         this.atStart();
      }
      
      public function get isOwner() : Boolean
      {
         return this._isOwner;
      }
      
      protected function atStart() : void
      {
      }
      
      public function set isOwner(param1:Boolean) : void
      {
         this._isOwner = param1;
      }
      
      public function get currentState() : int
      {
         return this._currentState;
      }
      
      public function activate() : void
      {
      }
   }
}
