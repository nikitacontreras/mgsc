package com.qb9.mines.mobject
{
   public final class MobjectCreator
   {
      
      private static const ARRAYS:Array = [MobjectDataType.INTEGER_ARRAY,MobjectDataType.FLOAT_ARRAY,MobjectDataType.STRING_ARRAY,MobjectDataType.BOOLEAN_ARRAY,MobjectDataType.MOBJECT_ARRAY];
       
      
      public function MobjectCreator()
      {
         super();
      }
      
      public function convert(param1:Object) : Mobject
      {
         if(MobjectDataType.infer(param1) !== MobjectDataType.MOBJECT)
         {
            throw new Error("MobjectCreator.convert() > The data must be a literal object or a Mobject");
         }
         return this.getValue(param1,MobjectDataType.MOBJECT) as Mobject;
      }
      
      private function getValue(param1:Object, param2:int) : Object
      {
         var _loc3_:Mobject = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         switch(param2)
         {
            case MobjectDataType.MOBJECT:
               if(param1 is Mobject)
               {
                  return param1;
               }
               _loc3_ = new Mobject();
               for(_loc5_ in param1)
               {
                  if((_loc6_ = param1[_loc5_]) is Array && _loc6_.length === 0)
                  {
                     for each(param2 in ARRAYS)
                     {
                        _loc3_.addData(new MobjectData(_loc5_,_loc6_,param2));
                     }
                  }
                  else
                  {
                     param2 = MobjectDataType.infer(_loc6_);
                     _loc3_.addData(new MobjectData(_loc5_,this.getValue(_loc6_,param2),param2));
                     if(param2 === MobjectDataType.INTEGER)
                     {
                        _loc3_.setFloat(_loc5_,_loc6_ as Number);
                     }
                  }
               }
               return _loc3_;
               break;
            case MobjectDataType.INTEGER:
            case MobjectDataType.FLOAT:
            case MobjectDataType.STRING:
            case MobjectDataType.BOOLEAN:
            case MobjectDataType.INTEGER_ARRAY:
            case MobjectDataType.FLOAT_ARRAY:
            case MobjectDataType.STRING_ARRAY:
            case MobjectDataType.BOOLEAN_ARRAY:
               return param1;
            case MobjectDataType.MOBJECT_ARRAY:
               _loc7_ = int((_loc4_ = (param1 as Array).concat()).length - 1);
               while(_loc7_ >= 0)
               {
                  _loc4_[_loc7_] = this.getValue(_loc4_[_loc7_],MobjectDataType.MOBJECT);
                  _loc7_--;
               }
               return _loc4_;
            default:
               throw new Error("MobjectCreator.convert() > Cannot handle data of type " + param2);
         }
      }
   }
}
