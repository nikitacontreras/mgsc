package com.qb9.gaturro.view.components.banner.halloweenTeam
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.view.component.canvas.switcher.FrameCanvasSwitcher;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.team.TeamDefinition;
   import com.qb9.gaturro.manager.team.TeamManager;
   import com.qb9.gaturro.view.components.canvas.impl.halloween.HalloweenTeamSelectorCanvas;
   import com.qb9.gaturro.view.components.canvas.impl.halloween.HalloweenTeamSelectorConfirmationCanvas;
   import com.qb9.gaturro.view.gui.base.modal.AbstractInstantiableConfirmatorModal;
   import flash.display.MovieClip;
   
   public class HalloweenTeamSelectorBanner extends AbstractInstantiableConfirmatorModal
   {
      
      public static const TEAM_SELECTOR:String = "halloweenTeamSelector";
      
      public static const TEAM_CONFIRMATION:String = "halloweenTeamConfirmation";
       
      
      private var teamManager:TeamManager;
      
      private var teamDefinitionList:IIterator;
      
      private var selectedTeam:TeamDefinition;
      
      private var canvasSwitcher:FrameCanvasSwitcher;
      
      public function HalloweenTeamSelectorBanner()
      {
         super("halloweenClubSelector","HalloweenSelectorBannerAsset");
         this.setup();
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupCanvas();
      }
      
      private function setupCanvas() : void
      {
         var _loc1_:MovieClip = view.getChildByName("canvasContainer") as MovieClip;
         this.canvasSwitcher = new FrameCanvasSwitcher(_loc1_);
         this.canvasSwitcher.addCanvas(new HalloweenTeamSelectorCanvas(TEAM_SELECTOR,"selector",_loc1_,this,this.teamDefinitionList));
         this.canvasSwitcher.addCanvas(new HalloweenTeamSelectorConfirmationCanvas(TEAM_CONFIRMATION,"confirmation",_loc1_,this));
         this.canvasSwitcher.switchCanvas(TEAM_SELECTOR);
      }
      
      override public function confirm() : void
      {
         this.teamManager.suscribeToTeam(this.selectedTeam.name,"halloween2017");
         this.close();
      }
      
      public function askConfirmation(param1:TeamDefinition) : void
      {
         this.selectedTeam = param1;
         this.canvasSwitcher.switchCanvas(TEAM_CONFIRMATION,this.selectedTeam);
      }
      
      public function showSelection() : void
      {
         this.canvasSwitcher.switchCanvas(TEAM_SELECTOR);
      }
      
      private function setup() : void
      {
         this.teamManager = Context.instance.getByType(TeamManager) as TeamManager;
         this.teamDefinitionList = this.teamManager.getTeamList("halloween2017");
      }
      
      override public function close() : void
      {
         var _loc1_:Object = {
            "id":0,
            "x":7,
            "y":10
         };
         switch(this.selectedTeam.name)
         {
            case "mono":
               _loc1_.id = 51689699;
               break;
            case "koala":
               _loc1_.id = 51689698;
               break;
            case "mulita":
               _loc1_.id = 51689697;
         }
         api.changeRoomXY(_loc1_.id,_loc1_.x,_loc1_.y);
      }
   }
}
