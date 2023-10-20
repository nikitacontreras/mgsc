package com.qb9.flashlib.utils
{
   import com.qb9.flashlib.color.Color;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class DisplayUtil
   {
       
      
      public function DisplayUtil()
      {
         super();
      }
      
      public static function globalCoords(param1:DisplayObject) : Point
      {
         return new Point(offsetX(param1),offsetY(param1));
      }
      
      public static function hide(param1:DisplayObject) : void
      {
         param1.visible = false;
      }
      
      public static function remove(param1:DisplayObject) : void
      {
         stopMovieClip(param1);
         if(Boolean(param1.parent) && !(param1.parent is Loader))
         {
            param1.parent.removeChild(param1);
         }
      }
      
      public static function offsetX(param1:DisplayObject, param2:DisplayObject = null) : Number
      {
         var _loc3_:Number = 0;
         while(param1)
         {
            _loc3_ += param1.x;
            param1 = param1.parent;
         }
         if(param2)
         {
            _loc3_ -= offsetX(param2);
         }
         return _loc3_;
      }
      
      public static function offsetY(param1:DisplayObject, param2:DisplayObject = null) : Number
      {
         var _loc3_:Number = 0;
         while(param1)
         {
            _loc3_ += param1.y;
            param1 = param1.parent;
         }
         if(param2)
         {
            _loc3_ -= offsetY(param2);
         }
         return _loc3_;
      }
      
      public static function reparentTo(param1:DisplayObject, param2:DisplayObjectContainer) : void
      {
         globalize(param1);
         param2.addChild(param1);
         localize(param1);
      }
      
      public static function disableMouse(param1:DisplayObject) : void
      {
         if(param1 is InteractiveObject)
         {
            InteractiveObject(param1).mouseEnabled = false;
            if(param1 is DisplayObjectContainer)
            {
               DisplayObjectContainer(param1).mouseChildren = false;
            }
         }
      }
      
      public static function localize(param1:DisplayObject) : void
      {
         var _loc2_:Point = localCoords(param1);
         param1.x = _loc2_.x;
         param1.y = _loc2_.y;
      }
      
      public static function mask(param1:DisplayObject, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0) : Shape
      {
         var _loc6_:Shape;
         (_loc6_ = new Shape()).graphics.beginFill(Color.BLACK);
         _loc6_.graphics.drawRect(param2,param3,param1.width + param4,param1.height + param5);
         _loc6_.x = param1.x;
         _loc6_.y = param1.y;
         param1.parent.addChild(_loc6_);
         param1.mask = _loc6_;
         return _loc6_;
      }
      
      public static function empty(param1:DisplayObjectContainer) : void
      {
         var _loc2_:int = param1.numChildren;
         while(_loc2_--)
         {
            param1.removeChildAt(0);
         }
      }
      
      public static function dispose(param1:DisplayObject) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         if(_loc2_)
         {
            for each(_loc3_ in children(_loc2_,true))
            {
               stopMovieClip(_loc3_);
            }
         }
         stopMovieClip(param1);
         remove(param1);
      }
      
      public static function transparentTint(param1:DisplayObject, param2:uint, param3:Number = 1) : void
      {
         param1.transform.colorTransform = createTransform(param2,param3);
      }
      
      public static function localCoords(param1:DisplayObject) : Point
      {
         return new Point(param1.x,param1.y).subtract(globalCoords(param1.parent));
      }
      
      public static function globalize(param1:DisplayObject) : void
      {
         var _loc2_:Point = globalCoords(param1);
         param1.x = _loc2_.x;
         param1.y = _loc2_.y;
      }
      
      public static function getByPath(param1:DisplayObjectContainer, param2:String = "") : DisplayObject
      {
         var _loc4_:String = null;
         var _loc3_:DisplayObject = param1;
         for each(_loc4_ in param2.split("."))
         {
            if(_loc4_ && _loc3_ is DisplayObjectContainer)
            {
               _loc3_ = DisplayObjectContainer(_loc3_).getChildByName(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function getAllByName(param1:DisplayObjectContainer, param2:String) : Array
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:Array = [];
         for each(_loc4_ in children(param1,true))
         {
            if(_loc4_.name === param2)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function center(param1:DisplayObject) : void
      {
         var elem:DisplayObject = param1;
         with(elem)
         {
            if(parent)
            {
               x = (parent.width - width) / 2;
               y = (parent.height - height) / 2;
            }
         }
      }
      
      public static function createTransform(param1:uint, param2:Number = 1) : ColorTransform
      {
         var _loc3_:Color = new Color(param1);
         var _loc4_:uint = 255 / param2;
         return new ColorTransform(_loc3_.r / _loc4_,_loc3_.g / _loc4_,_loc3_.b / _loc4_);
      }
      
      public static function getByName(param1:DisplayObjectContainer, param2:String) : DisplayObject
      {
         var _loc5_:DisplayObjectContainer = null;
         var _loc3_:DisplayObject = param1.getChildByName(param2);
         var _loc4_:int = param1.numChildren;
         while(!_loc3_ && Boolean(_loc4_--))
         {
            if(_loc5_ = param1.getChildAt(_loc4_) as DisplayObjectContainer)
            {
               _loc3_ = getByName(_loc5_,param2);
            }
         }
         return _loc3_;
      }
      
      public static function tint(param1:DisplayObject, param2:uint) : void
      {
         var _loc3_:ColorTransform = new ColorTransform();
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
      }
      
      public static function bringToFront(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = param1.parent;
         if(_loc2_)
         {
            _loc2_.setChildIndex(param1,_loc2_.numChildren - 1);
         }
      }
      
      public static function show(param1:DisplayObject) : void
      {
         param1.visible = true;
      }
      
      public static function stopMovieClip(param1:DisplayObject) : void
      {
         if(param1 is MovieClip)
         {
            MovieClip(param1).stop();
         }
      }
      
      public static function children(param1:DisplayObjectContainer, param2:Boolean = false) : Array
      {
         var _loc6_:DisplayObject = null;
         var _loc7_:Array = null;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         var _loc5_:int = param1.numChildren;
         while(_loc4_ < _loc5_)
         {
            if(_loc6_ = param1.getChildAt(_loc4_))
            {
               if(param2 && _loc6_ is DisplayObjectContainer)
               {
                  _loc7_ = children(_loc6_ as DisplayObjectContainer,true);
                  ArrayUtil.append(_loc3_,_loc7_);
               }
               _loc3_.push(_loc6_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
