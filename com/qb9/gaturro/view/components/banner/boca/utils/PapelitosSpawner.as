package com.qb9.gaturro.view.components.banner.boca.utils
{
   import assets.papel1;
   import assets.papel2;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PapelitosSpawner
   {
      
      private static const LIMIT_Y:Number = 350;
      
      private static const AMOUNT:Number = 60;
      
      private static const GRAVITY_CONST:Number = 17;
      
      private static const MAX_X:Number = 460;
       
      
      private var _container:MovieClip;
      
      private var _timer:Timer;
      
      private var _dontSpawn:Boolean = false;
      
      private var _cont:Number;
      
      private var _papelitos:Array;
      
      public function PapelitosSpawner(param1:MovieClip)
      {
         super();
         this._container = param1;
         this.buildPool();
      }
      
      public function spawn(param1:Event = null) : void
      {
         if(!this._dontSpawn)
         {
            this._timer.start();
            (this._papelitos[this._cont] as MovieClip).addEventListener(Event.ENTER_FRAME,this.gravity);
            (this._papelitos[this._cont] as MovieClip).gotoAndPlay(0);
            if(this._cont < AMOUNT - 1)
            {
               ++this._cont;
            }
            else
            {
               this._cont = 0;
            }
         }
      }
      
      private function buildPool() : void
      {
         this._papelitos = new Array();
         this._cont = 0;
         var _loc1_:int = 0;
         while(_loc1_ < AMOUNT)
         {
            if(Math.random() > 0.5)
            {
               this._papelitos.push(new papel1());
            }
            else
            {
               this._papelitos.push(new papel2());
            }
            this._container.addChild(this._papelitos[_loc1_]);
            this._papelitos[_loc1_].gotoAndStop(0);
            this._papelitos[_loc1_].x = Math.random() * MAX_X;
            _loc1_++;
         }
      }
      
      private function gravity(param1:Event = null) : void
      {
         if(param1.target)
         {
            param1.target.y += Math.random() * GRAVITY_CONST;
            param1.target.x += Math.random() > 0.5 ? -1 : 1 * 2 * Math.random();
            if(param1.target.y > LIMIT_Y)
            {
               param1.target.y = this._container.y;
            }
            if(param1.target.x > MAX_X)
            {
               param1.target.X = MAX_X;
            }
            if(param1.target.x < 0)
            {
               param1.target.X = 0;
            }
         }
      }
      
      public function restart() : void
      {
         this._cont = 0;
         if(this._timer)
         {
            this._timer.stop();
         }
         var _loc1_:int = 0;
         while(_loc1_ < AMOUNT)
         {
            (this._papelitos[_loc1_] as MovieClip).y = this._container.y;
            this._papelitos[_loc1_].gotoAndStop(0);
            (this._papelitos[_loc1_] as MovieClip).removeEventListener(Event.ENTER_FRAME,this.gravity);
            _loc1_++;
         }
      }
      
      public function dontSpawn() : void
      {
         this._dontSpawn = true;
      }
      
      public function startSpawn() : void
      {
         this._dontSpawn = false;
         this._timer = new Timer(0,10);
         this._timer.reset();
         this._timer.start();
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.spawn);
      }
   }
}
