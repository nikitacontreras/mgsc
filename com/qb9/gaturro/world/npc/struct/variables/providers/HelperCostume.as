package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.mambo.world.core.RoomSceneObject;
   
   internal final class HelperCostume
   {
      
      private static const COSTUME_BASE:String = "costumes.";
      
      private static const COSTUMES:Object = {
         "frankenstein":{
            "cloth":"remeraFrankestein",
            "arm":"remeraFrankestein_brazo",
            "leg":"jeanFrankestein",
            "foot":"zapaFrankestein",
            "hairs":"hairFrankestein"
         },
         "bee":{
            "cloth":"remeraAbeja",
            "leg":"jeanAbeja",
            "hats":"gorroAbeja"
         },
         "witch":{
            "cloth":"remeraBruja",
            "arm":"remeraBruja_brazo",
            "leg":"jeanBruja",
            "foot":"zapaBruja",
            "hats":"gorroBruja"
         },
         "mummy":{
            "cloth":"remeraMomia",
            "arm":"remeraMomia_brazo",
            "leg":"jeanMomia",
            "foot":"zapaMomia",
            "hairs":"hairMomia"
         },
         "skeleton":{
            "cloth":"remeraEsqueleto",
            "arm":"remeraEsqueleto_brazo",
            "leg":"jeanEsqueleto",
            "foot":"botaEsqueleto",
            "hats":"gorroEsqueleto"
         }
      };
      
      private static const COSTUME_END:String = "_on";
       
      
      public function HelperCostume()
      {
         super();
      }
      
      public static function costume(param1:RoomSceneObject) : String
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:* = COSTUMES;
         do
         {
            for(_loc2_ in _loc9_)
            {
               _loc3_ = COSTUMES[_loc2_];
               _loc4_ = true;
               for(_loc5_ in _loc3_)
               {
                  _loc6_ = String(param1.attributes[_loc5_]);
                  _loc7_ = COSTUME_BASE + _loc3_[_loc5_] + COSTUME_END;
                  if(_loc6_ !== _loc7_)
                  {
                     _loc4_ = false;
                     break;
                  }
               }
            }
            return "";
         }
         while(!_loc4_);
         
         return _loc2_;
      }
   }
}
