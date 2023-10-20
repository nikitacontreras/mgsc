package com.qb9.gaturro.view.gui
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.world.interaction.InteractionTypes;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class GuiInteractionView
   {
      
      public static var firstTimeLogin:Boolean = true;
       
      
      private var _block:Boolean;
      
      private var _asset:com.qb9.gaturro.view.gui.Gui;
      
      private var _interactionDisplayer:MovieClip;
      
      public function GuiInteractionView(param1:com.qb9.gaturro.view.gui.Gui)
      {
         super();
         this._asset = param1;
         this._interactionDisplayer = this._asset.interactionDisplayer;
      }
      
      public function dispose() : void
      {
         this._interactionDisplayer.removeEventListener(MouseEvent.CLICK,this.onPlayClick);
         this._interactionDisplayer.interactionPanel.copiarvestimenta.removeEventListener(MouseEvent.CLICK,this.onClickGame);
         this._interactionDisplayer.interactionPanel.futbolpenalrusia.removeEventListener(MouseEvent.CLICK,this.onClickGame);
         this._interactionDisplayer.interactionPanel.carreraCohete.removeEventListener(MouseEvent.CLICK,this.onClickGame);
         this._interactionDisplayer.interactionPanel.partidoFutbol.removeEventListener(MouseEvent.CLICK,this.onClickGame);
         this._interactionDisplayer.interactionPanel.peleaMagia.removeEventListener(MouseEvent.CLICK,this.onClickGame);
      }
      
      private function canSuperClasico(param1:String) : Boolean
      {
         var _loc2_:String = null;
         if(param1 == InteractionTypes.PARTIDO_FUTBOL)
         {
            _loc2_ = api.getAvatarAttribute("superClasico2018TEAM") as String;
            if(_loc2_ != "BOCA" && _loc2_ != "RIVER")
            {
               api.textMessageToGUI("TIENES QUE PERTENECER A BOCA O RIVER");
               api.showBannerModal("superclasicoBocaRiver");
               this.close();
               return false;
            }
         }
         return true;
      }
      
      public function init() : void
      {
         var interactionName:*;
         this._interactionDisplayer.addEventListener(MouseEvent.CLICK,this.onPlayClick);
         this._interactionDisplayer.interactionPanel.copiarvestimenta.addEventListener(MouseEvent.CLICK,this.onClickGame);
         this._interactionDisplayer.interactionPanel.futbolpenalrusia.addEventListener(MouseEvent.CLICK,this.onClickGame);
         this._interactionDisplayer.interactionPanel.carreraCohete.addEventListener(MouseEvent.CLICK,this.onClickGame);
         this._interactionDisplayer.interactionPanel.partidoFutbol.addEventListener(MouseEvent.CLICK,this.onClickGame);
         this._interactionDisplayer.interactionPanel.peleaMagia.addEventListener(MouseEvent.CLICK,this.onClickGame);
         this._interactionDisplayer.buttonMode = true;
         this._interactionDisplayer.interactionPanel.copiarvestimenta.buttonMode = true;
         this._interactionDisplayer.interactionPanel.futbolpenalrusia.buttonMode = true;
         this._interactionDisplayer.interactionPanel.carreraCohete.buttonMode = true;
         this._interactionDisplayer.interactionPanel.partidoFutbol.buttonMode = true;
         this._interactionDisplayer.interactionPanel.peleaMagia.buttonMode = true;
         this._interactionDisplayer.interactionPanel.copiarvestimenta.gotoAndStop(1);
         this._interactionDisplayer.interactionPanel.futbolpenalrusia.gotoAndStop(1);
         this._interactionDisplayer.interactionPanel.carreraCohete.gotoAndStop(1);
         this._interactionDisplayer.interactionPanel.partidoFutbol.gotoAndStop(1);
         this._interactionDisplayer.interactionPanel.peleaMagia.gotoAndStop(1);
         this._interactionDisplayer.interactionPanel.copiarvestimenta.mouseChildren = false;
         this._interactionDisplayer.interactionPanel.futbolpenalrusia.mouseChildren = false;
         this._interactionDisplayer.interactionPanel.carreraCohete.mouseChildren = false;
         this._interactionDisplayer.interactionPanel.partidoFutbol.mouseChildren = false;
         this._interactionDisplayer.interactionPanel.peleaMagia.mouseChildren = false;
         interactionName = api.getAvatarAttribute("interaction");
         if(!firstTimeLogin && interactionName && interactionName != "false" && interactionName != "true" && interactionName != "" && interactionName != " ")
         {
            (this._interactionDisplayer.interactionPanel[interactionName] as MovieClip).gotoAndStop("pressed");
         }
         if(firstTimeLogin && interactionName && interactionName != "false" && interactionName != "true" && interactionName != "" && interactionName != " ")
         {
            setTimeout(function():void
            {
               api.setAvatarAttribute("interaction"," ");
            },1000);
            firstTimeLogin = false;
         }
         this._block = false;
      }
      
      private function onPlayClick(param1:Event) : void
      {
         if(this._interactionDisplayer.currentLabel == "closed")
         {
            this._interactionDisplayer.gotoAndPlay("opens");
            this._interactionDisplayer.buttonMode = false;
            api.roomView.emoticonsGUI.whenClosed(null);
            this._asset.hideEmoticons();
         }
         else
         {
            this._interactionDisplayer.gotoAndPlay("closes");
            this._interactionDisplayer.buttonMode = true;
         }
      }
      
      public function close() : void
      {
         if(this._interactionDisplayer.currentLabel != "closed")
         {
            this._interactionDisplayer.gotoAndPlay("closes");
         }
      }
      
      private function onClickGame(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(e.target.name == api.getAvatarAttribute("interaction"))
         {
            api.setAvatarAttribute("interaction","false");
            (this._interactionDisplayer.interactionPanel[e.target.name] as MovieClip).gotoAndStop("normal");
         }
         else if(!this._block)
         {
            this._interactionDisplayer.interactionPanel.copiarvestimenta.gotoAndStop("normal");
            this._interactionDisplayer.interactionPanel.futbolpenalrusia.gotoAndStop("normal");
            this._interactionDisplayer.interactionPanel.carreraCohete.gotoAndStop("normal");
            this._interactionDisplayer.interactionPanel.partidoFutbol.gotoAndStop("normal");
            this._interactionDisplayer.interactionPanel.peleaMagia.gotoAndStop("normal");
            if(!this.canSuperClasico(e.target.name))
            {
               return;
            }
            api.setAvatarAttribute("interaction",e.target.name);
            (this._interactionDisplayer.interactionPanel[e.target.name] as MovieClip).gotoAndStop("pressed");
            this._block = true;
            setTimeout(function():void
            {
               _block = false;
            },100);
         }
      }
   }
}
