package com.qb9.gaturro.view.components.banner.carreraCohete
{
   import com.qb9.gaturro.globals.api;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CarreraCoheteView
   {
      
      private static const SHIP_SPEED:Number = 0.06;
      
      private static const MAX_AVATAR_X:Number = 336;
       
      
      private var _container:MovieClip;
      
      public var _isanimationRoundFinished:Boolean = false;
      
      private var _core:com.qb9.gaturro.view.components.banner.carreraCohete.CarreraCohete;
      
      private var _meteoritoDestroyCounter:int;
      
      private var _speedUpP1:Number;
      
      private var _speedUpP2:Number;
      
      private var _step1AnimationSpellSmashing:Boolean;
      
      private var _avatar1Hitted:Boolean;
      
      private var _avatar2:MovieClip;
      
      private var _winnerAvatar2:Boolean;
      
      private var _avatar1:MovieClip;
      
      private var _winnerAvatar1:Boolean;
      
      private var _meteoritoSuccessCounter:int;
      
      private var _guiShip1:MovieClip;
      
      private var _guiShip2:MovieClip;
      
      private var _stepNormalAnimation_0:Boolean;
      
      private var _stepNormalAnimation_1:Boolean;
      
      private var _stepNormalAnimation_2:Boolean;
      
      private var _step0AnimationSpellSmashing:Boolean;
      
      private var _step2AnimationSpellSmashing:Boolean;
      
      private var _avatar2Hitted:Boolean;
      
      private var _meteoritoGameOver:Boolean;
      
      public function CarreraCoheteView(param1:MovieClip, param2:com.qb9.gaturro.view.components.banner.carreraCohete.CarreraCohete)
      {
         super();
         this._container = param1;
         this._core = param2;
      }
      
      private function resetPosAndListen() : void
      {
         this.resetMeteoro(this._container.bannerMC.meteoro0);
         this.resetMeteoro(this._container.bannerMC.meteoro1);
         this.resetMeteoro(this._container.bannerMC.meteoro2);
         this.resetMeteoro(this._container.bannerMC.meteoro3);
         this._container.bannerMC.removeEventListener(MouseEvent.CLICK,this.shoot);
         this._container.removeEventListener(Event.ENTER_FRAME,this.updateMeteorito);
      }
      
      public function get guiShip1() : MovieClip
      {
         return this._guiShip1;
      }
      
      private function resolveHit() : void
      {
      }
      
      private function resetMeteoro(param1:MovieClip) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.destroyMeteorito);
         param1.x = 785;
         param1.gotoAndStop("normal");
      }
      
      public function init() : void
      {
         this._container.bannerMC.meteoroscomming.visible = false;
         this._container.bannerMC.winner.visible = false;
         this._container.bannerMC.winner.visible = false;
         this._container.bannerMC.fxAvatar2.visible = false;
         this._container.bannerMC.fxAvatar1.visible = false;
         this._container.bannerMC.hitFX.visible = false;
         this._guiShip1 = this._container.bannerMC.playerOneStart;
         this._guiShip2 = this._container.bannerMC.playerTwoStart;
         this._avatar1 = this._container.bannerMC.avatar1;
         this._avatar2 = this._container.bannerMC.avatar2;
         this._avatar1Hitted = false;
         this._avatar2Hitted = false;
         this._stepNormalAnimation_0 = false;
         this._stepNormalAnimation_1 = false;
         this._stepNormalAnimation_2 = false;
      }
      
      private function animationFinished() : void
      {
         this.resetSteps();
         this.disableSpells();
         this._container.removeEventListener(Event.ENTER_FRAME,this.update);
         this._isanimationRoundFinished = true;
         this._avatar1Hitted = false;
         this._avatar2Hitted = false;
         this._container.bannerMC.hitFX.visible = false;
         this._core.updateAndShootAgain();
      }
      
      private function resetSteps() : void
      {
         this._step0AnimationSpellSmashing = false;
         this._step1AnimationSpellSmashing = false;
         this._step2AnimationSpellSmashing = false;
         this._stepNormalAnimation_0 = false;
         this._stepNormalAnimation_1 = false;
         this._stepNormalAnimation_2 = false;
      }
      
      private function hitTestColission(param1:MovieClip) : void
      {
         if(param1.x < this._avatar1.x && param1.currentLabel != "destroy")
         {
            param1.gotoAndStop("destroy");
            api.playSound("explota");
            param1.mc.gotoAndPlay(0);
            this._container.bannerMC.hitFX.visible = true;
            this._container.bannerMC.hitFX.gotoAndPlay(0);
            ++this._meteoritoDestroyCounter;
         }
      }
      
      public function get winnerAvatar1() : Boolean
      {
         return this._winnerAvatar1;
      }
      
      public function get guiShip2() : MovieClip
      {
         return this._guiShip2;
      }
      
      private function destroyMeteorito(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(MouseEvent.CLICK,this.destroyMeteorito);
         param1.target.gotoAndStop("destroy");
         api.playSound("explota");
         param1.target.mc.gotoAndPlay(0);
         ++this._meteoritoDestroyCounter;
         ++this._meteoritoSuccessCounter;
      }
      
      public function startAnimate() : void
      {
         this._container.addEventListener(Event.ENTER_FRAME,this.update);
         this._isanimationRoundFinished = false;
      }
      
      public function dispose() : void
      {
         this._container.removeEventListener(Event.ENTER_FRAME,this.update);
         this._container.removeEventListener(Event.ENTER_FRAME,this.updateMeteorito);
         this._container.bannerMC.playerOneStart.removeEventListener(Event.ENTER_FRAME,this.shipProgressUpdate);
      }
      
      private function showSpells() : void
      {
      }
      
      public function meteorosComming() : void
      {
         this._container.bannerMC.meteoroscomming.visible = true;
         this._container.bannerMC.meteoroscomming.sign1.gotoAndPlay(0);
         this._container.bannerMC.meteoroscomming.sign2.gotoAndPlay(0);
         this._container.bannerMC.meteoroscomming.sign3.gotoAndPlay(0);
         this._container.bannerMC.meteoro0.visible = true;
         this._container.bannerMC.meteoro1.visible = true;
         this._container.bannerMC.meteoro2.visible = true;
         this._container.bannerMC.meteoro3.visible = true;
         this._container.bannerMC.shootMode.visible = true;
         this._container.addEventListener(Event.ENTER_FRAME,this.updateMeteorito);
         this._container.bannerMC.meteoro0.addEventListener(MouseEvent.CLICK,this.destroyMeteorito);
         this._container.bannerMC.meteoro0.mouseChildren = false;
         this._container.bannerMC.meteoro1.mouseChildren = false;
         this._container.bannerMC.meteoro2.mouseChildren = false;
         this._container.bannerMC.meteoro3.mouseChildren = false;
         this._container.bannerMC.hitFX.mouseChildren = false;
         this._container.bannerMC.meteoro1.addEventListener(MouseEvent.CLICK,this.destroyMeteorito);
         this._container.bannerMC.meteoro2.addEventListener(MouseEvent.CLICK,this.destroyMeteorito);
         this._container.bannerMC.meteoro3.addEventListener(MouseEvent.CLICK,this.destroyMeteorito);
         this._container.bannerMC.addEventListener(MouseEvent.CLICK,this.shoot);
         this._meteoritoGameOver = false;
         this._meteoritoDestroyCounter = 0;
         this._meteoritoSuccessCounter = 0;
         this._container.bannerMC.shootMode.visible = true;
      }
      
      private function shoot(param1:MouseEvent) : void
      {
         this._container.bannerMC.shootMode.gotoAndPlay(0);
      }
      
      private function updateMeteorito(param1:Event) : void
      {
         if(!this._meteoritoGameOver)
         {
            if(this._container.bannerMC.meteoro0.currentLabel == "normal")
            {
               this._container.bannerMC.meteoro0.x -= 4;
            }
            if(this._container.bannerMC.meteoro1.currentLabel == "normal")
            {
               this._container.bannerMC.meteoro1.x -= 7;
            }
            if(this._container.bannerMC.meteoro2.currentLabel == "normal")
            {
               this._container.bannerMC.meteoro2.x -= 5;
            }
            if(this._container.bannerMC.meteoro3.currentLabel == "normal")
            {
               this._container.bannerMC.meteoro3.x -= 6;
            }
            this._container.bannerMC.shootMode.x = this._container.stage.mouseX - 75;
            this._container.bannerMC.shootMode.y = this._container.stage.mouseY - 60;
            this.hitTestColission(this._container.bannerMC.meteoro0);
            this.hitTestColission(this._container.bannerMC.meteoro1);
            this.hitTestColission(this._container.bannerMC.meteoro2);
            this.hitTestColission(this._container.bannerMC.meteoro3);
            if(this._meteoritoDestroyCounter >= 4)
            {
               if((this._container.bannerMC.meteoro0.mc as MovieClip).currentFrame == (this._container.bannerMC.meteoro0.mc as MovieClip).totalFrames && (this._container.bannerMC.meteoro1.mc as MovieClip).currentFrame == (this._container.bannerMC.meteoro1.mc as MovieClip).totalFrames && (this._container.bannerMC.meteoro2.mc as MovieClip).currentFrame == (this._container.bannerMC.meteoro2.mc as MovieClip).totalFrames && (this._container.bannerMC.meteoro3.mc as MovieClip).currentFrame == (this._container.bannerMC.meteoro3.mc as MovieClip).totalFrames)
               {
                  this.endMeteorito();
               }
            }
         }
      }
      
      private function shipProgressUpdate(param1:Event) : void
      {
         this._container.bannerMC.playerOneStart.x += SHIP_SPEED;
         this._container.bannerMC.playerTwoStart.x += SHIP_SPEED;
         if(this._speedUpP1 > 0)
         {
            this._container.bannerMC.playerOneStart.x += 2;
            this._speedUpP1 -= 2;
         }
         else
         {
            this._speedUpP1 = 0;
         }
         if(this._speedUpP2 > 0)
         {
            this._container.bannerMC.playerTwoStart.x += 2;
            this._speedUpP2 -= 2;
         }
         else
         {
            this._speedUpP2 = 0;
         }
         this.distanceEffect4Progress();
         this.FXfollowTheAvatar();
         if(this._container.bannerMC.playerOneStart.x > 622)
         {
            this._container.bannerMC.playerOneStart.x = 622;
         }
         if(this._container.bannerMC.playerTwoStart.x > 622)
         {
            this._container.bannerMC.playerTwoStart.x = 622;
         }
         this.checkWinner();
      }
      
      public function setupShips() : void
      {
         this._container.bannerMC.playerOneStart.addEventListener(Event.ENTER_FRAME,this.shipProgressUpdate);
      }
      
      public function set speedUpP1(param1:Number) : void
      {
         this._speedUpP1 = param1;
      }
      
      private function update(param1:Event) : void
      {
         if(this._core.timeToAnimate)
         {
            if(!this._stepNormalAnimation_1)
            {
               this._stepNormalAnimation_1 = true;
            }
            else
            {
               this._core.timeToAnimate = false;
            }
         }
         else
         {
            this.animationFinished();
         }
      }
      
      private function disableSpells() : void
      {
      }
      
      private function resolveExplode() : void
      {
      }
      
      public function set speedUpP2(param1:Number) : void
      {
         this._speedUpP2 = param1;
      }
      
      private function showCorrectSpells() : void
      {
      }
      
      private function distanceEffect4Progress() : void
      {
         if(this._container.bannerMC.playerOneStart.x < this._container.bannerMC.playerTwoStart.x)
         {
            (this._container.bannerMC.avatar1 as MovieClip).x = this._guiShip1.x / this._guiShip2.x * 336;
            (this._container.bannerMC.user_name_gui_1 as MovieClip).x = this._guiShip1.x / this._guiShip2.x * 336;
         }
         else if(this._container.bannerMC.playerTwoStart.x < this._container.bannerMC.playerOneStart.x)
         {
            (this._container.bannerMC.avatar2 as MovieClip).x = this._guiShip2.x / this._guiShip1.x * 336;
            (this._container.bannerMC.user_name_gui_2 as MovieClip).x = this._guiShip2.x / this._guiShip1.x * 336;
         }
      }
      
      public function get winnerAvatar2() : Boolean
      {
         return this._winnerAvatar2;
      }
      
      public function endMeteorito() : void
      {
         this._meteoritoGameOver = true;
         this._container.bannerMC.shootMode.visible = false;
         if(!this._core.gameOver)
         {
            this._core.resultOfMeteorito(this._meteoritoSuccessCounter);
         }
         this.resetPosAndListen();
         this._container.bannerMC.meteoroscomming.visible = false;
      }
      
      public function test1() : void
      {
         this._container.bannerMC.playerOneStart.removeEventListener(Event.ENTER_FRAME,this.shipProgressUpdate);
      }
      
      public function scaleEffect4Progress() : void
      {
         var _loc1_:Number = NaN;
         if(this._container.bannerMC.playerOneStart.x < this._container.bannerMC.playerTwoStart.x)
         {
            _loc1_ = this._guiShip1.x / this._guiShip2.x;
            if(_loc1_ < 0.4)
            {
               _loc1_ = 0.4;
            }
            else
            {
               _loc1_ = _loc1_;
            }
            (this._container.bannerMC.avatar1 as MovieClip).scaleX = this._guiShip1.x / this._guiShip2.x;
            (this._container.bannerMC.avatar1 as MovieClip).scaleY = this._guiShip1.x / this._guiShip2.x;
         }
         else if(this._container.bannerMC.playerTwoStart.x < this._container.bannerMC.playerOneStart.x)
         {
            _loc1_ = this._guiShip2.x / this._guiShip1.x;
            if(_loc1_ < 0.4)
            {
               _loc1_ = 0.4;
            }
            else
            {
               _loc1_ = _loc1_;
            }
            (this._container.bannerMC.avatar2 as MovieClip).scaleX = this._guiShip2.x / this._guiShip1.x;
            (this._container.bannerMC.avatar2 as MovieClip).scaleY = this._guiShip2.x / this._guiShip1.x;
         }
      }
      
      private function FXfollowTheAvatar() : void
      {
         if(Boolean(this._container) && Boolean(this._container.bannerMC))
         {
            this._container.bannerMC.fxAvatar1.x = (this._container.bannerMC.avatar1 as MovieClip).x;
            this._container.bannerMC.fxAvatar2.x = (this._container.bannerMC.avatar2 as MovieClip).x;
         }
      }
      
      private function checkWinner() : void
      {
         trace("nave1:" + this.guiShip1.x);
         trace("nave2:" + this.guiShip2.x);
         if(!this._winnerAvatar1 && !this._winnerAvatar2)
         {
            if(this.guiShip1.x > this._container.bannerMC.goalFlag.x)
            {
               this._winnerAvatar1 = true;
            }
            if(this.guiShip2.x > this._container.bannerMC.goalFlag.x)
            {
               this._winnerAvatar2 = true;
            }
         }
      }
   }
}
