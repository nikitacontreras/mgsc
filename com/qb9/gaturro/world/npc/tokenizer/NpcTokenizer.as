package com.qb9.gaturro.world.npc.tokenizer
{
   import com.qb9.flashlib.input.reader.StringReader;
   import com.qb9.flashlib.lang.map;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.gaturro.world.npc.struct.NpcScript;
   import com.qb9.gaturro.world.npc.struct.NpcStatement;
   import com.qb9.gaturro.world.npc.struct.NpcToken;
   import com.qb9.gaturro.world.npc.struct.states.NpcState;
   import com.qb9.gaturro.world.npc.struct.states.action.NpcActionState;
   import com.qb9.gaturro.world.npc.struct.states.condition.NpcConditionState;
   import com.qb9.gaturro.world.npc.struct.states.dialog.NpcDialogState;
   import com.qb9.gaturro.world.npc.struct.variables.NpcSessionVariable;
   import com.qb9.gaturro.world.npc.struct.variables.NpcStoredVariable;
   import com.qb9.gaturro.world.npc.struct.variables.NpcVariable;
   
   public final class NpcTokenizer extends StringReader
   {
      
      private static const INDENTATION:String = "\t";
      
      private static var total:uint = 0;
      
      private static const CONDITION_TYPE:String = "FORK";
      
      private static const DIALOG_TYPE:String = "SAY";
      
      private static const SHARED_VARIABLE:String = "shared";
      
      private static const PRIVATE_VARIABLE:String = "private";
      
      private static const QUOTE:String = "\"";
      
      private static const STORED_VARIABLE:String = "stored";
      
      private static var CACHE:Object = {};
      
      private static const ACTION_TYPE:String = "DO";
      
      private static const SESSION_VARIABLE:String = "session";
      
      private static var created:uint = 0;
      
      private static const VARIABLES_HEADER:String = "define";
      
      private static const STATE_SEPARATOR:String = ":";
      
      private static const COMMENT:String = "#";
       
      
      private var context:NpcContext;
      
      public function NpcTokenizer(param1:String)
      {
         super(param1);
      }
      
      public function readScript(param1:String) : NpcScript
      {
         reset();
         var _loc2_:Array = this.readVariables();
         var _loc3_:Array = [];
         while(bytesAvailable)
         {
            _loc3_.push(this.readState());
         }
         return new NpcScript(param1,_loc3_,_loc2_);
      }
      
      private function readToken() : NpcToken
      {
         var _loc1_:String = null;
         var _loc2_:String = peek();
         var _loc3_:Boolean = false;
         switch(_loc2_)
         {
            case QUOTE:
               step();
               _loc1_ = readUntil(QUOTE);
               step();
               _loc3_ = true;
               break;
            case INDENTATION:
            case SPACE:
               step();
               return this.readToken();
            case COMMENT:
               readUntil(NEW_LINE);
            case NEW_LINE:
               readNewLine();
            case EMPTY:
               break;
            default:
               _loc1_ = readUntil(WHITE_SPACE);
         }
         if(_loc1_ === null)
         {
            return null;
         }
         if(_loc3_)
         {
            return new NpcToken(_loc1_);
         }
         if(_loc1_ in CACHE === false)
         {
            CACHE[_loc1_] = new NpcToken(_loc1_);
            ++created;
         }
         ++total;
         return CACHE[_loc1_];
      }
      
      private function readIndentedStatements() : Array
      {
         var _loc1_:Array = [];
         this.skipNeedlessLines();
         while(read(INDENTATION))
         {
            _loc1_.push(this.readStatement());
            this.skipNeedlessLines();
         }
         return _loc1_;
      }
      
      private function readVariables() : Array
      {
         this.skipNeedlessLines();
         if(!read(VARIABLES_HEADER))
         {
            return [];
         }
         expectNewLine();
         return map(this.readIndentedStatements(),this.makeVariable);
      }
      
      override protected function clean(param1:String) : String
      {
         return super.clean(param1).replace(/[\t ]+$/mg,"").replace(/^[ \t]*#.*$/mg,"").replace(/^[ \t]+/mg,INDENTATION);
      }
      
      private function makeVariable(param1:NpcStatement) : NpcVariable
      {
         var _loc3_:Boolean = false;
         var _loc2_:String = param1.reserved;
         switch(_loc2_)
         {
            case PRIVATE_VARIABLE:
               _loc3_ = false;
               break;
            case SHARED_VARIABLE:
               _loc3_ = true;
               break;
            default:
               error(_loc2_,"is not a valid visibility modifier for a variable");
               return null;
         }
         var _loc4_:Array;
         if((_loc4_ = param1.getArguments())[0] !== SESSION_VARIABLE && _loc4_[0] !== STORED_VARIABLE)
         {
            _loc4_.unshift(SESSION_VARIABLE);
         }
         var _loc5_:String = String(_loc4_[0]);
         var _loc6_:String = String(_loc4_[1]);
         var _loc7_:Object = _loc4_[2];
         switch(_loc5_)
         {
            case SESSION_VARIABLE:
               return new NpcSessionVariable(_loc6_,_loc3_,_loc7_);
            case STORED_VARIABLE:
               return new NpcStoredVariable(_loc6_,_loc3_,_loc7_);
            default:
               error(_loc5_,"is not a valid lifetime modifier for a variable");
               return null;
         }
      }
      
      private function skipNeedlessLines() : void
      {
         while(readNewLine())
         {
         }
      }
      
      private function get next() : String
      {
         return peek();
      }
      
      private function readStatement() : NpcStatement
      {
         var _loc2_:NpcToken = null;
         var _loc1_:Array = [];
         while(_loc2_ = this.readToken())
         {
            _loc1_.push(_loc2_);
         }
         return !!_loc1_.length ? new NpcStatement(_loc1_) : null;
      }
      
      private function readState() : NpcState
      {
         this.skipNeedlessLines();
         var _loc1_:String = readAlpha();
         expect(STATE_SEPARATOR);
         readSpace();
         var _loc2_:NpcStatement = this.readStatement();
         var _loc3_:String = _loc2_.reserved.toUpperCase();
         switch(_loc3_)
         {
            case ACTION_TYPE:
               return new NpcActionState(_loc1_,_loc2_,this.readIndentedStatements());
            case CONDITION_TYPE:
               return new NpcConditionState(_loc1_,_loc2_,this.readIndentedStatements());
            case DIALOG_TYPE:
               _loc2_.traslateArgument(0);
               return new NpcDialogState(_loc1_,_loc2_,this.readIndentedStatements());
            default:
               error("State type not found:",_loc3_);
               return null;
         }
      }
   }
}
