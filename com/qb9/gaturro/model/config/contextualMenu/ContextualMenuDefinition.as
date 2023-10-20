package com.qb9.gaturro.model.config.contextualMenu
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.commons.model.definition.IDefinition;
   import flash.utils.Dictionary;
   
   public class ContextualMenuDefinition implements IDefinition, IActionButtonDefinitionHolder
   {
       
      
      private var _data:Object;
      
      private var _buttonAssetClass:String;
      
      private var _assetName:String;
      
      private var _className:String;
      
      private var _name:String;
      
      private var actionDefinitionMap:Dictionary;
      
      private var _classAsset:String;
      
      public function ContextualMenuDefinition()
      {
         super();
         this.actionDefinitionMap = new Dictionary();
      }
      
      public function get buttonAssetClass() : String
      {
         return this._buttonAssetClass;
      }
      
      public function set className(param1:String) : void
      {
         this._className = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public function addAction(param1:ContextualMenuActionDefinition) : void
      {
         this.actionDefinitionMap[param1.name] = param1;
      }
      
      public function set assetClass(param1:String) : void
      {
         this._classAsset = param1;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get assetName() : String
      {
         return this._assetName;
      }
      
      public function get className() : String
      {
         return this._className;
      }
      
      public function get assetClass() : String
      {
         return this._classAsset;
      }
      
      public function getAction(param1:String) : ContextualMenuActionDefinition
      {
         var _loc2_:ContextualMenuActionDefinition = this.actionDefinitionMap[param1];
         if(!_loc2_)
         {
            throw new Error("There\'s no action definition with the name: " + param1);
         }
         return _loc2_;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set buttonAssetClass(param1:String) : void
      {
         this._buttonAssetClass = param1;
      }
      
      public function set assetName(param1:String) : void
      {
         this._assetName = param1;
      }
      
      public function get actions() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(this.actionDefinitionMap);
         return _loc1_;
      }
   }
}
