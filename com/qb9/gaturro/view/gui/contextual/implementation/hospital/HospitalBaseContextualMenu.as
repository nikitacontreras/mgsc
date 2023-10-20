package com.qb9.gaturro.view.gui.contextual.implementation.hospital
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.error.AbstractMethodError;
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.manager.proposal.ProposalManager;
   import com.qb9.gaturro.manager.proposal.view.HospitalManager;
   import com.qb9.gaturro.model.config.contextualMenu.ContextualMenuActionDefinition;
   import com.qb9.gaturro.model.config.contextualMenu.ContextualMenuDefinition;
   import com.qb9.gaturro.view.components.repeater.Repeater;
   import com.qb9.gaturro.view.gui.contextual.AbstractContextualMenu;
   import com.qb9.gaturro.view.gui.contextual.ContextualMenuManager;
   import com.qb9.mambo.geom.Coord;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   
   public class HospitalBaseContextualMenu extends AbstractContextualMenu
   {
      
      private static const MENU_X_POSITION:int = 110;
      
      private static const STATUS_PROPOSAL:String = "proposal";
      
      private static const EXCESS:int = 4;
      
      private static const STATUS_ANSWER:String = "answer";
      
      private static const MENU_Y_POSITION:int = 40;
       
      
      private var connector:DisplayObject;
      
      private var background:InteractiveObject;
      
      private var repeater:Repeater;
      
      private var repeaterHolder:DisplayObjectContainer;
      
      public function HospitalBaseContextualMenu(param1:ContextualMenuDefinition, param2:DisplayObject)
      {
         super(param1,param2);
      }
      
      override protected function disposeButtons() : void
      {
      }
      
      protected function notifyManger(param1:HospitalContextualMenuItemRenderer) : void
      {
         var _loc2_:ProposalManager = Context.instance.getByType(ProposalManager) as ProposalManager;
         var _loc3_:ContextualMenuActionDefinition = ContextualMenuActionDefinition(param1.data);
         var _loc4_:int = int(_loc3_.data.proposalCode);
         if(definition.data.proposalStatus == STATUS_ANSWER)
         {
            this.hospitalManager.response(_loc4_);
         }
         else
         {
            this.hospitalManager.propose(_loc4_);
         }
      }
      
      override protected function setupButtons() : void
      {
         var _loc1_:IIterable = this.getDataProvider();
         this.repeater = new Repeater(_loc1_,null,Repeater.SINGLE_SELECTABLE);
         this.repeater.itemRendererFactory = new HospitalContextualMenuItemRendererFactory(loaderWrapper,loaderWrapper.getDefinition(definition.buttonAssetClass));
         this.repeater.columns = 1;
         this.repeater.build();
         this.repeater.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
      }
      
      private function onItemSelected(param1:ItemRendererEvent) : void
      {
         var _loc2_:HospitalContextualMenuItemRenderer = param1.itemRenderer as HospitalContextualMenuItemRenderer;
         this.notifyManger(_loc2_);
         var _loc3_:ContextualMenuManager = Context.instance.getByType(ContextualMenuManager) as ContextualMenuManager;
         _loc3_.removeMenu(owner);
      }
      
      private function setupBackground() : void
      {
         this.background = view.getChildByName("background") as InteractiveObject;
         this.background.height = this.repeater.height + EXCESS * 2;
         this.background.y = this.background.height / 2;
         this.background.mouseEnabled = false;
      }
      
      private function setupRepeaterHolder() : void
      {
         this.repeaterHolder = view.getChildByName("repeaterHolder") as DisplayObjectContainer;
         this.repeaterHolder.addChild(this.repeater);
      }
      
      final protected function get hospitalManager() : HospitalManager
      {
         return HospitalManager(_data);
      }
      
      private function setupConnector() : void
      {
         this.connector = view.getChildByName("connector");
         this.connector.y = this.background.height / 2;
      }
      
      protected function getDataProvider() : IIterable
      {
         throw new AbstractMethodError();
      }
      
      override protected function viewReady() : void
      {
         super.viewReady();
         x = this.getPosition();
         y -= MENU_Y_POSITION;
         this.setupRepeaterHolder();
         this.setupBackground();
         this.setupConnector();
      }
      
      private function getPosition() : int
      {
         var _loc1_:Coord = api.room.userAvatar.coord;
         if(api.room.avatarsByCoord(_loc1_.x + 2,_loc1_.y))
         {
            return -MENU_X_POSITION + this.x;
         }
         if(api.room.avatarsByCoord(_loc1_.x - 2,_loc1_.y))
         {
            return MENU_X_POSITION + this.x;
         }
         logger.debug("Could\'t determine where is the contrapart");
         throw new Error("Could\'t determine where is the contrapart");
      }
   }
}
