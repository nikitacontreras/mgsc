package com.qb9.gaturro.manager.music.enum
{
   import flash.utils.Dictionary;
   
   public class MusicSerializedNoteEnum
   {
      
      public static const FA_REDONDA:String = "F";
      
      public static const SOL_NEGRA:String = "f";
      
      public static const DOS_CORCHEA:String = "l";
      
      public static const FA_NEGRA:String = "d";
      
      public static const RES_NEGRA:String = "b";
      
      public static const RE_BLANCA:String = "O";
      
      public static const RE_CORCHEA:String = "m";
      
      public static const SOLS_REDONDA:String = "I";
      
      public static const RES_BLANCA:String = "P";
      
      public static const FAS_SEMICORCHEA:String = "2";
      
      public static const REV_SEMICORCHEA:String = "y";
      
      public static const SOLS_NEGRA:String = "g";
      
      public static const SOL_BLANCA:String = "T";
      
      public static const FAS_REDONDA:String = "G";
      
      public static const LA_SEMICORCHEA:String = "5";
      
      public static const MI_NEGRA:String = "c";
      
      public static const DO_SEMICORCHEA:String = "w";
      
      public static const LA_NEGRA:String = "h";
      
      public static const SI_CORCHEA:String = "v";
      
      public static const SOL_CORCHEA:String = "r";
      
      public static const LA_CORCHEA:String = "t";
      
      public static const DOS_SEMICORCHEA:String = "x";
      
      public static const LAS_CORCHEA:String = "u";
      
      public static const SILENCIO:String = "8";
      
      public static const RES_CORCHEA:String = "n";
      
      public static const SOLS_BLANCA:String = "U";
      
      public static const DO_CORCHEA:String = "k";
      
      public static const FA_SEMICORCHEA:String = "1";
      
      public static const SI_NEGRA:String = "j";
      
      public static const DOS_REDONDA:String = "B";
      
      public static const RE_REDONDA:String = "C";
      
      public static const MI_CORCHEA:String = "o";
      
      public static const LAS_BLANCA:String = "W";
      
      public static const DOS_BLANCA:String = "N";
      
      public static const SI_SEMICORCHEA:String = "7";
      
      public static const FA_BLANCA:String = "R";
      
      public static const RE_NEGRA:String = "a";
      
      public static const SOLS_SEMICORCHEA:String = "4";
      
      public static const SI_BLANCA:String = "X";
      
      public static const LA_BLANCA:String = "V";
      
      public static const FA_CORCHEA:String = "p";
      
      public static const SI_REDONDA:String = "L";
      
      public static const LAS_NEGRA:String = "i";
      
      public static const MI_BLANCA:String = "Q";
      
      public static const FAS_NEGRA:String = "e";
      
      public static const SOL_SEMICORCHEA:String = "3";
      
      private static var _map:Dictionary;
      
      public static const LAS_SEMICORCHEA:String = "6";
      
      public static const FAS_BLANCA:String = "S";
      
      public static const SOL_REDONDA:String = "H";
      
      public static const RES_SEMICORCHEA:String = "z";
      
      public static const LA_REDONDA:String = "J";
      
      public static const DOS_NEGRA:String = "Z";
      
      public static const DO_BLANCA:String = "M";
      
      public static const SOLS_CORCHEA:String = "s";
      
      public static const LAS_REDONDA:String = "K";
      
      public static const RES_REDONDA:String = "D";
      
      public static const DO_REDONDA:String = "A";
      
      public static const MI_SEMICORCHEA:String = "0";
      
      public static const FAS_CORCHEA:String = "q";
      
      public static const MI_REDONDA:String = "E";
      
      public static const DO_NEGRA:String = "Y";
       
      
      public function MusicSerializedNoteEnum()
      {
         super();
         throw new Error("This class shouldn\'t be instantiated");
      }
      
      public static function get map() : Dictionary
      {
         if(!_map)
         {
            MusicSerializedNoteEnum.setupMap();
         }
         return map;
      }
      
      private static function setupMap() : void
      {
         _map = new Dictionary();
         _map[DO_REDONDA] = true;
         _map[DOS_REDONDA] = true;
         _map[RE_REDONDA] = true;
         _map[RES_REDONDA] = true;
         _map[MI_REDONDA] = true;
         _map[FA_REDONDA] = true;
         _map[FAS_REDONDA] = true;
         _map[SOL_REDONDA] = true;
         _map[SOLS_REDONDA] = true;
         _map[LA_REDONDA] = true;
         _map[LAS_REDONDA] = true;
         _map[SI_REDONDA] = true;
         _map[DO_BLANCA] = true;
         _map[DOS_BLANCA] = true;
         _map[RE_BLANCA] = true;
         _map[RES_BLANCA] = true;
         _map[MI_BLANCA] = true;
         _map[FA_BLANCA] = true;
         _map[FAS_BLANCA] = true;
         _map[SOL_BLANCA] = true;
         _map[SOLS_BLANCA] = true;
         _map[LA_BLANCA] = true;
         _map[LAS_BLANCA] = true;
         _map[SI_BLANCA] = true;
         _map[DO_NEGRA] = true;
         _map[DOS_NEGRA] = true;
         _map[RE_NEGRA] = true;
         _map[RES_NEGRA] = true;
         _map[MI_NEGRA] = true;
         _map[FA_NEGRA] = true;
         _map[FAS_NEGRA] = true;
         _map[SOL_NEGRA] = true;
         _map[SOLS_NEGRA] = true;
         _map[LA_NEGRA] = true;
         _map[LAS_NEGRA] = true;
         _map[SI_NEGRA] = true;
         _map[DO_CORCHEA] = true;
         _map[DOS_CORCHEA] = true;
         _map[RE_CORCHEA] = true;
         _map[RES_CORCHEA] = true;
         _map[MI_CORCHEA] = true;
         _map[FA_CORCHEA] = true;
         _map[FAS_CORCHEA] = true;
         _map[SOL_CORCHEA] = true;
         _map[SOLS_CORCHEA] = true;
         _map[LA_CORCHEA] = true;
         _map[LAS_CORCHEA] = true;
         _map[SI_CORCHEA] = true;
         _map[DO_SEMICORCHEA] = true;
         _map[DOS_SEMICORCHEA] = true;
         _map[REV_SEMICORCHEA] = true;
         _map[RES_SEMICORCHEA] = true;
         _map[MI_SEMICORCHEA] = true;
         _map[FA_SEMICORCHEA] = true;
         _map[FAS_SEMICORCHEA] = true;
         _map[SOL_SEMICORCHEA] = true;
         _map[SOLS_SEMICORCHEA] = true;
         _map[LA_SEMICORCHEA] = true;
         _map[LAS_SEMICORCHEA] = true;
         _map[SI_SEMICORCHEA] = true;
         _map[SILENCIO] = true;
      }
   }
}
