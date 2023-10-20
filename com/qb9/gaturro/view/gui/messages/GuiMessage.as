package com.qb9.gaturro.view.gui.messages
{
   import assets.guiMessageMC;
   
   public class GuiMessage extends guiMessageMC
   {
       
      
      public function GuiMessage()
      {
         super();
      }
      
      public function playMessage(param1:String) : void
      {
         container.t.text = param1;
         gotoAndPlay(1);
      }
   }
}
