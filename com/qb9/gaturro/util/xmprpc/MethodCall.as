package com.qb9.gaturro.util.xmprpc
{
   public interface MethodCall
   {
       
      
      function getXml() : XML;
      
      function get params() : Array;
      
      function removeParams() : void;
      
      function addParam(param1:Object, param2:String) : void;
      
      function setName(param1:String) : void;
   }
}
