package com.qb9.gaturro.view.components.canvas.impl.halloween
{
   import com.qb9.gaturro.manager.team.TeamDefinition;
   import com.qb9.gaturro.view.components.banner.halloweenTeam.HalloweenTeamSelectorBanner;
   import com.qb9.gaturro.view.components.canvas.common.CommonFrameConfirmationCanvas;
   import com.qb9.gaturro.view.gui.base.modal.AbstractInstantiableConfirmatorModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class HalloweenTeamSelectorConfirmationCanvas extends CommonFrameConfirmationCanvas
   {
       
      
      private var teamDefinition:TeamDefinition;
      
      private var backButton:MovieClip;
      
      public function HalloweenTeamSelectorConfirmationCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:AbstractInstantiableConfirmatorModal)
      {
         super(param1,param2,param3,param4);
      }
      
      private function onBackClick(param1:MouseEvent) : void
      {
         (getOwner() as HalloweenTeamSelectorBanner).showSelection();
      }
      
      override protected function setupButton() : void
      {
         super.setupButton();
         this.backButton = view.getChildByName("backBtn") as MovieClip;
         this.backButton.addEventListener(MouseEvent.CLICK,this.onBackClick);
      }
      
      override public function show(param1:Object = null) : void
      {
         super.show(param1);
         this.teamDefinition = param1 as TeamDefinition;
      }
      
      override protected function setupShowView() : void
      {
         super.setupShowView();
         var _loc1_:MovieClip = view.getChildByName("flagHolder") as MovieClip;
         _loc1_.gotoAndStop(this.teamDefinition.name);
         var _loc2_:MovieClip = view.getChildByName("teamDescription") as MovieClip;
         _loc2_.gotoAndStop(this.teamDefinition.name);
      }
   }
}
