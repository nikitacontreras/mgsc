package com.qb9.gaturro.manager.board
{
   public class TournamentData
   {
       
      
      private var _user:String;
      
      private var _point:int;
      
      private var _slot:int;
      
      public function TournamentData(param1:int, param2:String = "", param3:int = 0)
      {
         super();
         this._slot = param1;
         this._point = param3;
         this._user = param2;
      }
      
      public function set point(param1:int) : void
      {
         this._point = param1;
      }
      
      public function get user() : String
      {
         return this._user;
      }
      
      public function get point() : int
      {
         return this._point;
      }
      
      public function set user(param1:String) : void
      {
         this._user = param1;
      }
      
      public function get slot() : int
      {
         return this._slot;
      }
   }
}
