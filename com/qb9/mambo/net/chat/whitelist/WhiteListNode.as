package com.qb9.mambo.net.chat.whitelist
{
   import com.qb9.mines.mobject.Mobject;
   
   public class WhiteListNode
   {
       
      
      protected var _key:int;
      
      protected var _text:String;
      
      protected var _children:Array;
      
      public function WhiteListNode()
      {
         this._children = [];
         super();
      }
      
      public function get children() : Array
      {
         return this._children.concat();
      }
      
      public function get isLeaf() : Boolean
      {
         return this._children.length === 0;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function getByKey(param1:int) : WhiteListNode
      {
         var _loc2_:WhiteListNode = null;
         var _loc3_:WhiteListNode = null;
         if(this.key === param1)
         {
            return this;
         }
         for each(_loc2_ in this._children)
         {
            _loc3_ = _loc2_.getByKey(param1);
            if(_loc3_)
            {
               break;
            }
         }
         return _loc3_;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         var _loc2_:Mobject = null;
         var _loc3_:WhiteListNode = null;
         this._key = param1.getInteger("key");
         this._text = param1.getString("text");
         for each(_loc2_ in param1.getMobjectArray("children"))
         {
            _loc3_ = new WhiteListNode();
            _loc3_.buildFromMobject(_loc2_);
            this._children.push(_loc3_);
         }
      }
      
      public function get key() : int
      {
         return this._key;
      }
   }
}
