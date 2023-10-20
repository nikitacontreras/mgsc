package com.qb9.gaturro.user.inventory
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   
   public class TransportInventorySceneObject extends GaturroInventorySceneObject implements WearableInventorySceneObject
   {
       
      
      public function TransportInventorySceneObject(param1:CustomAttributes)
      {
         super(param1);
      }
      
      public function get providedAttributes() : Object
      {
         return {"transport":this.vehicle};
      }
      
      public function get vehicle() : String
      {
         var _loc1_:String = String(attributes.vehicle);
         if(!_loc1_)
         {
            return name;
         }
         if(_loc1_.indexOf(".") === -1)
         {
            return name.split(".")[0] + "." + _loc1_;
         }
         return _loc1_;
      }
   }
}
