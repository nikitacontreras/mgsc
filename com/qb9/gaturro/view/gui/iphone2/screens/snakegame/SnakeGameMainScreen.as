package com.qb9.gaturro.view.gui.iphone2.screens.snakegame
{
   import assets.SnakeGameMainMC;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.Parallel;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.view.gui.iphone2.CellPhoneButton;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.view.gui.iphone2.screens.BaseIPhone2Screen;
   import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2Screens;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class SnakeGameMainScreen extends BaseIPhone2Screen
   {
       
      
      private var playButton:CellPhoneButton;
      
      private var _wellcomeMess:MovieClip;
      
      private var _tasks:TaskContainer;
      
      private var _snakeGame:com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeGame;
      
      private var _bounds:Rectangle;
      
      private var _title:TextField;
      
      private var _boundsMask:Sprite;
      
      private var _scoreField:TextField;
      
      private var screen:SnakeGameMainMC;
      
      public function SnakeGameMainScreen(param1:IPhone2Modal, param2:MovieClip, param3:Object, param4:TaskContainer)
      {
         this._tasks = param4;
         super(param1,param2,{});
      }
      
      private function updateScore(param1:TextEvent) : void
      {
         var e:TextEvent = param1;
         this._scoreField.text = e.text;
         setTimeout(function a():void
         {
            screen.userCoinAmount.text = api.getProfileAttribute("coins").toString();
         },100);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(!this._snakeGame)
         {
            return;
         }
         this._snakeGame.removeEventListener(TextEvent.TEXT_INPUT,this.updateScore);
         this._snakeGame.removeEventListener(Event.COMPLETE,this.restartGame);
         this.playButton.dispose(null);
         this._bounds = null;
         this._snakeGame = null;
         this.removeEventListener(MouseEvent.CLICK,this.startGameTransition);
      }
      
      private function loseScreen(param1:Event) : void
      {
         asset.removeChild(this._snakeGame);
         this.screen.loseText.visible = true;
         var _loc2_:int = this.screen.scoreGroup.y;
         var _loc3_:ITask = new Parallel(new Tween(this.screen.scoreGroup,500,{"y":_loc2_ - 80}),new Tween(this.screen.scoreGroup.score_name,100,{"textColor":16711680}),new Tween(this.screen.scoreGroup.tf_score,100,{"textColor":16711680}),new Tween(this.screen.playButton,100,{"alpha":1}));
         this._tasks.add(_loc3_);
         this.playButton.changeCallback(this.restartGame);
      }
      
      private function startGameTransition(param1:MouseEvent) : void
      {
         audio.addLazyPlay("snake_jugar");
         var _loc2_:ITask = new Sequence(new Tween(this.screen.wellcomeText,500,{"alpha":0}),new Func(this.startGame));
         this._tasks.add(_loc2_);
      }
      
      override protected function whenAdded() : void
      {
         super.whenAdded();
         this.screen = SnakeGameMainMC(asset);
         this._wellcomeMess = this.screen.wellcomeText;
         this._scoreField = this.screen.scoreGroup.tf_score;
         this._scoreField.visible = false;
         this.screen.scoreGroup.visible = false;
         this.screen.loseText.visible = false;
         this.screen.userCoinAmount.textColor = 16776960;
         this.screen.userCoinAmount.text = api.getProfileAttribute("coins").toString();
         this._title = this.screen.title;
         this._title.text = api.getText("SNAKE");
         this.playButton = new CellPhoneButton(this.screen.playButton,this.startGameTransition);
         var _loc1_:MovieClip = this.screen.snake_area;
         this._bounds = new Rectangle(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
         asset.removeChild(_loc1_);
      }
      
      private function restartGame(param1:MouseEvent) : void
      {
         this.screen.removeEventListener(MouseEvent.CLICK,this.restartGame);
         this.screen.loseText.visible = false;
         this._scoreField.visible = false;
         this.screen.scoreGroup.visible = false;
         this.screen.scoreGroup.y += 80;
         this.screen.scoreGroup.score_name.textColor = 16777215;
         this.screen.scoreGroup.tf_score.textColor = 16777215;
         this.startGame();
      }
      
      private function startGame() : void
      {
         this._wellcomeMess.visible = false;
         this.screen.playButton.alpha = 0;
         this._scoreField.visible = true;
         this.screen.scoreGroup.visible = true;
         this._wellcomeMess.alpha = 1;
         this._snakeGame = new com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeGame(this._bounds);
         asset.addChild(this._snakeGame);
         this._boundsMask = new Sprite();
         this._boundsMask.graphics.beginFill(0);
         this._boundsMask.graphics.drawRect(0,0,this._bounds.width,this._bounds.height);
         this._boundsMask.graphics.endFill();
         this._boundsMask.x = this._bounds.x;
         this._boundsMask.y = this._bounds.y;
         this.addChild(this._boundsMask);
         this._snakeGame.mask = this._boundsMask;
         this._snakeGame.addEventListener(TextEvent.TEXT_INPUT,this.updateScore);
         this._snakeGame.addEventListener(Event.COMPLETE,this.loseScreen);
         this._snakeGame.paused = false;
         this._scoreField.text = "0";
      }
      
      override protected function backButton() : void
      {
         back(IPhone2Screens.MENU);
      }
   }
}
