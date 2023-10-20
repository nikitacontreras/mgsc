package com.qb9.mambo.world.avatars
{
   import flash.errors.IllegalOperationError;
   import flash.utils.Dictionary;
   
   public class AvatarBodyEnum
   {
      
      public static const GLOVE_FORE:String = "gloveFore";
      
      public static const ACCESORIES:String = "accesories";
      
      public static const GRIP_FORE:String = "gripFore";
      
      public static const MOUTHS:String = "mouths";
      
      public static const TRANSPORT:String = "transport";
      
      public static const ARM_BACK:String = "armBack";
      
      public static const GRIP:String = "grip";
      
      private static var list:Dictionary;
      
      public static const ARM_FORE:String = "armFore";
      
      public static const NECK:String = "neck";
      
      public static const GLOVE_BACK:String = "gloveBack";
      
      public static const LEG:String = "leg";
      
      public static const HAIRS:String = "hairs";
      
      public static const CUSTOMIZATION:String = "customization";
      
      public static const FOOT:String = "foot";
      
      public static const HATS:String = "hats";
      
      public static const GLOVE:String = "glove";
      
      public static const CLOTH:String = "cloth";
      
      public static const GRIP_BACK:String = "gripBack";
      
      public static const ARM:String = "arm";
       
      
      public function AvatarBodyEnum()
      {
         super();
         throw new IllegalOperationError("This class souldn\'t be instatiated. Its purpouse is enumerative only");
      }
      
      public static function validate(param1:String) : Boolean
      {
         if(!list)
         {
            list = getList();
         }
         return list[param1];
      }
      
      public static function getList() : Dictionary
      {
         var _loc1_:Dictionary = new Dictionary();
         _loc1_[HATS] = HATS;
         _loc1_[HAIRS] = HAIRS;
         _loc1_[MOUTHS] = MOUTHS;
         _loc1_[NECK] = NECK;
         _loc1_[ACCESORIES] = ACCESORIES;
         _loc1_[CLOTH] = CLOTH;
         _loc1_[LEG] = LEG;
         _loc1_[FOOT] = FOOT;
         _loc1_[ARM] = ARM;
         _loc1_[ARM_FORE] = ARM_FORE;
         _loc1_[ARM_BACK] = ARM_BACK;
         _loc1_[GLOVE] = GLOVE;
         _loc1_[GLOVE_FORE] = GLOVE_FORE;
         _loc1_[GLOVE_BACK] = GLOVE_BACK;
         _loc1_[GRIP] = GRIP;
         _loc1_[GRIP_FORE] = GRIP_FORE;
         _loc1_[GRIP_BACK] = GRIP_BACK;
         _loc1_[TRANSPORT] = TRANSPORT;
         _loc1_[CUSTOMIZATION] = CUSTOMIZATION;
         return _loc1_;
      }
   }
}
