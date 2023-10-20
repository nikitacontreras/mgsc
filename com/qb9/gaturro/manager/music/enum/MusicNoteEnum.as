package com.qb9.gaturro.manager.music.enum
{
   import flash.utils.Dictionary;
   
   public class MusicNoteEnum
   {
      
      public static const RES:String = "res";
      
      public static const DO:String = "do";
      
      public static const SI:String = "si";
      
      private static var _orderedSet:Array;
      
      public static const MI:String = "mi";
      
      public static const SOLS:String = "sols";
      
      private static var _map:Dictionary;
      
      public static const DOS:String = "dos";
      
      public static const SOL:String = "sol";
      
      public static const SILENCIO:String = "silencio";
      
      public static const RE:String = "re";
      
      public static const LA:String = "la";
      
      public static const FA:String = "fa";
      
      public static const LAS:String = "las";
      
      public static const FAS:String = "fas";
       
      
      public function MusicNoteEnum()
      {
         super();
         throw new Error("This class shouldn\'t be instantiated");
      }
      
      public static function get orderedSet() : Array
      {
         if(!_orderedSet)
         {
            MusicNoteEnum.setupSet();
         }
         return _orderedSet;
      }
      
      private static function setupMap() : void
      {
         _map = new Dictionary();
         _map[DO] = DO;
         _map[DOS] = DOS;
         _map[RE] = RE;
         _map[RES] = RES;
         _map[MI] = MI;
         _map[FA] = FA;
         _map[FAS] = FAS;
         _map[SOL] = SOL;
         _map[SOLS] = SOLS;
         _map[LA] = LA;
         _map[LAS] = LAS;
         _map[SI] = SI;
         _map[SILENCIO] = SILENCIO;
      }
      
      private static function setupSet() : void
      {
         _orderedSet = new Array();
         _orderedSet[0] = DO;
         _orderedSet[1] = DOS;
         _orderedSet[2] = RE;
         _orderedSet[3] = RES;
         _orderedSet[4] = MI;
         _orderedSet[5] = FA;
         _orderedSet[6] = FAS;
         _orderedSet[7] = SOL;
         _orderedSet[8] = SOLS;
         _orderedSet[9] = LA;
         _orderedSet[10] = LAS;
         _orderedSet[11] = SI;
         _orderedSet[12] = SILENCIO;
      }
      
      public static function get map() : Dictionary
      {
         if(!_map)
         {
            MusicNoteEnum.setupMap();
         }
         return _map;
      }
   }
}
