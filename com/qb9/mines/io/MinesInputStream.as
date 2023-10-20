package com.qb9.mines.io
{
   import com.qb9.mines.mobject.Mobject;
   import com.qb9.mines.mobject.MobjectData;
   import com.qb9.mines.mobject.MobjectDataType;
   import flash.utils.ByteArray;
   
   public class MinesInputStream extends ByteArray
   {
       
      
      public function MinesInputStream(param1:ByteArray = null)
      {
         super();
         if(param1 != null)
         {
            param1.position = 0;
            param1.readBytes(this,0,param1.length);
         }
      }
      
      public function readMobjectData() : MobjectData
      {
         var _loc4_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc1_:MobjectData = null;
         var _loc2_:int = 0;
         var _loc3_:String = "";
         var _loc5_:String = String.fromCharCode(readByte());
         switch(_loc5_)
         {
            case "b":
               _loc1_ = new MobjectData(this.readString(),readBoolean(),MobjectDataType.BOOLEAN);
               break;
            case "i":
               _loc1_ = new MobjectData(this.readString(),readInt(),MobjectDataType.INTEGER);
               break;
            case "s":
               _loc1_ = new MobjectData(this.readString(),this.readString(),MobjectDataType.STRING);
               break;
            case "f":
               _loc1_ = new MobjectData(this.readString(),readFloat(),MobjectDataType.FLOAT);
               break;
            case "m":
               _loc3_ = this.readString();
               _loc1_ = new MobjectData(_loc3_,this.readMobject(),MobjectDataType.MOBJECT);
               break;
            case "B":
               _loc3_ = this.readString();
               _loc2_ = readInt();
               _loc4_ = [];
               _loc6_ = 0;
               while(_loc6_ < _loc2_)
               {
                  _loc4_.push(readBoolean());
                  _loc6_++;
               }
               _loc1_ = new MobjectData(_loc3_,_loc4_,MobjectDataType.BOOLEAN_ARRAY);
               break;
            case "I":
               _loc3_ = this.readString();
               _loc2_ = readInt();
               _loc4_ = [];
               _loc7_ = 0;
               while(_loc7_ < _loc2_)
               {
                  _loc4_.push(readInt());
                  _loc7_++;
               }
               _loc1_ = new MobjectData(_loc3_,_loc4_,MobjectDataType.INTEGER_ARRAY);
               break;
            case "S":
               _loc3_ = this.readString();
               _loc2_ = readInt();
               _loc4_ = [];
               _loc8_ = 0;
               while(_loc8_ < _loc2_)
               {
                  _loc4_.push(this.readString());
                  _loc8_++;
               }
               _loc1_ = new MobjectData(_loc3_,_loc4_,MobjectDataType.STRING_ARRAY);
               break;
            case "F":
               _loc3_ = this.readString();
               _loc2_ = readInt();
               _loc4_ = [];
               _loc9_ = 0;
               while(_loc9_ < _loc2_)
               {
                  _loc4_.push(readFloat());
                  _loc9_++;
               }
               _loc1_ = new MobjectData(_loc3_,_loc4_,MobjectDataType.FLOAT_ARRAY);
               break;
            case "M":
               _loc3_ = this.readString();
               _loc2_ = readInt();
               _loc4_ = [];
               _loc10_ = 0;
               while(_loc10_ < _loc2_)
               {
                  this.discardHeader();
                  _loc4_.push(this.readMobject());
                  _loc10_++;
               }
               _loc1_ = new MobjectData(_loc3_,_loc4_,MobjectDataType.MOBJECT_ARRAY);
               break;
            default:
               trace("error, bytes available: " + bytesAvailable + " len: " + length);
               throw new Error("Invalid MobjectData header while reading: " + _loc5_ + "[" + _loc5_.charCodeAt(0) + "]");
         }
         return _loc1_;
      }
      
      public function discardHeader() : void
      {
         readByte();
      }
      
      public function readMobject() : Mobject
      {
         var _loc1_:int = readInt();
         var _loc2_:Mobject = new Mobject();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_.addData(this.readMobjectData());
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function readString() : String
      {
         var _loc1_:int = readInt();
         return readUTFBytes(_loc1_);
      }
   }
}
