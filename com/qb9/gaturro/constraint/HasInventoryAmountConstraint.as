package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mambo.user.inventory.events.InventoryEvent;
   
   public class HasInventoryAmountConstraint extends AbstractConstraint
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var item:String;
      
      private var amount:int;
      
      public function HasInventoryAmountConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      private function onAdded(param1:InventoryEvent) : void
      {
         if(param1.object.name == this.item)
         {
            changed();
         }
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Boolean = this.userHasItems(this.item,this.amount);
         return doInvert(_loc2_);
      }
      
      private function matches(param1:InventorySceneObject, param2:String) : Boolean
      {
         return param2.slice(-1) === "*" ? param1.name.indexOf(param2.slice(0,-1)) === 0 : param1.name === param2;
      }
      
      private function userHasItems(param1:String, param2:int = 1) : Boolean
      {
         var _loc3_:InventorySceneObject = null;
         for each(_loc3_ in user.allItems)
         {
            if(this.matches(_loc3_,param1) && --param2 === 0)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function setData(param1:*) : void
      {
         this.item = param1.item;
         this.amount = param1.amount;
      }
      
      private function setup() : void
      {
         if(!weak)
         {
            user.inventory(GaturroInventory.BAG).addEventListener(InventoryEvent.ITEM_ADDED,this.onAdded);
            user.inventory(GaturroInventory.BAG).addEventListener(InventoryEvent.ITEM_REMOVED,this.onAdded);
            user.inventory(GaturroInventory.HOUSE).addEventListener(InventoryEvent.ITEM_ADDED,this.onAdded);
            user.inventory(GaturroInventory.HOUSE).addEventListener(InventoryEvent.ITEM_REMOVED,this.onAdded);
            user.inventory(GaturroInventory.VISUALIZER).addEventListener(InventoryEvent.ITEM_ADDED,this.onAdded);
            user.inventory(GaturroInventory.VISUALIZER).addEventListener(InventoryEvent.ITEM_REMOVED,this.onAdded);
         }
      }
      
      override public function dispose() : void
      {
         user.inventory(GaturroInventory.BAG).removeEventListener(InventoryEvent.ITEM_ADDED,this.onAdded);
         user.inventory(GaturroInventory.BAG).removeEventListener(InventoryEvent.ITEM_REMOVED,this.onAdded);
         user.inventory(GaturroInventory.HOUSE).removeEventListener(InventoryEvent.ITEM_ADDED,this.onAdded);
         user.inventory(GaturroInventory.HOUSE).removeEventListener(InventoryEvent.ITEM_REMOVED,this.onAdded);
         user.inventory(GaturroInventory.VISUALIZER).removeEventListener(InventoryEvent.ITEM_ADDED,this.onAdded);
         user.inventory(GaturroInventory.VISUALIZER).removeEventListener(InventoryEvent.ITEM_REMOVED,this.onAdded);
         super.dispose();
      }
   }
}
