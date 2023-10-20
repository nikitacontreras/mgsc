package com.qb9.gaturro.view.gui.contextual.implementation
{
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.commons.iterator.iterable.IterableFactory;
   import com.qb9.gaturro.model.config.contextualMenu.ContextualMenuActionDefinition;
   import com.qb9.gaturro.model.config.contextualMenu.ContextualMenuDefinition;
   import flash.display.DisplayObject;
   
   public class BaseProposerContextualMenu extends BaseContextualMenu
   {
       
      
      public function BaseProposerContextualMenu(param1:ContextualMenuDefinition, param2:DisplayObject)
      {
         super(param1,param2);
      }
      
      override protected function getDataProvider() : IIterable
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc1_:Array = new Array();
         var _loc2_:Array = definition.actions.toArray();
         var _loc3_:int = int(definition.data.buttonAmount);
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_)
         {
            _loc4_ = (_loc5_ = Math.random()) * _loc2_.length;
            _loc1_.push(_loc2_[_loc4_]);
            _loc2_.splice(_loc4_,1);
            _loc7_++;
         }
         return IterableFactory.build(_loc1_);
      }
      
      override protected function notifyManger(param1:BaseContextualMenuItemRenderer) : void
      {
         var _loc2_:ContextualMenuActionDefinition = ContextualMenuActionDefinition(param1.data);
         var _loc3_:int = int(_loc2_.data.proposalCode);
         roomViewManager.propose(_loc3_);
      }
   }
}
