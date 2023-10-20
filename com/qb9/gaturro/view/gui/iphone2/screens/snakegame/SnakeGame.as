package com.qb9.gaturro.view.gui.iphone2.screens.snakegame
{
   import com.qb9.gaturro.globals.audio;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   
   public class SnakeGame extends Sprite
   {
       
      
      private var min_elements:int;
      
      private var timer:Timer;
      
      private var _paused:Boolean;
      
      private var coin:com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeCoin;
      
      private var score:Number;
      
      private var markers_array:Array;
      
      private var _bounds:Rectangle;
      
      private var apple:com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeElement;
      
      private var snake_array:Array;
      
      private var dead:Boolean;
      
      private var flag:Boolean;
      
      private var last_button_down:uint;
      
      private var _gameSpeed:uint = 200;
      
      private var space_value:Number;
      
      public function SnakeGame(param1:Rectangle)
      {
         super();
         this._bounds = param1;
         this._paused = false;
         if(!stage)
         {
            this.addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
         else
         {
            this.init();
         }
      }
      
      private function GAME_OVER() : void
      {
         this.dead = true;
         audio.addLazyPlay("snake_lose");
         this.timer.stop();
         while(this.numChildren)
         {
            this.removeChildAt(0);
         }
         this.timer.removeEventListener(TimerEvent.TIMER,this.moveIt);
         if(stage != null)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.directionChanged);
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function init(param1:Event = null) : void
      {
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
         this.snake_array = new Array();
         this.markers_array = new Array();
         this.x = this._bounds.x;
         this.y = this._bounds.y;
         this.space_value = 2;
         this.timer = new Timer(this._gameSpeed);
         this.dead = false;
         this.min_elements = 1;
         this.apple = new com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeElement(16711680,1,10,10);
         this.apple.catchValue = 0;
         this.last_button_down = Keyboard.RIGHT;
         this.score = 0;
         dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT,false,false,String(this.score)));
         var _loc2_:int = 0;
         while(_loc2_ < this.min_elements)
         {
            this.snake_array[_loc2_] = new com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeElement(43775,1,10,10);
            this.snake_array[_loc2_].direction = "R";
            if(_loc2_ == 0)
            {
               this.attachElement(this.snake_array[_loc2_],0,0,this.snake_array[_loc2_].direction);
               this.snake_array[0].alpha = 0.7;
            }
            else
            {
               this.attachElement(this.snake_array[_loc2_],this.snake_array[_loc2_ - 1].x,this.snake_array[_loc2_ - 1].y,this.snake_array[_loc2_ - 1].direction);
            }
            _loc2_++;
         }
         this.placeApple(false);
         this.coin = new com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeCoin(this.snake_array[0],this._bounds);
         addChild(this.coin);
         this.timer.addEventListener(TimerEvent.TIMER,this.moveIt);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.directionChanged);
         this.timer.start();
         this.snake_array[0].x = 0;
         this.coin.reposition();
         audio.register("snake_mueve").start();
         audio.register("snake_nivel").start();
         audio.register("snake_moneda").start();
      }
      
      private function moveIt(param1:TimerEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         if(this._paused)
         {
            return;
         }
         if(this.snake_array[0].x > this._bounds.width - this.snake_array[0].width || this.snake_array[0].x < 0 || this.snake_array[0].y > this._bounds.height - this.snake_array[0].height || this.snake_array[0].y < 0)
         {
            this.GAME_OVER();
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.snake_array.length)
         {
            if(this.markers_array.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < this.markers_array.length)
               {
                  if(this.snake_array[_loc2_].x == this.markers_array[_loc4_].x && this.snake_array[_loc2_].y == this.markers_array[_loc4_].y)
                  {
                     this.snake_array[_loc2_].direction = this.markers_array[_loc4_].type;
                     if(_loc2_ == this.snake_array.length - 1)
                     {
                        this.markers_array.splice(_loc4_,1);
                     }
                  }
                  _loc4_++;
               }
            }
            if(this.snake_array[_loc2_] != this.snake_array[0] && (this.snake_array[0].x == this.snake_array[_loc2_].x && this.snake_array[0].y == this.snake_array[_loc2_].y))
            {
               this.GAME_OVER();
               return;
            }
            if(this.snake_array[_loc2_] == null)
            {
               this.GAME_OVER();
               return;
            }
            _loc3_ = String(this.snake_array[_loc2_].direction);
            switch(_loc3_)
            {
               case "R":
                  this.snake_array[_loc2_].x += this.snake_array[_loc2_].width + this.space_value;
                  break;
               case "L":
                  this.snake_array[_loc2_].x -= this.snake_array[_loc2_].width + this.space_value;
                  break;
               case "D":
                  this.snake_array[_loc2_].y += this.snake_array[_loc2_].height + this.space_value;
                  break;
               case "U":
                  this.snake_array[_loc2_].y -= this.snake_array[_loc2_].width + this.space_value;
                  break;
            }
            _loc2_++;
         }
         if(this.snake_array[0].x == this.apple.x && this.snake_array[0].y == this.apple.y)
         {
            if(audio.isRunning("snake_nivel"))
            {
               audio.stop("snake_nivel");
            }
            audio.play("snake_nivel");
            this.placeApple();
            this.score += this.apple.catchValue;
            dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT,false,false,String(this.score)));
            this.snake_array.push(new com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeElement(43775,1,10,10));
            this.snake_array[this.snake_array.length - 1].direction = this.snake_array[this.snake_array.length - 2].direction;
            this.attachElement(this.snake_array[this.snake_array.length - 1],this.snake_array[this.snake_array.length - 2].x,this.snake_array[this.snake_array.length - 2].y,this.snake_array[this.snake_array.length - 2].direction);
         }
         if(this.coin.active && this.snake_array[0].x == this.coin.xPos && this.snake_array[0].y == this.coin.yPos)
         {
            this.coin.active = false;
            audio.play("snake_moneda");
            this.coin.acquired();
            dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT,false,false,String(this.score)));
         }
         this.flag = true;
      }
      
      private function dispose(param1:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
         this.timer.removeEventListener(TimerEvent.TIMER,this.moveIt);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.directionChanged);
         if(this.hasEventListener(Event.ADDED_TO_STAGE))
         {
            this.removeEventListener(Event.ADDED_TO_STAGE,this.init);
         }
         this.coin.dispose();
      }
      
      public function set paused(param1:Boolean) : void
      {
         this._paused = param1;
      }
      
      public function get paused() : Boolean
      {
         return this._paused;
      }
      
      private function placeApple(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.apple.catchValue += 10;
         }
         var _loc2_:int = Math.floor(this._bounds.width / (this.snake_array[0].width + this.space_value)) - 1;
         var _loc3_:Number = Math.floor(Math.random() * _loc2_);
         var _loc4_:int = Math.floor(this._bounds.height / (this.snake_array[0].height + this.space_value)) - 1;
         var _loc5_:Number = Math.floor(Math.random() * _loc4_);
         this.apple.x = _loc3_ * (this.apple.width + this.space_value);
         this.apple.y = _loc5_ * (this.apple.height + this.space_value);
         var _loc6_:uint = 0;
         while(_loc6_ < this.snake_array.length - 1)
         {
            if(this.snake_array[_loc6_].x == this.apple.x && this.snake_array[_loc6_].y == this.apple.y)
            {
               this.placeApple(false);
            }
            _loc6_++;
         }
         if(!this.apple.stage)
         {
            this.addChild(this.apple);
         }
      }
      
      private function attachElement(param1:com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeElement, param2:Number = 0, param3:Number = 0, param4:String = "R") : void
      {
         if(param4 == "R")
         {
            param1.x = param2 - this.snake_array[0].width - this.space_value;
            param1.y = param3;
         }
         else if(param4 == "L")
         {
            param1.x = param2 + this.snake_array[0].width + this.space_value;
            param1.y = param3;
         }
         else if(param4 == "U")
         {
            param1.x = param2;
            param1.y = param3 + this.snake_array[0].height + this.space_value;
         }
         else if(param4 == "D")
         {
            param1.x = param2;
            param1.y = param3 - this.snake_array[0].height - this.space_value;
         }
         this.addChild(param1);
      }
      
      private function directionChanged(param1:KeyboardEvent) : void
      {
         var _loc2_:Object = new Object();
         if(param1.keyCode == Keyboard.LEFT && this.last_button_down != param1.keyCode && this.last_button_down != Keyboard.RIGHT && this.flag)
         {
            this.snake_array[0].direction = "L";
            _loc2_ = {
               "x":this.snake_array[0].x,
               "y":this.snake_array[0].y,
               "type":"L"
            };
            this.last_button_down = Keyboard.LEFT;
            this.flag = false;
         }
         else if(param1.keyCode == Keyboard.RIGHT && this.last_button_down != param1.keyCode && this.last_button_down != Keyboard.LEFT && this.flag)
         {
            this.snake_array[0].direction = "R";
            _loc2_ = {
               "x":this.snake_array[0].x,
               "y":this.snake_array[0].y,
               "type":"R"
            };
            this.last_button_down = Keyboard.RIGHT;
            this.flag = false;
         }
         else if(param1.keyCode == Keyboard.UP && this.last_button_down != param1.keyCode && this.last_button_down != Keyboard.DOWN && this.flag)
         {
            this.snake_array[0].direction = "U";
            _loc2_ = {
               "x":this.snake_array[0].x,
               "y":this.snake_array[0].y,
               "type":"U"
            };
            this.last_button_down = Keyboard.UP;
            this.flag = false;
         }
         else if(param1.keyCode == Keyboard.DOWN && this.last_button_down != param1.keyCode && this.last_button_down != Keyboard.UP && this.flag)
         {
            this.snake_array[0].direction = "D";
            _loc2_ = {
               "x":this.snake_array[0].x,
               "y":this.snake_array[0].y,
               "type":"D"
            };
            this.last_button_down = Keyboard.DOWN;
            this.flag = false;
         }
         this.markers_array.push(_loc2_);
      }
   }
}
