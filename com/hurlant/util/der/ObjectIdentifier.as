package com.hurlant.util.der
{
   import flash.utils.ByteArray;
   
   public class ObjectIdentifier implements IAsn1Type
   {
       
      
      private var oid:Array;
      
      private var len:uint;
      
      private var type:uint;
      
      public function ObjectIdentifier(param1:uint, param2:uint, param3:*)
      {
         super();
         this.type = param1;
         this.len = param2;
         if(param3 is ByteArray)
         {
            parse(param3 as ByteArray);
         }
         else
         {
            if(!(param3 is String))
            {
               throw new Error("Invalid call to new ObjectIdentifier");
            }
            generate(param3 as String);
         }
      }
      
      public function dump() : String
      {
         return "OID[" + type + "][" + len + "][" + toString() + "]";
      }
      
      public function getLength() : uint
      {
         return len;
      }
      
      private function generate(param1:String) : void
      {
         oid = param1.split(".");
      }
      
      public function toString() : String
      {
         return DER.indent + oid.join(".");
      }
      
      public function getType() : uint
      {
         return type;
      }
      
      private function parse(param1:ByteArray) : void
      {
         var _loc5_:* = false;
         var _loc2_:uint = param1.readUnsignedByte();
         var _loc3_:Array = [];
         _loc3_.push(uint(_loc2_ / 40));
         _loc3_.push(uint(_loc2_ % 40));
         var _loc4_:uint = 0;
         while(param1.bytesAvailable > 0)
         {
            _loc2_ = param1.readUnsignedByte();
            _loc5_ = (_loc2_ & 128) == 0;
            _loc2_ &= 127;
            _loc4_ = _loc4_ * 128 + _loc2_;
            if(_loc5_)
            {
               _loc3_.push(_loc4_);
               _loc4_ = 0;
            }
         }
         oid = _loc3_;
      }
      
      public function toDER() : ByteArray
      {
         var _loc4_:int = 0;
         var _loc1_:Array = [];
         _loc1_[0] = oid[0] * 40 + oid[1];
         var _loc2_:int = 2;
         while(_loc2_ < oid.length)
         {
            if((_loc4_ = parseInt(oid[_loc2_])) < 128)
            {
               _loc1_.push(_loc4_);
            }
            else if(_loc4_ < 128 * 128)
            {
               _loc1_.push(_loc4_ >> 7 | 128);
               _loc1_.push(_loc4_ & 127);
            }
            else if(_loc4_ < 128 * 128 * 128)
            {
               _loc1_.push(_loc4_ >> 14 | 128);
               _loc1_.push(_loc4_ >> 7 & 127 | 128);
               _loc1_.push(_loc4_ & 127);
            }
            else
            {
               if(_loc4_ >= 128 * 128 * 128 * 128)
               {
                  throw new Error("OID element bigger than we thought. :(");
               }
               _loc1_.push(_loc4_ >> 21 | 128);
               _loc1_.push(_loc4_ >> 14 & 127 | 128);
               _loc1_.push(_loc4_ >> 7 & 127 | 128);
               _loc1_.push(_loc4_ & 127);
            }
            _loc2_++;
         }
         len = _loc1_.length;
         if(type == 0)
         {
            type = 6;
         }
         _loc1_.unshift(len);
         _loc1_.unshift(type);
         var _loc3_:ByteArray = new ByteArray();
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_[_loc2_] = _loc1_[_loc2_];
            _loc2_++;
         }
         return _loc3_;
      }
   }
}
