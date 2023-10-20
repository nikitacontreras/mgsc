package com.qb9.gaturro.view.display
{
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class HiScoreDisplay extends MovieClip
   {
       
      
      private var hiscores:Array;
      
      private var gso:GaturroSceneObjectAPI;
      
      private var refresh:Boolean;
      
      private var queuedScore:String = "";
      
      public function HiScoreDisplay()
      {
         this.hiscores = [];
         super();
         this.refresh = true;
         this.counter = 1;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this.hiscores[_loc1_] = [".","0"];
            _loc1_++;
         }
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function acquireObjectAPI(param1:GaturroSceneObjectAPI) : void
      {
         this.gso = param1;
      }
      
      private function sortScore(param1:Array, param2:Array) : int
      {
         if(parseInt(param1[1]) > parseInt(param2[1]))
         {
            return -1;
         }
         if(parseInt(param1[1]) < parseInt(param2[1]))
         {
            return 1;
         }
         return 0;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         if(this.gso)
         {
            if(!this.parent)
            {
               this.gso = null;
            }
            else
            {
               --this.counter;
               if(this.counter === 0 && this.refresh)
               {
                  _loc3_ = 0;
                  while(_loc3_ < 10)
                  {
                     _loc4_ = (this.gso.getAttribute("slot" + _loc3_) || ".:0").toString().split(":");
                     this["pos" + (_loc3_ + 1)].username.text = _loc4_[0];
                     this["pos" + (_loc3_ + 1)].userscore.text = _loc4_[1];
                     this.hiscores[_loc3_] = _loc4_;
                     _loc3_++;
                  }
                  this.refresh = false;
               }
               _loc2_ = this.gso.getAttribute("slotTemp");
               if(Boolean(_loc2_) && _loc2_ !== "")
               {
                  _loc5_ = _loc2_.toString().split(":");
                  this.hiscores[10] = _loc5_;
                  this.hiscores.sort(this.sortScore);
                  if(this.hiscores[10] !== _loc5_)
                  {
                     _loc6_ = 0;
                     while(_loc6_ < 10)
                     {
                        this.gso.setAttribute("slot" + _loc6_,this.hiscores[_loc6_][0] + ":" + this.hiscores[_loc6_][1]);
                        _loc6_++;
                     }
                     this.refresh = true;
                     this.counter = 1;
                  }
                  this.gso.setAttribute("slotTemp","");
               }
               else if(this.queuedScore !== "")
               {
                  this.gso.setAttribute("slotTemp",this.queuedScore);
                  this.queuedScore = "";
               }
            }
         }
      }
      
      public function saveScore(param1:String, param2:int) : void
      {
         trace(param1 + ":" + param2);
         this.queuedScore = param1 + ":" + param2;
      }
   }
}
