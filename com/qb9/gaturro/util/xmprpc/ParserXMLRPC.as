package com.qb9.gaturro.util.xmprpc
{
   public class ParserXMLRPC implements Parser
   {
       
      
      private var ELEMENT_NODE:Number = 1;
      
      private var MEMBER_NODE:String = "member";
      
      private var ARRAY_NODE:String = "array";
      
      private var _PRODUCT:String = "ParserImpl";
      
      private var PARAM_NODE:String = "param";
      
      private var TEXT_NODE:Number = 3;
      
      private var FAULT_NODE:String = "fault";
      
      private var METHOD_RESPONSE_NODE:String = "methodResponse";
      
      private var PARAMS_NODE:String = "params";
      
      private var STRUCT_NODE:String = "struct";
      
      private var VALUE_NODE:String = "value";
      
      private var DATA_NODE:String = "data";
      
      private var _VERSION:String = "1.0.0";
      
      public function ParserXMLRPC()
      {
         super();
      }
      
      private function createSimpleType(param1:String, param2:String) : Object
      {
         switch(param1)
         {
            case XMLRPCDataTypes.i4:
            case XMLRPCDataTypes.INT:
            case XMLRPCDataTypes.DOUBLE:
               return new Number(param2);
            case XMLRPCDataTypes.STRING:
               return new String(param2);
            case XMLRPCDataTypes.DATETIME:
               return this.getDateFromIso8601(param2);
            case XMLRPCDataTypes.BASE64:
               return param2;
            case XMLRPCDataTypes.CDATA:
               return param2;
            case XMLRPCDataTypes.BOOLEAN:
               if(param2 == "1" || param2.toLowerCase() == "true")
               {
                  return new Boolean(true);
               }
               if(param2 == "0" || param2.toLowerCase() == "false")
               {
                  return new Boolean(false);
               }
               break;
         }
         return param2;
      }
      
      private function debug(param1:String) : void
      {
      }
      
      public function parse(param1:XML) : Object
      {
         if(param1.toString().toLowerCase().indexOf("<html") >= 0)
         {
            trace("WARNING: XML-RPC Response looks like an html page.");
            return param1.toString();
         }
         return this._parse(param1);
      }
      
      private function _parse(param1:XML) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(param1.nodeKind() == "text")
         {
            return param1.toString();
         }
         if(param1.nodeKind() == "element")
         {
            if(param1.name() == this.METHOD_RESPONSE_NODE || param1.name() == this.PARAMS_NODE || param1.name() == this.VALUE_NODE || param1.name() == this.PARAM_NODE || param1.name() == this.FAULT_NODE || param1.name() == this.ARRAY_NODE)
            {
               this.debug("_parse(): >> " + param1.name());
               if(param1.name() == this.VALUE_NODE && param1.*.length() <= 0)
               {
                  return null;
               }
               return this._parse(param1.*[0]);
            }
            if(param1.name() == this.DATA_NODE)
            {
               this.debug("_parse(): >> Begin Array");
               _loc2_ = new Array();
               _loc3_ = 0;
               while(_loc3_ < param1.children().length())
               {
                  _loc2_.push(this._parse(param1.children()[_loc3_]));
                  this.debug("_parse(): adding data to array: " + _loc2_[_loc2_.length - 1]);
                  _loc3_++;
               }
               this.debug("_parse(): << End Array");
               return _loc2_;
            }
            if(param1.name() == this.STRUCT_NODE)
            {
               this.debug("_parse(): >> Begin Struct");
               _loc2_ = new Object();
               _loc3_ = 0;
               while(_loc3_ < param1.children().length())
               {
                  _loc4_ = this._parse(param1.children()[_loc3_]);
                  _loc2_[_loc4_.name] = _loc4_.value;
                  this.debug("_parse(): Struct item " + _loc4_.name + ":" + _loc4_.value);
                  _loc3_++;
               }
               this.debug("_parse(): << End Stuct");
               return _loc2_;
            }
            if(param1.name() == this.MEMBER_NODE)
            {
               _loc2_ = new Object();
               _loc2_.name = param1.name[0].toString();
               _loc2_.value = this._parse(param1.value[0]);
               return _loc2_;
            }
            if(param1.name() == "name")
            {
               return this._parse(param1.*[0]);
            }
            if(XMLRPCUtils.isSimpleType(param1.name()))
            {
               return this.createSimpleType(param1.name(),param1.*);
            }
         }
         this.debug("Received an invalid Response.");
         return null;
      }
      
      private function getDateFromIso8601(param1:String) : Date
      {
         var _loc2_:Array = param1.split("T");
         var _loc3_:String = String(_loc2_[0]);
         var _loc4_:String = String(_loc2_[1]);
         var _loc5_:Array = _loc3_.split("-");
         var _loc6_:Array = _loc4_.split(":");
         return new Date(_loc5_[0],_loc5_[1] - 1,_loc5_[2],_loc6_[0],_loc6_[1],_loc6_[2]);
      }
   }
}
