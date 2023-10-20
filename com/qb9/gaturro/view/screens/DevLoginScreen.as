package com.qb9.gaturro.view.screens
{
   import assets.*;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.view.screens.events.LoginScreenEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DevLoginScreen extends LoginScreen
   {
       
      
      private var usersConfig:Object;
      
      private var user:String;
      
      private var asset:DevLoginScreenMC;
      
      private var pass:String;
      
      public function DevLoginScreen(param1:Object)
      {
         super();
         this.usersConfig = param1;
      }
      
      private function login(param1:String, param2:String) : void
      {
         dispatchEvent(new LoginScreenEvent(LoginScreenEvent.LOGIN,param1,param2));
      }
      
      private function submit(param1:Event) : void
      {
         var _loc2_:Object = param1.currentTarget.data;
         this.login(_loc2_.user,_loc2_.pass);
      }
      
      override protected function whenAddedToStage() : void
      {
         this.asset = new DevLoginScreenMC();
         addChild(this.asset);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            if(this.usersConfig.users[_loc1_] != null)
            {
               this.asset["name_" + _loc1_].text.text = this.usersConfig.users[_loc1_].user;
               this.asset["name_" + _loc1_].data = this.usersConfig.users[_loc1_];
               this.asset["name_" + _loc1_].addEventListener(MouseEvent.CLICK,this.submit);
            }
            else
            {
               this.asset["name_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.asset["name_" + _loc1_].removeEventListener(MouseEvent.CLICK,this.submit);
            _loc1_++;
         }
         DisplayUtil.dispose(this.asset);
         this.asset = null;
      }
   }
}
