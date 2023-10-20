package com.qb9.gaturro.view.components.banner.olympic
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.view.component.canvas.switcher.FrameCanvasSwitcher;
   import com.qb9.gaturro.manager.team.TeamDefinition;
   import com.qb9.gaturro.manager.team.feature.OlympicTeamManager;
   import com.qb9.gaturro.view.components.canvas.impl.olympic.OlympicTeamSelectorCanvas;
   import com.qb9.gaturro.view.components.canvas.impl.olympic.OlympicTeamSelectorConfirmationCanvas;
   import com.qb9.gaturro.view.gui.base.modal.AbstractInstantiableConfirmatorModal;
   import flash.display.MovieClip;
   
   public class OlympicTeamSelectorBanner extends AbstractInstantiableConfirmatorModal
   {
      
      public static const OLYMPIC_TEAM_CONFIRMATION:String = "olympicTeamConfirmation";
      
      public static const OLYMPIC_TEAM_SELECTOR:String = "olympicTeamSelector";
       
      
      private var olympicTeamManager:OlympicTeamManager;
      
      private var selectedTeam:TeamDefinition;
      
      private var canvasSwitcher:FrameCanvasSwitcher;
      
      private var teamDefinitionList:IIterator;
      
      public function OlympicTeamSelectorBanner()
      {
         super("olimpiadasClubSelector","OlympicSelectorBannerAsset");
         this.setup();
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupCanvas();
      }
      
      private function setup() : void
      {
         this.olympicTeamManager = Context.instance.getByType(OlympicTeamManager) as OlympicTeamManager;
         this.teamDefinitionList = this.olympicTeamManager.getTeamDefinitionList();
      }
      
      override public function confirm() : void
      {
         this.olympicTeamManager.suscribe(this.selectedTeam.name);
         this.close();
      }
      
      private function setupCanvas() : void
      {
         var _loc1_:MovieClip = view.getChildByName("canvasContainer") as MovieClip;
         this.canvasSwitcher = new FrameCanvasSwitcher(_loc1_);
         this.canvasSwitcher.addCanvas(new OlympicTeamSelectorCanvas(OLYMPIC_TEAM_SELECTOR,"selector",_loc1_,this,this.teamDefinitionList));
         this.canvasSwitcher.addCanvas(new OlympicTeamSelectorConfirmationCanvas(OLYMPIC_TEAM_CONFIRMATION,"confirmation",_loc1_,this));
         this.canvasSwitcher.switchCanvas(OLYMPIC_TEAM_SELECTOR);
      }
      
      public function askConfirmation(param1:TeamDefinition) : void
      {
         this.selectedTeam = param1;
         this.canvasSwitcher.switchCanvas(OLYMPIC_TEAM_CONFIRMATION,this.selectedTeam);
      }
      
      override public function close() : void
      {
         super.close();
      }
   }
}
