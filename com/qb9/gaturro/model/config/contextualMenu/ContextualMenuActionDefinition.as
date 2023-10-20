package com.qb9.gaturro.model.config.contextualMenu
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import flash.utils.Dictionary;
   
   public class ContextualMenuActionDefinition implements IActionButtonDefinitionHolder
   {
       
      
      private var _data:Object;
      
      private var _tootltipText:String;
      
      private var _tooltipAsset:String;
      
      private var _action:String;
      
      private var _hasActions:Boolean;
      
      private var _name:String;
      
      private var actionDefinitionMap:Dictionary;
      
      public function ContextualMenuActionDefinition()
      {
         super();
         this.actionDefinitionMap = new Dictionary();
      }
      
      public function hasActions() : Boolean
      {
         return this._hasActions;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function set tooltipAsset(param1:String) : void
      {
         this._tooltipAsset = param1;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public function get tootltipText() : String
      {
         return this._tootltipText;
      }
      
      public function get actions() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         if(this.actionDefinitionMap)
         {
            _loc1_.setupIterable(this.actionDefinitionMap);
         }
         return _loc1_;
      }
      
      public function set action(param1:String) : void
      {
         this._action = param1;
      }
      
      public function get tooltipAsset() : String
      {
         return this._tooltipAsset;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function getAction(param1:String) : ContextualMenuActionDefinition
      {
         var _loc2_:ContextualMenuActionDefinition = this.actionDefinitionMap[param1];
         if(!this.actionDefinitionMap)
         {
            throw new Error("There\'s no action definition with the name: " + param1);
         }
         return _loc2_;
      }
      
      public function get action() : String
      {
         return this._action;
      }
      
      public function addAction(param1:ContextualMenuActionDefinition) : void
      {
         this.actionDefinitionMap[param1.name] = param1;
         this._hasActions = true;
      }
      
      public function set tootltipText(param1:String) : void
      {
         this._tootltipText = param1;
      }
   }
}
