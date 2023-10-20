package com.qb9.gaturro.view.world.movement
{
   import flash.errors.IllegalOperationError;
   
   public class MovementsEnum
   {
      
      public static const SKI:String = "SKI";
      
      public static const AVATAR_ACTIONS:String = "AVATAR_ACTIONS";
      
      public static const GRAVITY_VERTICAL:String = "GRAVITY_VERTICAL";
      
      public static const HORIZONTAL_FLIPPING:String = "HORIZONTAL_FLIPPING";
      
      public static const GRAVITY_ROTATION:String = "GRAVITY_ROTATION";
       
      
      public function MovementsEnum()
      {
         super();
         throw new IllegalOperationError("This class can´t be instantiated");
      }
   }
}
