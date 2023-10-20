package com.hurlant.math
{
   import com.hurlant.crypto.prng.Random;
   import com.hurlant.util.Hex;
   import com.hurlant.util.Memory;
   import flash.utils.ByteArray;
   
   public class BigInteger
   {
      
      public static const ONE:com.hurlant.math.BigInteger = nbv(1);
      
      public static const ZERO:com.hurlant.math.BigInteger = nbv(0);
      
      public static const lowprimes:Array = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241,251,257,263,269,271,277,281,283,293,307,311,313,317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,419,421,431,433,439,443,449,457,461,463,467,479,487,491,499,503,509];
      
      public static const lplim:int = (1 << 26) / lowprimes[lowprimes.length - 1];
      
      public static const BI_FP:int = 52;
      
      public static const FV:Number = Math.pow(2,BI_FP);
      
      public static const DB:int = 30;
      
      public static const DV:int = 1 << DB;
      
      public static const DM:int = DV - 1;
      
      public static const F1:int = BI_FP - DB;
      
      public static const F2:int = 2 * DB - BI_FP;
       
      
      bi_internal var a:Array;
      
      bi_internal var s:int;
      
      public var t:int;
      
      public function BigInteger(param1:* = null, param2:int = 0)
      {
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         super();
         bi_internal::a = new Array();
         if(param1 is String)
         {
            param1 = Hex.toArray(param1);
            param2 = 0;
         }
         if(param1 is ByteArray)
         {
            _loc3_ = param1 as ByteArray;
            _loc4_ = int(param2 || _loc3_.length - _loc3_.position);
            bi_internal::fromArray(_loc3_,_loc4_);
         }
      }
      
      public static function nbv(param1:int) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         _loc2_.bi_internal::fromInt(param1);
         return _loc2_;
      }
      
      public function clearBit(param1:int) : com.hurlant.math.BigInteger
      {
         return changeBit(param1,op_andnot);
      }
      
      private function op_or(param1:int, param2:int) : int
      {
         return param1 | param2;
      }
      
      public function negate() : com.hurlant.math.BigInteger
      {
         var _loc1_:com.hurlant.math.BigInteger = nbi();
         ZERO.bi_internal::subTo(this,_loc1_);
         return _loc1_;
      }
      
      public function andNot(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         bitwiseTo(param1,op_andnot,_loc2_);
         return _loc2_;
      }
      
      public function modPow(param1:com.hurlant.math.BigInteger, param2:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc4_:int = 0;
         var _loc6_:IReduction = null;
         var _loc12_:* = 0;
         var _loc15_:com.hurlant.math.BigInteger = null;
         var _loc16_:com.hurlant.math.BigInteger = null;
         var _loc3_:int = param1.bitLength();
         var _loc5_:com.hurlant.math.BigInteger = nbv(1);
         if(_loc3_ <= 0)
         {
            return _loc5_;
         }
         if(_loc3_ < 18)
         {
            _loc4_ = 1;
         }
         else if(_loc3_ < 48)
         {
            _loc4_ = 3;
         }
         else if(_loc3_ < 144)
         {
            _loc4_ = 4;
         }
         else if(_loc3_ < 768)
         {
            _loc4_ = 5;
         }
         else
         {
            _loc4_ = 6;
         }
         if(_loc3_ < 8)
         {
            _loc6_ = new ClassicReduction(param2);
         }
         else if(param2.bi_internal::isEven())
         {
            _loc6_ = new BarrettReduction(param2);
         }
         else
         {
            _loc6_ = new MontgomeryReduction(param2);
         }
         var _loc7_:Array = [];
         var _loc8_:int = 3;
         var _loc9_:int = _loc4_ - 1;
         var _loc10_:int = (1 << _loc4_) - 1;
         _loc7_[1] = _loc6_.convert(this);
         if(_loc4_ > 1)
         {
            _loc16_ = new com.hurlant.math.BigInteger();
            _loc6_.sqrTo(_loc7_[1],_loc16_);
            while(_loc8_ <= _loc10_)
            {
               _loc7_[_loc8_] = new com.hurlant.math.BigInteger();
               _loc6_.mulTo(_loc16_,_loc7_[_loc8_ - 2],_loc7_[_loc8_]);
               _loc8_ += 2;
            }
         }
         var _loc11_:int = param1.t - 1;
         var _loc13_:Boolean = true;
         var _loc14_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         _loc3_ = bi_internal::nbits(param1.bi_internal::a[_loc11_]) - 1;
         while(_loc11_ >= 0)
         {
            if(_loc3_ >= _loc9_)
            {
               _loc12_ = param1.bi_internal::a[_loc11_] >> _loc3_ - _loc9_ & _loc10_;
            }
            else
            {
               _loc12_ = (param1.bi_internal::a[_loc11_] & (1 << _loc3_ + 1) - 1) << _loc9_ - _loc3_;
               if(_loc11_ > 0)
               {
                  _loc12_ |= param1.bi_internal::a[_loc11_ - 1] >> DB + _loc3_ - _loc9_;
               }
            }
            _loc8_ = _loc4_;
            while((_loc12_ & 1) == 0)
            {
               _loc12_ >>= 1;
               _loc8_--;
            }
            if((_loc3_ = _loc3_ - _loc8_) < 0)
            {
               _loc3_ += DB;
               _loc11_--;
            }
            if(_loc13_)
            {
               _loc7_[_loc12_].copyTo(_loc5_);
               _loc13_ = false;
            }
            else
            {
               while(_loc8_ > 1)
               {
                  _loc6_.sqrTo(_loc5_,_loc14_);
                  _loc6_.sqrTo(_loc14_,_loc5_);
                  _loc8_ -= 2;
               }
               if(_loc8_ > 0)
               {
                  _loc6_.sqrTo(_loc5_,_loc14_);
               }
               else
               {
                  _loc15_ = _loc5_;
                  _loc5_ = _loc14_;
                  _loc14_ = _loc15_;
               }
               _loc6_.mulTo(_loc14_,_loc7_[_loc12_],_loc5_);
            }
            while(_loc11_ >= 0 && (param1.bi_internal::a[_loc11_] & 1 << _loc3_) == 0)
            {
               _loc6_.sqrTo(_loc5_,_loc14_);
               _loc15_ = _loc5_;
               _loc5_ = _loc14_;
               _loc14_ = _loc15_;
               if(--_loc3_ < 0)
               {
                  _loc3_ = DB - 1;
                  _loc11_--;
               }
            }
         }
         return _loc6_.revert(_loc5_);
      }
      
      public function isProbablePrime(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:com.hurlant.math.BigInteger = abs();
         if(_loc3_.t == 1 && _loc3_.bi_internal::a[0] <= lowprimes[lowprimes.length - 1])
         {
            _loc2_ = 0;
            while(_loc2_ < lowprimes.length)
            {
               if(_loc3_[0] == lowprimes[_loc2_])
               {
                  return true;
               }
               _loc2_++;
            }
            return false;
         }
         if(_loc3_.bi_internal::isEven())
         {
            return false;
         }
         _loc2_ = 1;
         while(_loc2_ < lowprimes.length)
         {
            _loc4_ = int(lowprimes[_loc2_]);
            _loc5_ = _loc2_ + 1;
            while(_loc5_ < lowprimes.length && _loc4_ < lplim)
            {
               _loc4_ *= lowprimes[_loc5_++];
            }
            _loc4_ = _loc3_.modInt(_loc4_);
            while(_loc2_ < _loc5_)
            {
               if(_loc4_ % lowprimes[_loc2_++] == 0)
               {
                  return false;
               }
            }
         }
         return _loc3_.millerRabin(param1);
      }
      
      public function divide(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         bi_internal::divRemTo(param1,_loc2_,null);
         return _loc2_;
      }
      
      public function mod(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = nbi();
         abs().bi_internal::divRemTo(param1,null,_loc2_);
         if(bi_internal::s < 0 && _loc2_.compareTo(ZERO) > 0)
         {
            param1.bi_internal::subTo(_loc2_,_loc2_);
         }
         return _loc2_;
      }
      
      protected function addTo(param1:com.hurlant.math.BigInteger, param2:com.hurlant.math.BigInteger) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc5_:int = Math.min(param1.t,t);
         while(_loc3_ < _loc5_)
         {
            _loc4_ += this.bi_internal::a[_loc3_] + param1.bi_internal::a[_loc3_];
            var _loc6_:*;
            param2.bi_internal::a[_loc6_ = _loc3_++] = _loc4_ & DM;
            _loc4_ >>= DB;
         }
         if(param1.t < t)
         {
            _loc4_ += param1.bi_internal::s;
            while(_loc3_ < t)
            {
               _loc4_ += this.bi_internal::a[_loc3_];
               param2.bi_internal::a[_loc6_ = _loc3_++] = _loc4_ & DM;
               _loc4_ >>= DB;
            }
            _loc4_ += bi_internal::s;
         }
         else
         {
            _loc4_ += bi_internal::s;
            while(_loc3_ < param1.t)
            {
               _loc4_ += param1.bi_internal::a[_loc3_];
               param2.bi_internal::a[_loc6_ = _loc3_++] = _loc4_ & DM;
               _loc4_ >>= DB;
            }
            _loc4_ += param1.bi_internal::s;
         }
         param2.bi_internal::s = _loc4_ < 0 ? -1 : 0;
         if(_loc4_ > 0)
         {
            param2.bi_internal::a[_loc6_ = _loc3_++] = _loc4_;
         }
         else if(_loc4_ < -1)
         {
            param2.bi_internal::a[_loc6_ = _loc3_++] = DV + _loc4_;
         }
         param2.t = _loc3_;
         param2.bi_internal::clamp();
      }
      
      protected function bitwiseTo(param1:com.hurlant.math.BigInteger, param2:Function, param3:com.hurlant.math.BigInteger) : void
      {
         var _loc4_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:int = Math.min(param1.t,t);
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            param3.bi_internal::a[_loc4_] = param2(this.bi_internal::a[_loc4_],param1.bi_internal::a[_loc4_]);
            _loc4_++;
         }
         if(param1.t < t)
         {
            _loc5_ = param1.bi_internal::s & DM;
            _loc4_ = _loc6_;
            while(_loc4_ < t)
            {
               param3.bi_internal::a[_loc4_] = param2(this.bi_internal::a[_loc4_],_loc5_);
               _loc4_++;
            }
            param3.t = t;
         }
         else
         {
            _loc5_ = bi_internal::s & DM;
            _loc4_ = _loc6_;
            while(_loc4_ < param1.t)
            {
               param3.bi_internal::a[_loc4_] = param2(_loc5_,param1.bi_internal::a[_loc4_]);
               _loc4_++;
            }
            param3.t = param1.t;
         }
         param3.bi_internal::s = param2(bi_internal::s,param1.bi_internal::s);
         param3.bi_internal::clamp();
      }
      
      protected function modInt(param1:int) : int
      {
         var _loc4_:int = 0;
         if(param1 <= 0)
         {
            return 0;
         }
         var _loc2_:int = DV % param1;
         var _loc3_:int = bi_internal::s < 0 ? param1 - 1 : 0;
         if(t > 0)
         {
            if(_loc2_ == 0)
            {
               _loc3_ = bi_internal::a[0] % param1;
            }
            else
            {
               _loc4_ = t - 1;
               while(_loc4_ >= 0)
               {
                  _loc3_ = (_loc2_ * _loc3_ + bi_internal::a[_loc4_]) % param1;
                  _loc4_--;
               }
            }
         }
         return _loc3_;
      }
      
      protected function chunkSize(param1:Number) : int
      {
         return Math.floor(Math.LN2 * DB / Math.log(param1));
      }
      
      public function gcd(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc6_:com.hurlant.math.BigInteger = null;
         var _loc2_:com.hurlant.math.BigInteger = bi_internal::s < 0 ? negate() : clone();
         var _loc3_:com.hurlant.math.BigInteger = param1.bi_internal::s < 0 ? param1.negate() : param1.clone();
         if(_loc2_.compareTo(_loc3_) < 0)
         {
            _loc6_ = _loc2_;
            _loc2_ = _loc3_;
            _loc3_ = _loc6_;
         }
         var _loc4_:int = _loc2_.getLowestSetBit();
         var _loc5_:int;
         if((_loc5_ = _loc3_.getLowestSetBit()) < 0)
         {
            return _loc2_;
         }
         if(_loc4_ < _loc5_)
         {
            _loc5_ = _loc4_;
         }
         if(_loc5_ > 0)
         {
            _loc2_.bi_internal::rShiftTo(_loc5_,_loc2_);
            _loc3_.bi_internal::rShiftTo(_loc5_,_loc3_);
         }
         while(_loc2_.sigNum() > 0)
         {
            if((_loc4_ = _loc2_.getLowestSetBit()) > 0)
            {
               _loc2_.bi_internal::rShiftTo(_loc4_,_loc2_);
            }
            if((_loc4_ = _loc3_.getLowestSetBit()) > 0)
            {
               _loc3_.bi_internal::rShiftTo(_loc4_,_loc3_);
            }
            if(_loc2_.compareTo(_loc3_) >= 0)
            {
               _loc2_.bi_internal::subTo(_loc3_,_loc2_);
               _loc2_.bi_internal::rShiftTo(1,_loc2_);
            }
            else
            {
               _loc3_.bi_internal::subTo(_loc2_,_loc3_);
               _loc3_.bi_internal::rShiftTo(1,_loc3_);
            }
         }
         if(_loc5_ > 0)
         {
            _loc3_.bi_internal::lShiftTo(_loc5_,_loc3_);
         }
         return _loc3_;
      }
      
      bi_internal function dAddOffset(param1:int, param2:int) : void
      {
         while(t <= param2)
         {
            var _loc3_:* = t++;
            bi_internal::a[_loc3_] = 0;
         }
         bi_internal::a[param2] += param1;
         while(bi_internal::a[param2] >= DV)
         {
            bi_internal::a[param2] -= DV;
            if(++param2 >= t)
            {
               _loc3_ = t++;
               bi_internal::a[_loc3_] = 0;
            }
            ++bi_internal::a[param2];
         }
      }
      
      bi_internal function lShiftTo(param1:int, param2:com.hurlant.math.BigInteger) : void
      {
         var _loc8_:int = 0;
         var _loc3_:int = param1 % DB;
         var _loc4_:int = DB - _loc3_;
         var _loc5_:int = (1 << _loc4_) - 1;
         var _loc6_:int = param1 / DB;
         var _loc7_:* = bi_internal::s << _loc3_ & DM;
         _loc8_ = t - 1;
         while(_loc8_ >= 0)
         {
            param2.bi_internal::a[_loc8_ + _loc6_ + 1] = bi_internal::a[_loc8_] >> _loc4_ | _loc7_;
            _loc7_ = (bi_internal::a[_loc8_] & _loc5_) << _loc3_;
            _loc8_--;
         }
         _loc8_ = _loc6_ - 1;
         while(_loc8_ >= 0)
         {
            param2.bi_internal::a[_loc8_] = 0;
            _loc8_--;
         }
         param2.bi_internal::a[_loc6_] = _loc7_;
         param2.t = t + _loc6_ + 1;
         param2.bi_internal::s = bi_internal::s;
         param2.bi_internal::clamp();
      }
      
      public function getLowestSetBit() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < t)
         {
            if(bi_internal::a[_loc1_] != 0)
            {
               return _loc1_ * DB + lbit(bi_internal::a[_loc1_]);
            }
            _loc1_++;
         }
         if(bi_internal::s < 0)
         {
            return t * DB;
         }
         return -1;
      }
      
      public function subtract(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         bi_internal::subTo(param1,_loc2_);
         return _loc2_;
      }
      
      public function primify(param1:int, param2:int) : void
      {
         if(!testBit(param1 - 1))
         {
            bitwiseTo(com.hurlant.math.BigInteger.ONE.shiftLeft(param1 - 1),op_or,this);
         }
         if(bi_internal::isEven())
         {
            bi_internal::dAddOffset(1,0);
         }
         while(!isProbablePrime(param2))
         {
            bi_internal::dAddOffset(2,0);
            while(bitLength() > param1)
            {
               bi_internal::subTo(com.hurlant.math.BigInteger.ONE.shiftLeft(param1 - 1),this);
            }
         }
      }
      
      bi_internal function multiplyLowerTo(param1:com.hurlant.math.BigInteger, param2:int, param3:com.hurlant.math.BigInteger) : void
      {
         var _loc5_:int = 0;
         var _loc4_:int = Math.min(t + param1.t,param2);
         param3.bi_internal::s = 0;
         param3.t = _loc4_;
         while(_loc4_ > 0)
         {
            var _loc6_:*;
            param3.bi_internal::a[_loc6_ = --_loc4_] = 0;
         }
         _loc5_ = param3.t - t;
         while(_loc4_ < _loc5_)
         {
            param3.bi_internal::a[_loc4_ + t] = bi_internal::am(0,param1.bi_internal::a[_loc4_],param3,_loc4_,0,t);
            _loc4_++;
         }
         _loc5_ = Math.min(param1.t,param2);
         while(_loc4_ < _loc5_)
         {
            bi_internal::am(0,param1.bi_internal::a[_loc4_],param3,_loc4_,0,param2 - _loc4_);
            _loc4_++;
         }
         param3.bi_internal::clamp();
      }
      
      public function modPowInt(param1:int, param2:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc3_:IReduction = null;
         if(param1 < 256 || param2.bi_internal::isEven())
         {
            _loc3_ = new ClassicReduction(param2);
         }
         else
         {
            _loc3_ = new MontgomeryReduction(param2);
         }
         return bi_internal::exp(param1,_loc3_);
      }
      
      bi_internal function intAt(param1:String, param2:int) : int
      {
         return parseInt(param1.charAt(param2),36);
      }
      
      public function testBit(param1:int) : Boolean
      {
         var _loc2_:int = Math.floor(param1 / DB);
         if(_loc2_ >= t)
         {
            return bi_internal::s != 0;
         }
         return (bi_internal::a[_loc2_] & 1 << param1 % DB) != 0;
      }
      
      bi_internal function exp(param1:int, param2:IReduction) : com.hurlant.math.BigInteger
      {
         var _loc7_:com.hurlant.math.BigInteger = null;
         if(param1 > 4294967295 || param1 < 1)
         {
            return ONE;
         }
         var _loc3_:com.hurlant.math.BigInteger = nbi();
         var _loc4_:com.hurlant.math.BigInteger = nbi();
         var _loc5_:com.hurlant.math.BigInteger = param2.convert(this);
         var _loc6_:int = bi_internal::nbits(param1) - 1;
         _loc5_.bi_internal::copyTo(_loc3_);
         while(--_loc6_ >= 0)
         {
            param2.sqrTo(_loc3_,_loc4_);
            if((param1 & 1 << _loc6_) > 0)
            {
               param2.mulTo(_loc4_,_loc5_,_loc3_);
            }
            else
            {
               _loc7_ = _loc3_;
               _loc3_ = _loc4_;
               _loc4_ = _loc7_;
            }
         }
         return param2.revert(_loc3_);
      }
      
      public function toArray(param1:ByteArray) : uint
      {
         var _loc3_:int = (1 << 8) - 1;
         var _loc4_:* = 0;
         var _loc5_:int = t;
         var _loc6_:int = DB - _loc5_ * DB % 8;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         if(_loc5_-- > 0)
         {
            if(_loc6_ < DB && (_loc4_ = bi_internal::a[_loc5_] >> _loc6_) > 0)
            {
               _loc7_ = true;
               param1.writeByte(_loc4_);
               _loc8_++;
            }
            while(_loc5_ >= 0)
            {
               if(_loc6_ < 8)
               {
                  _loc4_ = (_loc4_ = (bi_internal::a[_loc5_] & (1 << _loc6_) - 1) << 8 - _loc6_) | bi_internal::a[--_loc5_] >> (_loc6_ = _loc6_ + (DB - 8));
               }
               else
               {
                  _loc4_ = bi_internal::a[_loc5_] >> (_loc6_ = _loc6_ - 8) & _loc3_;
                  if(_loc6_ <= 0)
                  {
                     _loc6_ += DB;
                     _loc5_--;
                  }
               }
               if(_loc4_ > 0)
               {
                  _loc7_ = true;
               }
               if(_loc7_)
               {
                  param1.writeByte(_loc4_);
                  _loc8_++;
               }
            }
         }
         return _loc8_;
      }
      
      public function dispose() : void
      {
         var _loc1_:Random = new Random();
         var _loc2_:uint = 0;
         while(_loc2_ < bi_internal::a.length)
         {
            bi_internal::a[_loc2_] = _loc1_.nextByte();
            delete bi_internal::a[_loc2_];
            _loc2_++;
         }
         bi_internal::a = null;
         t = 0;
         bi_internal::s = 0;
         Memory.gc();
      }
      
      private function lbit(param1:int) : int
      {
         if(param1 == 0)
         {
            return -1;
         }
         var _loc2_:int = 0;
         if((param1 & 65535) == 0)
         {
            param1 >>= 16;
            _loc2_ += 16;
         }
         if((param1 & 255) == 0)
         {
            param1 >>= 8;
            _loc2_ += 8;
         }
         if((param1 & 15) == 0)
         {
            param1 >>= 4;
            _loc2_ += 4;
         }
         if((param1 & 3) == 0)
         {
            param1 >>= 2;
            _loc2_ += 2;
         }
         if((param1 & 1) == 0)
         {
            _loc2_++;
         }
         return _loc2_;
      }
      
      bi_internal function divRemTo(param1:com.hurlant.math.BigInteger, param2:com.hurlant.math.BigInteger = null, param3:com.hurlant.math.BigInteger = null) : void
      {
         var y:com.hurlant.math.BigInteger;
         var nsh:int;
         var pt:com.hurlant.math.BigInteger;
         var d1:Number;
         var d2:Number;
         var y0:int;
         var yt:Number;
         var ys:int;
         var e:Number;
         var ms:int;
         var j:int;
         var i:int;
         var t:com.hurlant.math.BigInteger;
         var ts:int;
         var qd:int = 0;
         var m:com.hurlant.math.BigInteger = param1;
         var q:com.hurlant.math.BigInteger = param2;
         var r:com.hurlant.math.BigInteger = param3;
         var pm:com.hurlant.math.BigInteger = m.abs();
         if(pm.t <= 0)
         {
            return;
         }
         pt = abs();
         if(pt.t < pm.t)
         {
            if(q != null)
            {
               q.bi_internal::fromInt(0);
            }
            if(r != null)
            {
               bi_internal::copyTo(r);
            }
            return;
         }
         if(r == null)
         {
            r = nbi();
         }
         y = nbi();
         ts = bi_internal::s;
         ms = m.bi_internal::s;
         nsh = DB - bi_internal::nbits(pm.bi_internal::a[pm.t - 1]);
         if(nsh > 0)
         {
            pm.bi_internal::lShiftTo(nsh,y);
            pt.bi_internal::lShiftTo(nsh,r);
         }
         else
         {
            pm.bi_internal::copyTo(y);
            pt.bi_internal::copyTo(r);
         }
         ys = y.t;
         y0 = int(y.bi_internal::a[ys - 1]);
         if(y0 == 0)
         {
            return;
         }
         yt = y0 * (1 << F1) + (ys > 1 ? y.bi_internal::a[ys - 2] >> F2 : 0);
         d1 = FV / yt;
         d2 = (1 << F1) / yt;
         e = 1 << F2;
         i = r.t;
         j = i - ys;
         t = q == null ? nbi() : q;
         y.bi_internal::dlShiftTo(j,t);
         if(r.compareTo(t) >= 0)
         {
            var _loc5_:*;
            r.bi_internal::a[_loc5_ = r.t++] = 1;
            r.bi_internal::subTo(t,r);
         }
         ONE.bi_internal::dlShiftTo(ys,t);
         t.bi_internal::subTo(y,y);
         while(y.t < ys)
         {
            y.(++y.t, false);
         }
         while(--j >= 0)
         {
            qd = r.bi_internal::a[--i] == y0 ? DM : int(Number(r.bi_internal::a[i]) * d1 + (Number(r.bi_internal::a[i - 1]) + e) * d2);
            if((r.bi_internal::a[i] = r.bi_internal::a[i] + y.bi_internal::am(0,qd,r,j,0,ys)) < qd)
            {
               y.bi_internal::dlShiftTo(j,t);
               r.bi_internal::subTo(t,r);
               while(r.bi_internal::a[i] < --qd)
               {
                  r.bi_internal::subTo(t,r);
               }
            }
         }
         if(q != null)
         {
            r.bi_internal::drShiftTo(ys,q);
            if(ts != ms)
            {
               ZERO.bi_internal::subTo(q,q);
            }
         }
         r.t = ys;
         r.bi_internal::clamp();
         if(nsh > 0)
         {
            r.bi_internal::rShiftTo(nsh,r);
         }
         if(ts < 0)
         {
            ZERO.bi_internal::subTo(r,r);
         }
      }
      
      public function remainder(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         bi_internal::divRemTo(param1,null,_loc2_);
         return _loc2_;
      }
      
      bi_internal function multiplyUpperTo(param1:com.hurlant.math.BigInteger, param2:int, param3:com.hurlant.math.BigInteger) : void
      {
         param2--;
         var _loc4_:int = param3.t = t + param1.t - param2;
         param3.bi_internal::s = 0;
         while(--_loc4_ >= 0)
         {
            param3.bi_internal::a[_loc4_] = 0;
         }
         _loc4_ = Math.max(param2 - t,0);
         while(_loc4_ < param1.t)
         {
            param3.bi_internal::a[t + _loc4_ - param2] = bi_internal::am(param2 - _loc4_,param1.bi_internal::a[_loc4_],param3,0,0,t + _loc4_ - param2);
            _loc4_++;
         }
         param3.bi_internal::clamp();
         param3.bi_internal::drShiftTo(1,param3);
      }
      
      public function divideAndRemainder(param1:com.hurlant.math.BigInteger) : Array
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         var _loc3_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         bi_internal::divRemTo(param1,_loc2_,_loc3_);
         return [_loc2_,_loc3_];
      }
      
      public function valueOf() : Number
      {
         var _loc1_:Number = 1;
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < t)
         {
            _loc2_ += bi_internal::a[_loc3_] * _loc1_;
            _loc1_ *= DV;
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function shiftLeft(param1:int) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         if(param1 < 0)
         {
            bi_internal::rShiftTo(-param1,_loc2_);
         }
         else
         {
            bi_internal::lShiftTo(param1,_loc2_);
         }
         return _loc2_;
      }
      
      public function multiply(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         bi_internal::multiplyTo(param1,_loc2_);
         return _loc2_;
      }
      
      bi_internal function am(param1:int, param2:int, param3:com.hurlant.math.BigInteger, param4:int, param5:int, param6:int) : int
      {
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:int = 0;
         var _loc7_:* = param2 & 32767;
         var _loc8_:* = param2 >> 15;
         while(--param6 >= 0)
         {
            _loc9_ = bi_internal::a[param1] & 32767;
            _loc10_ = bi_internal::a[param1++] >> 15;
            _loc11_ = _loc8_ * _loc9_ + _loc10_ * _loc7_;
            param5 = ((_loc9_ = _loc7_ * _loc9_ + ((_loc11_ & 32767) << 15) + param3.bi_internal::a[param4] + (param5 & 1073741823)) >>> 30) + (_loc11_ >>> 15) + _loc8_ * _loc10_ + (param5 >>> 30);
            var _loc12_:*;
            param3.bi_internal::a[_loc12_ = param4++] = _loc9_ & 1073741823;
         }
         return param5;
      }
      
      bi_internal function drShiftTo(param1:int, param2:com.hurlant.math.BigInteger) : void
      {
         var _loc3_:int = 0;
         _loc3_ = param1;
         while(_loc3_ < t)
         {
            param2.bi_internal::a[_loc3_ - param1] = bi_internal::a[_loc3_];
            _loc3_++;
         }
         param2.t = Math.max(t - param1,0);
         param2.bi_internal::s = bi_internal::s;
      }
      
      public function add(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         addTo(param1,_loc2_);
         return _loc2_;
      }
      
      protected function nbi() : *
      {
         return new com.hurlant.math.BigInteger();
      }
      
      protected function millerRabin(param1:int) : Boolean
      {
         var _loc7_:com.hurlant.math.BigInteger = null;
         var _loc8_:int = 0;
         var _loc2_:com.hurlant.math.BigInteger = subtract(com.hurlant.math.BigInteger.ONE);
         var _loc3_:int = _loc2_.getLowestSetBit();
         if(_loc3_ <= 0)
         {
            return false;
         }
         var _loc4_:com.hurlant.math.BigInteger = _loc2_.shiftRight(_loc3_);
         param1 = param1 + 1 >> 1;
         if(param1 > lowprimes.length)
         {
            param1 = int(lowprimes.length);
         }
         var _loc5_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         var _loc6_:int = 0;
         while(_loc6_ < param1)
         {
            _loc5_.bi_internal::fromInt(lowprimes[_loc6_]);
            if((_loc7_ = _loc5_.modPow(_loc4_,this)).compareTo(com.hurlant.math.BigInteger.ONE) != 0 && _loc7_.compareTo(_loc2_) != 0)
            {
               _loc8_ = 1;
               while(_loc8_++ < _loc3_ && _loc7_.compareTo(_loc2_) != 0)
               {
                  if((_loc7_ = _loc7_.modPowInt(2,this)).compareTo(com.hurlant.math.BigInteger.ONE) == 0)
                  {
                     return false;
                  }
               }
               if(_loc7_.compareTo(_loc2_) != 0)
               {
                  return false;
               }
            }
            _loc6_++;
         }
         return true;
      }
      
      bi_internal function dMultiply(param1:int) : void
      {
         bi_internal::a[t] = bi_internal::am(0,param1 - 1,this,0,0,t);
         ++t;
         bi_internal::clamp();
      }
      
      private function op_andnot(param1:int, param2:int) : int
      {
         return param1 & ~param2;
      }
      
      bi_internal function clamp() : void
      {
         var _loc1_:* = bi_internal::s & DM;
         while(t > 0 && bi_internal::a[t - 1] == _loc1_)
         {
            --t;
         }
      }
      
      bi_internal function invDigit() : int
      {
         if(t < 1)
         {
            return 0;
         }
         var _loc1_:int = int(bi_internal::a[0]);
         if((_loc1_ & 1) == 0)
         {
            return 0;
         }
         var _loc2_:* = _loc1_ & 3;
         _loc2_ = _loc2_ * (2 - (_loc1_ & 15) * _loc2_) & 15;
         _loc2_ = _loc2_ * (2 - (_loc1_ & 255) * _loc2_) & 255;
         _loc2_ = _loc2_ * (2 - ((_loc1_ & 65535) * _loc2_ & 65535)) & 65535;
         _loc2_ = _loc2_ * (2 - _loc1_ * _loc2_ % DV) % DV;
         return _loc2_ > 0 ? DV - _loc2_ : int(-_loc2_);
      }
      
      protected function changeBit(param1:int, param2:Function) : com.hurlant.math.BigInteger
      {
         var _loc3_:com.hurlant.math.BigInteger = com.hurlant.math.BigInteger.ONE.shiftLeft(param1);
         bitwiseTo(_loc3_,param2,_loc3_);
         return _loc3_;
      }
      
      public function equals(param1:com.hurlant.math.BigInteger) : Boolean
      {
         return compareTo(param1) == 0;
      }
      
      public function compareTo(param1:com.hurlant.math.BigInteger) : int
      {
         var _loc2_:int = bi_internal::s - param1.bi_internal::s;
         if(_loc2_ != 0)
         {
            return _loc2_;
         }
         var _loc3_:int = t;
         _loc2_ = _loc3_ - param1.t;
         if(_loc2_ != 0)
         {
            return _loc2_;
         }
         while(--_loc3_ >= 0)
         {
            _loc2_ = bi_internal::a[_loc3_] - param1.bi_internal::a[_loc3_];
            if(_loc2_ != 0)
            {
               return _loc2_;
            }
         }
         return 0;
      }
      
      public function shiftRight(param1:int) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         if(param1 < 0)
         {
            bi_internal::lShiftTo(-param1,_loc2_);
         }
         else
         {
            bi_internal::rShiftTo(param1,_loc2_);
         }
         return _loc2_;
      }
      
      bi_internal function multiplyTo(param1:com.hurlant.math.BigInteger, param2:com.hurlant.math.BigInteger) : void
      {
         var _loc3_:com.hurlant.math.BigInteger = abs();
         var _loc4_:com.hurlant.math.BigInteger = param1.abs();
         var _loc5_:int = _loc3_.t;
         param2.t = _loc5_ + _loc4_.t;
         while(--_loc5_ >= 0)
         {
            param2.bi_internal::a[_loc5_] = 0;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_.t)
         {
            param2.bi_internal::a[_loc5_ + _loc3_.t] = _loc3_.bi_internal::am(0,_loc4_.bi_internal::a[_loc5_],param2,_loc5_,0,_loc3_.t);
            _loc5_++;
         }
         param2.bi_internal::s = 0;
         param2.bi_internal::clamp();
         if(bi_internal::s != param1.bi_internal::s)
         {
            ZERO.bi_internal::subTo(param2,param2);
         }
      }
      
      public function bitCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:* = bi_internal::s & DM;
         var _loc3_:int = 0;
         while(_loc3_ < t)
         {
            _loc1_ += cbit(bi_internal::a[_loc3_] ^ _loc2_);
            _loc3_++;
         }
         return _loc1_;
      }
      
      protected function toRadix(param1:uint = 10) : String
      {
         if(sigNum() == 0 || param1 < 2 || param1 > 32)
         {
            return "0";
         }
         var _loc2_:int = chunkSize(param1);
         var _loc3_:Number = Math.pow(param1,_loc2_);
         var _loc4_:com.hurlant.math.BigInteger = nbv(_loc3_);
         var _loc5_:com.hurlant.math.BigInteger = nbi();
         var _loc6_:com.hurlant.math.BigInteger = nbi();
         var _loc7_:String = "";
         bi_internal::divRemTo(_loc4_,_loc5_,_loc6_);
         while(_loc5_.sigNum() > 0)
         {
            _loc7_ = (_loc3_ + _loc6_.intValue()).toString(param1).substr(1) + _loc7_;
            _loc5_.bi_internal::divRemTo(_loc4_,_loc5_,_loc6_);
         }
         return _loc6_.intValue().toString(param1) + _loc7_;
      }
      
      private function cbit(param1:int) : int
      {
         var _loc2_:uint = 0;
         while(param1 != 0)
         {
            param1 &= param1 - 1;
            _loc2_++;
         }
         return _loc2_;
      }
      
      bi_internal function rShiftTo(param1:int, param2:com.hurlant.math.BigInteger) : void
      {
         var _loc7_:int = 0;
         param2.bi_internal::s = bi_internal::s;
         var _loc3_:int = param1 / DB;
         if(_loc3_ >= t)
         {
            param2.t = 0;
            return;
         }
         var _loc4_:int = param1 % DB;
         var _loc5_:int = DB - _loc4_;
         var _loc6_:int = (1 << _loc4_) - 1;
         param2.bi_internal::a[0] = bi_internal::a[_loc3_] >> _loc4_;
         _loc7_ = _loc3_ + 1;
         while(_loc7_ < t)
         {
            param2.bi_internal::a[_loc7_ - _loc3_ - 1] |= (bi_internal::a[_loc7_] & _loc6_) << _loc5_;
            param2.bi_internal::a[_loc7_ - _loc3_] = bi_internal::a[_loc7_] >> _loc4_;
            _loc7_++;
         }
         if(_loc4_ > 0)
         {
            param2.bi_internal::a[t - _loc3_ - 1] |= (bi_internal::s & _loc6_) << _loc5_;
         }
         param2.t = t - _loc3_;
         param2.bi_internal::clamp();
      }
      
      public function modInverse(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:Boolean = param1.bi_internal::isEven();
         if(bi_internal::isEven() && _loc2_ || param1.sigNum() == 0)
         {
            return com.hurlant.math.BigInteger.ZERO;
         }
         var _loc3_:com.hurlant.math.BigInteger = param1.clone();
         var _loc4_:com.hurlant.math.BigInteger = clone();
         var _loc5_:com.hurlant.math.BigInteger = nbv(1);
         var _loc6_:com.hurlant.math.BigInteger = nbv(0);
         var _loc7_:com.hurlant.math.BigInteger = nbv(0);
         var _loc8_:com.hurlant.math.BigInteger = nbv(1);
         while(_loc3_.sigNum() != 0)
         {
            while(_loc3_.bi_internal::isEven())
            {
               _loc3_.bi_internal::rShiftTo(1,_loc3_);
               if(_loc2_)
               {
                  if(!_loc5_.bi_internal::isEven() || !_loc6_.bi_internal::isEven())
                  {
                     _loc5_.addTo(this,_loc5_);
                     _loc6_.bi_internal::subTo(param1,_loc6_);
                  }
                  _loc5_.bi_internal::rShiftTo(1,_loc5_);
               }
               else if(!_loc6_.bi_internal::isEven())
               {
                  _loc6_.bi_internal::subTo(param1,_loc6_);
               }
               _loc6_.bi_internal::rShiftTo(1,_loc6_);
            }
            while(_loc4_.bi_internal::isEven())
            {
               _loc4_.bi_internal::rShiftTo(1,_loc4_);
               if(_loc2_)
               {
                  if(!_loc7_.bi_internal::isEven() || !_loc8_.bi_internal::isEven())
                  {
                     _loc7_.addTo(this,_loc7_);
                     _loc8_.bi_internal::subTo(param1,_loc8_);
                  }
                  _loc7_.bi_internal::rShiftTo(1,_loc7_);
               }
               else if(!_loc8_.bi_internal::isEven())
               {
                  _loc8_.bi_internal::subTo(param1,_loc8_);
               }
               _loc8_.bi_internal::rShiftTo(1,_loc8_);
            }
            if(_loc3_.compareTo(_loc4_) >= 0)
            {
               _loc3_.bi_internal::subTo(_loc4_,_loc3_);
               if(_loc2_)
               {
                  _loc5_.bi_internal::subTo(_loc7_,_loc5_);
               }
               _loc6_.bi_internal::subTo(_loc8_,_loc6_);
            }
            else
            {
               _loc4_.bi_internal::subTo(_loc3_,_loc4_);
               if(_loc2_)
               {
                  _loc7_.bi_internal::subTo(_loc5_,_loc7_);
               }
               _loc8_.bi_internal::subTo(_loc6_,_loc8_);
            }
         }
         if(_loc4_.compareTo(com.hurlant.math.BigInteger.ONE) != 0)
         {
            return com.hurlant.math.BigInteger.ZERO;
         }
         if(_loc8_.compareTo(param1) >= 0)
         {
            return _loc8_.subtract(param1);
         }
         if(_loc8_.sigNum() < 0)
         {
            _loc8_.addTo(param1,_loc8_);
            if(_loc8_.sigNum() < 0)
            {
               return _loc8_.add(param1);
            }
            return _loc8_;
         }
         return _loc8_;
      }
      
      bi_internal function fromArray(param1:ByteArray, param2:int) : void
      {
         var _loc7_:int = 0;
         var _loc3_:int = int(param1.position);
         var _loc4_:int = _loc3_ + param2;
         var _loc5_:int = 0;
         t = 0;
         bi_internal::s = 0;
         while(--_loc4_ >= _loc3_)
         {
            _loc7_ = _loc4_ < param1.length ? int(param1[_loc4_]) : 0;
            if(_loc5_ == 0)
            {
               var _loc8_:*;
               bi_internal::a[_loc8_ = t++] = _loc7_;
            }
            else if(_loc5_ + 8 > DB)
            {
               bi_internal::a[t - 1] |= (_loc7_ & (1 << DB - _loc5_) - 1) << _loc5_;
               bi_internal::a[_loc8_ = t++] = _loc7_ >> DB - _loc5_;
            }
            else
            {
               bi_internal::a[t - 1] |= _loc7_ << _loc5_;
            }
            if((_loc5_ += 8) >= DB)
            {
               _loc5_ -= DB;
            }
         }
         bi_internal::clamp();
         param1.position = Math.min(_loc3_ + param2,param1.length);
      }
      
      bi_internal function copyTo(param1:com.hurlant.math.BigInteger) : void
      {
         var _loc2_:int = t - 1;
         while(_loc2_ >= 0)
         {
            param1.bi_internal::a[_loc2_] = bi_internal::a[_loc2_];
            _loc2_--;
         }
         param1.t = t;
         param1.bi_internal::s = bi_internal::s;
      }
      
      public function intValue() : int
      {
         if(bi_internal::s < 0)
         {
            if(t == 1)
            {
               return bi_internal::a[0] - DV;
            }
            if(t == 0)
            {
               return -1;
            }
         }
         else
         {
            if(t == 1)
            {
               return bi_internal::a[0];
            }
            if(t == 0)
            {
               return 0;
            }
         }
         return (bi_internal::a[1] & (1 << 32 - DB) - 1) << DB | bi_internal::a[0];
      }
      
      public function min(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         return compareTo(param1) < 0 ? this : param1;
      }
      
      public function bitLength() : int
      {
         if(t <= 0)
         {
            return 0;
         }
         return DB * (t - 1) + bi_internal::nbits(bi_internal::a[t - 1] ^ bi_internal::s & DM);
      }
      
      public function shortValue() : int
      {
         return t == 0 ? bi_internal::s : bi_internal::a[0] << 16 >> 16;
      }
      
      public function and(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         bitwiseTo(param1,op_and,_loc2_);
         return _loc2_;
      }
      
      public function byteValue() : int
      {
         return t == 0 ? bi_internal::s : bi_internal::a[0] << 24 >> 24;
      }
      
      public function not() : com.hurlant.math.BigInteger
      {
         var _loc1_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         var _loc2_:int = 0;
         while(_loc2_ < t)
         {
            _loc1_[_loc2_] = DM & ~bi_internal::a[_loc2_];
            _loc2_++;
         }
         _loc1_.t = t;
         _loc1_.bi_internal::s = ~bi_internal::s;
         return _loc1_;
      }
      
      bi_internal function subTo(param1:com.hurlant.math.BigInteger, param2:com.hurlant.math.BigInteger) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc5_:int = Math.min(param1.t,t);
         while(_loc3_ < _loc5_)
         {
            _loc4_ += bi_internal::a[_loc3_] - param1.bi_internal::a[_loc3_];
            var _loc6_:*;
            param2.bi_internal::a[_loc6_ = _loc3_++] = _loc4_ & DM;
            _loc4_ >>= DB;
         }
         if(param1.t < t)
         {
            _loc4_ -= param1.bi_internal::s;
            while(_loc3_ < t)
            {
               _loc4_ += bi_internal::a[_loc3_];
               param2.bi_internal::a[_loc6_ = _loc3_++] = _loc4_ & DM;
               _loc4_ >>= DB;
            }
            _loc4_ += bi_internal::s;
         }
         else
         {
            _loc4_ += bi_internal::s;
            while(_loc3_ < param1.t)
            {
               _loc4_ -= param1.bi_internal::a[_loc3_];
               param2.bi_internal::a[_loc6_ = _loc3_++] = _loc4_ & DM;
               _loc4_ >>= DB;
            }
            _loc4_ -= param1.bi_internal::s;
         }
         param2.bi_internal::s = _loc4_ < 0 ? -1 : 0;
         if(_loc4_ < -1)
         {
            param2.bi_internal::a[_loc6_ = _loc3_++] = DV + _loc4_;
         }
         else if(_loc4_ > 0)
         {
            param2.bi_internal::a[_loc6_ = _loc3_++] = _loc4_;
         }
         param2.t = _loc3_;
         param2.bi_internal::clamp();
      }
      
      public function clone() : com.hurlant.math.BigInteger
      {
         var _loc1_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         this.bi_internal::copyTo(_loc1_);
         return _loc1_;
      }
      
      public function pow(param1:int) : com.hurlant.math.BigInteger
      {
         return bi_internal::exp(param1,new NullReduction());
      }
      
      public function flipBit(param1:int) : com.hurlant.math.BigInteger
      {
         return changeBit(param1,op_xor);
      }
      
      public function xor(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         bitwiseTo(param1,op_xor,_loc2_);
         return _loc2_;
      }
      
      public function or(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = new com.hurlant.math.BigInteger();
         bitwiseTo(param1,op_or,_loc2_);
         return _loc2_;
      }
      
      public function max(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         return compareTo(param1) > 0 ? this : param1;
      }
      
      bi_internal function fromInt(param1:int) : void
      {
         t = 1;
         bi_internal::s = param1 < 0 ? -1 : 0;
         if(param1 > 0)
         {
            bi_internal::a[0] = param1;
         }
         else if(param1 < -1)
         {
            bi_internal::a[0] = param1 + DV;
         }
         else
         {
            t = 0;
         }
      }
      
      bi_internal function isEven() : Boolean
      {
         return (t > 0 ? bi_internal::a[0] & 1 : bi_internal::s) == 0;
      }
      
      public function toString(param1:Number = 16) : String
      {
         var _loc2_:int = 0;
         if(bi_internal::s < 0)
         {
            return "-" + negate().toString(param1);
         }
         switch(param1)
         {
            case 2:
               _loc2_ = 1;
               break;
            case 4:
               _loc2_ = 2;
               break;
            case 8:
               _loc2_ = 3;
               break;
            case 16:
               _loc2_ = 4;
               break;
            case 32:
               _loc2_ = 5;
         }
         var _loc3_:int = (1 << _loc2_) - 1;
         var _loc4_:* = 0;
         var _loc5_:Boolean = false;
         var _loc6_:String = "";
         var _loc7_:int = t;
         var _loc8_:int = DB - _loc7_ * DB % _loc2_;
         if(_loc7_-- > 0)
         {
            if(_loc8_ < DB && (_loc4_ = bi_internal::a[_loc7_] >> _loc8_) > 0)
            {
               _loc5_ = true;
               _loc6_ = _loc4_.toString(36);
            }
            while(_loc7_ >= 0)
            {
               if(_loc8_ < _loc2_)
               {
                  _loc4_ = (_loc4_ = (bi_internal::a[_loc7_] & (1 << _loc8_) - 1) << _loc2_ - _loc8_) | bi_internal::a[--_loc7_] >> (_loc8_ = _loc8_ + (DB - _loc2_));
               }
               else
               {
                  _loc4_ = bi_internal::a[_loc7_] >> (_loc8_ = _loc8_ - _loc2_) & _loc3_;
                  if(_loc8_ <= 0)
                  {
                     _loc8_ += DB;
                     _loc7_--;
                  }
               }
               if(_loc4_ > 0)
               {
                  _loc5_ = true;
               }
               if(_loc5_)
               {
                  _loc6_ += _loc4_.toString(36);
               }
            }
         }
         return _loc5_ ? _loc6_ : "0";
      }
      
      public function setBit(param1:int) : com.hurlant.math.BigInteger
      {
         return changeBit(param1,op_or);
      }
      
      public function abs() : com.hurlant.math.BigInteger
      {
         return bi_internal::s < 0 ? negate() : this;
      }
      
      bi_internal function nbits(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = 1;
         if((_loc3_ = param1 >>> 16) != 0)
         {
            param1 = _loc3_;
            _loc2_ += 16;
         }
         if((_loc3_ = param1 >> 8) != 0)
         {
            param1 = _loc3_;
            _loc2_ += 8;
         }
         if((_loc3_ = param1 >> 4) != 0)
         {
            param1 = _loc3_;
            _loc2_ += 4;
         }
         if((_loc3_ = param1 >> 2) != 0)
         {
            param1 = _loc3_;
            _loc2_ += 2;
         }
         if((_loc3_ = param1 >> 1) != 0)
         {
            param1 = _loc3_;
            _loc2_ += 1;
         }
         return _loc2_;
      }
      
      public function sigNum() : int
      {
         if(bi_internal::s < 0)
         {
            return -1;
         }
         if(t <= 0 || t == 1 && bi_internal::a[0] <= 0)
         {
            return 0;
         }
         return 1;
      }
      
      public function toByteArray() : ByteArray
      {
         var _loc4_:* = 0;
         var _loc1_:int = t;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_[0] = bi_internal::s;
         var _loc3_:int = DB - _loc1_ * DB % 8;
         var _loc5_:int = 0;
         if(_loc1_-- > 0)
         {
            if(_loc3_ < DB && (_loc4_ = bi_internal::a[_loc1_] >> _loc3_) != (bi_internal::s & DM) >> _loc3_)
            {
               var _loc6_:*;
               _loc2_[_loc6_ = _loc5_++] = _loc4_ | bi_internal::s << DB - _loc3_;
            }
            while(_loc1_ >= 0)
            {
               if(_loc3_ < 8)
               {
                  _loc4_ = (_loc4_ = (bi_internal::a[_loc1_] & (1 << _loc3_) - 1) << 8 - _loc3_) | bi_internal::a[--_loc1_] >> (_loc3_ = _loc3_ + (DB - 8));
               }
               else
               {
                  _loc4_ = bi_internal::a[_loc1_] >> (_loc3_ = _loc3_ - 8) & 255;
                  if(_loc3_ <= 0)
                  {
                     _loc3_ += DB;
                     _loc1_--;
                  }
               }
               if((_loc4_ & 128) != 0)
               {
                  _loc4_ |= -256;
               }
               if(_loc5_ == 0 && (bi_internal::s & 128) != (_loc4_ & 128))
               {
                  _loc5_++;
               }
               if(_loc5_ > 0 || _loc4_ != bi_internal::s)
               {
                  _loc2_[_loc6_ = _loc5_++] = _loc4_;
               }
            }
         }
         return _loc2_;
      }
      
      bi_internal function squareTo(param1:com.hurlant.math.BigInteger) : void
      {
         var _loc4_:int = 0;
         var _loc2_:com.hurlant.math.BigInteger = abs();
         var _loc3_:int = param1.t = 2 * _loc2_.t;
         while(--_loc3_ >= 0)
         {
            param1.bi_internal::a[_loc3_] = 0;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.t - 1)
         {
            _loc4_ = _loc2_.bi_internal::am(_loc3_,_loc2_.bi_internal::a[_loc3_],param1,2 * _loc3_,0,1);
            if((param1.bi_internal::a[_loc3_ + _loc2_.t] = param1.bi_internal::a[_loc3_ + _loc2_.t] + _loc2_.bi_internal::am(_loc3_ + 1,2 * _loc2_.bi_internal::a[_loc3_],param1,2 * _loc3_ + 1,_loc4_,_loc2_.t - _loc3_ - 1)) >= DV)
            {
               param1.bi_internal::a[_loc3_ + _loc2_.t] -= DV;
               param1.bi_internal::a[_loc3_ + _loc2_.t + 1] = 1;
            }
            _loc3_++;
         }
         if(param1.t > 0)
         {
            param1.bi_internal::a[param1.t - 1] += _loc2_.bi_internal::am(_loc3_,_loc2_.bi_internal::a[_loc3_],param1,2 * _loc3_,0,1);
         }
         param1.bi_internal::s = 0;
         param1.bi_internal::clamp();
      }
      
      private function op_and(param1:int, param2:int) : int
      {
         return param1 & param2;
      }
      
      protected function fromRadix(param1:String, param2:int = 10) : void
      {
         var _loc9_:int = 0;
         bi_internal::fromInt(0);
         var _loc3_:int = chunkSize(param2);
         var _loc4_:Number = Math.pow(param2,_loc3_);
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc8_ < param1.length)
         {
            if((_loc9_ = bi_internal::intAt(param1,_loc8_)) < 0)
            {
               if(param1.charAt(_loc8_) == "-" && sigNum() == 0)
               {
                  _loc5_ = true;
               }
            }
            else
            {
               _loc7_ = param2 * _loc7_ + _loc9_;
               if(++_loc6_ >= _loc3_)
               {
                  bi_internal::dMultiply(_loc4_);
                  bi_internal::dAddOffset(_loc7_,0);
                  _loc6_ = 0;
                  _loc7_ = 0;
               }
            }
            _loc8_++;
         }
         if(_loc6_ > 0)
         {
            bi_internal::dMultiply(Math.pow(param2,_loc6_));
            bi_internal::dAddOffset(_loc7_,0);
         }
         if(_loc5_)
         {
            com.hurlant.math.BigInteger.ZERO.bi_internal::subTo(this,this);
         }
      }
      
      bi_internal function dlShiftTo(param1:int, param2:com.hurlant.math.BigInteger) : void
      {
         var _loc3_:int = 0;
         _loc3_ = t - 1;
         while(_loc3_ >= 0)
         {
            param2.bi_internal::a[_loc3_ + param1] = bi_internal::a[_loc3_];
            _loc3_--;
         }
         _loc3_ = param1 - 1;
         while(_loc3_ >= 0)
         {
            param2.bi_internal::a[_loc3_] = 0;
            _loc3_--;
         }
         param2.t = t + param1;
         param2.bi_internal::s = bi_internal::s;
      }
      
      private function op_xor(param1:int, param2:int) : int
      {
         return param1 ^ param2;
      }
   }
}
