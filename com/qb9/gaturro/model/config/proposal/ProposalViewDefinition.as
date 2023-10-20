package com.qb9.gaturro.model.config.proposal
{
   import com.qb9.gaturro.commons.model.definition.IDefinition;
   import flash.utils.Dictionary;
   
   public class ProposalViewDefinition implements IDefinition
   {
       
      
      private var _feedbackMessage:Dictionary;
      
      private var _singleRoomViewManager:String;
      
      private var _data:Object;
      
      private var _feedbackAudio:Dictionary;
      
      private var _code:int;
      
      private var _timedRoomViewManager:String;
      
      private var _responserAvailableContraint:Object;
      
      private var _name:String;
      
      private var _proposerAvailableConstraint:Object;
      
      public function ProposalViewDefinition(param1:int, param2:String)
      {
         super();
         this._name = param2;
         this._code = param1;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set feedbackMessage(param1:Dictionary) : void
      {
         this._feedbackMessage = param1;
      }
      
      public function get singleRoomViewManager() : String
      {
         return this._singleRoomViewManager;
      }
      
      public function set singleRoomViewManager(param1:String) : void
      {
         this._singleRoomViewManager = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function getFeedbackMessage(param1:String) : String
      {
         var _loc2_:String = String(this._feedbackMessage[param1]);
         if(!_loc2_)
         {
            throw new Error("There is no message under the key: " + param1);
         }
         return _loc2_;
      }
      
      public function get responserAvailableContraint() : Object
      {
         return this._responserAvailableContraint;
      }
      
      public function getFeedbackAudio(param1:String) : String
      {
         var _loc2_:String = String(this._feedbackAudio[param1]);
         if(!_loc2_)
         {
            throw new Error("There is no audio under the key: " + param1);
         }
         return _loc2_;
      }
      
      public function set feedbackAudio(param1:Dictionary) : void
      {
         this._feedbackAudio = param1;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public function set proposerAvailableConstraint(param1:Object) : void
      {
         this._proposerAvailableConstraint = param1;
      }
      
      public function set timedRoomViewManager(param1:String) : void
      {
         this._timedRoomViewManager = param1;
      }
      
      public function get code() : int
      {
         return this._code;
      }
      
      public function get proposerAvailableConstraint() : Object
      {
         return this._proposerAvailableConstraint;
      }
      
      public function get timedRoomViewManager() : String
      {
         return this._timedRoomViewManager;
      }
      
      public function set responserAvailableContraint(param1:Object) : void
      {
         this._responserAvailableContraint = param1;
      }
   }
}
