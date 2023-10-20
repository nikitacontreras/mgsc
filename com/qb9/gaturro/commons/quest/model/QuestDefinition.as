package com.qb9.gaturro.commons.quest.model
{
   import com.qb9.gaturro.commons.object.ObjectUtil;
   
   public class QuestDefinition
   {
       
      
      private var _description:String;
      
      private var _code:int;
      
      private var _title:String;
      
      private var _goToRoomData:com.qb9.gaturro.commons.quest.model.GoToRoomDefinition;
      
      private var _endDate:Date;
      
      private var _iconClassName:String;
      
      private var _initializationPopup:com.qb9.gaturro.commons.quest.model.QuestPopUpDefinition;
      
      private var _completionPopup:String;
      
      private var _amount:int;
      
      private var _activationConstraint:Object;
      
      private var _accomplishmentConstraint:Object;
      
      public function QuestDefinition()
      {
         super();
      }
      
      public function get iconClassName() : String
      {
         return this._iconClassName;
      }
      
      public function set accomplishmentConstraint(param1:Object) : void
      {
         this._accomplishmentConstraint = param1;
      }
      
      public function set amount(param1:int) : void
      {
         this._amount = param1;
      }
      
      public function setGoToRoomData(param1:Object) : void
      {
         this._goToRoomData = new com.qb9.gaturro.commons.quest.model.GoToRoomDefinition(param1);
      }
      
      public function get goToRoomData() : com.qb9.gaturro.commons.quest.model.GoToRoomDefinition
      {
         return this._goToRoomData;
      }
      
      public function set endDate(param1:Date) : void
      {
         this._endDate = param1;
      }
      
      public function get activationConstraint() : Object
      {
         return ObjectUtil.clone(this._activationConstraint) as Object;
      }
      
      public function setInitializationPopup(param1:Object) : void
      {
         this._initializationPopup = !!param1 ? new com.qb9.gaturro.commons.quest.model.QuestPopUpDefinition(param1) : null;
      }
      
      public function set iconClassName(param1:String) : void
      {
         this._iconClassName = param1;
      }
      
      public function get completionPopup() : String
      {
         return this._completionPopup;
      }
      
      public function get accomplishmentConstraint() : Object
      {
         return ObjectUtil.clone(this._accomplishmentConstraint) as Object;
      }
      
      public function get title() : String
      {
         return this._title.toUpperCase();
      }
      
      public function set completionPopup(param1:String) : void
      {
         this._completionPopup = param1;
      }
      
      public function set code(param1:int) : void
      {
         this._code = param1;
      }
      
      public function set activationConstraint(param1:Object) : void
      {
         this._activationConstraint = param1;
      }
      
      public function get endDate() : Date
      {
         return this._endDate;
      }
      
      public function get initializationPopup() : com.qb9.gaturro.commons.quest.model.QuestPopUpDefinition
      {
         return this._initializationPopup;
      }
      
      public function get amount() : int
      {
         return this._amount;
      }
      
      public function get code() : int
      {
         return this._code;
      }
      
      public function set description(param1:String) : void
      {
         this._description = param1;
      }
      
      public function toString() : String
      {
         return "[QuestDefinition: Name= " + this.code + " // Title= " + this.title + " // Description= " + this.description + "]";
      }
      
      public function get description() : String
      {
         return this._description.toUpperCase();
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
      }
   }
}
