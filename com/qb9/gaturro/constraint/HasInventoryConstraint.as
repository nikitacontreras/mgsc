package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.user.GaturroUser;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mambo.user.inventory.events.InventoryEvent;
   import flash.utils.Dictionary;
   
   public class HasInventoryConstraint extends AbstractConstraint
   {
      
      private static var inventoryMap:Dictionary;
       
      
      private var selectedInventory:Inventory;
      
      private var notificationManager:NotificationManager;
      
      private var user:GaturroUser;
      
      private var item:String;
      
      private var inventory:String;
      
      public function HasInventoryConstraint(param1:Boolean)
      {
         super(param1);
      }
      
      private static function getNormalizedInventory(param1:String) : String
      {
         if(!inventoryMap)
         {
            setupMap();
         }
         return inventoryMap[param1];
      }
      
      private static function setupMap() : void
      {
         inventoryMap = new Dictionary();
         inventoryMap["bag"] = GaturroInventory.BAG;
         inventoryMap["house"] = GaturroInventory.HOUSE;
         inventoryMap["visualizer"] = GaturroInventory.VISUALIZER;
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Boolean = !!this.selectedInventory ? this.selectedInventory.hasAnyOf(this.item) : false;
         return doInvert(_loc2_);
      }
      
      private function setupUser() : void
      {
         if(Context.instance.hasByType(GaturroUser))
         {
            this.user = Context.instance.getByType(GaturroUser) as GaturroUser;
            this.selectedInventory = this.user.inventory(getNormalizedInventory(this.inventory));
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAddedUser);
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.item = param1.item;
         this.inventory = param1.inventory;
         this.setup();
      }
      
      private function onAdded(param1:InventoryEvent) : void
      {
         if(param1.object.name == this.item)
         {
            changed();
         }
      }
      
      private function onAddedUser(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroUser)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAddedUser);
            this.user = param1.instance as GaturroUser;
            this.selectedInventory = this.user.inventory(getNormalizedInventory(this.inventory));
            changed();
         }
      }
      
      private function setup() : void
      {
         this.setupUser();
         if(!weak)
         {
            this.user.inventory(getNormalizedInventory(this.inventory)).addEventListener(InventoryEvent.ITEM_ADDED,this.onAdded);
         }
      }
      
      override public function dispose() : void
      {
         this.user.inventory(getNormalizedInventory(this.inventory)).removeEventListener(InventoryEvent.ITEM_ADDED,this.onAdded);
         super.dispose();
      }
   }
}
