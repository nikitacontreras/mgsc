package com.qb9.gaturro.manager.music
{
   import com.qb9.gaturro.manager.music.enum.MusicNoteEnum;
   import com.qb9.gaturro.manager.music.enum.MusicRhythmicEnum;
   import com.qb9.gaturro.manager.music.enum.MusicSerializedNoteEnum;
   import flash.utils.Dictionary;
   
   public class MusicNoteSequenceDeserializer
   {
       
      
      private var deserializedMap:Dictionary;
      
      private var serializedMap:Dictionary;
      
      public function MusicNoteSequenceDeserializer()
      {
         super();
         this.setupMap();
      }
      
      public function serialize(param1:Array) : String
      {
         var _loc3_:String = null;
         var _loc4_:MusicNote = null;
         var _loc2_:String = "";
         for each(_loc4_ in param1)
         {
            _loc3_ = String(this.deserializedMap[_loc4_.splitableToString()]);
            _loc2_ += _loc3_;
         }
         return _loc2_;
      }
      
      private function setupMap() : void
      {
         this.setupSerializedMap();
         this.setupDeserializedMap();
      }
      
      private function setupDeserializedMap() : void
      {
         this.deserializedMap = new Dictionary();
         this.deserializedMap[MusicNoteEnum.DO + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.DO_REDONDA;
         this.deserializedMap[MusicNoteEnum.DOS + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.DOS_REDONDA;
         this.deserializedMap[MusicNoteEnum.RE + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.RE_REDONDA;
         this.deserializedMap[MusicNoteEnum.RES + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.RES_REDONDA;
         this.deserializedMap[MusicNoteEnum.MI + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.MI_REDONDA;
         this.deserializedMap[MusicNoteEnum.FA + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.FA_REDONDA;
         this.deserializedMap[MusicNoteEnum.FAS + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.FAS_REDONDA;
         this.deserializedMap[MusicNoteEnum.SOL + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.SOL_REDONDA;
         this.deserializedMap[MusicNoteEnum.SOLS + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.SOLS_REDONDA;
         this.deserializedMap[MusicNoteEnum.LA + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.LA_REDONDA;
         this.deserializedMap[MusicNoteEnum.LAS + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.LAS_REDONDA;
         this.deserializedMap[MusicNoteEnum.SI + ";" + MusicRhythmicEnum.REDONDA] = MusicSerializedNoteEnum.SI_REDONDA;
         this.deserializedMap[MusicNoteEnum.DO + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.DO_BLANCA;
         this.deserializedMap[MusicNoteEnum.DOS + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.DOS_BLANCA;
         this.deserializedMap[MusicNoteEnum.RE + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.RE_BLANCA;
         this.deserializedMap[MusicNoteEnum.RES + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.RES_BLANCA;
         this.deserializedMap[MusicNoteEnum.MI + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.MI_BLANCA;
         this.deserializedMap[MusicNoteEnum.FA + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.FA_BLANCA;
         this.deserializedMap[MusicNoteEnum.FAS + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.FAS_BLANCA;
         this.deserializedMap[MusicNoteEnum.SOL + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.SOL_BLANCA;
         this.deserializedMap[MusicNoteEnum.SOLS + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.SOLS_BLANCA;
         this.deserializedMap[MusicNoteEnum.LA + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.LA_BLANCA;
         this.deserializedMap[MusicNoteEnum.LAS + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.LAS_BLANCA;
         this.deserializedMap[MusicNoteEnum.SI + ";" + MusicRhythmicEnum.BLANCA] = MusicSerializedNoteEnum.SI_BLANCA;
         this.deserializedMap[MusicNoteEnum.DO + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.DO_NEGRA;
         this.deserializedMap[MusicNoteEnum.DOS + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.DOS_NEGRA;
         this.deserializedMap[MusicNoteEnum.RE + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.RE_NEGRA;
         this.deserializedMap[MusicNoteEnum.RES + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.RES_NEGRA;
         this.deserializedMap[MusicNoteEnum.MI + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.MI_NEGRA;
         this.deserializedMap[MusicNoteEnum.FA + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.FA_NEGRA;
         this.deserializedMap[MusicNoteEnum.FAS + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.FAS_NEGRA;
         this.deserializedMap[MusicNoteEnum.SOL + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.SOL_NEGRA;
         this.deserializedMap[MusicNoteEnum.SOLS + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.SOLS_NEGRA;
         this.deserializedMap[MusicNoteEnum.LA + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.LA_NEGRA;
         this.deserializedMap[MusicNoteEnum.LAS + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.LAS_NEGRA;
         this.deserializedMap[MusicNoteEnum.SI + ";" + MusicRhythmicEnum.NEGRA] = MusicSerializedNoteEnum.SI_NEGRA;
         this.deserializedMap[MusicNoteEnum.DO + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.DO_CORCHEA;
         this.deserializedMap[MusicNoteEnum.DOS + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.DOS_CORCHEA;
         this.deserializedMap[MusicNoteEnum.RE + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.RE_CORCHEA;
         this.deserializedMap[MusicNoteEnum.RES + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.RES_CORCHEA;
         this.deserializedMap[MusicNoteEnum.MI + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.MI_CORCHEA;
         this.deserializedMap[MusicNoteEnum.FA + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.FA_CORCHEA;
         this.deserializedMap[MusicNoteEnum.FAS + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.FAS_CORCHEA;
         this.deserializedMap[MusicNoteEnum.SOL + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.SOL_CORCHEA;
         this.deserializedMap[MusicNoteEnum.SOLS + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.SOLS_CORCHEA;
         this.deserializedMap[MusicNoteEnum.LA + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.LA_CORCHEA;
         this.deserializedMap[MusicNoteEnum.LAS + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.LAS_CORCHEA;
         this.deserializedMap[MusicNoteEnum.SI + ";" + MusicRhythmicEnum.CORCHEA] = MusicSerializedNoteEnum.SI_CORCHEA;
         this.deserializedMap[MusicNoteEnum.DO + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.DO_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.DOS + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.DOS_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.RE + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.REV_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.RES + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.RES_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.MI + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.MI_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.FA + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.FA_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.FAS + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.FAS_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.SOL + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.SOL_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.SOLS + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.SOLS_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.LA + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.LA_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.LAS + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.LAS_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.SI + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.SI_SEMICORCHEA;
         this.deserializedMap[MusicNoteEnum.SILENCIO + ";" + MusicRhythmicEnum.SEMICORCHEA] = MusicSerializedNoteEnum.SILENCIO;
      }
      
      private function setupSerializedMap() : void
      {
         this.serializedMap = new Dictionary();
         this.serializedMap[MusicSerializedNoteEnum.DO_REDONDA] = MusicNoteEnum.DO + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.DOS_REDONDA] = MusicNoteEnum.DOS + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.RE_REDONDA] = MusicNoteEnum.RE + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.RES_REDONDA] = MusicNoteEnum.RES + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.MI_REDONDA] = MusicNoteEnum.MI + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.FA_REDONDA] = MusicNoteEnum.FA + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.FAS_REDONDA] = MusicNoteEnum.FAS + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.SOL_REDONDA] = MusicNoteEnum.SOL + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.SOLS_REDONDA] = MusicNoteEnum.SOLS + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.LA_REDONDA] = MusicNoteEnum.LA + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.LAS_REDONDA] = MusicNoteEnum.LAS + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.SI_REDONDA] = MusicNoteEnum.SI + ";" + MusicRhythmicEnum.REDONDA;
         this.serializedMap[MusicSerializedNoteEnum.DO_BLANCA] = MusicNoteEnum.DO + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.DOS_BLANCA] = MusicNoteEnum.DOS + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.RE_BLANCA] = MusicNoteEnum.RE + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.RES_BLANCA] = MusicNoteEnum.RES + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.MI_BLANCA] = MusicNoteEnum.MI + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.FA_BLANCA] = MusicNoteEnum.FA + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.FAS_BLANCA] = MusicNoteEnum.FAS + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.SOL_BLANCA] = MusicNoteEnum.SOL + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.SOLS_BLANCA] = MusicNoteEnum.SOLS + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.LA_BLANCA] = MusicNoteEnum.LA + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.LAS_BLANCA] = MusicNoteEnum.LAS + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.SI_BLANCA] = MusicNoteEnum.SI + ";" + MusicRhythmicEnum.BLANCA;
         this.serializedMap[MusicSerializedNoteEnum.DO_NEGRA] = MusicNoteEnum.DO + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.DOS_NEGRA] = MusicNoteEnum.DOS + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.RE_NEGRA] = MusicNoteEnum.RE + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.RES_NEGRA] = MusicNoteEnum.RES + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.MI_NEGRA] = MusicNoteEnum.MI + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.FA_NEGRA] = MusicNoteEnum.FA + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.FAS_NEGRA] = MusicNoteEnum.FAS + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.SOL_NEGRA] = MusicNoteEnum.SOL + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.SOLS_NEGRA] = MusicNoteEnum.SOLS + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.LA_NEGRA] = MusicNoteEnum.LA + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.LAS_NEGRA] = MusicNoteEnum.LAS + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.SI_NEGRA] = MusicNoteEnum.SI + ";" + MusicRhythmicEnum.NEGRA;
         this.serializedMap[MusicSerializedNoteEnum.DO_CORCHEA] = MusicNoteEnum.DO + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.DOS_CORCHEA] = MusicNoteEnum.DOS + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.RE_CORCHEA] = MusicNoteEnum.RE + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.RES_CORCHEA] = MusicNoteEnum.RES + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.MI_CORCHEA] = MusicNoteEnum.MI + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.FA_CORCHEA] = MusicNoteEnum.FA + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.FAS_CORCHEA] = MusicNoteEnum.FAS + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.SOL_CORCHEA] = MusicNoteEnum.SOL + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.SOLS_CORCHEA] = MusicNoteEnum.SOLS + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.LA_CORCHEA] = MusicNoteEnum.LA + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.LAS_CORCHEA] = MusicNoteEnum.LAS + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.SI_CORCHEA] = MusicNoteEnum.SI + ";" + MusicRhythmicEnum.CORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.DO_SEMICORCHEA] = MusicNoteEnum.DO + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.DOS_SEMICORCHEA] = MusicNoteEnum.DOS + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.REV_SEMICORCHEA] = MusicNoteEnum.RE + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.RES_SEMICORCHEA] = MusicNoteEnum.RES + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.MI_SEMICORCHEA] = MusicNoteEnum.MI + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.FA_SEMICORCHEA] = MusicNoteEnum.FA + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.FAS_SEMICORCHEA] = MusicNoteEnum.FAS + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.SOL_SEMICORCHEA] = MusicNoteEnum.SOL + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.SOLS_SEMICORCHEA] = MusicNoteEnum.SOLS + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.LA_SEMICORCHEA] = MusicNoteEnum.LA + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.LAS_SEMICORCHEA] = MusicNoteEnum.LAS + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.SI_SEMICORCHEA] = MusicNoteEnum.SI + ";" + MusicRhythmicEnum.SEMICORCHEA;
         this.serializedMap[MusicSerializedNoteEnum.SILENCIO] = MusicNoteEnum.SILENCIO + ";" + MusicRhythmicEnum.SEMICORCHEA;
      }
      
      public function deserialize(param1:Array) : Array
      {
         var _loc3_:MusicNote = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:Array = new Array();
         for each(_loc6_ in param1)
         {
            _loc4_ = (_loc5_ = String(this.serializedMap[_loc6_])).split(";");
            _loc3_ = new MusicNote(_loc4_[0],_loc4_[1],_loc6_);
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
   }
}
