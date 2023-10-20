package com.qb9.gaturro.view.world.interaction
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.chat.BalloonManager;
   import com.qb9.gaturro.view.world.chat.InteractionBalloon;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.net.chat.ChatMessage;
   import com.qb9.mambo.world.avatars.Avatar;
   import config.AdminControl;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class InteractionManager
   {
      
      public static const INIT_INTERACTION_EVENT:String = "INIT_INTERACTION_EVENT";
       
      
      private var proposals:Dictionary;
      
      private var avatars:Object;
      
      private var interaction:com.qb9.gaturro.view.world.interaction.Interaction;
      
      private var room:GaturroRoom;
      
      private var balloons:BalloonManager;
      
      private const PREFIX_LENGTH:int = 2;
      
      private var gui:Gui;
      
      public function InteractionManager(param1:GaturroRoom, param2:Object, param3:BalloonManager, param4:Gui)
      {
         this.proposals = new Dictionary(true);
         super();
         this.room = param1;
         this.avatars = param2;
         this.balloons = param3;
         this.gui = param4;
      }
      
      public function closeInteraction() : void
      {
         if(this.interaction)
         {
            this.interaction.dispose();
         }
         this.interaction = null;
      }
      
      private function healingBabosa(param1:Avatar) : void
      {
         if(!this.ableToInteract())
         {
            return;
         }
      }
      
      private function gettingParalize(param1:Avatar) : void
      {
         var canParalize:Boolean;
         var result:Object;
         var sender:Avatar = param1;
         if(!this.ableToInteract())
         {
            return;
         }
         result = api.getAvatarAttribute("medal");
         canParalize = false;
         if((sender.attributes.medal == "troll" || sender.attributes.medal == "supertroll") && result == "papa")
         {
            canParalize = true;
         }
         else if(result == "superpapa" && sender.attributes.medal == "supertroll")
         {
            canParalize = true;
         }
         else if((sender.attributes.medal == "papa" || sender.attributes.medal == "superpapa") && result == "troll")
         {
            canParalize = true;
         }
         else if(result == "supertroll" && (sender.attributes.medal == "superpapa" || sender.isCitizen))
         {
            canParalize = true;
         }
         if(canParalize)
         {
            api.setAvatarAttribute("interaction","salvar");
            api.roomView.blockGuiFor(99999);
            api.textMessageToGUI(sender.username + " ! : TE HA PARALIZADO");
            api.userTrapped = true;
            setTimeout(function():void
            {
               api.setAvatarAttribute("special_ph","navidad2018/guerra.paralized_on");
            },300);
         }
      }
      
      private function kickingUser(param1:Avatar) : void
      {
         var sender:Avatar = param1;
         if(this.room.ownerName == sender.username)
         {
            if(!AdminControl.isAdminUser(api.user.username))
            {
               api.changeRoomXY(25355,4,8);
               setTimeout(function():void
               {
                  api.textMessageToGUI(sender.username + " TE SACO DE SU CASA");
               },2000);
               api.trackEvent("FEATURES:HOUSE:KICKBANNER:KICK_SUCCESS",this.room.id.toString());
            }
         }
         else
         {
            api.trackEvent("FEATURES:HOUSE:KICKBANNER:HACKING",sender.username);
         }
      }
      
      private function getIteractionData(param1:String) : Object
      {
         return settings.interactions[param1];
      }
      
      private function canSuperClasico(param1:String, param2:Avatar) : Boolean
      {
         var _loc3_:String = null;
         if(param1 == InteractionTypes.PARTIDO_FUTBOL)
         {
            _loc3_ = api.getAvatarAttribute("superClasico2018TEAM") as String;
            if(_loc3_ != "BOCA" && _loc3_ != "RIVER")
            {
               api.textMessageToGUI("TIENES QUE PERTENECER A BOCA O RIVER");
               api.showBannerModal("superclasicoBocaRiver");
               return false;
            }
            if(_loc3_ == "BOCA" && param2.attributes.superClasico2018TEAM == "BOCA" || _loc3_ == "RIVER" && param2.attributes.superClasico2018TEAM == "RIVER")
            {
               api.textMessageToGUI("BUSCA DESAFIO CONTRA EL EQUIPO RIVAL");
               return false;
            }
            if(param2.attributes.superClasico2018TEAM != "BOCA" && param2.attributes.superClasico2018TEAM != "RIVER")
            {
               api.textMessageToGUI("EL RIVAL NO TIENE EQUIPO");
               return false;
            }
         }
         return true;
      }
      
      private function gettingBombazo(param1:Avatar) : void
      {
         var sender:Avatar = param1;
         setTimeout(function():void
         {
            api.roomView.blockGuiFor(99999);
            api.setAvatarAttribute("special_ph","carnival.splash_on");
            api.textMessageToGUI(sender.username + " ! : TE HA MOJADO");
            setTimeout(function():void
            {
               api.setAvatarAttribute("special_ph"," ");
               api.roomView.unlockGui();
            },1400);
         },1000);
      }
      
      private function ableToInteract() : Boolean
      {
         if(api.room.id == 51690416 || api.room.id == 51690472 || api.room.id == 51690473)
         {
            return true;
         }
         return true;
      }
      
      public function acceptProposeInteraction(param1:String, param2:String) : void
      {
         var _loc3_:Object = this.getIteractionData(param1);
         this.interaction = new com.qb9.gaturro.view.world.interaction.Interaction(GaturroRoom(this.room),_loc3_);
         this.interaction.acceptPropose(this.gui,param2);
      }
      
      private function revivirUsuario2(param1:Avatar) : void
      {
         var sender:Avatar = param1;
         var prevResult:Object = api.getAvatarAttribute("effect");
         if(prevResult == "ghost")
         {
            api.setAvatarAttribute("special_ph","halloween2018/props4.rayoSalvador_on");
            api.textMessageToGUI(sender.username + " ! : TE REVIVIO");
            setTimeout(function():void
            {
               api.setAvatarAttribute("effect"," ");
            },1900);
            setTimeout(function():void
            {
               api.setAvatarAttribute("special_ph","false");
               api.userTrapped = false;
               api.roomView.blockGuiFor(0);
               api.roomView.unlockGui();
            },2000);
            return;
         }
      }
      
      public function dispose() : void
      {
         this.closeInteraction();
         this.proposals = null;
         this.room = null;
         this.avatars = null;
         this.balloons = null;
         this.gui = null;
      }
      
      private function gettingRob(param1:Avatar) : void
      {
         var canRob:Boolean;
         var result2:Object;
         var result:Object;
         var sender:Avatar = param1;
         if(!this.ableToInteract())
         {
            return;
         }
         result = api.getAvatarAttribute("medal");
         result2 = api.getAvatarAttribute("gripFore");
         canRob = false;
         if((sender.attributes.medal == "troll" || sender.attributes.medal == "supertroll") && (result == "papa" || result == "superpapa"))
         {
            canRob = true;
         }
         else if((sender.attributes.medal == "papa" || sender.attributes.medal == "superpapa") && (result == "troll" || result == "supertroll"))
         {
            canRob = true;
         }
         if(canRob)
         {
            api.userTrapped = false;
            api.roomView.blockGuiFor(0);
            api.roomView.unlockGui();
            api.textMessageToGUI(sender.username + " ! : TE HA ROBADO");
            api.setAvatarAttribute("interaction","false");
            setTimeout(function():void
            {
               api.setAvatarAttribute("special_ph","navidad2018/guerra.roba_on");
            },300);
            setTimeout(function():void
            {
               api.setAvatarAttribute("special_ph"," ");
            },900);
            setTimeout(function():void
            {
               api.setAvatarAttribute("effect","ghost");
            },1200);
            if(result2 == "navidad2018/guerra.gift_on")
            {
               setTimeout(function():void
               {
                  api.setAvatarAttribute("gripFore"," ");
               },1500);
               api.room.proposeInteraction(InteractionTypes.ROBARSUCCESS,sender.username.toUpperCase());
            }
         }
      }
      
      public function receivedOp(param1:ChatMessage) : void
      {
         if(this.interaction && this.interaction.modalForm && !this.interaction.modalForm.parent)
         {
            this.interaction = null;
         }
         var _loc2_:Array = param1.message.split(";");
         var _loc3_:String = String(_loc2_[0].substr(1,this.PREFIX_LENGTH));
         var _loc4_:String = String(_loc2_[0].substr(this.PREFIX_LENGTH + 1,String(_loc2_[0]).length - this.PREFIX_LENGTH));
         var _loc5_:String = _loc3_ + _loc4_;
         var _loc6_:Avatar = this.room.avatarByUsername(param1.sender);
         var _loc7_:Avatar = this.room.avatarByUsername(_loc2_[1]);
         if(_loc2_.length >= 1)
         {
            ArrayUtil.removeElement(_loc2_,_loc2_[0]);
         }
         if(_loc2_.length >= 1)
         {
            ArrayUtil.removeElement(_loc2_,_loc2_[0]);
         }
         if(!_loc6_ || !_loc7_)
         {
            return;
         }
         if(this.room.userAvatar.username != _loc6_.username && this.room.userAvatar.username != _loc7_.username)
         {
            return;
         }
         var _loc8_:GaturroAvatarView = this.avatars[_loc6_.username];
         var _loc9_:GaturroAvatarView = this.avatars[_loc7_.username];
         if(_loc3_ == "SS" && this.interaction && _loc4_ == "P")
         {
            this.interaction = null;
         }
         if(this.interaction)
         {
            this.interaction.received(_loc5_,_loc6_,_loc8_,_loc7_,_loc9_,_loc2_);
         }
         else if(_loc4_ == "P" && this.room.userAvatar.username == _loc7_.username)
         {
            this.showProposeBalloon(_loc3_,_loc6_,_loc8_);
         }
      }
      
      private function salvarUsuario(param1:Avatar) : void
      {
         var result:Object;
         var sender:Avatar = param1;
         var prevResult:Object = api.getAvatarAttribute("special_ph");
         if(prevResult == "halloween2018/props2.captura02_on" || prevResult == "navidad2018/guerra.paralized_on")
         {
            api.setAvatarAttribute("special_ph","navidad2018/guerra.removeParalized_on");
            api.textMessageToGUI(sender.username + " ! : TE SALVO");
            setTimeout(function():void
            {
               api.setAvatarAttribute("special_ph","false");
               api.userTrapped = false;
               api.roomView.blockGuiFor(0);
               api.roomView.unlockGui();
            },500);
            return;
         }
         result = api.getAvatarAttribute("trapped");
         if(api.userTrapped)
         {
            api.textMessageToGUI(sender.username + " ! : TE SALVO");
            api.userTrapped = false;
            api.roomView.blockGuiFor(0);
            api.roomView.unlockGui();
            api.setAvatarAttribute("trapped","false");
         }
      }
      
      private function robDone(param1:Avatar) : void
      {
         var result:* = undefined;
         var sender:Avatar = param1;
         api.setAvatarAttribute("gripFore","navidad2018/guerra.gift_on");
         result = api.getProfileAttribute("puntosNavidad2018");
         result++;
         setTimeout(function():void
         {
            api.setProfileAttribute("puntosNavidad2018",result);
         },300);
         trace("ROB SUCCESS");
      }
      
      private function responseNo(param1:Event) : void
      {
         var _loc2_:InteractionBalloon = InteractionBalloon(param1.currentTarget);
         if(!this.proposals || !_loc2_)
         {
            return;
         }
         var _loc3_:String = this.getTypeFromPrefix(_loc2_.interactionPrefix);
         this.rejectProposeInteraction(_loc3_,this.proposals[_loc2_].sender.username);
         this.proposals[_loc2_] = null;
      }
      
      private function getTypeFromPrefix(param1:String) : String
      {
         var _loc2_:String = null;
         for(_loc2_ in settings.interactions)
         {
            if(settings.interactions[_loc2_].prefix == param1)
            {
               return _loc2_;
            }
         }
         return "";
      }
      
      private function responseYes(param1:Event) : void
      {
         var _loc2_:InteractionBalloon = InteractionBalloon(param1.currentTarget);
         if(!_loc2_ || !this.proposals[_loc2_].sender)
         {
            return;
         }
         var _loc3_:String = this.getTypeFromPrefix(_loc2_.interactionPrefix);
         this.acceptProposeInteraction(_loc3_,this.proposals[_loc2_].sender.username);
         this.proposals[_loc2_] = null;
      }
      
      private function showProposeBalloon(param1:String, param2:Avatar, param3:GaturroAvatarView) : void
      {
         var interactionAttr:Object;
         var fullInteractionName:String = null;
         var balloon:InteractionBalloon = null;
         var interactionPrefix:String = param1;
         var sender:Avatar = param2;
         var senderView:GaturroAvatarView = param3;
         trace("************ INTERACTION :  " + interactionPrefix);
         fullInteractionName = InteractionTypes.twoLetterToFull(interactionPrefix);
         interactionAttr = api.getAvatarAttribute("interaction");
         if(interactionPrefix == "BO")
         {
            this.gettingBombazo(sender);
            return;
         }
         if(interactionPrefix == "PA")
         {
            if(sender.attributes.effect == "ghost")
            {
               return;
            }
            this.gettingParalize(sender);
            return;
         }
         if(interactionPrefix == "RO")
         {
            if(sender.attributes.effect == "ghost")
            {
               return;
            }
            this.gettingRob(sender);
            return;
         }
         if(interactionPrefix == "SS")
         {
            this.robDone(sender);
            return;
         }
         if(interactionPrefix == "SA")
         {
            if(sender.attributes.effect == "ghost")
            {
               return;
            }
            this.salvarUsuario(sender);
         }
         if(interactionAttr == fullInteractionName && fullInteractionName != "null")
         {
            if(this.canSuperClasico(fullInteractionName,sender))
            {
               setTimeout(function():void
               {
                  acceptProposeInteraction(fullInteractionName,sender.username);
               },300);
               api.setAvatarAttribute("interaction","false");
            }
         }
         else if(interactionPrefix == "KH")
         {
            this.kickingUser(sender);
         }
         else
         {
            if(!this.canSuperClasico(fullInteractionName,sender))
            {
               return;
            }
            balloon = this.balloons.proposeInteraction(interactionPrefix,senderView);
            balloon.addEventListener(InteractionBalloon.RESPONSE_YES,this.responseYes);
            balloon.addEventListener(InteractionBalloon.RESPONSE_NO,this.responseNo);
            this.proposals[balloon] = {
               "sender":sender,
               "senderView":senderView
            };
         }
      }
      
      public function say(param1:BalloonManager, param2:String, param3:String) : void
      {
         if(this.interaction)
         {
            this.interaction.say(param1,param2,param3);
         }
      }
      
      public function rejectProposeInteraction(param1:String, param2:String) : void
      {
         var _loc3_:Object = this.getIteractionData(param1);
         this.interaction = new com.qb9.gaturro.view.world.interaction.Interaction(GaturroRoom(this.room),_loc3_);
         this.interaction.rejectPropose(param2);
         this.interaction.dispose();
         this.interaction = null;
      }
      
      public function initProposeInteraction(param1:String, param2:String) : void
      {
         var _loc3_:Object = this.getIteractionData(param1);
         this.interaction = new com.qb9.gaturro.view.world.interaction.Interaction(GaturroRoom(this.room),_loc3_);
         this.interaction.initPropose(this.gui,param2);
      }
      
      private function gettingBabosa(param1:Avatar) : void
      {
         if(!this.ableToInteract())
         {
            return;
         }
      }
   }
}
