package com.qb9.flashlib.input.reader
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.math.QMath;
   import com.qb9.flashlib.utils.StringUtil;
   
   public class StringReader implements IDisposable
   {
      
      public static const NUMBER:RegExp = /\d/;
      
      public static const EMPTY:String = "";
      
      public static const WHITE_SPACE:RegExp = /\s/m;
      
      public static const NEW_LINE:String = "\n";
      
      public static const SPACE:String = " ";
      
      public static const WORD_SEPARATOR:RegExp = /[\n ,.;:-]/;
      
      public static const DOT:String = ".";
      
      public static const CARRIAGE_RETURN:RegExp = /\r/g;
      
      public static const ALPHA:RegExp = /\w/;
      
      public static const MINUS:String = "-";
       
      
      protected var _pointer:uint;
      
      protected var source:String;
      
      public function StringReader(param1:String = null)
      {
         super();
         if(param1)
         {
            this.setSource(param1);
         }
      }
      
      public function readWord() : String
      {
         return this.readUntil(WORD_SEPARATOR);
      }
      
      protected function at(param1:int) : String
      {
         return this.source.charAt(param1);
      }
      
      public function readUnsignedInt() : String
      {
         return this.readWhile(NUMBER);
      }
      
      public function readNumber() : String
      {
         var _loc1_:String = this.readInt();
         if(this.read(DOT))
         {
            _loc1_ += DOT + this.readUnsignedInt();
         }
         return _loc1_;
      }
      
      public function take(param1:int = 1) : String
      {
         var _loc2_:String = this.peek(param1);
         this.step(param1);
         return _loc2_;
      }
      
      protected function error(... rest) : void
      {
         var _loc2_:Array = this.source.slice(0,this.pointer).split(NEW_LINE);
         var _loc3_:String = String(StringUtil.trim(_loc2_.pop()) || _loc2_.pop() + NEW_LINE);
         rest.push("at: ",_loc3_,"<--");
         throw new StringReaderError(rest.join(" "));
      }
      
      protected function clean(param1:String) : String
      {
         return param1.replace(CARRIAGE_RETURN,EMPTY);
      }
      
      protected function step(param1:int = 1) : void
      {
         this._pointer = QMath.clamp(this.pointer + param1,0,this.bytesTotal);
      }
      
      protected function baseRead(param1:Object, param2:Boolean) : String
      {
         var _loc5_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:int = int(this.bytesAvailable);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.at(_loc3_ + this.pointer);
            if(this.matches(_loc5_,param1) !== param2)
            {
               break;
            }
            _loc3_++;
         }
         return !!_loc3_ ? this.take(_loc3_) : null;
      }
      
      public function reset() : void
      {
         this._pointer = 0;
      }
      
      public function readSpace() : String
      {
         return this.read(SPACE);
      }
      
      public function expectEnd() : void
      {
         if(this.bytesAvailable > 0)
         {
            this.error("expected empty buffer but found",this.bytesAvailable,"bytes");
         }
      }
      
      public function expectNewLine() : void
      {
         this.expect(NEW_LINE);
      }
      
      public function read(param1:Object) : String
      {
         var _loc2_:uint = this.tokenLength(param1);
         var _loc3_:String = this.peek(_loc2_);
         if(!this.matches(_loc3_,param1))
         {
            return null;
         }
         this.step(_loc2_);
         return _loc3_;
      }
      
      public function get bytesTotal() : uint
      {
         return this.source.length;
      }
      
      public function setSource(param1:String) : void
      {
         this.source = this.clean(param1);
         this.reset();
      }
      
      public function get bytesAvailable() : uint
      {
         return this.bytesTotal - this.pointer;
      }
      
      public function dispose() : void
      {
         this.source = null;
      }
      
      public function expect(param1:Object) : String
      {
         var _loc2_:String = this.read(param1);
         if(!this.matches(_loc2_,param1))
         {
            this.error("expected \"" + param1 + "\" but found \"" + this.peek(this.tokenLength(param1)) + "\"");
         }
         return _loc2_;
      }
      
      public function peek(param1:int = 1) : String
      {
         return this.source.substr(this.pointer,param1);
      }
      
      protected function get lineNumber() : uint
      {
         return this.source.slice(0,this.pointer).split(NEW_LINE).length;
      }
      
      public function readUntil(param1:Object) : String
      {
         return this.baseRead(param1,false);
      }
      
      public function readLine() : String
      {
         var _loc1_:String = this.readUntil(NEW_LINE);
         this.step();
         return _loc1_;
      }
      
      public function expectSpace() : String
      {
         return this.expect(SPACE);
      }
      
      public function readAlpha() : String
      {
         return this.readWhile(ALPHA);
      }
      
      protected function matches(param1:String, param2:Object) : Boolean
      {
         return param2 is RegExp ? RegExp(param2).test(param1) : param1 === param2;
      }
      
      public function readInt() : String
      {
         var _loc1_:String = !!this.read(MINUS) ? MINUS : EMPTY;
         return _loc1_ + this.readUnsignedInt();
      }
      
      public function readWhile(param1:Object) : String
      {
         return this.baseRead(param1,true);
      }
      
      public function get pointer() : uint
      {
         return this._pointer;
      }
      
      public function readNewLine() : String
      {
         return this.read(NEW_LINE);
      }
      
      protected function tokenLength(param1:Object) : uint
      {
         return param1 is RegExp ? 1 : uint(param1.toString().length);
      }
   }
}
