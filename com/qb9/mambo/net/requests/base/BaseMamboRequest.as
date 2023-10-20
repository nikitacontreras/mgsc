package com.qb9.mambo.net.requests.base
{
   import com.qb9.flashlib.utils.ClassUtil;
   import com.qb9.mines.mobject.Mobject;
   
   public class BaseMamboRequest implements MamboRequest
   {
       
      
      protected var _type:String;
      
      public function BaseMamboRequest(param1:String = null)
      {
         super();
         this._type = param1 || ClassUtil.getName(this);
      }
      
      final public function toMobject() : Mobject
      {
         var _loc1_:Mobject = new Mobject();
         this.build(_loc1_);
         return _loc1_;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      protected function build(param1:Mobject) : void
      {
      }
   }
}
