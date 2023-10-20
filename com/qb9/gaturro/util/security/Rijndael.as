package com.qb9.gaturro.util.security
{
   public class Rijndael
   {
       
      
      public var keySize:Number = 128;
      
      private var Nb:Number;
      
      private var SBoxInverse:Array;
      
      private var Nk:Number;
      
      private var shiftOffsets:Array;
      
      private var Nr:Number;
      
      public var blockSize:Number = 128;
      
      private var roundsArray:Array;
      
      private var Rcon:Array;
      
      private var SBox:Array;
      
      public function Rijndael(... rest)
      {
         this.Rcon = new Array(1,2,4,8,16,32,64,128,27,54,108,216,171,77,154,47,94,188,99,198,151,53,106,212,179,125,250,239,197,145);
         this.SBox = new Array(99,124,119,123,242,107,111,197,48,1,103,43,254,215,171,118,202,130,201,125,250,89,71,240,173,212,162,175,156,164,114,192,183,253,147,38,54,63,247,204,52,165,229,241,113,216,49,21,4,199,35,195,24,150,5,154,7,18,128,226,235,39,178,117,9,131,44,26,27,110,90,160,82,59,214,179,41,227,47,132,83,209,0,237,32,252,177,91,106,203,190,57,74,76,88,207,208,239,170,251,67,77,51,133,69,249,2,127,80,60,159,168,81,163,64,143,146,157,56,245,188,182,218,33,16,255,243,210,205,12,19,236,95,151,68,23,196,167,126,61,100,93,25,115,96,129,79,220,34,42,144,136,70,238,184,20,222,94,11,219,224,50,58,10,73,6,36,92,194,211,172,98,145,149,228,121,231,200,55,109,141,213,78,169,108,86,244,234,101,122,174,8,186,120,37,46,28,166,180,198,232,221,116,31,75,189,139,138,112,62,181,102,72,3,246,14,97,53,87,185,134,193,29,158,225,248,152,17,105,217,142,148,155,30,135,233,206,85,40,223,140,161,137,13,191,230,66,104,65,153,45,15,176,84,187,22);
         this.SBoxInverse = new Array(82,9,106,213,48,54,165,56,191,64,163,158,129,243,215,251,124,227,57,130,155,47,255,135,52,142,67,68,196,222,233,203,84,123,148,50,166,194,35,61,238,76,149,11,66,250,195,78,8,46,161,102,40,217,36,178,118,91,162,73,109,139,209,37,114,248,246,100,134,104,152,22,212,164,92,204,93,101,182,146,108,112,72,80,253,237,185,218,94,21,70,87,167,141,157,132,144,216,171,0,140,188,211,10,247,228,88,5,184,179,69,6,208,44,30,143,202,63,15,2,193,175,189,3,1,19,138,107,58,145,17,65,79,103,220,234,151,242,207,206,240,180,230,115,150,172,116,34,231,173,53,133,226,249,55,232,28,117,223,110,71,241,26,113,29,41,197,137,111,183,98,14,170,24,190,27,252,86,62,75,198,210,121,32,154,219,192,254,120,205,90,244,31,221,168,51,136,7,199,49,177,18,16,89,39,128,236,95,96,81,127,169,25,181,74,13,45,229,122,159,147,201,156,239,160,224,59,77,174,42,245,176,200,235,187,60,131,83,153,97,23,43,4,126,186,119,214,38,225,105,20,99,85,33,12,125);
         super();
         if(rest.length >= 0 && !isNaN(rest[0]))
         {
            this.keySize = rest[0];
         }
         if(rest.length >= 1 && !isNaN(rest[1]))
         {
            this.blockSize = rest[1];
         }
         this.roundsArray = [0,0,0,0,[0,0,0,0,10,0,12,0,14],0,[0,0,0,0,12,0,12,0,14],0,[0,0,0,0,14,0,14,0,14]];
         this.shiftOffsets = [0,0,0,0,[0,1,2,3],0,[0,1,2,3],0,[0,1,3,4]];
         this.Nb = this.blockSize / 32;
         this.Nk = this.keySize / 32;
         this.Nr = this.roundsArray[this.Nk][this.Nb];
      }
      
      private function encryption(param1:Array, param2:Array) : Array
      {
         param1 = this.packBytes(param1);
         this.addRoundKey(param1,param2);
         var _loc3_:Number = 1;
         while(_loc3_ < this.Nr)
         {
            this.Round(param1,param2.slice(this.Nb * _loc3_,this.Nb * (_loc3_ + 1)));
            _loc3_++;
         }
         this.FinalRound(param1,param2.slice(this.Nb * this.Nr));
         return this.unpackBytes(param1);
      }
      
      private function xtime(param1:Number) : Number
      {
         param1 <<= 1;
         return !!(param1 & 256) ? param1 ^ 283 : param1;
      }
      
      private function charsToHex(param1:Array) : String
      {
         var _loc2_:String = new String("");
         var _loc3_:Array = new Array("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f");
         var _loc4_:Number = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ += _loc3_[param1[_loc4_] >> 4] + _loc3_[param1[_loc4_] & 15];
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function InverseFinalRound(param1:Array, param2:Array) : void
      {
         this.addRoundKey(param1,param2);
         this.shiftRow(param1,"decrypt");
         this.byteSub(param1,"decrypt");
      }
      
      private function mult_GF256(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = 0;
         var _loc4_:Number = 1;
         while(_loc4_ < 256)
         {
            if(param1 & _loc4_)
            {
               _loc3_ ^= param2;
            }
            _loc4_ *= 2;
            param2 = this.xtime(param2);
         }
         return _loc3_;
      }
      
      public function decrypt(param1:String, param2:String, param3:String) : String
      {
         var _loc10_:Number = NaN;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = this.hexToChars(param1);
         var _loc7_:Number = this.blockSize / 8;
         var _loc8_:Array = this.keyExpansion(this.strToChars(param2));
         var _loc9_:Number = _loc6_.length / _loc7_ - 1;
         while(_loc9_ > 0)
         {
            _loc5_ = this.decryption(_loc6_.slice(_loc9_ * _loc7_,(_loc9_ + 1) * _loc7_),_loc8_);
            if(param3 == "CBC")
            {
               _loc10_ = 0;
               while(_loc10_ < _loc7_)
               {
                  _loc4_[(_loc9_ - 1) * _loc7_ + _loc10_] = _loc5_[_loc10_] ^ _loc6_[(_loc9_ - 1) * _loc7_ + _loc10_];
                  _loc10_++;
               }
            }
            else
            {
               _loc4_ = _loc5_.concat(_loc4_);
            }
            _loc9_--;
         }
         if(param3 == "ECB")
         {
            _loc4_ = this.decryption(_loc6_.slice(0,_loc7_),_loc8_).concat(_loc4_);
         }
         return this.charsToStr(_loc4_);
      }
      
      private function hexToChars(param1:String) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:Number = param1.substr(0,2) == "0x" ? 2 : 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(parseInt(param1.substr(_loc3_,2),16));
            _loc3_ += 2;
         }
         return _loc2_;
      }
      
      private function formatPlaintext(param1:Array) : Array
      {
         var _loc2_:Number = this.blockSize / 8;
         var _loc3_:Number = _loc2_ - param1.length % _loc2_;
         while(_loc3_ > 0 && _loc3_ < _loc2_)
         {
            param1[param1.length] = 0;
            _loc3_--;
         }
         return param1;
      }
      
      private function shiftRow(param1:Array, param2:String) : void
      {
         var _loc3_:Number = 1;
         while(_loc3_ < 4)
         {
            if(param2 == "encrypt")
            {
               param1[_loc3_] = this.cyclicShiftLeft(param1[_loc3_],this.shiftOffsets[this.Nb][_loc3_]);
            }
            else
            {
               param1[_loc3_] = this.cyclicShiftLeft(param1[_loc3_],this.Nb - this.shiftOffsets[this.Nb][_loc3_]);
            }
            _loc3_++;
         }
      }
      
      private function FinalRound(param1:Array, param2:Array) : void
      {
         this.byteSub(param1,"encrypt");
         this.shiftRow(param1,"encrypt");
         this.addRoundKey(param1,param2);
      }
      
      private function strToChars(param1:String) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1.charCodeAt(_loc3_));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function mixColumn(param1:Array, param2:String) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:Array = new Array();
         _loc5_ = 0;
         while(_loc5_ < this.Nb)
         {
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               if(param2 == "encrypt")
               {
                  _loc3_[_loc4_] = this.mult_GF256(param1[_loc4_][_loc5_],2) ^ this.mult_GF256(param1[(_loc4_ + 1) % 4][_loc5_],3) ^ param1[(_loc4_ + 2) % 4][_loc5_] ^ param1[(_loc4_ + 3) % 4][_loc5_];
               }
               else
               {
                  _loc3_[_loc4_] = this.mult_GF256(param1[_loc4_][_loc5_],14) ^ this.mult_GF256(param1[(_loc4_ + 1) % 4][_loc5_],11) ^ this.mult_GF256(param1[(_loc4_ + 2) % 4][_loc5_],13) ^ this.mult_GF256(param1[(_loc4_ + 3) % 4][_loc5_],9);
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               param1[_loc4_][_loc5_] = _loc3_[_loc4_];
               _loc4_++;
            }
            _loc5_++;
         }
      }
      
      private function decryption(param1:Array, param2:Array) : Array
      {
         param1 = this.packBytes(param1);
         this.InverseFinalRound(param1,param2.slice(this.Nb * this.Nr));
         var _loc3_:Number = this.Nr - 1;
         while(_loc3_ > 0)
         {
            this.InverseRound(param1,param2.slice(this.Nb * _loc3_,this.Nb * (_loc3_ + 1)));
            _loc3_--;
         }
         this.addRoundKey(param1,param2);
         return this.unpackBytes(param1);
      }
      
      private function byteSub(param1:Array, param2:String) : void
      {
         var _loc5_:Number = NaN;
         var _loc3_:Array = new Array();
         if(param2 == "encrypt")
         {
            _loc3_ = this.SBox;
         }
         else
         {
            _loc3_ = this.SBoxInverse;
         }
         var _loc4_:Number = 0;
         while(_loc4_ < 4)
         {
            _loc5_ = 0;
            while(_loc5_ < this.Nb)
            {
               param1[_loc4_][_loc5_] = _loc3_[param1[_loc4_][_loc5_]];
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      private function packBytes(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         _loc2_[0] = new Array();
         _loc2_[1] = new Array();
         _loc2_[2] = new Array();
         _loc2_[3] = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_[0][_loc3_ / 4] = param1[_loc3_];
            _loc2_[1][_loc3_ / 4] = param1[_loc3_ + 1];
            _loc2_[2][_loc3_ / 4] = param1[_loc3_ + 2];
            _loc2_[3][_loc3_ / 4] = param1[_loc3_ + 3];
            _loc3_ += 4;
         }
         return _loc2_;
      }
      
      public function encrypt(param1:String, param2:String, param3:String) : String
      {
         var _loc10_:Number = NaN;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Number = this.blockSize / 8;
         if(param3 == "CBC")
         {
            _loc4_ = this.getRandomBytes(_loc6_);
         }
         var _loc7_:Array = this.formatPlaintext(this.strToChars(param1));
         var _loc8_:Array = this.keyExpansion(this.strToChars(param2));
         var _loc9_:Number = 0;
         while(_loc9_ < _loc7_.length / _loc6_)
         {
            _loc5_ = _loc7_.slice(_loc9_ * _loc6_,(_loc9_ + 1) * _loc6_);
            if(param3 == "CBC")
            {
               _loc10_ = 0;
               while(_loc10_ < _loc6_)
               {
                  _loc5_[_loc10_] ^= _loc4_[_loc9_ * _loc6_ + _loc10_];
                  _loc10_++;
               }
            }
            _loc4_ = _loc4_.concat(this.encryption(_loc5_,_loc8_));
            _loc9_++;
         }
         return this.charsToHex(_loc4_);
      }
      
      private function keyExpansion(param1:Array) : Array
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = 0;
         this.Nk = this.keySize / 32;
         this.Nb = this.blockSize / 32;
         var _loc3_:Array = new Array();
         this.Nr = this.roundsArray[this.Nk][this.Nb];
         _loc4_ = 0;
         while(_loc4_ < this.Nk)
         {
            _loc3_[_loc4_] = param1[4 * _loc4_] | param1[4 * _loc4_ + 1] << 8 | param1[4 * _loc4_ + 2] << 16 | param1[4 * _loc4_ + 3] << 24;
            _loc4_++;
         }
         _loc4_ = this.Nk;
         while(_loc4_ < this.Nb * (this.Nr + 1))
         {
            _loc2_ = Number(_loc3_[_loc4_ - 1]);
            if(_loc4_ % this.Nk == 0)
            {
               _loc2_ = (this.SBox[_loc2_ >> 8 & 255] | this.SBox[_loc2_ >> 16 & 255] << 8 | this.SBox[_loc2_ >> 24 & 255] << 16 | this.SBox[_loc2_ & 255] << 24) ^ this.Rcon[Math.floor(_loc4_ / this.Nk) - 1];
            }
            else if(this.Nk > 6 && _loc4_ % this.Nk == 4)
            {
               _loc2_ = this.SBox[_loc2_ >> 24 & 255] << 24 | this.SBox[_loc2_ >> 16 & 255] << 16 | this.SBox[_loc2_ >> 8 & 255] << 8 | this.SBox[_loc2_ & 255];
            }
            _loc3_[_loc4_] = _loc3_[_loc4_ - this.Nk] ^ _loc2_;
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function InverseRound(param1:Array, param2:Array) : void
      {
         this.addRoundKey(param1,param2);
         this.mixColumn(param1,"decrypt");
         this.shiftRow(param1,"decrypt");
         this.byteSub(param1,"decrypt");
      }
      
      private function cyclicShiftLeft(param1:Array, param2:Number) : Array
      {
         var _loc3_:Array = param1.slice(0,param2);
         return param1.slice(param2).concat(_loc3_);
      }
      
      private function unpackBytes(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < param1[0].length)
         {
            _loc2_[_loc2_.length] = param1[0][_loc3_];
            _loc2_[_loc2_.length] = param1[1][_loc3_];
            _loc2_[_loc2_.length] = param1[2][_loc3_];
            _loc2_[_loc2_.length] = param1[3][_loc3_];
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function addRoundKey(param1:Array, param2:Array) : void
      {
         var _loc3_:Number = 0;
         while(_loc3_ < this.Nb)
         {
            param1[0][_loc3_] ^= param2[_loc3_] & 255;
            param1[1][_loc3_] ^= param2[_loc3_] >> 8 & 255;
            param1[2][_loc3_] ^= param2[_loc3_] >> 16 & 255;
            param1[3][_loc3_] ^= param2[_loc3_] >> 24 & 255;
            _loc3_++;
         }
      }
      
      private function Round(param1:Array, param2:Array) : void
      {
         this.byteSub(param1,"encrypt");
         this.shiftRow(param1,"encrypt");
         this.mixColumn(param1,"encrypt");
         this.addRoundKey(param1,param2);
      }
      
      private function getRandomBytes(param1:Number) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < param1)
         {
            _loc2_[_loc3_] = Math.round(Math.random() * 255);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function charsToStr(param1:Array) : String
      {
         var _loc2_:String = new String("");
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += String.fromCharCode(param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
