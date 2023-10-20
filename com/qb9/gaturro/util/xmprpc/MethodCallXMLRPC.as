package com.qb9.gaturro.util.xmprpc
{
   public class MethodCallXMLRPC implements MethodCall
   {
       
      
      private var _parameters:Array;
      
      private var _TRACE_LEVEL:Number = 3;
      
      private var _PRODUCT:String = "MethodCallImpl";
      
      private var _xml:XML;
      
      private var _name:String;
      
      private var _VERSION:String = "1.0";
      
      public function MethodCallXMLRPC()
      {
         super();
         this.removeParams();
         this.debug("MethodCallImpl instance created. (v" + this._VERSION + ")");
      }
      
      public function removeParams() : void
      {
         this._parameters = new Array();
      }
      
      private function createParamsNode(param1:Object) : XML
      {
         var _loc3_:XML = null;
         var _loc4_:Object = null;
         var _loc5_:XML = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:XML = null;
         this.debug("CreateParameterNode()");
         var _loc2_:XML = <value/>;
         if(!param1.value && param1 && (!param1.type || param1.type == XMLRPCDataTypes.ARRAY || param1.type == XMLRPCDataTypes.STRUCT))
         {
            param1 = {"value":param1};
            if(!param1.type)
            {
               if((_loc4_ = param1.value) is String)
               {
                  param1.type = XMLRPCDataTypes.STRING;
               }
               else if(_loc4_ is Array)
               {
                  param1.type = XMLRPCDataTypes.ARRAY;
               }
               else
               {
                  param1.type = XMLRPCDataTypes.STRUCT;
               }
            }
         }
         if(typeof param1 == "object")
         {
            if(!param1.type)
            {
               if((_loc4_ = param1.value) is Array)
               {
                  param1.type = XMLRPCDataTypes.ARRAY;
               }
               else if(_loc4_ is Object && !_loc4_ is String)
               {
                  param1.type = XMLRPCDataTypes.STRUCT;
               }
               else
               {
                  param1.type = XMLRPCDataTypes.STRING;
               }
            }
            if(XMLRPCUtils.isSimpleType(param1.type))
            {
               param1 = this.fixCDATAParameter(param1);
               this.debug("CreateParameterNode(): Creating object \'" + param1.value + "\' as type " + param1.type);
               _loc3_ = <{param1.type}>{param1.value}</{param1.type}>;
               _loc2_.appendChild(_loc3_);
               return _loc2_;
            }
            if(param1.type == XMLRPCDataTypes.ARRAY)
            {
               this.debug("CreateParameterNode(): >> Begin Array");
               _loc3_ = <array/>;
               _loc5_ = <data/>;
               _loc6_ = 0;
               while(_loc6_ < param1.value.length)
               {
                  _loc5_.appendChild(this.createParamsNode(param1.value[_loc6_]));
                  _loc6_++;
               }
               _loc3_.appendChild(_loc5_);
               this.debug("CreateParameterNode(): << End Array");
               _loc2_.appendChild(_loc3_);
               return _loc2_;
            }
            if(param1.type == XMLRPCDataTypes.STRUCT)
            {
               this.debug("CreateParameterNode(): >> Begin struct");
               _loc3_ = <struct/>;
               for(_loc7_ in param1.value)
               {
                  (_loc8_ = <member/>).appendChild(<name>{_loc7_}</name>);
                  _loc8_.appendChild(<value>{param1.value[_loc7_]}</value>);
                  _loc3_.appendChild(_loc8_);
               }
               this.debug("CreateParameterNode(): << End struct");
               _loc2_.appendChild(_loc3_);
               return _loc2_;
            }
         }
         return _loc2_;
      }
      
      public function get params() : Array
      {
         return this._parameters;
      }
      
      public function setName(param1:String) : void
      {
         this._name = param1;
      }
      
      private function fixCDATAParameter(param1:Object) : Object
      {
         if(param1.type == XMLRPCDataTypes.CDATA)
         {
            param1.type = XMLRPCDataTypes.STRING;
            param1.value = "<![CDATA[" + param1.value + "]]>";
         }
         return param1;
      }
      
      public function cleanUp() : void
      {
      }
      
      private function debug(param1:Object) : void
      {
      }
      
      public function getXml() : XML
      {
         var _loc1_:XML = null;
         var _loc2_:XML = null;
         var _loc3_:Number = NaN;
         this.debug("getXml()");
         _loc1_ = <methodCall/>;
         this._xml = _loc1_;
         _loc2_ = <methodName>{this._name}</methodName>;
         _loc1_.appendChild(_loc2_);
         _loc2_ = <params/>;
         _loc1_.appendChild(_loc2_);
         _loc1_ = _loc2_;
         this.debug("Render(): Creating the params node.");
         _loc3_ = 0;
         while(_loc3_ < this._parameters.length)
         {
            this.debug("PARAM: " + [this._parameters[_loc3_].type,this._parameters[_loc3_].value]);
            _loc2_ = <param/>;
            _loc2_.appendChild(this.createParamsNode(this._parameters[_loc3_]));
            _loc1_.appendChild(_loc2_);
            _loc3_++;
         }
         this.debug("Render(): Resulting XML document:");
         this.debug("Render(): " + this._xml.toXMLString());
         return this._xml;
      }
      
      public function addParam(param1:Object, param2:String) : void
      {
         this.debug("MethodCallImpl.addParam(" + arguments + ")");
         this._parameters.push({
            "type":param2,
            "value":param1
         });
      }
   }
}
