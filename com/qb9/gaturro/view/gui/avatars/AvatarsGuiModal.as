package com.qb9.gaturro.view.gui.avatars
{
   import assets.AvatarsOptionsMCph;
   import assets.MedalFreeMC;
   import assets.MedalMC;
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.achievements;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.service.passport.BubbleFlannysService;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.TransportInventorySceneObject;
   import com.qb9.gaturro.util.StubAttributeHolder;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.gift.GiftGuiModalEvent;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.interaction.InteractionTypes;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mambo.world.avatars.Avatar;
   import config.AdminControl;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public final class AvatarsGuiModal extends BaseGuiModal
   {
      
      private static const CHARACTER_SCALE:Number = 1.3;
       
      
      private var socialSkills:Object;
      
      private var character:Gaturro;
      
      private var comunityTimeout:int;
      
      private var competitiveSkills:Object;
      
      private var avatar:Avatar;
      
      private var room:GaturroRoom;
      
      private var firstVarita:InventorySceneObject;
      
      private var levelDef:Settings;
      
      private var explorerSkills:Object;
      
      private var interactionTimeout:int;
      
      private var asset:AvatarsOptionsMCph;
      
      private var profileOpened:Boolean = false;
      
      private var firstTransport:InventorySceneObject;
      
      public function AvatarsGuiModal(param1:Avatar, param2:GaturroRoom)
      {
         super();
         this.avatar = param1;
         this.room = param2;
         this.init();
      }
      
      private function proposeExchange(param1:Event) : void
      {
         this.room.proposeInteraction("exchange",this.avatar.username.toUpperCase());
         this.close();
      }
      
      private function wearsVarita() : Boolean
      {
         var _loc1_:String = api.getAvatarAttribute("gripFore") as String;
         return Boolean(_loc1_) && _loc1_.indexOf("halloween2017") != -1 && _loc1_.indexOf("varita") != -1;
      }
      
      private function visitAvatar(param1:Event) : void
      {
         this.room.visit(this.avatar.username);
      }
      
      private function getLevelOfSkill(param1:Object) : int
      {
         var _loc4_:Object = null;
         var _loc2_:Object = this.levelDef.definition.levels;
         var _loc3_:int = 1;
         for each(_loc4_ in _loc2_)
         {
            if(param1 as int >= _loc4_.exp)
            {
               _loc3_ = int(_loc4_.level);
            }
            else if(param1 as int < _loc4_.exp)
            {
               return _loc3_;
            }
         }
         return _loc3_;
      }
      
      private function achievAvatar(param1:Event) : void
      {
         achievements.getFriendAchiev(this.avatar.username,this.avatar.avatarId);
         api.showAchievementBannerModal(this.avatar.username);
      }
      
      private function init() : void
      {
         var _loc3_:MovieClip = null;
         this.asset = new AvatarsOptionsMCph();
         this.asset.tooltip.visible = false;
         this.asset.close.addEventListener(MouseEvent.CLICK,_close);
         if(this.avatar.attributes.thehand == "true" && AdminControl.isAdminUser(this.avatar.username))
         {
            this.asset.visible = false;
         }
         this.asset.username.text = this.avatar.username.toUpperCase();
         this.competitiveSkills = this.avatar.attributes.competitiveSkills;
         this.socialSkills = this.avatar.attributes.socialSkills;
         this.explorerSkills = this.avatar.attributes.explorerSkills;
         this.initconfig();
         this.setupButtons();
         this.setupButtonMenues();
         this.character = new Gaturro(StubAttributeHolder.fromHolder(this.avatar));
         this.character.scaleX = this.character.scaleY = CHARACTER_SCALE;
         this.asset.avatarPh.addChild(this.character);
         user.club.getInsigniaFromAvatar(this.avatar,this.asset.club_ph);
         if(this.avatar.attributes.passportType)
         {
            if(this.avatar.attributes.passportType != "none")
            {
               _loc3_ = new MedalMC();
               this.asset.medalPh.addChild(_loc3_);
               if(this.avatar.attributes.passportType == "boca")
               {
                  _loc3_.gotoAndStop(2);
               }
            }
            else
            {
               var _loc4_:MovieClip = new MedalFreeMC();
               this.asset.medalPh.addChild(_loc4_);
            }
         }
         addChild(this.asset);
         var _loc1_:int = int(api.room.avatarByUsername(this.avatar.username).attributes["profileBackground"]);
         this.loadBackground(this.asset.bgHolder,_loc1_);
         var _loc2_:String = TrackActions.SEE_BUDDY_PROFILE;
         _loc2_ += ":" + this.avatar.username;
         Telemetry.getInstance().trackEvent(TrackCategories.AVATAR,_loc2_);
         if(Boolean(this.avatar.attributes) && this.avatar.attributes.trapped == "true")
         {
         }
      }
      
      private function proposeCarreraCohete(param1:Event) : void
      {
         if(this.hasTransport())
         {
            if(!this.wearsTransport())
            {
               api.setAvatarAttribute("transport",this.firstTransport.name + "_on");
            }
            this.room.proposeInteraction(InteractionTypes.CARRERA_COHETE_GAME,this.avatar.username.toUpperCase());
         }
         else
         {
            api.openIphoneNews("carrerasEstelares2017");
            api.textMessageToGUI("¡NECESITAS UN TRANSPORTE!");
         }
         this.close();
      }
      
      private function addToPh(param1:DisplayObject, param2:Object) : void
      {
         if(param1)
         {
            param2.asset.addChild(param1);
            (param1 as MovieClip).gotoAndStop(param2.frame);
         }
      }
      
      private function get followThisBuddy() : Boolean
      {
         return user.community.followThisBuddy(this.avatar.username);
      }
      
      private function proposeDarRecibir(param1:Event) : void
      {
         this.room.proposeInteraction("darRecibir",this.avatar.username.toUpperCase());
         this.close();
      }
      
      private function proposeMedicCure(param1:Event) : void
      {
      }
      
      private function proposeBombitas(param1:MouseEvent) : void
      {
         var result:* = undefined;
         var e:MouseEvent = param1;
         api.setAvatarAttribute("gripFore","carnival.bombita1_on");
         setTimeout(function():void
         {
            api.setAvatarAttribute("action","throw");
         },200);
         setTimeout(function():void
         {
            api.setAvatarAttribute("gripFore"," ");
         },1000);
         this.room.proposeInteraction(InteractionTypes.BOMBITAS,this.avatar.username.toUpperCase());
         result = api.getProfileAttribute("puntosCarnaval2019");
         result++;
         setTimeout(function():void
         {
            api.setProfileAttribute("puntosCarnaval2019",result);
            checkIfWinBombita(result);
         },1500);
         this.close();
      }
      
      private function proposeParalizar(param1:Event) : void
      {
         var e:Event = param1;
         this.room.proposeInteraction(InteractionTypes.PARALIZAR,this.avatar.username.toUpperCase());
         setTimeout(function():void
         {
            api.setAvatarAttribute("action","rayos");
         },300);
         this.close();
      }
      
      private function stateFriendButton(param1:Boolean) : void
      {
         if(param1)
         {
            this.asset.friend_btn.gotoAndStop(1);
            this.asset.friend_btn.addEventListener(MouseEvent.CLICK,this.proposeFrienship);
         }
         else
         {
            this.asset.friend_btn.gotoAndStop(3);
            this.asset.friend_btn.removeEventListener(MouseEvent.CLICK,this.proposeFrienship);
         }
         this.asset.friend_btn.buttonMode = param1;
      }
      
      private function proposeZombieBite(param1:Event) : void
      {
      }
      
      private function proposeFrienship(param1:Event) : void
      {
         this.room.proposeInteraction("friendship",this.avatar.username.toUpperCase());
         this.close();
      }
      
      override public function dispose() : void
      {
         this.asset.bombitas_btn.removeEventListener(MouseEvent.CLICK,this.proposeBombitas);
         this.asset.niveles_gris.removeEventListener(MouseEvent.CLICK,this.showPassPort);
         this.asset.close.removeEventListener(MouseEvent.CLICK,_close);
         this.asset.friend_btn.removeEventListener(MouseEvent.CLICK,this.proposeFrienship);
         this.asset.gift_btn.removeEventListener(MouseEvent.CLICK,this.giveGift);
         this.asset.home_btn.removeEventListener(MouseEvent.CLICK,this.visitAvatar);
         this.asset.exchange_btn.removeEventListener(MouseEvent.CLICK,this.proposeExchange);
         this.asset.ach_btn.removeEventListener(MouseEvent.CLICK,this.proposeCopiarRopa);
         this.asset.cards_btn.removeEventListener(MouseEvent.CLICK,this.proposeChallenge);
         this.asset.cowboys_btn.removeEventListener(MouseEvent.CLICK,this.proposeDarRecibir);
         this.asset.sanValentin_btn.removeEventListener(MouseEvent.CLICK,this.proposeSanValentin);
         this.asset.friend_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.asset.gift_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.asset.home_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.asset.exchange_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.asset.ach_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.asset.cards_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.asset.sanValentin_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.asset.interaction_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.asset.cowboys_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.asset.profile_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.asset.varitas_btn.removeEventListener(MouseEvent.CLICK,this.proposePeleaMagiaChallenge);
         this.asset.salvar_btn.removeEventListener(MouseEvent.CLICK,this.proposePeleaMagiaChallenge);
         this.asset.friend_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.asset.gift_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.asset.home_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.asset.exchange_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.asset.ach_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.asset.cards_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.asset.sanValentin_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.asset.cowboys_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.asset.comunity_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
         this.asset.comunity_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.asset.comunity_btn.removeEventListener(MouseEvent.CLICK,this.proposeFrienship);
         this.asset.interaction_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
         this.asset.interaction_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.showInteraction);
         this.asset.interaction_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.hideInteraction);
         this.asset = null;
         this.character.dispose();
         this.character = null;
         this.avatar = null;
         this.room = null;
         super.dispose();
      }
      
      private function proposeFulbejo(param1:MouseEvent) : void
      {
         var _loc2_:String = api.getAvatarAttribute("superClasico2018TEAM") as String;
         if(_loc2_ != "BOCA" && _loc2_ != "RIVER")
         {
            api.textMessageToGUI("TIENES QUE PERTENECER A BOCA O RIVER");
            return;
         }
         if(_loc2_ == "BOCA" && this.avatar.attributes.superClasico2018TEAM == "BOCA" || _loc2_ == "RIVER" && this.avatar.attributes.superClasico2018TEAM == "RIVER")
         {
            api.textMessageToGUI("BUSCA DESAFIO CONTRA EL EQUIPO RIVAL");
            return;
         }
         if(this.avatar.attributes.superClasico2018TEAM != "BOCA" && this.avatar.attributes.superClasico2018TEAM != "RIVER")
         {
            api.textMessageToGUI("EL RIVAL NO TIENE EQUIPO");
         }
         this.room.proposeInteraction(InteractionTypes.PARTIDO_FUTBOL,this.avatar.username.toUpperCase());
         this.close();
      }
      
      private function showExchangeButtons(param1:Boolean) : void
      {
         var b:Boolean = param1;
         with(this.asset)
         {
            cards_btn.visible = thumb_cards.visible = b;
            exchange_btn.visible = thumb_exchange.visible = b;
         }
      }
      
      private function hasTransport() : Boolean
      {
         var _loc2_:InventorySceneObject = null;
         var _loc1_:GaturroInventory = api.user.inventory(GaturroInventory.VISUALIZER) as GaturroInventory;
         for each(_loc2_ in _loc1_.items)
         {
            if(_loc2_ is TransportInventorySceneObject)
            {
               this.firstTransport = _loc2_;
               return true;
            }
         }
         return false;
      }
      
      private function checkIfAvatarCanBeSaved() : void
      {
         if(this.avatar.attributes.trapped != "true")
         {
            this.asset.salvar_btn.visible = false;
            this.asset.thumb_salvar.visible = false;
         }
      }
      
      private function loadBackground(param1:MovieClip, param2:int = 0) : void
      {
         api.libraries.fetch(settings.yoBackgroundsPath,this.addToPh,{
            "asset":param1,
            "frame":param2
         });
      }
      
      private function wearsTransport() : Boolean
      {
         var _loc1_:String = api.getAvatarAttribute("transport") as String;
         return Boolean(_loc1_) && _loc1_ != "";
      }
      
      private function proposeSanValentin(param1:Event) : void
      {
         this.room.proposeInteraction("sanValentin",this.avatar.username.toUpperCase());
         this.close();
      }
      
      private function proposecowboys(param1:Event) : void
      {
         this.room.proposeInteraction("cowboys",this.avatar.username.toUpperCase());
         this.close();
      }
      
      private function setupButtonMenues() : void
      {
         with(this.asset)
         {
            comunity_btn.addEventListener(MouseEvent.MOUSE_OVER,over);
            comunity_btn.addEventListener(MouseEvent.MOUSE_OUT,out);
            comunity_btn.addEventListener(MouseEvent.CLICK,proposeFrienship);
            interaction_btn.addEventListener(MouseEvent.MOUSE_OVER,showInteraction);
            interaction_btn.addEventListener(MouseEvent.MOUSE_OUT,hideInteraction);
            interaction_btn.gotoAndStop(1);
            comunity_btn.gotoAndStop(1);
            cards_btn.x = cards_btn.y = -500;
            cowboys_btn.x = cowboys_btn.y = -500;
            friend_btn.x = friend_btn.y = 0;
            thumb_users.x = thumb_users.y = friend_btn.width / 2;
            thumb_block.x = thumb_block.y = 8;
            thumb_block.visible = false;
            thumb_users.visible = false;
            if(user.community.buddies.length <= 0)
            {
               thumb_comunity.gotoAndPlay("on");
            }
            else
            {
               thumb_comunity.gotoAndPlay("idle");
            }
         }
      }
      
      private function howToPlay(param1:MouseEvent) : void
      {
         api.openIphoneNews("babosas2018");
      }
      
      private function setupButtons() : void
      {
         var list:* = undefined;
         var _bubbleFlanysServie:* = undefined;
         with(this.asset)
         {
            list = [thumb_block,thumb_bombita,nuInteract,thumb_fulbejo,thumb_gift,thumb_house,thumb_users,thumb_exchange,thumb_achievements,thumb_comunity,thumb_interaction,thumb_cards,tooltip,thumb_cowboys,thumb_sanValentin,thumb_rusiaBtn,medic_cure,zombie_infect,thumb_profile,thumb_magia,thumb_salvar];
            foreach(list,DisplayUtil.disableMouse);
            thumb_achievements.visible = false;
            gift_btn.addEventListener(MouseEvent.CLICK,giveGift);
            home_btn.addEventListener(MouseEvent.CLICK,visitAvatar);
            exchange_btn.addEventListener(MouseEvent.CLICK,proposeExchange);
            varitas_btn.addEventListener(MouseEvent.CLICK,proposePeleaMagiaChallenge);
            salvar_btn.addEventListener(MouseEvent.CLICK,proposeParalizar);
            ach_btn2.addEventListener(MouseEvent.CLICK,proposeCarreraCohete);
            ach_btn2.buttonMode = true;
            rusia_btn.addEventListener(MouseEvent.CLICK,proposeFutbolPenalty);
            rusia_btn.buttonMode = true;
            cards_btn.addEventListener(MouseEvent.CLICK,proposeChallenge);
            profile_btn.addEventListener(MouseEvent.CLICK,showProfile);
            profile_btn.buttonMode = true;
            if(Context.instance.hasByType(BubbleFlannysService))
            {
               _bubbleFlanysServie = Context.instance.getByType(BubbleFlannysService) as BubbleFlannysService;
            }
            else
            {
               _bubbleFlanysServie = new BubbleFlannysService();
               _bubbleFlanysServie.init();
               Context.instance.addByType(_bubbleFlanysServie,BubbleFlannysService);
            }
            fulbejo_btn.addEventListener(MouseEvent.CLICK,proposeFulbejo);
            fulbejo_btn.buttonMode = true;
            ach_btn.addEventListener(MouseEvent.CLICK,proposeCopiarRopa);
            if(api.getAvatarAttribute("medal") == "villano")
            {
               zombie_btn.visible = true;
               zombie_infect.visible = true;
            }
            if(api.getAvatarAttribute("medal") == "heroe")
            {
               medic_btn.visible = true;
               medic_cure.visible = true;
            }
            if(zombie_btn.visible == false && medic_btn.visible == false)
            {
            }
            zombie_btn.visible = false;
            zombie_infect.visible = false;
            medic_btn.visible = false;
            medic_cure.visible = false;
            thumb_bombita.visible = true;
            bombitas_btn.visible = true;
            bombitas_btn.addEventListener(MouseEvent.CLICK,proposeBombitas);
            sanValentin_btn.visible = true;
            thumb_sanValentin.visible = true;
            thumb_rusiaBtn.visible = true;
            friend_btn.visible = false;
            ignore_btn.visible = false;
            turnSpecialProfileOn();
            foreach([profile_btn,bombitas_btn,fulbejo_btn,gift_btn,home_btn,exchange_btn,ach_btn,ach_btn2,cards_btn,rusia_btn,cowboys_btn,sanValentin_btn,zombie_btn,medic_btn,nuInteract_btn,varitas_btn,salvar_btn],setupOver);
            if(!_bubbleFlanysServie.ableToSendReq)
            {
               sanValentin_btn.gotoAndStop(4);
               thumb_sanValentin.gotoAndStop(2);
               sanValentin_btn.buttonMode = false;
               thumb_sanValentin.buttonMode = false;
            }
            else
            {
               sanValentin_btn.addEventListener(MouseEvent.CLICK,openFannys);
            }
         }
      }
      
      private function proposePeleaMagiaChallenge(param1:Event) : void
      {
         if(this.hasVarita())
         {
            if(!this.wearsVarita())
            {
               api.setAvatarAttribute("gripFore",this.firstVarita.name + "_on");
            }
            this.room.proposeInteraction(InteractionTypes.PELEAMAGIA_GAME,this.avatar.username.toUpperCase());
         }
         else
         {
            api.setAvatarAttribute("gripFore","halloween2017/wears.varitaFuego_on");
            this.room.proposeInteraction(InteractionTypes.PELEAMAGIA_GAME,this.avatar.username.toUpperCase());
         }
         this.close();
      }
      
      private function hideMenu(param1:Object) : void
      {
         if(param1.currentLabel == "opening")
         {
            param1.gotoAndPlay("closing");
         }
      }
      
      private function turnSpecialProfileOn() : void
      {
         if(api.room.id == 51690416 || api.room.id == 51690472 || api.room.id == 51690473)
         {
            this.asset.salvar_btn.visible = true;
            this.asset.thumb_salvar.visible = true;
         }
         else
         {
            this.asset.salvar_btn.visible = false;
            this.asset.thumb_salvar.visible = false;
         }
      }
      
      private function out(param1:MouseEvent) : void
      {
         if(this.asset)
         {
            this.asset.tooltip.visible = false;
            this.asset.tooltip.stopDrag();
         }
      }
      
      private function showPassPort(param1:MouseEvent) : void
      {
      }
      
      private function hasVarita() : Boolean
      {
         var _loc2_:InventorySceneObject = null;
         var _loc1_:GaturroInventory = api.user.inventory(GaturroInventory.VISUALIZER) as GaturroInventory;
         for each(_loc2_ in _loc1_.items)
         {
            if(_loc2_.name.indexOf("halloween2017") != -1 && _loc2_.name.indexOf("varita") != -1)
            {
               this.firstVarita = _loc2_;
               return true;
            }
         }
         return false;
      }
      
      private function proposeCopiarRopa(param1:Event) : void
      {
         this.room.proposeInteraction(InteractionTypes.COPIAR_VESTIMENTA,this.avatar.username.toUpperCase());
         this.close();
      }
      
      private function setupLevels(param1:Event = null) : void
      {
         if(this.avatar.isCitizen)
         {
            this.asset.niveles_gris.visible = false;
            this.asset.comp_txt.text = this.getLevelOfSkill(this.competitiveSkills).toString();
            this.asset.soc_txt.text = this.getLevelOfSkill(this.socialSkills).toString();
            this.asset.explo_txt.text = this.getLevelOfSkill(this.explorerSkills).toString();
         }
         else if(this.profileOpened)
         {
            this.asset.niveles_gris.visible = true;
         }
      }
      
      private function over(param1:MouseEvent) : void
      {
         this.asset.tooltip.visible = true;
         switch(param1.currentTarget)
         {
            case this.asset.fulbejo_btn:
               region.setText(this.asset.tooltip.field,"JUGAR PARTIDO");
               break;
            case this.asset.profile_btn:
               region.setText(this.asset.tooltip.field,"PERFIL");
               break;
            case this.asset.nuInteract_btn:
               region.setText(this.asset.tooltip.field,"UNETE A LA BATALLA");
               break;
            case this.asset.zombie_btn:
               region.setText(this.asset.tooltip.field,"BABOSEAR");
               break;
            case this.asset.medic_btn:
               region.setText(this.asset.tooltip.field,"CURAR");
               break;
            case this.asset.gift_btn:
               region.setText(this.asset.tooltip.field,"HACER UN REGALO");
               break;
            case this.asset.home_btn:
               region.setText(this.asset.tooltip.field,"IR A SU CASA");
               break;
            case this.asset.exchange_btn:
               region.setText(this.asset.tooltip.field,"INTERCAMBIAR");
               break;
            case this.asset.cards_btn:
               region.setText(this.asset.tooltip.field,"DESAFIAR");
               break;
            case this.asset.cowboys_btn:
               region.setText(this.asset.tooltip.field,"COWBOYS");
               break;
            case this.asset.rusia_btn:
               region.setText(this.asset.tooltip.field,"PENALES RUSOS");
               break;
            case this.asset.sanValentin_btn:
               region.setText(this.asset.tooltip.field,"BUBBLE FLANYS");
               break;
            case this.asset.ach_btn:
               region.setText(this.asset.tooltip.field,"COPIAR LOOK");
               break;
            case this.asset.salvar_btn:
               region.setText(this.asset.tooltip.field,"PARALIZAR!");
               break;
            case this.asset.varitas_btn:
               region.setText(this.asset.tooltip.field,"¡DUELO DE MAGIA!");
               break;
            case this.asset.ach_btn2:
               region.setText(this.asset.tooltip.field,"¡CARRERAS!");
               break;
            case this.asset.pandulce_btn:
               region.setText(this.asset.tooltip.field,"PAN DULCE NAVIDEÑO");
               break;
            case this.asset.bombitas_btn:
               region.setText(this.asset.tooltip.field,"DAR BOMBAZO");
               break;
            case this.asset.comunity_btn:
               region.setText(this.asset.tooltip.field,"SER AMIGOS");
         }
         this.asset.tooltip.startDrag(true);
      }
      
      private function showInteraction(param1:Event) : void
      {
         clearTimeout(this.interactionTimeout);
         var _loc2_:Object = param1.target;
         while(Boolean(_loc2_) && _loc2_ != this.asset.interaction_btn)
         {
            _loc2_ = _loc2_.parent;
         }
         if(_loc2_.currentLabel != "opening")
         {
            _loc2_.gotoAndPlay("opening");
         }
      }
      
      private function proposeNavidadPandulceComun(param1:Event) : void
      {
         var _loc2_:String = api.getAvatarAttribute("effect2") as String;
         if(_loc2_ && _loc2_ != "" && _loc2_ != " ")
         {
            api.showModal("VE A DEJAR EL QUE TIENES EN LA HELADERA","information","¿YA TIENES UN PAN DULCE ARMADO!");
         }
         else
         {
            this.room.proposeInteraction(InteractionTypes.NAVIDAD_PAN_DULCE_GAME,this.avatar.username.toUpperCase());
         }
         this.close();
      }
      
      private function proposePenalesRiver(param1:Event) : void
      {
         this.room.proposeInteraction(InteractionTypes.FUTBOL_RIVER_GAME,this.avatar.username.toUpperCase());
         this.close();
      }
      
      private function checkIfWinBombita(param1:int) : void
      {
         if(param1 == 3)
         {
            api.showAwardModal("¡FELICITACIONES! SEGUI JUGANDO TE QUEDAN 5 PREMIOS!","hairs1.afroEspuma");
            api.giveUser("hairs1.afroEspuma");
         }
         else if(param1 == 9)
         {
            api.showAwardModal("¡FELICITACIONES! SEGUI JUGANDO TE QUEDAN 4 PREMIOS!","hairs1.pelucaJustinEspuma");
            api.giveUser("hairs1.pelucaJustinEspuma",1);
         }
         else if(param1 == 18)
         {
            api.showAwardModal("¡FELICITACIONES! SEGUI JUGANDO TE QUEDAN 3 PREMIOS!","hairs1.punkEspuma");
            api.giveUser("hairs1.punkEspuma",1);
         }
         else if(param1 == 36)
         {
            api.showAwardModal("¡FELICITACIONES! SEGUI JUGANDO TE QUEDAN 2 PREMIO!","hairs1.trenzaEspuma");
            api.giveUser("hairs1.trenzaEspuma",1);
         }
         else if(param1 == 72)
         {
            api.showAwardModal("¡FELICITACIONES! SEGUI JUGANDO TE QUEDAN 1 PREMIO!","hairs1.carreEspuma");
            api.giveUser("hairs1.carreEspuma",1);
         }
         else if(param1 == 150)
         {
            api.showAwardModal("¡FELICITACIONES! DESBLOQUEASTE TODOS!","virtualGoods2.burbujero");
            api.giveUser("virtualGoods2.burbujero",1);
         }
      }
      
      private function turnProfileOff() : void
      {
         this.profileOpened = false;
         this.asset.thumb_cards.visible = false;
         this.asset.thumb_interaction.visible = false;
         this.asset.avatarPh.visible = false;
         this.asset.club_ph.visible = false;
         this.asset.background.visible = false;
         this.asset.medalPh.visible = false;
         this.asset.bgHolder.visible = false;
         this.asset.close.visible = false;
         this.asset.niveles_gris.visible = false;
         this.asset.niveles_color.visible = false;
         this.asset.soc_txt.visible = false;
         this.asset.explo_txt.visible = false;
         this.asset.comp_txt.visible = false;
      }
      
      private function proposeEstrella(param1:Event) : void
      {
         this.room.proposeInteraction("estrellaVotos",this.avatar.username.toUpperCase());
         this.close();
      }
      
      private function proposeSalvar(param1:Event) : void
      {
         var e:Event = param1;
         if(this.avatar.attributes.trapped == "true")
         {
            this.room.proposeInteraction(InteractionTypes.SALVAR,this.avatar.username.toUpperCase());
            setTimeout(function():void
            {
               api.setAvatarAttribute("action","rayos");
            },300);
         }
         else
         {
            api.textMessageToGUI(this.avatar.username + "  NO PUEDE SER SALVADO");
         }
         this.close();
      }
      
      private function initconfig() : void
      {
         this.levelDef = new Settings();
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc1_:String = URLUtil.getUrl("cfgs/profileStats.json");
         var _loc2_:LoadFile = new LoadFile(_loc1_,"json");
         this.levelDef.addFile(_loc2_);
         _loc2_.addEventListener(TaskEvent.COMPLETE,this.setupLevels);
         _loc2_.start();
      }
      
      private function turnProfileOn() : void
      {
         this.profileOpened = true;
         this.asset.avatarPh.visible = true;
         this.asset.club_ph.visible = true;
         this.asset.background.visible = true;
         this.asset.medalPh.visible = true;
         this.asset.bgHolder.visible = true;
         this.asset.close.visible = true;
         this.asset.niveles_gris.visible = true;
         this.asset.niveles_color.visible = true;
         this.asset.soc_txt.visible = true;
         this.asset.explo_txt.visible = true;
         this.asset.comp_txt.visible = true;
         this.setupLevels();
      }
      
      private function showProfile(param1:MouseEvent) : void
      {
         if(this.asset.avatarPh.visible)
         {
            this.turnProfileOff();
         }
         else
         {
            this.turnProfileOn();
         }
      }
      
      private function setupOver(param1:DisplayObject) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.over);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.out);
      }
      
      private function hideInteraction(param1:Event) : void
      {
         clearTimeout(this.interactionTimeout);
         var _loc2_:Object = param1.target;
         while(Boolean(_loc2_) && _loc2_ != this.asset.interaction_btn)
         {
            _loc2_ = _loc2_.parent;
         }
         this.interactionTimeout = setTimeout(this.hideMenu,200,_loc2_);
      }
      
      private function proposeFutbolPenalty(param1:Event) : void
      {
         this.room.proposeInteraction(InteractionTypes.FUTBOL_RUSIA_GAME,this.avatar.username.toUpperCase());
         this.close();
      }
      
      private function giveGift(param1:Event) : void
      {
         dispatchEvent(new GiftGuiModalEvent(GiftGuiModalEvent.OPEN,this.avatar.username));
      }
      
      private function proposeChallenge(param1:Event) : void
      {
         this.room.proposeInteraction("cards",this.avatar.username.toUpperCase());
         this.close();
      }
      
      private function openFannys(param1:Event) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.userName = this.avatar.username;
         _loc2_.token = api.view.bubbleFlanysServie.funnysToken;
         api.trackEvent("FEATURES:BUBBLEFLANYS:SHOW_OTHER_USER_LIST","");
         api.startUnityMinigame("fluffyflaffy",0,null,_loc2_);
         this.close();
      }
   }
}
