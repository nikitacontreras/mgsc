package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import flash.display.MovieClip;
   
   internal class InternalTitledScreen extends BaseIPhone2Screen
   {
       
      
      public function InternalTitledScreen(param1:IPhone2Modal, param2:String, param3:MovieClip, param4:Object)
      {
         super(param1,param3,param4);
         this.setTitle(param2);
      }
      
      protected function setTitle(param1:String) : void
      {
         setText("title.field",param1);
      }
   }
}
