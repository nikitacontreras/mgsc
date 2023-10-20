package com.qb9.gaturro.view.components.banner.peleaMagia
{
   import com.qb9.gaturro.globals.api;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class PeleaMagiaView
   {
       
      
      private var _container:MovieClip;
      
      public var _isanimationRoundFinished:Boolean = false;
      
      private var _flag2:Boolean;
      
      private var _flag1:Boolean;
      
      private var _stepNormalAnimation_0:Boolean;
      
      private var _stepNormalAnimation_1:Boolean;
      
      private var _stepNormalAnimation_2:Boolean;
      
      private var _step0AnimationSpellSmashing:Boolean;
      
      private var _step1AnimationSpellSmashing:Boolean;
      
      private var _step2AnimationSpellSmashing:Boolean;
      
      private var _avatar1Hitted:Boolean;
      
      private var _avatar2Hitted:Boolean;
      
      private var _core:com.qb9.gaturro.view.components.banner.peleaMagia.PeleaMagiaCore;
      
      public function PeleaMagiaView(param1:MovieClip, param2:com.qb9.gaturro.view.components.banner.peleaMagia.PeleaMagiaCore)
      {
         super();
         this._container = param1;
         this._core = param2;
      }
      
      private function update(param1:Event) : void
      {
         if(this._core.timeToAnimate)
         {
            if(!this._stepNormalAnimation_1 && !this._core.spellSmashing && this._core.normalFight)
            {
               if(!this._stepNormalAnimation_1 && !this._stepNormalAnimation_0 && this._core.getMyAvatarOnScene().currentLabel != "flag")
               {
                  this._core.getMyAvatarOnScene().gotoAndPlay("flag");
                  this._core.getEnemyAvatarOnScene().gotoAndPlay("flag");
                  api.playSound("halloween2017/ataque");
                  this._stepNormalAnimation_0 = true;
               }
               else if(this._stepNormalAnimation_0)
               {
                  if(this._core.getMyAvatarOnScene().currentLabel != "spellfighting" && this._core.getMyAvatarOnScene().currentLabel != "flag")
                  {
                     this.showSpells();
                     this._core.getMyAvatarOnScene().gotoAndPlay("spellfighting");
                     this._core.getEnemyAvatarOnScene().gotoAndPlay("spellfighting");
                     this._step1AnimationSpellSmashing = true;
                     this._stepNormalAnimation_0 = false;
                     this._stepNormalAnimation_1 = true;
                  }
               }
            }
            else if(this._core.spellSmashing && !this._step0AnimationSpellSmashing)
            {
               if(this._core.getMyAvatarOnScene().currentLabel != "flag")
               {
                  this._core.getMyAvatarOnScene().gotoAndPlay("flag");
                  this._core.getEnemyAvatarOnScene().gotoAndPlay("flag");
                  api.playSound("halloween2017/ataque");
                  this._step0AnimationSpellSmashing = true;
               }
            }
            else if(this._core.spellSmashing && this._step0AnimationSpellSmashing)
            {
               this._step1AnimationSpellSmashing = true;
               if(this._core.getMyAvatarOnScene().currentLabel != "spellfighting" && this._core.getMyAvatarOnScene().currentLabel != "flag")
               {
                  this.showSpells();
                  this._container.bannerMC.spellSmash.visible = true;
                  this._core.getMyAvatarOnScene().gotoAndPlay("spellfighting");
                  this._core.getEnemyAvatarOnScene().gotoAndPlay("spellfighting");
               }
            }
            else if(!this._core.spellSmashing && this._step1AnimationSpellSmashing)
            {
               this._step1AnimationSpellSmashing = false;
               this._step2AnimationSpellSmashing = true;
               this.resolveHit();
            }
            else if(this._step2AnimationSpellSmashing)
            {
               if((this._container.bannerMC.spellFighting as MovieClip).currentLabel == "complete")
               {
                  if(this._avatar1Hitted)
                  {
                     this._container.bannerMC.exploteAvatar1.visible = true;
                     this._container.bannerMC.exploteAvatar1.gotoAndPlay(0);
                     this._container.bannerMC.hitFX.visible = true;
                     this._container.bannerMC.hitFX.gotoAndPlay(0);
                  }
                  else if(this._avatar2Hitted)
                  {
                     this._container.bannerMC.exploteAvatar2.visible = true;
                     this._container.bannerMC.exploteAvatar2.gotoAndPlay(0);
                  }
                  this._step2AnimationSpellSmashing = false;
                  this._container.bannerMC.spellSmash.visible = false;
                  this.disableSpells();
                  this._container.bannerMC.spellFighting.visible = false;
               }
               else if(!this._stepNormalAnimation_1 && this._core.spellSmashingLocalDATA == this._core.spellSmashingRemoteDATA)
               {
                  this._step2AnimationSpellSmashing = false;
                  this._container.bannerMC.spellSmash.visible = false;
                  this.disableSpells();
                  this._container.bannerMC.spellFighting.visible = false;
               }
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
      
      public function init() : void
      {
         this._container.bannerMC.winner.visible = false;
         this._container.bannerMC.winner.visible = false;
         this._container.bannerMC.spellSmash.visible = false;
         this._container.bannerMC.spellFighting.visible = false;
         this._container.bannerMC.exploteAvatar1.visible = false;
         this._container.bannerMC.exploteAvatar2.visible = false;
         this._container.bannerMC.hitFX.visible = false;
         this.disableSpells();
         this._avatar1Hitted = false;
         this._avatar2Hitted = false;
         this._stepNormalAnimation_0 = false;
         this._stepNormalAnimation_1 = false;
         this._stepNormalAnimation_2 = false;
      }
      
      private function disableSpells() : void
      {
         if(this._container && this._container.bannerMC && Boolean(this._container.bannerMC.spellFighting))
         {
            this._container.bannerMC.spellFighting.enemy_spell_ataque0.visible = false;
            this._container.bannerMC.spellFighting.enemy_spell_ataque1.visible = false;
            this._container.bannerMC.spellFighting.enemy_spell_ataque2.visible = false;
            this._container.bannerMC.spellFighting.my_spell_ataque0.visible = false;
            this._container.bannerMC.spellFighting.my_spell_ataque1.visible = false;
            this._container.bannerMC.spellFighting.my_spell_ataque2.visible = false;
         }
      }
      
      private function resolveExplode() : void
      {
      }
      
      private function resolveHit() : void
      {
         if(this._core.normalFight)
         {
            if(this._core.spellResolveWinner(this._core.optionSelectedDataLocal,this._core.optionSelectedDataRemote))
            {
               this._container.bannerMC.spellFighting.gotoAndPlay("winAvatar1");
               this._avatar2Hitted = true;
            }
            else
            {
               this._container.bannerMC.spellFighting.gotoAndPlay("winAvatar2");
               this._avatar1Hitted = true;
            }
            this.showCorrectSpells();
         }
         else if(this._core.spellSmashingLocalDATA > this._core.spellSmashingRemoteDATA)
         {
            this._container.bannerMC.spellFighting.gotoAndPlay("winAvatar1");
            this.showCorrectSpells();
            this._avatar2Hitted = true;
         }
         else if(this._core.spellSmashingLocalDATA < this._core.spellSmashingRemoteDATA)
         {
            this._container.bannerMC.spellFighting.gotoAndPlay("winAvatar2");
            this.showCorrectSpells();
            this._avatar1Hitted = true;
         }
      }
      
      private function showCorrectSpells() : void
      {
         this.disableSpells();
         var _loc1_:MovieClip = this._container.bannerMC.spellFighting["my_spell_" + this._core.optionSelectedDataLocal];
         var _loc2_:MovieClip = this._container.bannerMC.spellFighting["enemy_spell_" + this._core.optionSelectedDataRemote];
         _loc1_.visible = true;
         _loc2_.visible = true;
         if(_loc1_.currentFrame == _loc1_.totalFrames)
         {
            _loc1_.gotoAndPlay(0);
         }
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.gotoAndPlay(0);
         }
         if(!this._flag1)
         {
            this._flag1 = true;
            _loc1_.gotoAndPlay(0);
         }
         if(!this._flag2)
         {
            this._flag2 = true;
            _loc2_.gotoAndPlay(0);
         }
      }
      
      private function animationFinished() : void
      {
         this.resetSteps();
         this.disableSpells();
         this._container.removeEventListener(Event.ENTER_FRAME,this.update);
         this._isanimationRoundFinished = true;
         this._container.bannerMC.spellSmash.visible = false;
         this._avatar1Hitted = false;
         this._avatar2Hitted = false;
         this._container.bannerMC.hitFX.visible = false;
         this._core.updateAndShootAgain();
      }
      
      public function startAnimate() : void
      {
         this._container.addEventListener(Event.ENTER_FRAME,this.update);
         this._isanimationRoundFinished = false;
      }
      
      public function dispose() : void
      {
         this._container.removeEventListener(Event.ENTER_FRAME,this.update);
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
      
      private function showSpells() : void
      {
         if(this._container && this._container.bannerMC && Boolean(this._container.bannerMC.spellFighting))
         {
            this._container.bannerMC.spellFighting.visible = true;
            this.showCorrectSpells();
         }
      }
      
      private function selectSpellSound(param1:String) : void
      {
         switch(param1)
         {
            case "ataque0":
               api.playSound("halloween2017/fuego");
               break;
            case "ataque1":
               api.playSound("halloween2017/agua");
               break;
            case "ataque2":
               api.playSound("halloween2017/hielo");
         }
      }
   }
}
