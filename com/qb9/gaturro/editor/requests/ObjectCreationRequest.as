package com.qb9.gaturro.editor.requests
{
   import com.qb9.flashlib.geom.Size;
   import com.qb9.flashlib.lang.map;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public class ObjectCreationRequest extends BaseMamboRequest
   {
       
      
      private var size:Size;
      
      private var blocks:Boolean;
      
      private var attrs:Array;
      
      private var name:String;
      
      private var coord:Coord;
      
      public function ObjectCreationRequest(param1:String, param2:Coord = null, param3:Boolean = false, param4:Size = null, param5:Array = null)
      {
         super("ObjectCreateOrUpdateRequest");
         this.name = param1;
         this.coord = param2 || Coord.create();
         this.blocks = param3;
         this.size = param4 || new Size(1,1);
         this.attrs = param5;
      }
      
      private function attrToMobject(param1:CustomAttribute) : Mobject
      {
         return param1.toMobject();
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("name",this.name);
         param1.setIntegerArray("coord",this.coord.toArray());
         param1.setIntegerArray("size",this.size.toArray());
         param1.setBoolean("blockingHint",this.blocks);
         if(this.attrs)
         {
            param1.setMobjectArray("customAttributes",map(this.attrs,this.attrToMobject));
         }
         param1.setInteger("speed",0);
         param1.setInteger("direction",0);
      }
   }
}
