package com.qb9.gaturro.view.screens
{
   import assets.LoginScreenMC;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.view.screens.events.LoginScreenEvent;
   import com.qb9.mambo.view.MamboView;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class LoginScreen extends MamboView
   {
       
      
      private var asset:LoginScreenMC;
      
      public function LoginScreen()
      {
         super();
      }
      
      private function get pass() : String
      {
         return this.asset.password.text;
      }
      
      private function submitWithKeyboard(param1:KeyboardEvent) : void
      {
         if(param1.keyCode === Keyboard.ENTER || param1.charCode === Keyboard.ENTER)
         {
            this.submit(param1);
         }
      }
      
      override public function dispose() : void
      {
         this.asset.submit.removeEventListener(MouseEvent.CLICK,this.submit);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.submitWithKeyboard);
         DisplayUtil.dispose(this.asset);
         this.asset = null;
         super.dispose();
      }
      
      private function submit(param1:Event) : void
      {
         if(Boolean(this.user) && Boolean(this.pass))
         {
            this.login(this.user,this.pass);
         }
      }
      
      private function login(param1:String, param2:String) : void
      {
         dispatchEvent(new LoginScreenEvent(LoginScreenEvent.LOGIN,param1,param2));
      }
      
      private function get user() : String
      {
         return this.userField.text;
      }
      
      override protected function whenAddedToStage() : void
      {
      }
      
      private function get userField() : TextField
      {
         return this.asset.username;
      }
   }
}
