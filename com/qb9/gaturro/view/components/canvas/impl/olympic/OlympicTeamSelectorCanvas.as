package com.qb9.gaturro.view.components.canvas.impl.olympic
{
   import com.qb9.gaturro.commons.event.EventManager;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.manager.team.TeamDefinition;
   import com.qb9.gaturro.view.components.banner.olympic.OlympicTeamSelectorBanner;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class OlympicTeamSelectorCanvas extends FrameCanvas
   {
       
      
      private var holder:DisplayObjectContainer;
      
      private var teamDefinitionList:IIterator;
      
      private var eventManager:EventManager;
      
      public function OlympicTeamSelectorCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal, param5:IIterator)
      {
         super(param1,param2,param3,param4);
         this.teamDefinitionList = param5;
         this.eventManager = new EventManager();
      }
      
      override public function dispose() : void
      {
         this.removeListeners();
         super.dispose();
      }
      
      override public function hide() : void
      {
         this.removeListeners();
         super.hide();
      }
      
      private function setupFlag(param1:DisplayObjectContainer, param2:TeamDefinition) : void
      {
         var _loc3_:MovieClip = param1.getChildByName("flagHolder") as MovieClip;
         _loc3_.gotoAndStop(param2.name);
         trace("OlympicTeamSelectorCanvas > setupFlag > teamDefinition.label = [" + param2.label + "]");
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:TeamDefinition = this.getSelectedTeam(param1.currentTarget as Sprite);
         var _loc3_:OlympicTeamSelectorBanner = owner as OlympicTeamSelectorBanner;
         _loc3_.askConfirmation(_loc2_);
      }
      
      private function getSelectedTeam(param1:Sprite) : TeamDefinition
      {
         var _loc2_:int = this.holder.getChildIndex(param1);
         this.teamDefinitionList.index = _loc2_;
         return this.teamDefinitionList.current() as TeamDefinition;
      }
      
      private function setupLabel(param1:DisplayObjectContainer, param2:TeamDefinition) : void
      {
         var _loc3_:TextField = param1.getChildByName("label") as TextField;
         _loc3_.text = param2.label;
      }
      
      private function removeListeners() : void
      {
         this.eventManager.removeAll();
      }
      
      override public function show(param1:Object = null) : void
      {
         this.setupShowView();
         super.show(param1);
      }
      
      override protected function setupShowView() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TeamDefinition = null;
         this.holder = view.getChildByName("holder") as DisplayObjectContainer;
         var _loc3_:int = 0;
         while(this.teamDefinitionList.next())
         {
            _loc1_ = this.holder.getChildAt(_loc3_) as Sprite;
            _loc2_ = this.teamDefinitionList.current() as TeamDefinition;
            this.eventManager.addEventListener(_loc1_,MouseEvent.CLICK,this.onClick);
            this.setupLabel(_loc1_,_loc2_);
            this.setupFlag(_loc1_,_loc2_);
            _loc3_++;
         }
      }
   }
}
