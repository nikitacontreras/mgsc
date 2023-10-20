package com.qb9.gaturro.world.houseInteractive.buyer
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.granja.FarmRequest;
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import com.qb9.gaturro.world.core.elements.HomeInteractiveRoomSceneObject;
   import com.qb9.gaturro.world.houseInteractive.silo.SiloManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class BuyingManager
   {
       
      
      private var buttonHeight:int;
      
      private var config:Object;
      
      private var buttonMargin:int = 10;
      
      private var _buttons:Array;
      
      private const SIDEBAR_ASSET:String = "granja.sideBarHolder";
      
      private var _pedido2:FarmRequest;
      
      private var _pedido3:FarmRequest;
      
      private var _pedido1:FarmRequest;
      
      private var _siloManager:SiloManager;
      
      private var _tasks:TaskContainer;
      
      private var _api:GaturroRoomAPI;
      
      private var crops:Object;
      
      private var userLevel:Object;
      
      private var _gui:Gui;
      
      private var _roomView:GaturroHomeGranjaView;
      
      public function BuyingManager(param1:GaturroRoomAPI, param2:Gui, param3:TaskContainer)
      {
         super();
         this._api = param1;
         this._gui = param2;
         this._tasks = param3;
         this._roomView = param1.roomView as GaturroHomeGranjaView;
         this._siloManager = this._roomView.siloManager;
         this._buttons = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < 3)
         {
            param1.libraries.fetch(this.SIDEBAR_ASSET,this.fetchButtons,_loc4_);
            _loc4_++;
         }
         this.crops = settings.granjaHome.crops;
         this.userLevel = this._roomView.jobStats.currentLevel.toString();
         this.config = settings.granjaHome.selling[this._roomView.jobStats.currentLevel.toString()];
      }
      
      public function get pedido1() : Object
      {
         return this._pedido1;
      }
      
      public function get pedido2() : Object
      {
         return this._pedido2;
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:FarmRequest = null;
         var _loc3_:MovieClip = param1.target as MovieClip;
         var _loc4_:int = this.determineButtonIndex(_loc3_);
         switch(_loc4_)
         {
            case 0:
               _loc2_ = this._pedido1;
               break;
            case 1:
               _loc2_ = this._pedido2;
               break;
            case 2:
               _loc2_ = this._pedido3;
         }
         this._api.showGranjaSellingModal(_loc2_);
      }
      
      public function get pedido3() : Object
      {
         return this._pedido3;
      }
      
      private function updateButton(param1:Boolean, param2:MovieClip) : void
      {
         if(param1)
         {
            param2.tick.visible = true;
            this._api.playSound("granja/pedido");
         }
         else
         {
            param2.tick.visible = false;
         }
      }
      
      public function deleteRequest(param1:int) : void
      {
         var _loc3_:HomeInteractiveRoomSceneObject = null;
         switch(param1)
         {
            case 1:
               this._pedido1 = null;
               break;
            case 2:
               this._pedido2 = null;
               break;
            case 3:
               this._pedido3 = null;
         }
         this._buttons[param1 - 1].visible = false;
         this._api.setProfileAttribute("granjaPedido" + param1,"");
         var _loc2_:int = 0;
         while(_loc2_ < this._api.room.sceneObjects.length)
         {
            if(this._api.room.sceneObjects[_loc2_] is HomeInteractiveRoomSceneObject)
            {
               _loc3_ = this._api.room.sceneObjects[_loc2_] as HomeInteractiveRoomSceneObject;
               if(_loc3_.name == "granja.Comprador_" + param1.toString())
               {
                  (_loc3_.stateMachine as BuyerBehavior).makeVisible();
               }
            }
            _loc2_++;
         }
         this.checkReady();
      }
      
      private function fetchButtons(param1:DisplayObject, param2:int) : void
      {
         var _loc3_:MovieClip = null;
         _loc3_ = param1 as MovieClip;
         if(!this.buttonHeight)
         {
            this.buttonHeight = param1.height;
         }
         _loc3_.y = param2 * (this.buttonHeight + this.buttonMargin);
         _loc3_.buttonMode = true;
         _loc3_.glow.visible = false;
         _loc3_.tick.visible = false;
         this._api.libraries.fetch("granja.Comprador" + (param2 + 1) + "Cara",this.fetchFaces,{"button":_loc3_.ph});
         this._buttons.push(_loc3_);
         this._gui.jobSidebar.addChild(_loc3_);
         _loc3_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onButtonMouseOver);
         _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.onButtonMouseOut);
         var _loc4_:String = "granjaPedido" + (param2 + 1).toString();
         var _loc5_:Object;
         if(_loc5_ = this._api.getProfileAttribute(_loc4_))
         {
            switch(param2)
            {
               case 0:
                  this._pedido1 = new FarmRequest(this.config,this.crops,param2 + 1,_loc5_);
                  break;
               case 1:
                  this._pedido2 = new FarmRequest(this.config,this.crops,param2 + 1,_loc5_);
                  break;
               case 2:
                  this._pedido3 = new FarmRequest(this.config,this.crops,param2 + 1,_loc5_);
            }
            _loc3_.visible = true;
            this.checkReady();
         }
         else
         {
            _loc3_.visible = false;
         }
      }
      
      private function onButtonMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this.determineButton(param1.target as MovieClip);
         if(_loc2_)
         {
            _loc2_.glow.visible = true;
         }
      }
      
      public function generateRequest(param1:int) : void
      {
         var _loc2_:FarmRequest = null;
         this.userLevel = this._roomView.jobStats.currentLevel.toString();
         this.config = settings.granjaHome.selling[this._roomView.jobStats.currentLevel.toString()];
         switch(param1)
         {
            case 1:
               this._pedido1 = new FarmRequest(this.config,this.crops,param1);
               _loc2_ = this._pedido1;
               break;
            case 2:
               this._pedido2 = new FarmRequest(this.config,this.crops,param1);
               _loc2_ = this._pedido2;
               break;
            case 3:
               this._pedido3 = new FarmRequest(this.config,this.crops,param1);
               _loc2_ = this._pedido3;
         }
         this._api.setProfileAttribute("granjaPedido" + param1,_loc2_.toString());
         this._api.showGranjaSellingModal(_loc2_);
         this._buttons[param1 - 1].visible = true;
         this.checkReady();
      }
      
      private function fetchFaces(param1:DisplayObject, param2:Object) : void
      {
         param2.button.addChild(param1);
      }
      
      private function determineButton(param1:MovieClip) : MovieClip
      {
         var _loc2_:int = 0;
         while(Boolean(param1) && param1 != this._gui)
         {
            _loc2_ = 0;
            while(_loc2_ < this._buttons.length)
            {
               if(param1 == this._buttons[_loc2_])
               {
                  return param1;
               }
               _loc2_++;
            }
            param1 = param1.parent as MovieClip;
         }
         return null;
      }
      
      private function determineButtonIndex(param1:MovieClip) : int
      {
         var _loc2_:int = 0;
         while(Boolean(param1) && param1 != this._gui)
         {
            _loc2_ = 0;
            while(_loc2_ < this._buttons.length)
            {
               if(param1 == this._buttons[_loc2_])
               {
                  return _loc2_;
               }
               _loc2_++;
            }
            param1 = param1.parent as MovieClip;
         }
         return 0;
      }
      
      public function openPedido(param1:int) : void
      {
         var _loc2_:FarmRequest = null;
         switch(param1)
         {
            case 1:
               _loc2_ = this._pedido1;
               break;
            case 2:
               _loc2_ = this._pedido2;
               break;
            case 3:
               _loc2_ = this._pedido3;
         }
         this._api.showGranjaSellingModal(_loc2_);
      }
      
      private function onButtonMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this.determineButton(param1.target as MovieClip);
         if(_loc2_)
         {
            _loc2_.glow.visible = false;
         }
      }
      
      public function checkReady() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._buttons.length)
         {
            this.updateButton(false,this._buttons[_loc1_]);
            _loc1_++;
         }
         if(Boolean(this._pedido1) && this._pedido1.isReady(this._siloManager))
         {
            this.updateButton(true,this._buttons[0]);
         }
         if(Boolean(this._pedido2) && this._pedido2.isReady(this._siloManager))
         {
            this.updateButton(true,this._buttons[1]);
         }
         if(Boolean(this._pedido3) && this._pedido3.isReady(this._siloManager))
         {
            this.updateButton(true,this._buttons[2]);
         }
      }
   }
}
