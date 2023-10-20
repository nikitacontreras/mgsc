package com.qb9.gaturro.view.gui.base.components
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import fl.controls.ComboBox;
   
   public final class DropDown extends ComboBox implements IDisposable
   {
       
      
      public function DropDown()
      {
         super();
      }
      
      public function add(param1:String, param2:String = null) : void
      {
         addItem(new DropDownItem(param1,param2));
      }
      
      public function dispose() : void
      {
         close();
      }
   }
}
