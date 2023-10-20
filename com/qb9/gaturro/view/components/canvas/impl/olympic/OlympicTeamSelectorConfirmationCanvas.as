package com.qb9.gaturro.view.components.canvas.impl.olympic
{
   import com.qb9.gaturro.manager.team.TeamDefinition;
   import com.qb9.gaturro.view.components.canvas.common.CommonFrameConfirmationCanvas;
   import com.qb9.gaturro.view.gui.base.modal.AbstractInstantiableConfirmatorModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class OlympicTeamSelectorConfirmationCanvas extends CommonFrameConfirmationCanvas
   {
       
      
      private var teamDefinition:TeamDefinition;
      
      public function OlympicTeamSelectorConfirmationCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:AbstractInstantiableConfirmatorModal)
      {
         super(param1,param2,param3,param4);
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
      }
   }
}
