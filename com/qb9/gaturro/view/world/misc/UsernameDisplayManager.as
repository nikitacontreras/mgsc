package com.qb9.gaturro.view.world.misc
{
   import assets.AvatarTooltipMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.world.elements.behaviors.NamedView;
   import com.qb9.mambo.world.avatars.Avatar;
   import config.AdminControl;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public final class UsernameDisplayManager extends AvatarTooltipMC implements IDisposable
   {
       
      
      private var lastParent:DisplayObjectContainer;
      
      private var last:DisplayObject;
      
      public function UsernameDisplayManager()
      {
         super();
         this.init();
      }
      
      private function unsetLast() : void
      {
         this.unsetCharacter(this.last as NamedView);
      }
      
      public function unsetCharacter(param1:NamedView) : void
      {
         if(param1 !== this.last)
         {
            return;
         }
         removeEventListener(Event.ENTER_FRAME,this.position);
         visible = false;
         this.last = null;
      }
      
      private function position(param1:Event = null) : void
      {
         if(this.last.parent !== this.lastParent)
         {
            return this.unsetLast();
         }
         x = DisplayUtil.offsetX(this.last,parent);
         y = DisplayUtil.offsetY(this.last,parent) - NamedView(this.last).displayHeight;
      }
      
      private function apply(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:Avatar = null;
         var _loc5_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < api.avatars.length)
         {
            _loc3_ = (api.avatars[_loc2_] as Avatar).username;
            if(_loc3_ == param1)
            {
               _loc4_ = api.avatars[_loc2_] as Avatar;
               _loc5_ = this.getChildAt(1) as MovieClip;
               if(_loc4_.isCitizen)
               {
                  if(_loc4_.attributes.thehand == "true")
                  {
                     if(AdminControl.isAdminUser(_loc3_))
                     {
                        _loc5_.gotoAndStop("admin");
                     }
                     else
                     {
                        _loc5_.gotoAndStop("alien");
                     }
                  }
                  else if(_loc4_.attributes.passportType == "boca")
                  {
                     _loc5_.gotoAndStop("boca");
                  }
                  else if(_loc4_.attributes.passportType == "river")
                  {
                     _loc5_.gotoAndStop("river");
                  }
                  else
                  {
                     _loc5_.gotoAndStop("pasaporte");
                  }
               }
               else
               {
                  _loc5_.gotoAndStop("free");
               }
            }
            _loc2_++;
         }
         this.lastParent = this.last.parent;
         container.text.text = param1.toUpperCase();
         this.position();
         visible = true;
         addEventListener(Event.ENTER_FRAME,this.position);
      }
      
      private function init() : void
      {
         mouseChildren = false;
         mouseEnabled = false;
         visible = false;
      }
      
      public function setCharacter(param1:NamedView) : void
      {
         if(param1 === this.last)
         {
            return;
         }
         if(this.last)
         {
            this.unsetLast();
         }
         var _loc2_:String = param1.displayName;
         if(_loc2_)
         {
            this.last = param1 as DisplayObject;
            this.apply(_loc2_);
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.position);
         this.last = null;
         this.lastParent = null;
      }
   }
}
