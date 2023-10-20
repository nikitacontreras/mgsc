package com.qb9.gaturro.world.core.avatar.pet
{
   import com.qb9.flashlib.math.Random;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.inventory.PetCareSceneObject;
   import com.qb9.gaturro.user.inventory.PetFoodSceneObject;
   import com.qb9.gaturro.user.inventory.PetToySceneObject;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.avatars.PetMovieClip;
   import com.qb9.gaturro.world.collection.NpcScriptList;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.attributes.delegate.CustomAttributesDelegate;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mambo.world.tiling.TileGrid;
   import flash.utils.clearInterval;
   
   public class AvatarPet extends NpcRoomSceneObject
   {
      
      public static const COLOR:String = "pet_color";
      
      public static const RESPONSE_THANKS:int = 1;
      
      public static const NAME:String = "penguin";
      
      public static const RESPONSE_FULL:int = 3;
      
      public static const COLOR_PREFIX:String = "color";
      
      public static const COLOR2:String = "color2";
      
      public static const COLOR4:String = "color4";
      
      public static const PREFIX:String = "pet_";
      
      public static const RESPONSE_NOT_WANT_SUPER_COOKIE:int = 4;
      
      public static const COLOR1:String = "color1";
      
      public static const COLOR3:String = "color3";
      
      private static const HOME_KEY:String = "home";
      
      public static const PET_HOME:String = PREFIX + HOME_KEY;
      
      private static const PET_CLOTHES:Array = ["pet_accesories","pet_hats","pet_neck","pet_cloth","pet_arm","pet_leg"];
      
      private static const ALIVE_KEY:String = "alive";
      
      public static const RESPONSE_NO_FOR_ME:int = 2;
      
      public static const HAS_PET:String = PREFIX + ALIVE_KEY;
       
      
      private var net:NetworkManager;
      
      private var _powerLevel:int = 0;
      
      private var _witLevel:int = 0;
      
      private var _glamorLevel:int = 0;
      
      private var _petType:String;
      
      private var intervalId:uint;
      
      private var lastTick:uint;
      
      private var _avatar:Avatar;
      
      public function AvatarPet(param1:TileGrid, param2:Avatar, param3:NpcScriptList, param4:NetworkManager)
      {
         this.net = param4;
         this._avatar = param2;
         var _loc5_:CustomAttributes = new CustomAttributesDelegate(PREFIX,param2,this);
         this._petType = String(_loc5_.type) || "penguin";
         if(this.isMyPet)
         {
            if(_loc5_.type == null)
            {
               this.adapt(_loc5_);
            }
            if(_loc5_.signo == null || _loc5_.signo == "")
            {
               this.asignSign(_loc5_);
            }
            if(user.attributes.pet_qty == null)
            {
               this.adaptQty(_loc5_);
            }
         }
         super(_loc5_,param1,param3);
         this.init();
         if(this.isMyPet)
         {
            this.executeStatus(_loc5_);
            this.calculatePowerLevel();
            this.calculateWitLevel();
            this.calculateGlamorLevel();
         }
      }
      
      private function asignSign(param1:CustomAttributes) : void
      {
         var _loc2_:int = Random.randint(1,12);
         var _loc3_:Object = {"signo":_loc2_};
         param1.mergeObject(_loc3_);
      }
      
      private function level(param1:Number) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < settings.petAttrLevels.length)
         {
            if(param1 < settings.petAttrLevels[_loc2_])
            {
               return _loc2_ + 1;
            }
            _loc2_++;
         }
         return settings.petAttrLevels.length + 1;
      }
      
      private function calculatePowerLevel() : void
      {
         this._powerLevel = this.level(attributes.power);
      }
      
      public function get energy() : int
      {
         return this.get(PetMovieClip.ENERGY_KEY);
      }
      
      private function setEnergy(param1:int) : void
      {
         this.set(PetMovieClip.ENERGY_KEY,param1);
      }
      
      override public function get name() : String
      {
         return NAME;
      }
      
      private function init() : void
      {
         this.build();
      }
      
      public function get state() : int
      {
         if(this.energy < 100)
         {
            return AvatarPetState.HUNGRY;
         }
         if(this.love < 100)
         {
            return AvatarPetState.SAD;
         }
         if(this.cleanliness < 100)
         {
            return AvatarPetState.DIRTY;
         }
         return AvatarPetState.SATISFIED;
      }
      
      private function setCleanliness(param1:int) : void
      {
         this.set(PetMovieClip.CLEANLINESS_KEY,param1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._avatar = null;
         this.net = null;
         this.stopConsumption();
      }
      
      private function adapt(param1:CustomAttributes) : void
      {
         var _loc2_:Object = {
            "type":this._petType,
            "love":this.data.initialLove,
            "cleanliness":this.data.initialCleanliness
         };
         if(param1.alive == null)
         {
            _loc2_["alive"] = false;
            _loc2_["home"] = false;
         }
         param1.mergeObject(_loc2_);
      }
      
      public function feed(param1:PetFoodSceneObject) : int
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         if(param1.forPetType != "" && param1.forPetType != this._petType)
         {
            return RESPONSE_NO_FOR_ME;
         }
         if(this.energy >= this.data.maxEnergy)
         {
            return RESPONSE_FULL;
         }
         if(param1.superCookies)
         {
            _loc2_ = this.get("superCookie");
            _loc3_ = new Date().getTime() / 1000 / 60 / 60 / 24;
            if(_loc2_ != 0 && _loc3_ - _loc2_ < 0.25)
            {
               return RESPONSE_NOT_WANT_SUPER_COOKIE;
            }
            _loc4_ = {
               "superCookie":_loc3_,
               "superCookieType":param1.superCookiesType
            };
            attributes.mergeObject(_loc4_);
         }
         this.setEnergy(Math.min(this.energy + param1.energy,this.data.maxEnergy));
         this.set(PetMovieClip.FOOD_KEY,param1.name);
         return RESPONSE_THANKS;
      }
      
      private function executeNeeds(param1:Number) : void
      {
         var _loc2_:Number = param1 * 24 * 60;
         var _loc3_:Number = this.data.energyLostPerMinute * _loc2_;
         var _loc4_:Number = this.data.loveLostPerMinute * _loc2_;
         var _loc5_:Number = this.data.cleanlinessLostPerMinute * _loc2_;
         this.setEnergy(Math.max(this.energy - _loc3_,0));
         this.setLove(Math.max(this.love - _loc4_,0));
         this.setCleanliness(Math.max(this.cleanliness - _loc5_,0));
      }
      
      public function get data() : Object
      {
         return settings[this._petType];
      }
      
      private function progress(param1:Number) : Number
      {
         var _loc2_:int = this.level(param1);
         var _loc3_:int = _loc2_ - 2;
         if(_loc3_ >= settings.petAttrLevels.length || _loc3_ + 1 >= settings.petAttrLevels.length)
         {
            return 1;
         }
         var _loc4_:Number = Number(settings.petAttrLevels[_loc3_]);
         var _loc5_:Number = Number(settings.petAttrLevels[_loc3_ + 1]);
         return (param1 - _loc4_) / (_loc5_ - _loc4_);
      }
      
      public function get cleanlinessRatio() : Number
      {
         return this.cleanliness / this.data.maxCleanliness;
      }
      
      public function get witProgress() : Number
      {
         return this.progress(attributes.wit);
      }
      
      public function get atHome() : Boolean
      {
         return this.get(HOME_KEY);
      }
      
      private function adaptQty(param1:CustomAttributes) : void
      {
         var _loc2_:int = 0;
         if(param1.alive == true)
         {
            _loc2_ = 1;
         }
         user.attributes.pet_qty = _loc2_;
      }
      
      public function get loveRatio() : Number
      {
         return this.love / this.data.maxLove;
      }
      
      public function get sign() : int
      {
         return attributes.signo;
      }
      
      public function get glamorProgress() : Number
      {
         return this.progress(attributes.glamor);
      }
      
      public function feedEnergy(param1:int) : void
      {
         this.setEnergy(this.energy + param1);
         this.set(Gaturro.ACTION_KEY,AvatarPetState.EATING);
      }
      
      private function executeStatus(param1:CustomAttributes) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:Number = this.get("check");
         var _loc3_:Number = new Date().getTime() / 1000 / 60 / 60 / 24;
         if(_loc2_ > 0)
         {
            if((_loc5_ = _loc3_ - _loc2_) <= 0.15)
            {
               return;
            }
            this.executeNeeds(_loc5_);
            this.executePetAttributes(_loc5_,_loc3_,param1);
         }
         var _loc4_:Object = {"check":_loc3_};
         param1.mergeObject(_loc4_);
      }
      
      private function calculateWitLevel() : void
      {
         this._witLevel = this.level(attributes.wit);
      }
      
      private function get isMyPet() : Boolean
      {
         return this._avatar.username == user.username;
      }
      
      public function get petName() : String
      {
         return String(attributes.name) || "";
      }
      
      private function calculateGlamorLevel() : void
      {
         this._glamorLevel = this.level(attributes.glamor);
      }
      
      public function get alive() : Boolean
      {
         return this.get(ALIVE_KEY);
      }
      
      public function clean(param1:PetCareSceneObject) : int
      {
         if(this.cleanliness >= this.data.maxCleanliness)
         {
            return RESPONSE_FULL;
         }
         this.setCleanliness(Math.min(this.cleanliness + param1.cleanliness,this.data.maxCleanliness));
         this.set(PetMovieClip.CARE_KEY,param1.name);
         return RESPONSE_THANKS;
      }
      
      public function get witLevel() : int
      {
         return this._witLevel;
      }
      
      public function get powerProgress() : Number
      {
         return this.progress(attributes.power);
      }
      
      private function get(param1:String) : *
      {
         return attributes[param1];
      }
      
      public function get avatar() : Avatar
      {
         return this._avatar;
      }
      
      private function stopConsumption() : void
      {
         clearInterval(this.intervalId);
      }
      
      public function get type() : String
      {
         return this._petType;
      }
      
      public function get cleanliness() : int
      {
         return this.get(PetMovieClip.CLEANLINESS_KEY);
      }
      
      public function adore(param1:PetToySceneObject) : int
      {
         if(this.love >= this.data.maxLove)
         {
            return RESPONSE_FULL;
         }
         this.setLove(Math.min(this.love + param1.love,this.data.maxLove));
         this.set(PetMovieClip.TOY_KEY,param1.name);
         return RESPONSE_THANKS;
      }
      
      private function executePetAttributes(param1:Number, param2:Number, param3:CustomAttributes) : void
      {
         var _loc4_:Number = param1;
         var _loc5_:Number = this.loveRatio >= 0.25 ? 1 : 0;
         var _loc6_:Number = this.cleanlinessRatio >= 0.25 && this.energyRatio >= 0.25 ? 1 : 0;
         var _loc7_:Number = this.get("superCookie");
         var _loc8_:String = this.get("superCookieType");
         var _loc9_:int = _loc7_ > 0 && param2 - _loc7_ <= 1 && _loc8_ == "power" ? 1 : 0;
         var _loc10_:int = _loc7_ > 0 && param2 - _loc7_ <= 1 && _loc8_ == "wit" ? 1 : 0;
         var _loc11_:int = _loc7_ > 0 && param2 - _loc7_ <= 1 && _loc8_ == "glamor" ? 1 : 0;
         var _loc12_:Number = (10 * _loc5_ + 10 * _loc6_ + 20 * _loc9_ + 15 * settings.petSignAttr[param3.signo - 1][0] * _loc6_ + 20 * this.data.speciesAttrValues[0] * _loc6_) * _loc4_;
         var _loc13_:Number = (10 * _loc5_ + 10 * _loc6_ + 20 * _loc10_ + 15 * settings.petSignAttr[param3.signo - 1][1] * _loc6_ + 20 * this.data.speciesAttrValues[1] * _loc6_) * _loc4_;
         var _loc14_:Number = (10 * _loc5_ + 10 * _loc6_ + 20 * _loc11_ + 15 * settings.petSignAttr[param3.signo - 1][2] * _loc6_ + 20 * this.data.speciesAttrValues[2] * _loc6_) * _loc4_;
         var _loc15_:Number = this.get("power");
         var _loc16_:Number = this.get("wit");
         var _loc17_:Number = this.get("glamor");
         _loc15_ += _loc12_;
         _loc16_ += _loc13_;
         _loc17_ += _loc14_;
         _loc15_ = _loc15_ < 0 ? 0 : _loc15_;
         _loc16_ = _loc16_ < 0 ? 0 : _loc16_;
         _loc17_ = _loc17_ < 0 ? 0 : _loc17_;
         var _loc18_:Object = {
            "power":_loc15_,
            "wit":_loc16_,
            "glamor":_loc17_
         };
         param3.mergeObject(_loc18_);
      }
      
      public function get energyRatio() : Number
      {
         return this.energy / this.data.maxEnergy;
      }
      
      public function set atHome(param1:Boolean) : void
      {
         return this.set(HOME_KEY,param1);
      }
      
      private function set(param1:String, param2:Object) : void
      {
         attributes[param1] = param2;
      }
      
      public function get color() : int
      {
         return this.get(COLOR);
      }
      
      private function build() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Coord = null;
         var _loc5_:Tile = null;
         _id = this.avatar.id;
         _size = this.avatar.size;
         var _loc1_:Coord = this.avatar.coord;
         var _loc2_:int = -1;
         while(_loc2_ <= 1)
         {
            _loc3_ = -1;
            while(_loc3_ <= 1)
            {
               _loc4_ = _loc1_.add(_loc2_,_loc3_);
               if((_loc5_ = coordToTile(_loc4_)) && !_loc5_.blocked && !_loc5_.blockedByChildren)
               {
                  return setCoord(_loc4_);
               }
               _loc3_++;
            }
            _loc2_++;
         }
         setCoord(this.avatar.coord);
      }
      
      public function get love() : int
      {
         return this.get(PetMovieClip.LOVE_KEY);
      }
      
      public function get glamorLevel() : int
      {
         return this._glamorLevel;
      }
      
      private function setLove(param1:int) : void
      {
         this.set(PetMovieClip.LOVE_KEY,param1);
      }
      
      override public function get behaviorName() : String
      {
         return this.atHome ? "pet" + this._petType + "Home" : "pet" + this._petType;
      }
      
      public function get powerLevel() : int
      {
         return this._powerLevel;
      }
   }
}
