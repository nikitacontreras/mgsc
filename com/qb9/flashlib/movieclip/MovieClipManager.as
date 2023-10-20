package com.qb9.flashlib.movieclip
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.ArrayUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MovieClipManager implements IDisposable
   {
       
      
      private var mc:MovieClip;
      
      private var list:Array;
      
      public function MovieClipManager(param1:MovieClip)
      {
         this.list = [];
         super();
         this.mc = param1;
      }
      
      private function start() : void
      {
         this.mc.addEventListener(Event.ENTER_FRAME,this.update);
      }
      
      public function remove(param1:Trigger) : void
      {
         ArrayUtil.removeElement(this.list,param1);
         if(this.list.length == 0)
         {
            this.stop();
         }
      }
      
      public function dispose() : void
      {
         this.stop();
      }
      
      private function update(param1:Event) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.list.slice())
         {
            this.checkTrigger(Trigger(_loc2_));
         }
         if(this.list.length == 0)
         {
            this.stop();
         }
      }
      
      private function checkTrigger(param1:Trigger) : void
      {
         if(param1.condition.fulfilled(this.mc) == true)
         {
            param1.action.run(this.mc);
            ArrayUtil.removeElement(this.list,param1);
         }
      }
      
      private function stop() : void
      {
         this.mc.removeEventListener(Event.ENTER_FRAME,this.update);
      }
      
      public function when(param1:Trigger) : void
      {
         if(this.list.length == 0)
         {
            this.start();
         }
         this.list.push(param1);
      }
   }
}
