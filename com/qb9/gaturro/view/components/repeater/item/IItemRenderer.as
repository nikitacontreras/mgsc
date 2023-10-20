package com.qb9.gaturro.view.components.repeater.item
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   
   public interface IItemRenderer extends ICheckableDisposable
   {
       
      
      function set itemId(param1:int) : void;
      
      function get isSelected() : Boolean;
      
      function refresh(param1:Object = null) : void;
      
      function select() : void;
      
      function deselect() : void;
      
      function get itemId() : int;
   }
}
