package com.qb9.gaturro.util.xmprpc
{
   public interface MethodFault
   {
       
      
      function getFaultCode() : Number;
      
      function getArgs() : Array;
      
      function toString() : String;
      
      function getFaultString() : String;
      
      function setFaultObject(param1:Object) : void;
   }
}
