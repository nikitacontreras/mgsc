package com.qb9.gaturro.view.world.avatars
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public class AvatarDresser
   {
       
      
      private const COLOR1:Number = 16770003;
      
      private const COLOR2:Number = 16770003;
      
      private var parts:Array;
      
      private const old_COLOR1:String = "0xF9FF00";
      
      private const old_COLOR2:String = "0xD5B800";
      
      private var holder:Holder;
      
      public function AvatarDresser()
      {
         this.parts = ["hats","hairs","mouths","neck","accesories","cloth","leg","foot","arm","armFore","armBack","glove","gloveFore","gloveBack","grip","gripFore","gripBack","transport","customization"];
         super();
      }
      
      private function clean(param1:Holder) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.parts)
         {
            param1.attributes[_loc2_] = " ";
         }
         api.userAvatar.attributes.merge(param1.attributes);
      }
      
      private function onIndividualClothFetched(param1:DisplayObject, param2:MovieClip) : void
      {
         param2.addChild(param1);
      }
      
      public function dispose() : void
      {
         this.holder = null;
      }
      
      private function setColor(param1:Array, param2:Object) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:ColorTransform = new ColorTransform();
         if(param2 is Number)
         {
            _loc3_.color = uint(param2);
         }
         for each(_loc4_ in param1)
         {
            _loc4_.transform.colorTransform = _loc3_;
         }
      }
      
      public function dressUser(param1:Object) : void
      {
         var _loc3_:Object = null;
         this.holder = new Holder(api.userAvatar);
         this.clean(this.holder);
         var _loc2_:int = 0;
         while(_loc2_ < this.parts.length)
         {
            _loc3_ = this.getCloth(this.parts[_loc2_],param1.parts);
            if(_loc3_)
            {
               logger.debug(this,"accepted",_loc3_.part,_loc3_.pack + "." + _loc3_.name);
               this.holder.attributes[_loc3_.part] = _loc3_.pack + "." + _loc3_.name;
            }
            else
            {
               this.holder.attributes[this.parts[_loc2_]] = " ";
            }
            _loc2_++;
         }
         if(param1.hasOwnProperty("colors"))
         {
            if(this.holder.attributes["color1"] != null)
            {
               this.holder.attributes["color1"] = param1.colors.color1;
            }
            if(this.holder.attributes["color2"] != null)
            {
               this.holder.attributes["color2"] = param1.colors.color2;
            }
         }
         else
         {
            if(this.holder.attributes["color1"])
            {
               this.holder.attributes["color1"] = this.COLOR1;
            }
            if(this.holder.attributes["color2"])
            {
               this.holder.attributes["color2"] = this.COLOR2;
            }
         }
         api.userAvatar.attributes.merge(this.holder.attributes);
      }
      
      private function fix(param1:String) : String
      {
         var _loc2_:String = param1;
         if(_loc2_ == "armFore" || _loc2_ == "armBack")
         {
            return "arm";
         }
         if(_loc2_ == "gloveFore" || _loc2_ == "gloveBack")
         {
            return "glove";
         }
         if(_loc2_ == "gripFore" || _loc2_ == "gripBack")
         {
            return "grip";
         }
         return _loc2_;
      }
      
      private function gatherOcuppiedPlaceholders(param1:MovieClip) : Array
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Array = [];
         for each(_loc3_ in DisplayUtil.children(param1,true))
         {
            if(_loc3_.name && _loc3_ is MovieClip && this.parts.indexOf(_loc3_.name) != -1 && MovieClip(_loc3_).numChildren != 0)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function getCloth(param1:String, param2:Object) : Object
      {
         var _loc3_:Object = null;
         for each(_loc3_ in param2)
         {
            if(Boolean(_loc3_) && _loc3_.part == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function userIsWearing(param1:String) : Boolean
      {
         this.holder = new Holder(api.userAvatar);
         var _loc3_:int = 0;
         while(_loc3_ < this.parts.length)
         {
            if(this.holder.attributes[this.parts[_loc3_]])
            {
               if((this.holder.attributes[this.parts[_loc3_]] as String).indexOf(param1) != -1)
               {
                  return true;
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      private function setColors(param1:MovieClip, param2:Object) : void
      {
         var _loc3_:Array = DisplayUtil.getAllByName(param1,"color1");
         var _loc4_:Array = DisplayUtil.getAllByName(param1,"color2");
         this.setColor(_loc3_,param2.color1);
         this.setColor(_loc4_,param2.color2);
      }
      
      public function changeClothUser(param1:Object) : void
      {
         this.holder = new Holder(api.userAvatar);
         if(param1)
         {
            logger.debug(this,"accepted",param1.part,param1.pack + "." + param1.name);
            this.holder.attributes[param1.part] = param1.pack + "." + param1.name;
         }
         else
         {
            this.holder.attributes[param1.part] = " ";
         }
         api.userAvatar.attributes.merge(this.holder.attributes);
      }
      
      public function removeCloth(param1:String) : void
      {
         this.holder = new Holder(api.userAvatar);
         if(this.holder.attributes[param1])
         {
            logger.debug(this,param1,this.holder.attributes[param1]);
            this.holder.attributes[param1] = " ";
         }
         api.userAvatar.attributes.merge(this.holder.attributes,true);
      }
      
      public function dress(param1:MovieClip, param2:Object) : void
      {
         var _loc4_:Object = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Object = null;
         var _loc3_:Array = this.gatherPlaceholders(param1);
         if(param2.hasOwnProperty("colors"))
         {
            _loc4_ = param2.colors;
         }
         else
         {
            _loc4_ = {
               "color1":this.COLOR1,
               "color2":this.COLOR2
            };
         }
         this.setColors(param1,_loc4_);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc7_ = this.getCloth(this.fix(_loc6_.name),param2.parts))
            {
               api.libraries.fetch(_loc7_.pack + "." + _loc7_.name,this.onIndividualClothFetched,_loc6_);
            }
            _loc5_++;
         }
      }
      
      private function unsetColors(param1:MovieClip) : void
      {
         var _loc2_:Array = DisplayUtil.getAllByName(param1,"color1");
         var _loc3_:Array = DisplayUtil.getAllByName(param1,"color2");
         this.setColor(_loc2_,this.COLOR1);
         this.setColor(_loc3_,this.COLOR2);
      }
      
      private function gatherPlaceholders(param1:MovieClip) : Array
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Array = [];
         for each(_loc3_ in DisplayUtil.children(param1,true))
         {
            if(_loc3_.name && _loc3_ is MovieClip && MovieClip(_loc3_).numChildren === 0)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function undress(param1:MovieClip) : void
      {
         this.unsetColors(param1);
         var _loc2_:Array = this.gatherOcuppiedPlaceholders(param1);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            DisplayUtil.empty(_loc2_[_loc3_] as MovieClip);
            _loc3_++;
         }
      }
   }
}

import com.qb9.mambo.core.objects.BaseCustomAttributeDispatcher;
import com.qb9.mambo.world.avatars.UserAvatar;

class Holder extends BaseCustomAttributeDispatcher
{
    
   
   public function Holder(param1:UserAvatar)
   {
      super();
      _attributes = param1.attributes.clone(this);
   }
}
