package com.qb9.gaturro.view.components.repeater
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   import com.qb9.gaturro.view.components.repeater.item.IItemRendererFactory;
   
   public interface IRepeater extends ICheckableDisposable
   {
       
      
      function get selectedData() : Array;
      
      function set itemRendererFactory(param1:IItemRendererFactory) : void;
      
      function get selectedItem() : Array;
      
      function addSelectedItem(param1:AbstractItemRenderer) : void;
      
      function get itemList() : Array;
      
      function set rows(param1:int) : void;
      
      function set layout(param1:int) : void;
      
      function build() : void;
      
      function set dataProvider(param1:IIterable) : void;
      
      function get selectedIndex() : Array;
      
      function set columns(param1:int) : void;
      
      function refresh() : void;
      
      function addSelectedIndex(param1:int) : void;
   }
}
