package com.qb9.mambo.core.attributes
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.filter;
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.lang.map;
   import com.qb9.flashlib.utils.ObjectUtil;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mines.mobject.Mobject;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   public dynamic class CustomAttributes extends Proxy implements MobjectBuildable, IDisposable
   {
       
      
      private var arrCache:Array;
      
      private var list:Object;
      
      private var _owner:com.qb9.mambo.core.attributes.CustomAttributeDispatcher;
      
      public function CustomAttributes(param1:com.qb9.mambo.core.attributes.CustomAttributeDispatcher = null)
      {
         this.list = {};
         super();
         this.assignTo(param1);
      }
      
      protected function dispatch(param1:Array) : void
      {
         if(Boolean(this.owner) && Boolean(param1.length))
         {
            this.owner.dispatchCustomAttributes(param1);
         }
      }
      
      public function mergeObject(param1:Object, param2:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc3_:Array = [];
         for(_loc4_ in param1)
         {
            _loc3_.push(new CustomAttribute(_loc4_,param1[_loc4_]));
         }
         this.mergeAttributesArray(_loc3_,param2);
      }
      
      public function assignTo(param1:com.qb9.mambo.core.attributes.CustomAttributeDispatcher) : void
      {
         this._owner = param1;
      }
      
      protected function getProperty(param1:String) : Object
      {
         var _loc2_:CustomAttribute = this.getAttr(param1);
         return _loc2_ && _loc2_.value;
      }
      
      public function toString() : String
      {
         return "[CustomAttributes " + this.toArray().toString() + "]";
      }
      
      protected function hasProperty(param1:String) : Boolean
      {
         return param1 in this.list;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this.getProperty(this.getKey(param1));
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         if(param1 === 0)
         {
            this.arrCache = this.toArray();
         }
         return (param1 + 1) % (this.arrCache.length + 1);
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return this.hasProperty(this.getKey(param1));
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         this.setProperty(this.getKey(param1),param2);
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this.list = {};
         foreach(this.parseMobjectArray(param1),this.addAttribute);
      }
      
      public function clone(param1:com.qb9.mambo.core.attributes.CustomAttributeDispatcher = null) : CustomAttributes
      {
         var _loc2_:CustomAttributes = new CustomAttributes(param1);
         ObjectUtil.copy(this.list,_loc2_.list);
         return _loc2_;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return this.arrCache[param1 - 1].key;
      }
      
      public function dispose() : void
      {
         this.list = null;
         this.arrCache = null;
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         return delete this.list[this.getKey(param1)];
      }
      
      protected function setProperty(param1:String, param2:Object) : void
      {
         this.setValue(param1,param2);
         if(this.owner)
         {
            this.owner.dispatchCustomAttributes([this.getAttr(param1)]);
         }
      }
      
      private function getAttr(param1:String) : CustomAttribute
      {
         return this.list[param1] as CustomAttribute;
      }
      
      protected function getKey(param1:Object) : String
      {
         return param1 is QName ? String(param1.localName) : String(param1.toString());
      }
      
      public function mergeAttributesArray(param1:Array, param2:Boolean = false) : void
      {
         if(!param2)
         {
            param1 = filter(param1,this.isDifferentThanCurrent);
         }
         foreach(param1,this.addAttribute);
         this.dispatch(param1);
      }
      
      public function mergeMobject(param1:Mobject, param2:Boolean = false) : void
      {
         this.mergeAttributesArray(this.parseMobjectArray(param1),param2);
      }
      
      public function toArray() : Array
      {
         return ObjectUtil.values(this.list);
      }
      
      private function setValue(param1:String, param2:Object) : void
      {
         this.list[param1] = new CustomAttribute(param1,param2);
      }
      
      private function isDifferentThanCurrent(param1:CustomAttribute) : Boolean
      {
         var _loc2_:CustomAttribute = this.getAttr(param1.key);
         return _loc2_ === null || param1.value !== _loc2_.value;
      }
      
      private function parseMobjectArray(param1:Mobject) : Array
      {
         var _loc2_:Array = param1.getMobjectArray("customAttributes");
         return map(_loc2_ || [],this.parseMobject);
      }
      
      private function parseMobject(param1:Mobject) : CustomAttribute
      {
         var _loc2_:CustomAttribute = new CustomAttribute();
         _loc2_.buildFromMobject(param1);
         return _loc2_;
      }
      
      public function get owner() : com.qb9.mambo.core.attributes.CustomAttributeDispatcher
      {
         return this._owner;
      }
      
      protected function addAttribute(param1:CustomAttribute) : void
      {
         this.list[param1.key] = param1;
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         return this.arrCache[param1 - 1].value;
      }
      
      public function merge(param1:CustomAttributes, param2:Boolean = false) : void
      {
         this.mergeAttributesArray(param1.toArray(),param2);
      }
   }
}
