package com.qb9.gaturro.commons.navigation
{
   public interface INavigation
   {
       
      
      function gotoPage(param1:uint = 0) : void;
      
      function gotoPrevPage() : void;
      
      function gotoEnd() : void;
      
      function gotoBeginning() : void;
      
      function refresh() : void;
      
      function gotoNextPage() : void;
   }
}
