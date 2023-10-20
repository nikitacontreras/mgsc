package com.qb9.gaturro.view.gui.iphone2.screens.store
{
   import assets.AppStoreMainMC;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.user.cellPhone.ICellPhoneApp;
   import com.qb9.gaturro.user.cellPhone.apps.CellPhoneAppDefinition;
   import com.qb9.gaturro.view.gui.iphone2.CellPhoneButton;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.view.gui.iphone2.screens.BaseIPhone2Screen;
   import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2Screens;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class AppStoreMainScreen extends BaseIPhone2Screen
   {
       
      
      private var selectedApp:uint;
      
      private var tasks:TaskContainer;
      
      private var coin:MovieClip;
      
      private var arrowRight:CellPhoneButton;
      
      private var confirmationPopUp:MovieClip;
      
      private var appDescription:TextField;
      
      private var installButton:CellPhoneButton;
      
      private var arrowLeft:CellPhoneButton;
      
      private const INSTALL_BUTTON_NAME:String = "INSTALAR";
      
      private var confirmInstallButton:CellPhoneButton;
      
      private var declineInstallButton:CellPhoneButton;
      
      private const availableApps:Array = [5,6,7,8,9];
      
      private var screen:AppStoreMainMC;
      
      private var notEnoughCoinsPopUp:MovieClip;
      
      private var value:TextField;
      
      private var apps:Array;
      
      private var userCoinAmount:TextField;
      
      private var appView:MovieClip;
      
      private var currentApp:ICellPhoneApp;
      
      private var appSelectorCont:MovieClip;
      
      private const UNINSTALL_BUTTON_NAME:String = "REMOVER";
      
      public function AppStoreMainScreen(param1:IPhone2Modal, param2:MovieClip, param3:Object, param4:TaskContainer)
      {
         super(param1,param2,{});
         this.tasks = param4;
      }
      
      override protected function backButton() : void
      {
         this.screen.removeChild(this.appView);
         back(IPhone2Screens.MENU);
      }
      
      private function onArrowRightPress(param1:Event) : void
      {
         if(this.selectedApp == this.apps.length - 1)
         {
            this.selectedApp = 0;
         }
         else
         {
            ++this.selectedApp;
         }
         this.setCurrentAppView();
      }
      
      override public function dispose() : void
      {
         var _loc1_:AppSelector = null;
         for each(_loc1_ in this.appSelectorCont)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onAppSelectorClick);
            _loc1_ = null;
         }
         super.dispose();
      }
      
      private function isAppInstalled(param1:ICellPhoneApp) : Boolean
      {
         var _loc3_:ICellPhoneApp = null;
         var _loc2_:Array = api.user.cellPhone.apps.apps;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.appkey == param1.appkey)
            {
               return true;
            }
         }
         return false;
      }
      
      private function setCurrentAppView() : void
      {
         var _loc1_:ICellPhoneApp = this.apps[this.selectedApp];
         if(this.screen.appView.numChildren > 0)
         {
            this.screen.appView.removeChildAt(0);
         }
         this.screen.appView.addChild(_loc1_.marketView);
         var _loc2_:int = 0;
         while(_loc2_ < this.appSelectorCont.numChildren)
         {
            if(_loc2_ == this.selectedApp)
            {
               AppSelector(this.appSelectorCont.getChildAt(_loc2_)).gotoAndStop("on");
            }
            else
            {
               AppSelector(this.appSelectorCont.getChildAt(_loc2_)).gotoAndStop("off");
            }
            _loc2_++;
         }
         if(_loc1_.value > 0)
         {
            this.coin.visible = true;
            this.screen.gatuPesoPrecio.visible = true;
            this.value.text = "   " + _loc1_.value.toString();
         }
         else
         {
            this.screen.gatuPesoPrecio.visible = false;
            this.coin.visible = false;
            this.value.text = api.getText("GRATIS");
         }
         this.appDescription.text = api.getText(_loc1_.appDescription);
         this.installButton.view.installText.text = this.isAppInstalled(_loc1_) ? api.getText(this.UNINSTALL_BUTTON_NAME) : api.getText(this.INSTALL_BUTTON_NAME);
      }
      
      private function onArrowLeftPress(param1:Event) : void
      {
         if(this.selectedApp == 0)
         {
            this.selectedApp = this.apps.length - 1;
         }
         else
         {
            --this.selectedApp;
         }
         this.setCurrentAppView();
      }
      
      private function onConfirmInstallation(param1:MouseEvent) : void
      {
         var _loc5_:int = 0;
         this.confirmationPopUp.visible = false;
         var _loc2_:ICellPhoneApp = this.apps[this.selectedApp];
         var _loc3_:int = int(api.getProfileAttribute("coins"));
         var _loc4_:int = int(_loc2_.value);
         if(this.isAppInstalled(_loc2_))
         {
            api.user.cellPhone.apps.remove(_loc2_.appkey);
         }
         else if(_loc4_ > 0)
         {
            if(_loc3_ >= _loc4_)
            {
               _loc5_ = _loc3_ - _loc4_;
               api.setProfileAttribute("system_coins",_loc5_);
               api.user.cellPhone.apps.add(_loc2_.appkey);
               this.userCoinAmount.text = _loc5_.toString();
            }
            else
            {
               this.notEnoughCoinsPopUp.visible = true;
            }
         }
         else
         {
            api.user.cellPhone.apps.add(_loc2_.appkey);
         }
         this.setCurrentAppView();
      }
      
      private function onInstall(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:ICellPhoneApp = this.apps[this.selectedApp];
         if(!this.isAppInstalled(_loc2_))
         {
            if(_loc2_.value > 0)
            {
               _loc3_ = int(api.getProfileAttribute("coins"));
               if(_loc3_ < _loc2_.value)
               {
                  this.notEnoughCoinsPopUp.visible = true;
               }
               else
               {
                  this.confirmationPopUp.visible = true;
                  this.confirmationPopUp.text.text = api.getText("¿DESEAS INSTALAR");
               }
            }
            else
            {
               this.confirmationPopUp.visible = true;
               this.confirmationPopUp.text.text = api.getText("¿DESEAS INSTALAR");
            }
         }
         else
         {
            this.confirmationPopUp.visible = true;
            this.confirmationPopUp.text.text = api.getText("¿DESEAS REMOVER");
         }
      }
      
      private function setConfirmationPopUps() : void
      {
         this.confirmationPopUp = new MarketConfirmationPopUp();
         this.confirmationPopUp.x = 65;
         this.confirmationPopUp.y = 50;
         this.confirmationPopUp.visible = false;
         this.confirmInstallButton = new CellPhoneButton(this.confirmationPopUp.yes,this.onConfirmInstallation);
         this.declineInstallButton = new CellPhoneButton(this.confirmationPopUp.no,this.onDeclineInstallation);
         this.screen.addChild(this.confirmationPopUp);
         this.notEnoughCoinsPopUp = new MarketNoMoneyPopUp();
         this.notEnoughCoinsPopUp.x = 65;
         this.notEnoughCoinsPopUp.y = 50;
         this.notEnoughCoinsPopUp.visible = false;
         this.screen.addChild(this.notEnoughCoinsPopUp);
         new CellPhoneButton(this.notEnoughCoinsPopUp,this.onCloseNotEnoughCoins);
      }
      
      private function onAppSelectorClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.appSelectorCont.numChildren)
         {
            if(this.appSelectorCont.getChildAt(_loc2_) == param1.target)
            {
               this.selectedApp = _loc2_;
               this.setCurrentAppView();
            }
            _loc2_++;
         }
      }
      
      private function onCloseNotEnoughCoins(param1:MouseEvent) : void
      {
         this.notEnoughCoinsPopUp.visible = false;
      }
      
      override protected function whenAdded() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:AppSelector = null;
         this.apps = new Array();
         for each(_loc1_ in this.availableApps)
         {
            this.apps.push(CellPhoneAppDefinition.generateAppbyId(_loc1_));
         }
         this.selectedApp = 0;
         this.screen = asset as AppStoreMainMC;
         this.installButton = new CellPhoneButton(this.screen.installButton,this.onInstall);
         this.appDescription = this.screen.appDescription;
         this.appView = this.screen.appView;
         this.appView.y = 115;
         this.coin = this.screen.coin;
         this.value = this.screen.value;
         this.userCoinAmount = this.screen.userCoinAmount;
         this.userCoinAmount.text = api.getProfileAttribute("coins").toString();
         this.arrowLeft = new CellPhoneButton(this.screen.arrowLeft,this.onArrowLeftPress);
         this.arrowRight = new CellPhoneButton(this.screen.arrowRight,this.onArrowRightPress);
         this.appSelectorCont = new MovieClip();
         _loc2_ = 0;
         while(_loc2_ < this.availableApps.length)
         {
            _loc3_ = new AppSelector();
            _loc3_.x = _loc2_ * (_loc3_.width + 5);
            this.appSelectorCont.addChild(_loc3_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onAppSelectorClick);
            _loc3_.mouseChildren = false;
            _loc3_.buttonMode = true;
            _loc2_++;
         }
         this.appSelectorCont.x = -this.appSelectorCont.width / 2;
         this.screen.appSelectorContainer.addChild(this.appSelectorCont);
         this.setCurrentAppView();
         this.setConfirmationPopUps();
      }
      
      private function onDeclineInstallation(param1:MouseEvent) : void
      {
         this.confirmationPopUp.visible = false;
      }
   }
}
