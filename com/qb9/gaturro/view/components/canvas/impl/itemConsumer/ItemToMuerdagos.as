package com.qb9.gaturro.view.components.canvas.impl.itemConsumer
{
   import com.qb9.gaturro.globals.api;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class ItemToMuerdagos
   {
      
      public static const TARTA_LIMON:String = "food.tortaLimon";
      
      public static var pandulceBuilded:DisplayObject = null;
      
      public static const FOOD_LIMON:String = "food.limon";
      
      public static const FOOD_CIRUELA:String = "food.ciruela";
      
      public static const FOOD_NARANJA:String = "food.naranja";
      
      public static const TARTA_CIRUELA:String = "food.tortaCiruela";
      
      public static const TARTA_NARANJA:String = "food.tortaNaranja";
      
      public static const TARTA_CEREZA:String = "food.tortaCereza";
      
      public static const FOOD_CEREZA:String = "food.cereza";
       
      
      public function ItemToMuerdagos()
      {
         super();
      }
      
      public static function getPandulceWithParams(param1:DisplayObject, param2:MovieClip) : void
      {
         var _loc3_:Array = api.userAvatar.attributes["effect2"].split(":");
         (param1 as Object).buildWithParams("1","1","1","1");
         pandulceBuilded = param1;
         if(param2)
         {
            pandulceBuilded.scaleY = 0.3;
            pandulceBuilded.scaleX = 0.3;
            pandulceBuilded.x += pandulceBuilded.width / 2;
            pandulceBuilded.y += pandulceBuilded.height - pandulceBuilded.height / 4;
            param2.addChild(pandulceBuilded);
         }
      }
      
      public static function convert(param1:String) : int
      {
         if(param1 == FOOD_LIMON || param1 == FOOD_CIRUELA || param1 == FOOD_CEREZA || param1 == FOOD_NARANJA)
         {
            return 10;
         }
         if(param1 == TARTA_CIRUELA || param1 == TARTA_CEREZA || param1 == TARTA_LIMON || param1 == TARTA_NARANJA)
         {
            return 40;
         }
         return 5;
      }
      
      public static function userHasPanDulce() : Boolean
      {
         var _loc2_:Array = null;
         if(!api)
         {
            return false;
         }
         if(!api.userAvatar)
         {
            return false;
         }
         trace(api.userAvatar.attributes["effect2"]);
         var _loc1_:String = String(api.userAvatar.attributes["effect2"]);
         if(_loc1_ && _loc1_ != " " && _loc1_ != "")
         {
            _loc2_ = _loc1_.split(":");
            if(Boolean(_loc2_) && _loc2_[0] == "navidad2017")
            {
               return true;
            }
            return false;
         }
         return false;
      }
   }
}
