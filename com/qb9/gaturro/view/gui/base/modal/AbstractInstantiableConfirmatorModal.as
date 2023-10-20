package com.qb9.gaturro.view.gui.base.modal
{
   import com.qb9.gaturro.view.gui.base.IConfirmator;
   
   public class AbstractInstantiableConfirmatorModal extends InstantiableGuiModal implements IConfirmator
   {
       
      
      public function AbstractInstantiableConfirmatorModal(param1:String = "", param2:String = "")
      {
         super(param1,param2);
      }
      
      public function confirm() : void
      {
         throw new Error("Have to implement within a subclass");
      }
   }
}
