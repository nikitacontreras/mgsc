package com.qb9.mines.io
{
   import com.qb9.mines.mobject.Mobject;
   import com.qb9.mines.mobject.MobjectData;
   import com.qb9.mines.mobject.MobjectDataType;
   import flash.utils.ByteArray;
   
   public class MinesOutputStream extends ByteArray
   {
      
      public static const HEADER_TYPE_PING:int = 1;
      
      public static const HEADER_TYPE_LOGIN:int = 2;
      
      public static const HEADER_TYPE_MOBJECT:int = 3;
       
      
      public function MinesOutputStream(param1:ByteArray = null)
      {
         super();
         if(param1 != null)
         {
            this.writeBytes(param1);
         }
      }
      
      public function writeString(param1:String) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         writeInt(_loc2_.length);
         writeBytes(_loc2_,0,_loc2_.length);
      }
      
      public function writePing(param1:String) : void
      {
         writeByte(HEADER_TYPE_PING);
         this.writeString(param1);
      }
      
      private function writeArrayHeader(param1:MinesOutputStream, param2:String, param3:MobjectData) : void
      {
         this.writeHeader(param1,param2,param3);
         param1.writeInt(param3.getValue().length);
      }
      
      public function writeLogin(param1:String, param2:String) : void
      {
         writeByte(HEADER_TYPE_LOGIN);
         var _loc3_:MinesOutputStream = new MinesOutputStream();
         _loc3_.writeString(param1);
         _loc3_.writeString(param2);
         writeInt(_loc3_.length);
         writeBytes(_loc3_,0,_loc3_.length);
      }
      
      private function writeHeader(param1:MinesOutputStream, param2:String, param3:MobjectData) : void
      {
         param1.writeByte(param2.charCodeAt(0));
         param1.writeString(param3.getKey());
      }
      
      public function writeMobject(param1:Mobject) : void
      {
         var _loc4_:MobjectData = null;
         var _loc2_:int = 0;
         var _loc3_:MinesOutputStream = new MinesOutputStream();
         for each(_loc4_ in param1.iterator())
         {
            _loc2_++;
            _loc3_.writeMobjectData(_loc4_);
         }
         writeInt(_loc2_);
         writeBytes(_loc3_,0,_loc3_.length);
      }
      
      public function writeMobjectData(param1:MobjectData) : void
      {
         var _loc4_:Mobject = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Mobject = null;
         var _loc2_:MinesOutputStream = new MinesOutputStream();
         var _loc3_:Array = [];
         switch(param1.getDataType())
         {
            case MobjectDataType.BOOLEAN:
               this.writeHeader(_loc2_,"b",param1);
               _loc2_.writeBoolean(Boolean(param1.getValue()));
               break;
            case MobjectDataType.INTEGER:
               this.writeHeader(_loc2_,"i",param1);
               _loc2_.writeInt(int(param1.getValue()));
               break;
            case MobjectDataType.STRING:
               this.writeHeader(_loc2_,"s",param1);
               _loc2_.writeString(String(param1.getValue()));
               break;
            case MobjectDataType.FLOAT:
               this.writeHeader(_loc2_,"f",param1);
               _loc2_.writeFloat(Number(param1.getValue()));
               break;
            case MobjectDataType.MOBJECT:
               this.writeHeader(_loc2_,"m",param1);
               _loc4_ = param1.getValue() as Mobject;
               _loc2_.writeMobject(_loc4_);
               break;
            case MobjectDataType.BOOLEAN_ARRAY:
               this.writeArrayHeader(_loc2_,"B",param1);
               _loc3_ = param1.getValue() as Array;
               for each(_loc5_ in _loc3_)
               {
                  _loc2_.writeBoolean(_loc5_);
               }
               break;
            case MobjectDataType.INTEGER_ARRAY:
               this.writeArrayHeader(_loc2_,"I",param1);
               _loc3_ = param1.getValue() as Array;
               for each(_loc6_ in _loc3_)
               {
                  _loc2_.writeInt(_loc6_ as int);
               }
               break;
            case MobjectDataType.STRING_ARRAY:
               this.writeArrayHeader(_loc2_,"S",param1);
               _loc3_ = param1.getValue() as Array;
               for each(_loc7_ in _loc3_)
               {
                  _loc2_.writeString(_loc7_ as String);
               }
               break;
            case MobjectDataType.FLOAT_ARRAY:
               this.writeArrayHeader(_loc2_,"F",param1);
               _loc3_ = param1.getValue() as Array;
               for each(_loc8_ in _loc3_)
               {
                  _loc2_.writeFloat(_loc8_ as Number);
               }
               break;
            case MobjectDataType.MOBJECT_ARRAY:
               this.writeArrayHeader(_loc2_,"M",param1);
               _loc3_ = param1.getValue() as Array;
               for each(_loc9_ in _loc3_)
               {
                  _loc2_.writeByte("m".charCodeAt(0));
                  _loc2_.writeMobject(_loc9_);
               }
         }
         writeBytes(_loc2_,0,_loc2_.length);
      }
   }
}
