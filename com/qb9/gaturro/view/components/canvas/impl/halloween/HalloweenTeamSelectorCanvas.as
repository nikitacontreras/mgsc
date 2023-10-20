package com.qb9.gaturro.view.components.canvas.impl.halloween
{
   import com.qb9.gaturro.commons.event.EventManager;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.manager.team.TeamDefinition;
   import com.qb9.gaturro.view.components.banner.halloweenTeam.HalloweenTeamSelectorBanner;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class HalloweenTeamSelectorCanvas extends FrameCanvas
   {
       
      
      private var holder:DisplayObjectContainer;
      
      private var teamDefinitionList:IIterator;
      
      private var eventManager:EventManager;
      
      public function HalloweenTeamSelectorCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal, param5:IIterator)
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
         trace("HalloweenTeamSelectorCanvas > setupFlag > teamDefinition.label = [" + param2.label + "]");
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:TeamDefinition = this.getSelectedTeam(param1.currentTarget as Sprite);
         var _loc3_:HalloweenTeamSelectorBanner = owner as HalloweenTeamSelectorBanner;
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
      
      private function onFrameLoaded(param1:Event) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:TeamDefinition = null;
         this.holder = view.getChildByName("holder") as DisplayObjectContainer;
         var _loc4_:int = 0;
         while(this.teamDefinitionList.next())
         {
            _loc2_ = this.holder.getChildAt(_loc4_) as Sprite;
            _loc3_ = this.teamDefinitionList.current() as TeamDefinition;
            this.eventManager.addEventListener(_loc2_,MouseEvent.CLICK,this.onClick);
            this.setupLabel(_loc2_,_loc3_);
            this.setupFlag(_loc2_,_loc3_);
            _loc4_++;
         }
         this.teamDefinitionList.reset();
         view.removeEventListener(Event.EXIT_FRAME,this.onFrameLoaded);
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
         view.addEventListener(Event.EXIT_FRAME,this.onFrameLoaded);
      }
   }
}
