package com.qb9.gaturro.user.inventory
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   
   public class ConsumableInventorySceneObject extends UsableInventorySceneObject
   {
       
      
      public function ConsumableInventorySceneObject(param1:CustomAttributes)
      {
         super(param1);
      }
      
      public function set uses(param1:uint) : void
      {
         attributes.uses = param1;
      }
      
      public function get uses() : uint
      {
         return attributes.uses;
      }
   }
}
