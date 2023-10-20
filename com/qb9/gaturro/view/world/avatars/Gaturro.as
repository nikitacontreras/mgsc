package com.qb9.gaturro.view.world.avatars
{
   import assets.AvatarTooltipMC;
   import assets.GaturroMC;
   import assets.Heart;
   import assets.MissingAssetMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.math.Random;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.service.events.gui.InvitationBallon;
   import com.qb9.gaturro.user.settings.UserSettings;
   import com.qb9.gaturro.view.world.events.CreateOwnedNpcEvent;
   import com.qb9.gaturro.world.core.avatar.GaturroUserAvatar;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.attributes.CustomAttributeHolder;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.library.Library;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import config.AdminControl;
   import config.AttributeControl;
   import config.PassportControl;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.utils.setTimeout;
   
   public final class Gaturro extends GaturroMC implements IDisposable
   {
      
      public static const EFFECT2_KEY:String = "effect2";
      
      public static const TRANSPORT_KEY:String = "transport";
      
      public static const EFFECT_KEY:String = "effect";
      
      public static const MEDAL_KEY:String = "medal";
      
      public static const EMOTE_KEY:String = "emote";
      
      private static var firstInit:Boolean = true;
      
      public static const OWNED_NPC_USER_ATTR:String = "ownednpc";
      
      public static const INTERACTION_KEY:String = "interaction";
      
      public static const ACTION_KEY:String = "action";
      
      public static const COLOR_3_KEY:String = "color3";
      
      public static const DEFAULT_EMOTE:String = "normal";
      
      public static const COLOR_1_KEY:String = "color1";
      
      public static const COLOR_2_KEY:String = "color2";
      
      public static const GATURRO_FLIPPED:String = "gaturroFlipped";
       
      
      private var userSetting:UserSettings;
      
      private var usernameDisplay:AvatarTooltipMC;
      
      private var queue:Array;
      
      public var invitationBallon:InvitationBallon;
      
      private var source:CustomAttributeHolder;
      
      private var medalAsset:MovieClip;
      
      public var action:String;
      
      private var headEffect:DisplayObject;
      
      private var _fakeGaturro:Boolean = false;
      
      private var changed:Boolean = false;
      
      private var colors1:Array;
      
      private var colors2:Array;
      
      private var colors3:Array;
      
      private var foreTransport:DisplayObject;
      
      private var children:Array;
      
      public function Gaturro(param1:CustomAttributeHolder, param2:Boolean = true)
      {
         this.queue = [];
         super();
         this.source = param1;
         this._fakeGaturro = param2;
         this.init();
      }
      
      private function updateAttributes(param1:CustomAttributesEvent) : void
      {
         var _loc2_:CustomAttribute = null;
         for each(_loc2_ in param1.attributes)
         {
            this.attempt(_loc2_.key);
         }
         this.checkIfLoaded();
      }
      
      private function setScale() : void
      {
         var _loc1_:Object = settings._tiles_;
         if(_loc1_[api.room.id.toString()])
         {
            this.scaleX = this.scaleY = _loc1_[api.room.id.toString()].gaturroSize;
         }
         else
         {
            this.scaleX = this.scaleY = _loc1_["normal"].gaturroSize;
         }
      }
      
      private function addAndIgnoreSize(param1:DisplayObject, param2:MovieClip) : void
      {
         if(this.disposed)
         {
            return;
         }
         this.lookForHideParts(param2);
         this.lookForHidePartsPacks(param2);
         DisplayUtil.empty(param2);
         if(param1.width != 0 && param1.height != 0)
         {
            if(param2.name == TRANSPORT_KEY)
            {
               this.transportForeground(param1,param2);
            }
            param2.addChild(param1 || new MissingAssetMC());
         }
         ArrayUtil.removeElement(this.queue,param2.name);
         this.checkIfLoaded();
      }
      
      private function init() : void
      {
         logger.info("setUsername : NO ESTA AQUÍ!!!!!!!!!!");
         var _loc1_:String = null;
         this.children = InternalClipUtil.gatherPlaceholders(this);
         this.initEvents();
         for(_loc1_ in this.attrs)
         {
            this.attempt(_loc1_);
         }
         this.setOwnedNpcAsset();
         this.stand();
         this.updateEmote();
         this.updateColors1();
         this.updateColors2();
         this.updateColors3();
         this.updateEffect2();
         if(!this._fakeGaturro)
         {
            this.updateInteraction();
         }
         this.setScale();
         this.cleanSpecialph();
         if(!firstInit && Boolean(this.source.attributes.effect))
         {
            this.updateEffect();
         }
         firstInit = false;
      }
      
      private function setOwnedNpcAsset() : void
      {
         var _loc1_:String = this.attrs[Gaturro.OWNED_NPC_USER_ATTR] as String;
         var _loc2_:CreateOwnedNpcEvent = new CreateOwnedNpcEvent(_loc1_);
         setTimeout(dispatchEvent,100,_loc2_);
      }
      
      public function get loaded() : Boolean
      {
         return this.queue.length === 0;
      }
      
      private function toTheMoon(param1:Event) : void
      {
         var _loc2_:DisplayObject = null;
         if(objects_ph.numChildren > 0)
         {
            _loc2_ = objects_ph.getChildAt(0);
            if((_loc2_ as MovieClip).currentFrame == (_loc2_ as MovieClip).totalFrames)
            {
               if(this.source is GaturroUserAvatar)
               {
                  api.user.attributes["effect2"] = " ";
                  api.user.attributes["action"] = " ";
                  api.changeRoom(42684,new Coord(10,5));
               }
               removeEventListener(Event.ENTER_FRAME,this.toTheMoon);
            }
         }
      }
      
      public function dispose() : void
      {
         if(!this.source)
         {
            return;
         }
         this.source.removeEventListener(CustomAttributesEvent.CHANGED,this.updateAttributes);
         this.source.removeCustomAttributeListener(ACTION_KEY,this.doAction);
         this.source.removeCustomAttributeListener(EMOTE_KEY,this.updateEmote);
         this.source.removeCustomAttributeListener(EFFECT_KEY,this.updateEffect);
         this.source.removeCustomAttributeListener(COLOR_1_KEY,this.updateColors1);
         this.source.removeCustomAttributeListener(COLOR_2_KEY,this.updateColors2);
         this.source.removeCustomAttributeListener(COLOR_3_KEY,this.updateColors3);
         this.source.removeCustomAttributeListener(OWNED_NPC_USER_ATTR,this.changeOwnedNpc);
         this.source.removeCustomAttributeListener(MEDAL_KEY,this.changeMedal);
         this.source.removeCustomAttributeListener(INTERACTION_KEY,this.updateInteraction);
         removeEventListener(Gaturro.GATURRO_FLIPPED,this.onFlipped);
         removeEventListener(Event.ENTER_FRAME,this.toTheMoon);
         this.source.removeCustomAttributeListener(EFFECT2_KEY,this.updateEffect2);
         this.children = null;
         this.colors2 = null;
         this.colors1 = null;
         this.invitationBallon = null;
         this.source = null;
         this.queue = null;
         this.foreTransport = null;
         DisplayUtil.empty(this);
      }
      
      private function setColor(param1:Array, param2:Object) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:ColorTransform = new ColorTransform();
         if(param2 is Number)
         {
            _loc3_.color = uint(param2);
         }
         for each(_loc4_ in param1)
         {
            _loc4_.transform.colorTransform = _loc3_;
         }
      }
      
      private function get disposed() : Boolean
      {
         return this.source === null;
      }
      
      private function changeMedal(param1:CustomAttributeEvent = null) : void
      {
         if(this.attrs == null)
         {
            return;
         }
         if(this.attrs.toString() == "TypeError: Error #1009: Cannot access a property or method of a null object reference.")
         {
            return;
         }
         if(this.medalAsset == null)
         {
            return;
         }
         if(Boolean(this.attrs.medal) && this.attrs.medal != "qb9")
         {
            this.medalAsset.gotoAndStop(this.attrs.medal);
         }
         else if(Boolean(this.attrs.medal) && AdminControl.isAdminUser(Object(this.source).username))
         {
            this.medalAsset.gotoAndStop(this.attrs.medal);
         }
         setTimeout(this.upgradeMedal,1200);
      }
      
      private function cleanSpecialph() : void
      {
         if(firstInit)
         {
            if(!(api.room.id == 51690416 || api.room.id == 51690472 || api.room.id == 51690473))
            {
               api.setAvatarAttribute("special_ph"," ");
            }
         }
      }
      
      private function isSameTeam() : Boolean
      {
         var _loc1_:String = api.getAvatarAttribute("teamNavidad2018") as String;
         if((this.attrs.medal as String).indexOf("supertroll") != -1 || (this.attrs.medal as String).indexOf("troll") != -1)
         {
            if(_loc1_ == "trolls")
            {
               return true;
            }
            if(_loc1_ == "papas")
            {
               return false;
            }
         }
         else if((this.attrs.medal as String).indexOf("papa") != -1 || (this.attrs.medal as String).indexOf("superpapa") != -1)
         {
            if(_loc1_ == "trolls")
            {
               return false;
            }
            if(_loc1_ == "papas")
            {
               return true;
            }
         }
         return false;
      }
      
      private function disposePartyInviteBillboard() : void
      {
         if(!this.invitationBallon)
         {
            return;
         }
         logger.info(this,"disposePartyInviteBillboard");
         this.invitationBallon.dispose();
         this.invitationBallon = null;
      }
      
      private function lookForHideParts(param1:MovieClip, param2:DisplayObject = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         if(!this._fakeGaturro)
         {
            if(!(_loc5_ = Boolean(Object(this.source).isCitizen)))
            {
               return;
            }
         }
         if(Boolean(param1) && Boolean(param1.parent))
         {
            _loc4_ = param1.parent;
         }
         if(param1.name == "transport")
         {
            return;
         }
         if(param1.name == "medal_ph")
         {
            return;
         }
         if(param2)
         {
            _loc3_ = param2.toString();
         }
         if(Boolean(_loc3_) && _loc3_.indexOf("invisible_") != -1)
         {
            if(Boolean(param1) && Boolean(_loc4_))
            {
               if(_loc4_.hasOwnProperty("brillo"))
               {
                  _loc4_.brillo.visible = false;
               }
               if(_loc4_.hasOwnProperty("contorno1"))
               {
                  _loc4_.contorno1.visible = false;
               }
               if(_loc4_.hasOwnProperty("contorno2"))
               {
                  _loc4_.contorno2.visible = false;
               }
               if(_loc4_.hasOwnProperty("color1"))
               {
                  _loc4_.color1.visible = false;
               }
               if(_loc4_.hasOwnProperty("color2"))
               {
                  _loc4_.color2.visible = false;
               }
               if(param1.name == "hats")
               {
                  if(_loc4_.hasOwnProperty("eye1"))
                  {
                     _loc4_.eye1.visible = false;
                  }
                  if(_loc4_.hasOwnProperty("eye2"))
                  {
                     _loc4_.eye2.visible = false;
                  }
                  if(_loc4_.hasOwnProperty("ears1"))
                  {
                     _loc4_.ears1.visible = false;
                  }
                  if(_loc4_.hasOwnProperty("ears2"))
                  {
                     _loc4_.ears2.visible = false;
                  }
                  if(_loc4_.hasOwnProperty("mouth1"))
                  {
                     _loc4_.mouth1.visible = false;
                  }
                  if(_loc4_.hasOwnProperty("mouth2"))
                  {
                     _loc4_.mouth2.visible = false;
                  }
                  if(_loc4_.hasOwnProperty("nose"))
                  {
                     _loc4_.nose.visible = false;
                  }
               }
            }
         }
         else if(Boolean(param1) && Boolean(_loc4_))
         {
            if(_loc4_.hasOwnProperty("brillo"))
            {
               _loc4_.brillo.visible = true;
            }
            if(_loc4_.hasOwnProperty("contorno1"))
            {
               _loc4_.contorno1.visible = true;
            }
            if(_loc4_.hasOwnProperty("contorno2"))
            {
               _loc4_.contorno2.visible = true;
            }
            if(_loc4_.hasOwnProperty("color1"))
            {
               _loc4_.color1.visible = true;
            }
            if(_loc4_.hasOwnProperty("color2"))
            {
               _loc4_.color2.visible = true;
            }
            if(param1.name == "hats")
            {
               if(_loc4_.hasOwnProperty("eye1"))
               {
                  _loc4_.eye1.visible = true;
               }
               if(_loc4_.hasOwnProperty("eye2"))
               {
                  _loc4_.eye2.visible = true;
               }
               if(_loc4_.hasOwnProperty("ears1"))
               {
                  _loc4_.ears1.visible = true;
               }
               if(_loc4_.hasOwnProperty("ears2"))
               {
                  _loc4_.ears2.visible = true;
               }
               if(_loc4_.hasOwnProperty("mouth1"))
               {
                  _loc4_.mouth1.visible = true;
               }
               if(_loc4_.hasOwnProperty("mouth2"))
               {
                  _loc4_.mouth2.visible = true;
               }
               if(_loc4_.hasOwnProperty("nose"))
               {
                  _loc4_.nose.visible = true;
               }
            }
         }
      }
      
      private function checkBabosita() : void
      {
         if(api.getAvatarAttribute("babosita") == "true")
         {
            api.setAvatarAttribute("hats","gatumemes2018/wears.babosaEspacial_on");
         }
      }
      
      private function upgradeMedal() : void
      {
         if(this.disposed)
         {
            return;
         }
         if(!this.attrs || !this.attrs.medal)
         {
            return;
         }
         if((this.attrs.medal as String).indexOf("super") != -1)
         {
            this.medalAsset.gotoAndStop("empty");
         }
         var _loc1_:int = int(api.levelManager.getLevelOfSkill(this.attrs.competitiveSkills));
         var _loc2_:Boolean = Boolean(Object(this.source).isCitizen);
         if(_loc2_)
         {
            if(this.attrs.medal == "papa" || this.attrs.medal == "troll")
            {
               this.medalAsset.gotoAndStop("super" + this.attrs.medal);
            }
         }
      }
      
      private function updateEmote(param1:Event = null) : void
      {
         var _loc2_:String = null;
         if(this.disposed)
         {
            return;
         }
         if(this.source.attributes)
         {
            _loc2_ = String(String(this.source.attributes.emote) || DEFAULT_EMOTE);
         }
         head.gotoAndStop(-1);
         head.gotoAndStop(_loc2_);
         if(param1)
         {
            this.delay(this.complete,100);
         }
      }
      
      private function onMedalFetch(param1:DisplayObject) : void
      {
         param1.scaleY = 0.7;
         param1.scaleX = 0.7;
         this.medalAsset = param1 as MovieClip;
         this.changeMedal();
         this.usernameDisplay.medal.addChild(param1);
      }
      
      public function get speed() : uint
      {
         var _loc1_:Object = this.vehicleMc;
         return Boolean(_loc1_) && "speed" in _loc1_ ? uint(_loc1_.speed) : uint(settings.avatar.speed);
      }
      
      private function complete() : void
      {
         this.stand();
         this.dispatchComplete();
      }
      
      private function initEvents() : void
      {
         this.source.addEventListener(CustomAttributesEvent.CHANGED,this.updateAttributes);
         this.source.addCustomAttributeListener(ACTION_KEY,this.doAction);
         this.source.addCustomAttributeListener(EMOTE_KEY,this.updateEmote);
         this.source.addCustomAttributeListener(EFFECT_KEY,this.updateEffect);
         this.source.addCustomAttributeListener(EFFECT2_KEY,this.updateEffect2);
         this.source.addCustomAttributeListener(COLOR_1_KEY,this.updateColors1);
         this.source.addCustomAttributeListener(COLOR_2_KEY,this.updateColors2);
         this.source.addCustomAttributeListener(COLOR_3_KEY,this.updateColors3);
         this.source.addCustomAttributeListener(OWNED_NPC_USER_ATTR,this.changeOwnedNpc);
         this.source.addCustomAttributeListener(MEDAL_KEY,this.changeMedal);
         this.source.addCustomAttributeListener(INTERACTION_KEY,this.updateInteraction);
         addEventListener(Gaturro.GATURRO_FLIPPED,this.onFlipped);
      }
      
      private function canWearPacks(param1:DisplayObject, param2:Library) : Boolean
      {
         return true;
      }
      
      private function transportForeground(param1:DisplayObject, param2:MovieClip) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc3_:MovieClip = param2.parent.getChildByName("foreground") as MovieClip;
         var _loc4_:MovieClip = param1 as MovieClip;
         if(_loc3_)
         {
            param2.parent.removeChild(_loc3_);
         }
         if(Boolean(_loc4_) && Boolean(_loc4_.getChildByName("foreground")))
         {
            _loc5_ = _loc4_.getChildByName("foreground");
         }
         if(_loc5_)
         {
            param2.parent.addChild(_loc5_);
         }
      }
      
      private function whenAssetForPlaceholderIsLoaded(param1:DisplayObject) : void
      {
         if(this.disposed)
         {
            return;
         }
         if(param1.width == 0 && param1.height == 0)
         {
            return;
         }
         if(param1.width <= 150 && param1.height <= 150)
         {
            this.cleanPlaceholder();
            objects_ph.addChild(param1 || new MissingAssetMC());
         }
      }
      
      private function transportLabel(param1:String) : String
      {
         var _loc2_:String = this.vehicleType;
         return param1 + (_loc2_ && "_") + _loc2_;
      }
      
      private function setUsername() : void
      {
         logger.info("inhabilitado ---> ¡¡IMPORTANTE DESACTIVAR EL VIEJO VISUALIZADOR DE NOMBRES PARA ACTIVAR!!");
         var _loc1_:Object = this.source as Object;
         var _loc2_:Boolean = Boolean(api.userSettings.getValue(UserSettings.USERNAMES_KEY));
         if(Boolean(_loc1_) && "username" in _loc1_)
         {
            this.usernameDisplay = new AvatarTooltipMC();
            this.usernameDisplay.container.text.text = Object(this.source).username;
            medal_ph.addChild(this.usernameDisplay);
            api.libraries.fetch("medals.oficios",this.onMedalFetch);
            this.usernameDisplay.container.visible = _loc2_;
         }
         setTimeout(this.onFlipped,1500,new Event("checkName"));
      }
      
      public function leanOver() : void
      {
         if(!this.walking)
         {
            this.state(AvatarClipState.LEAN_OVER,true);
         }
      }
      
      public function get placeholders() : Array
      {
         return this.children.concat();
      }
      
      private function cleanPlaceholder() : void
      {
         var _loc1_:DisplayObject = null;
         while(objects_ph.numChildren)
         {
            _loc1_ = objects_ph.getChildAt(0);
            DisplayUtil.stopMovieClip(_loc1_);
            objects_ph.removeChildAt(0);
         }
      }
      
      private function t() : void
      {
         this.head.addChild(this.headEffect);
      }
      
      public function get walking() : Boolean
      {
         return currentLabel === AvatarClipState.WALK || currentLabel === AvatarClipState.TRANSPORT_MOVE;
      }
      
      private function ifActionChanged(param1:Object) : void
      {
         this.action = String(param1);
         if(param1 !== currentLabel)
         {
            this.cleanPlaceholder();
            this.restoreEmote();
         }
      }
      
      private function delay(param1:Function, param2:uint = 10) : void
      {
         setTimeout(param1,param2);
      }
      
      public function swim() : void
      {
         this.state(this.hasTransport ? this.transportLabel(AvatarClipState.TRANSPORT_STAND) : AvatarClipState.NADANDO,true);
      }
      
      private function updateInteraction(param1:CustomAttributeEvent = null) : void
      {
         var interaction:String = null;
         var e:CustomAttributeEvent = param1;
         interaction = String(String(this.source.attributes[INTERACTION_KEY]) || "");
         if(!interaction || interaction == " " || interaction == "false" || interaction == "true")
         {
            if(this.invitationBallon != null)
            {
               this.invitationBallon.dispose();
               this.invitationBallon = null;
            }
            return;
         }
         if(interaction == "salvar")
         {
         }
         if(interaction == "revivir" && api.room.id != 51690360)
         {
            return;
         }
         if(!this.invitationBallon)
         {
            this.invitationBallon = new InvitationBallon(this,interaction,"interacciones.interactionInviter");
            this.invitationBallon.addEventListener(Event.ADDED,function(param1:Event):void
            {
               invitationBallon.removeEventListener(param1.type,arguments.callee);
               invitationBallon.interactionCustomize(interaction);
            });
         }
         else if(this.invitationBallon.customData != interaction)
         {
            this.invitationBallon.dispose();
            this.invitationBallon = new InvitationBallon(this,interaction,"interacciones.interactionInviter");
            this.invitationBallon.addEventListener(Event.ADDED,function(param1:Event):void
            {
               invitationBallon.removeEventListener(param1.type,arguments.callee);
               invitationBallon.interactionCustomize(interaction);
            });
         }
      }
      
      private function restoreEmote() : void
      {
         this.delay(this.conditionalEmote);
      }
      
      private function readEffect2Pandulce() : void
      {
      }
      
      public function floatar() : void
      {
         this.state(this.hasTransport ? this.transportLabel(AvatarClipState.TRANSPORT_STAND) : AvatarClipState.FLOTANDO,true);
      }
      
      public function effect() : String
      {
         this.attrs;
         if(this.attrs.effect)
         {
            return this.attrs.effect;
         }
         return "no_effect";
      }
      
      private function conditionalEmote() : void
      {
         if(!this.disposed && (this.idle || this.walking))
         {
            this.updateEmote();
         }
      }
      
      private function get vehicleType() : String
      {
         var _loc1_:MovieClip = this.vehicleMc as MovieClip;
         if(!_loc1_ || !("type" in _loc1_))
         {
            return "";
         }
         return _loc1_.type.toLowerCase();
      }
      
      override public function gotoAndStop(param1:Object, param2:String = null) : void
      {
         this.ifActionChanged(param1);
         super.gotoAndStop(param1,param2);
      }
      
      private function addEasterEgg(param1:DisplayObject) : void
      {
         var _loc2_:Array = this.source.attributes[EFFECT2_KEY].split(":");
         var _loc3_:Array = _loc2_[1].split(",");
         (param1 as Object).buildWithParams("1","1","1","1");
         (param1 as Object).bground.visible = true;
         param1.name = "Huevo";
         param1.y -= 80;
         this.head.addChild(param1);
      }
      
      private function onHeadFetch(param1:DisplayObject) : void
      {
         if(this.headEffect)
         {
            this.head.removeChild(this.headEffect);
            this.headEffect = null;
         }
         if(param1.width == 0 && param1.height == 0 || param1.width >= 300 && param1.height >= 300)
         {
            return;
         }
         this.headEffect = param1;
         setTimeout(this.t,200);
      }
      
      private function add(param1:DisplayObject, param2:MovieClip) : void
      {
         if(this.disposed)
         {
            return;
         }
         if(param1 == null)
         {
            return;
         }
         this.lookForHideParts(param2);
         this.lookForHidePartsPacks(param2);
         DisplayUtil.empty(param2);
         if(param1.width <= 300 && param1.height <= 300 && (param1.width != 0 && param1.height != 0))
         {
            if(param2.name == TRANSPORT_KEY)
            {
               this.transportForeground(param1,param2);
               if("acquireAPI" in param1)
               {
                  Object(param1).acquireAPI(api);
               }
               if("acquireObjectAPI" in param1)
               {
                  Object(param1).acquireObjectAPI(api);
               }
            }
            this.lookForHideParts(param2,param1);
            this.lookForHidePartsPacks(param2,param1);
            if(!this.canWearPacks(param1,param2.lib))
            {
               param1 = null;
            }
            param2.addChild(param1 || new MissingAssetMC());
         }
         ArrayUtil.removeElement(this.queue,param2.name);
         this.checkIfLoaded();
      }
      
      public function get attrs() : CustomAttributes
      {
         if(this.source == null)
         {
            return null;
         }
         return this.source.attributes;
      }
      
      private function onFlipped(param1:Event) : void
      {
         if(!this.usernameDisplay)
         {
            return;
         }
         if(scaleX > 0)
         {
            this.usernameDisplay.scaleX = Math.abs(this.usernameDisplay.scaleX);
         }
         else
         {
            this.usernameDisplay.scaleX = -Math.abs(this.usernameDisplay.scaleX);
         }
         var _loc2_:Boolean = Boolean(api.userSettings.getValue(UserSettings.USERNAMES_KEY));
         this.usernameDisplay.container.visible = _loc2_;
      }
      
      private function lookForHidePartsPacks(param1:MovieClip, param2:DisplayObject = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         if(param1 && param1.lib && Boolean(param1.lib.url))
         {
            _loc3_ = String(param1.lib.url);
         }
         if(Boolean(_loc3_) && _loc3_.indexOf("gatupacks") != -1)
         {
            if(Boolean(param1) && Boolean(param1.parent))
            {
               _loc5_ = param1.parent;
            }
            if(param1.name == "transport")
            {
               return;
            }
            if(param1.name == "medal_ph")
            {
               return;
            }
            if(param2)
            {
               _loc4_ = param2.toString();
            }
            if(Boolean(_loc4_) && _loc4_.indexOf("hide_") != -1)
            {
               if(Boolean(param1) && Boolean(_loc5_))
               {
                  if(_loc5_.hasOwnProperty("brillo"))
                  {
                     _loc5_.brillo.visible = false;
                  }
                  if(_loc5_.hasOwnProperty("contorno1"))
                  {
                     _loc5_.contorno1.visible = false;
                  }
                  if(_loc5_.hasOwnProperty("contorno2"))
                  {
                     _loc5_.contorno2.visible = false;
                  }
                  if(_loc5_.hasOwnProperty("color1"))
                  {
                     _loc5_.color1.visible = false;
                  }
                  if(_loc5_.hasOwnProperty("color2"))
                  {
                     _loc5_.color2.visible = false;
                  }
                  if(param1.name == "hats")
                  {
                     if(_loc5_.hasOwnProperty("eye1"))
                     {
                        _loc5_.eye1.visible = false;
                     }
                     if(_loc5_.hasOwnProperty("eye2"))
                     {
                        _loc5_.eye2.visible = false;
                     }
                     if(_loc5_.hasOwnProperty("ears1"))
                     {
                        _loc5_.ears1.visible = false;
                     }
                     if(_loc5_.hasOwnProperty("ears2"))
                     {
                        _loc5_.ears2.visible = false;
                     }
                     if(_loc5_.hasOwnProperty("mouth1"))
                     {
                        _loc5_.mouth1.visible = false;
                     }
                     if(_loc5_.hasOwnProperty("mouth2"))
                     {
                        _loc5_.mouth2.visible = false;
                     }
                     if(_loc5_.hasOwnProperty("nose"))
                     {
                        _loc5_.nose.visible = false;
                     }
                  }
               }
            }
            else
            {
               if(!this._fakeGaturro)
               {
                  if(_loc6_ = Boolean(Object(this.source).isCitizen))
                  {
                     return;
                  }
               }
               if(Boolean(param1) && Boolean(_loc5_))
               {
                  if(_loc5_.hasOwnProperty("brillo"))
                  {
                     _loc5_.brillo.visible = true;
                  }
                  if(_loc5_.hasOwnProperty("contorno1"))
                  {
                     _loc5_.contorno1.visible = true;
                  }
                  if(_loc5_.hasOwnProperty("contorno2"))
                  {
                     _loc5_.contorno2.visible = true;
                  }
                  if(_loc5_.hasOwnProperty("color1"))
                  {
                     _loc5_.color1.visible = true;
                  }
                  if(_loc5_.hasOwnProperty("color2"))
                  {
                     _loc5_.color2.visible = true;
                  }
                  if(param1.name == "hats")
                  {
                     if(_loc5_.hasOwnProperty("eye1"))
                     {
                        _loc5_.eye1.visible = true;
                     }
                     if(_loc5_.hasOwnProperty("eye2"))
                     {
                        _loc5_.eye2.visible = true;
                     }
                     if(_loc5_.hasOwnProperty("ears1"))
                     {
                        _loc5_.ears1.visible = true;
                     }
                     if(_loc5_.hasOwnProperty("ears2"))
                     {
                        _loc5_.ears2.visible = true;
                     }
                     if(_loc5_.hasOwnProperty("mouth1"))
                     {
                        _loc5_.mouth1.visible = true;
                     }
                     if(_loc5_.hasOwnProperty("mouth2"))
                     {
                        _loc5_.mouth2.visible = true;
                     }
                     if(_loc5_.hasOwnProperty("nose"))
                     {
                        _loc5_.nose.visible = true;
                     }
                  }
               }
            }
         }
      }
      
      private function doAction(param1:CustomAttributeEvent) : void
      {
         if(this.walking)
         {
            return;
         }
         var _loc2_:Array = param1.attribute.value.toString().split(".");
         if(this.source is GaturroUserAvatar && _loc2_ && _loc2_.length >= 3)
         {
            api.trackEvent("DEBUG:ACTIONS",param1.attribute.value.toString());
         }
         this.state(_loc2_.shift(),true);
         if(_loc2_.length)
         {
            libs.fetch(_loc2_.join("."),this.whenAssetForPlaceholderIsLoaded);
         }
      }
      
      private function checkDolencias() : void
      {
         var _loc1_:String = api.getAvatarAttribute("accesories") as String;
         var _loc2_:String = api.getAvatarAttribute("mouths") as String;
         var _loc3_:String = api.getAvatarAttribute("hats") as String;
         var _loc4_:String = api.getAvatarAttribute("gloveFore") as String;
         var _loc5_:String = api.getAvatarAttribute("foot") as String;
         var _loc6_:String = api.getAvatarAttribute("leg") as String;
         var _loc7_:String = api.getAvatarAttribute("arm") as String;
         if(Boolean(_loc1_) && _loc1_.indexOf("salitaMedicaDolencias") != -1)
         {
            api.setAvatarAttribute("accesories","");
         }
         if(Boolean(_loc2_) && _loc2_.indexOf("salitaMedicaDolencias") != -1)
         {
            api.setAvatarAttribute("mouths","");
         }
         if(Boolean(_loc3_) && _loc3_.indexOf("salitaMedicaDolencias") != -1)
         {
            api.setAvatarAttribute("hats","");
         }
         if(Boolean(_loc4_) && _loc4_.indexOf("salitaMedicaDolencias") != -1)
         {
            api.setAvatarAttribute("gloveFore","");
         }
         if(Boolean(_loc5_) && _loc5_.indexOf("salitaMedicaDolencias") != -1)
         {
            api.setAvatarAttribute("foot","");
         }
         if(Boolean(_loc6_) && _loc6_.indexOf("salitaMedicaDolencias") != -1)
         {
            api.setAvatarAttribute("leg","");
         }
         if(Boolean(_loc7_) && _loc7_.indexOf("salitaMedicaDolencias") != -1)
         {
            api.setAvatarAttribute("arm","");
         }
         api.setAvatarAttribute("effect","none");
      }
      
      private function checkIfLoaded() : void
      {
         if(this.changed && this.loaded)
         {
            this.changed = false;
            this.complete();
         }
      }
      
      private function setAsset(param1:MovieClip, param2:String, param3:String = null) : void
      {
         this.changed = true;
         if(param3 === null)
         {
            param3 = param2;
         }
         var _loc4_:String = this.attrs[param2] as String;
         var _loc5_:String = "";
         if("username" in this.source)
         {
            _loc5_ = String((this.source as Object).username);
         }
         if(AttributeControl.isUserProhibited(_loc5_,_loc4_))
         {
            return;
         }
         if(PassportControl.isVipPack(_loc4_))
         {
            if(this.source is UserAvatar && !(this.source as Object).isCitizen)
            {
               if(_loc5_ == api.user.username)
               {
                  api.setAvatarAttribute(param2," ");
               }
               api.showBannerModal("pasaporte3");
               return;
            }
         }
         if(_loc4_ && /\D/.test(_loc4_) && !AttributeControl.isProhibited(_loc4_))
         {
            ArrayUtil.addUnique(this.queue,param3);
            if(AttributeControl.isFree(_loc4_))
            {
               libs.fetch(_loc4_,this.addAndIgnoreSize,param1);
            }
            else
            {
               libs.fetch(_loc4_,this.add,param1);
            }
         }
         else
         {
            this.lookForHideParts(param1);
            this.lookForHidePartsPacks(param1);
            DisplayUtil.empty(param1);
         }
         if(param2 === TRANSPORT_KEY)
         {
            this.stand();
            if(getChildByName("foreground"))
            {
               removeChild(getChildByName("foreground"));
            }
         }
      }
      
      public function get hasTransport() : Boolean
      {
         return this.vehicleMc !== null || ArrayUtil.contains(this.queue,TRANSPORT_KEY);
      }
      
      public function randomDance() : void
      {
         var _loc1_:Array = ["dance","dance2","dance3","dance4","dance5","fortnite1","fortnite2"];
         var _loc2_:String = String(_loc1_[Random.randint(0,_loc1_.length - 1)]);
         this.state(this.hasTransport ? this.transportLabel(AvatarClipState.TRANSPORT_STAND) : _loc2_,true);
      }
      
      private function resetEffects() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in DisplayUtil.children(this,true))
         {
            _loc1_.visible = true;
         }
         this.alpha = 1;
         this.setScale();
      }
      
      private function updateEffect2(param1:Event = null) : void
      {
         var effect2:String;
         var parts:Array = null;
         var hasPassport:Boolean = false;
         var type:String = null;
         var e:Event = param1;
         this.resetEffects2();
         effect2 = String(String(this.source.attributes[EFFECT2_KEY]) || "");
         if(!effect2 || effect2 == " " || effect2 == "false" || effect2 == "true" || !isNaN(Number(effect2)))
         {
            return;
         }
         logger.info(this,"updateEffect2",effect2);
         parts = this.source.attributes[EFFECT2_KEY].split(":");
         if(parts.length > 1)
         {
            switch(parts[0])
            {
               case "navidad2017":
                  api.requestPanDulce(this.addPandulce);
                  break;
               case "poolInvite":
                  hasPassport = Boolean(api.hasPassportType(parts[1]));
                  if(!hasPassport && this.source is GaturroUserAvatar)
                  {
                     type = String(parts[1]);
                     type = type.substr(0,1).toUpperCase() + type.substr(1);
                     api.showBannerModal("pasaporte" + type);
                     break;
                  }
                  if(!this.invitationBallon)
                  {
                     this.invitationBallon = new InvitationBallon(this,InvitationBallon.TYPE_POOL);
                     this.invitationBallon.addEventListener(Event.ADDED,function(param1:Event):void
                     {
                        invitationBallon.removeEventListener(param1.type,arguments.callee);
                        invitationBallon.customize(parts[1]);
                     });
                     break;
                  }
                  break;
            }
         }
         switch(effect2)
         {
            case "easter2017":
               api.requestEasterEgg(this.addEasterEgg);
               break;
            case "portalGunGoToMoon":
               break;
            case "partyInvite":
               if(!this.invitationBallon)
               {
                  this.invitationBallon = new InvitationBallon(this);
               }
         }
      }
      
      private function updateColors2(param1:Event = null) : void
      {
         this.colors2 = this.colors2 || DisplayUtil.getAllByName(this,COLOR_2_KEY);
         this.setColor(this.colors2,this.source.attributes[COLOR_2_KEY]);
         this.dispatchComplete();
      }
      
      private function updateEffect(param1:Event = null) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:DisplayObjectContainer = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:Number = NaN;
         var _loc12_:MovieClip = null;
         var _loc13_:DisplayObjectContainer = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         this.resetEffects();
         var _loc2_:Array = [];
         _loc4_ = "".split(".");
         switch(_loc4_[0])
         {
            case "retro":
               _loc5_ = [0.2225,0.7169,0.0606,0,0];
               _loc5_ = _loc5_.concat(_loc5_,_loc5_,[0,0,0,1,0]);
               _loc2_.push(new ColorMatrixFilter(_loc5_));
               break;
            case "censored":
               _loc2_.push(new BlurFilter(8,8));
               break;
            case "dirty":
               _loc2_.push(new DropShadowFilter(16,45,0,0.8,8,8,1,1,true));
               break;
            case "radioactive":
               _loc4_[1] = "00FF00";
            case "glow":
               if(_loc4_.length >= 3 && _loc4_[2] == "barEspacial")
               {
                  api.setSession("barEspacialTrago",1);
               }
               _loc6_ = null;
               for each(_loc13_ in this.placeholders)
               {
                  if(_loc13_.name == _loc4_[1])
                  {
                     _loc6_ = _loc13_;
                  }
               }
               if(_loc6_)
               {
                  _loc14_ = parseInt(_loc4_[2],16);
                  this.updatePhGlow(_loc6_,_loc14_);
                  return;
               }
               if(_loc4_.length == 2)
               {
                  _loc15_ = parseInt(_loc4_[1],16);
                  _loc2_.push(new GlowFilter(_loc15_,0.7,25,25,1.5));
                  break;
               }
               ArrayUtil.removeElement(_loc4_,_loc4_[0]);
               this.updateGlow(_loc4_,0);
               return;
               break;
            case "alpha":
               if(Number(_loc4_[2]) < 15)
               {
                  _loc4_[2] = "15";
               }
               this.alpha = Number(_loc4_[1] + "." + _loc4_[2]);
               break;
            case "ghost":
               this.alpha = 0.4;
               _loc7_ = (_loc7_ = (_loc7_ = (_loc7_ = (_loc7_ = new Array()).concat([0,0.5,0.5,0,0])).concat([0,0.9,0.9,0,5])).concat([0,0,0.9,0.9,5])).concat([0,0,0,1,0]);
               _loc2_.push(new ColorMatrixFilter(_loc7_));
               break;
            case "sulfur":
               _loc8_ = (_loc8_ = (_loc8_ = (_loc8_ = (_loc8_ = new Array()).concat([0.7,0.7,0,0,2])).concat([0.7,0.7,0,0,2])).concat([0,0,0,0,0])).concat([0,0,0,1,0]);
               _loc2_.push(new ColorMatrixFilter(_loc8_));
               break;
            case "shadow":
               _loc9_ = (_loc9_ = (_loc9_ = (_loc9_ = (_loc9_ = new Array()).concat([0,0,0,0,0])).concat([0,0,0,0,0])).concat([0,0,0,0,0])).concat([0,0,0,1,0]);
               _loc2_.push(new ColorMatrixFilter(_loc9_));
               break;
            case "head":
               _loc10_ = _loc4_[1] + "." + _loc4_[2];
               if(this.source is GaturroUserAvatar)
               {
                  api.trackEvent("DEBUG:HEAD_ITEMS",_loc10_);
               }
               if(AttributeControl.isProhibitedInAction(_loc10_))
               {
                  return;
               }
               api.libraries.fetch(_loc10_,this.onHeadFetch);
               break;
            case "lookLeft":
               this.scaleX = -1;
               break;
            case "lookRight":
               this.scaleX = 1;
               break;
            case "scale":
               if((_loc11_ = parseFloat(_loc4_[1]) / 10) == 0.7 || _loc11_ == 1)
               {
                  this.scaleX = _loc11_;
                  this.scaleY = _loc11_;
                  break;
               }
               break;
            case "cleanse":
               if(this.source is GaturroUserAvatar)
               {
                  this.checkDolencias();
                  break;
               }
               break;
            case "sanValentin":
               _loc12_ = new Heart();
               _loc16_ = 0;
               while(_loc16_ < head.numChildren)
               {
                  if(head.getChildAt(_loc16_) is Heart)
                  {
                     head.removeChildAt(_loc16_);
                  }
                  _loc16_++;
               }
               this.head.addChild(_loc12_);
               if(_loc4_[1])
               {
                  trace(_loc4_[1]);
                  _loc12_.gotoAndStop(_loc4_[1]);
                  break;
               }
         }
         this.filters = _loc2_;
      }
      
      private function getTilesFromConfig(param1:int) : Object
      {
         var _loc2_:String = null;
         for(_loc2_ in settings._tiles_)
         {
            if(param1.toString() == _loc2_)
            {
               return settings._tiles_[_loc2_];
            }
         }
         return settings._tiles_.normal;
      }
      
      private function state(param1:Object, param2:Boolean) : void
      {
         if(currentLabel === param1 || currentFrame === param1)
         {
            return;
         }
         if(param2)
         {
            this.gotoAndPlay(param1);
         }
         else
         {
            this.gotoAndStop(param1);
         }
      }
      
      private function updateColors1(param1:Event = null) : void
      {
         this.colors1 = this.colors1 || DisplayUtil.getAllByName(this,COLOR_1_KEY);
         this.setColor(this.colors1,this.source.attributes[COLOR_1_KEY]);
         this.dispatchComplete();
      }
      
      public function celebrate() : void
      {
         if(!this.walking)
         {
            this.state(AvatarClipState.CELEBRATE,true);
         }
      }
      
      private function checkBabositaAttr(param1:MovieClip, param2:String, param3:String = null) : Boolean
      {
         if(param3 === null)
         {
            param3 = param2;
         }
         var _loc4_:String = this.attrs[param2] as String;
         if(param2 == "hats" && _loc4_ != "gatumemes2018/wears.babosaEspacial_on" && api.getAvatarAttribute("babosita") == "true")
         {
            return true;
         }
         return false;
      }
      
      private function updateColors3(param1:Event = null) : void
      {
         var _loc4_:Boolean = false;
         var _loc2_:* = this.source.attributes[COLOR_3_KEY];
         var _loc3_:ColorTransform = new ColorTransform();
         if(_loc2_ == null)
         {
            _loc2_ = 16777215;
         }
         if(!this._fakeGaturro)
         {
            if(_loc4_ = Boolean(Object(this.source).isCitizen))
            {
               _loc3_.color = _loc2_;
            }
            else
            {
               _loc3_.color = 16777215;
            }
         }
         else
         {
            _loc3_.color = _loc2_;
         }
         (this.head.eye2.colorEye as MovieClip).transform.colorTransform = _loc3_;
         (this.head.eye1.colorEye as MovieClip).transform.colorTransform = _loc3_;
         this.dispatchComplete();
      }
      
      public function dance() : void
      {
         this.state(this.hasTransport ? this.transportLabel(AvatarClipState.TRANSPORT_STAND) : AvatarClipState.DANCE,true);
      }
      
      private function changeOwnedNpc(param1:CustomAttributeEvent) : void
      {
         this.setOwnedNpcAsset();
      }
      
      private function attempt(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         if(param1 === ACTION_KEY || param1 === EMOTE_KEY || param1 === EFFECT_KEY || param1 === EFFECT2_KEY || param1 === COLOR_1_KEY || param1 === COLOR_2_KEY)
         {
            return;
         }
         for each(_loc2_ in this.children)
         {
            if(_loc2_.name === param1)
            {
               this.setAsset(_loc2_,param1);
            }
            else if(_loc2_.name === param1 + "Fore" || _loc2_.name === param1 + "Back")
            {
               this.setAsset(_loc2_,param1,_loc2_.name);
            }
         }
      }
      
      private function updatePhGlow(param1:DisplayObjectContainer, param2:int) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Array = null;
         if(param1.numChildren > 0)
         {
            _loc3_ = param1.getChildAt(0);
            _loc4_ = [new GlowFilter(param2,0.7,25,25,1.5)];
            _loc3_.filters = _loc4_;
         }
         else
         {
            setTimeout(this.updatePhGlow,500,param1,param2);
         }
      }
      
      override public function gotoAndPlay(param1:Object, param2:String = null) : void
      {
         this.ifActionChanged(param1);
         super.gotoAndPlay(param1,param2);
      }
      
      public function walk() : void
      {
         this.state(this.hasTransport ? this.transportLabel(AvatarClipState.TRANSPORT_MOVE) : AvatarClipState.WALK,true);
      }
      
      private function dispatchComplete() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get idle() : Boolean
      {
         return currentLabel === AvatarClipState.STAND || currentLabel === AvatarClipState.TRANSPORT_STAND;
      }
      
      public function sad() : void
      {
         if(!this.walking)
         {
            this.state(AvatarClipState.SAD,true);
         }
      }
      
      private function updateAttribute(param1:CustomAttributeEvent) : void
      {
         this.attempt(param1.attribute.key);
      }
      
      public function stand() : void
      {
         this.state(this.hasTransport ? this.transportLabel(AvatarClipState.TRANSPORT_STAND) : AvatarClipState.STAND,false);
      }
      
      private function resetEffects2() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObject = null;
         logger.info(this,"resetEffects2");
         var _loc1_:int = 0;
         while(_loc1_ < head.numChildren)
         {
            _loc2_ = head.getChildAt(_loc1_);
            if(_loc2_.name == "Huevo")
            {
               head.removeChildAt(_loc1_);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < arm1.gripFore.numChildren)
         {
            _loc3_ = arm1.gripFore.getChildAt(_loc1_);
            if(_loc3_.name == "Huevo")
            {
               arm1.gripFore.removeChildAt(_loc1_);
            }
            _loc1_++;
         }
         this.disposePartyInviteBillboard();
      }
      
      private function addPandulce(param1:DisplayObject) : void
      {
         var _loc2_:Array = this.source.attributes[EFFECT2_KEY].split(":");
         var _loc3_:Array = _loc2_[1].split(",");
         (param1 as Object).buildWithParams("1","1","1","1");
         param1.name = "Huevo";
         param1.scaleX = param1.scaleY = 1;
         param1.scaleX = param1.scaleY = 0.2;
         param1.rotation -= 90;
         param1.visible = true;
         this.arm1.gripFore.addChild(param1);
      }
      
      private function get vehicleMc() : DisplayObject
      {
         var _loc1_:DisplayObject = null;
         if(transport === null)
         {
            logger.warning("transport was null within Gaturro.as");
            return null;
         }
         if(transport.numChildren === 0)
         {
            return null;
         }
         return transport.getChildAt(0);
      }
      
      private function updateGlow(param1:Array, param2:int) : void
      {
         if(!this.source || !this.source.attributes || !this.source.attributes.effect)
         {
            return;
         }
         var _loc3_:Array = this.source.attributes.effect.split(".");
         if(_loc3_[0] != "glow")
         {
            return;
         }
         var _loc4_:int = parseInt(param1[param2],16);
         var _loc5_:Array = [new GlowFilter(_loc4_,0.7,25,25,1.5)];
         this.filters = _loc5_;
         param2++;
         if(param2 >= param1.length)
         {
            param2 = 0;
         }
         setTimeout(this.updateGlow,3000,param1,param2);
      }
      
      public function cleanInfoLayer() : void
      {
         var _loc1_:Sprite = api.roomView.infoLayer;
         while(_loc1_.numChildren > 0)
         {
            _loc1_.removeChildAt(0);
         }
      }
   }
}
