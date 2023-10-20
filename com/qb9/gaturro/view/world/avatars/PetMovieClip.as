package com.qb9.gaturro.view.world.avatars
{
   import assets.DragonMC;
   import assets.KoalaMC;
   import assets.MissingAssetMC;
   import assets.MonkeyMC;
   import assets.MulitaMC;
   import assets.PenguinMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.world.core.avatar.pet.AvatarPet;
   import com.qb9.gaturro.world.core.avatar.pet.AvatarPetState;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.attributes.CustomAttributeHolder;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   
   public final class PetMovieClip extends MovieClip implements IDisposable
   {
      
      public static const WIT_KEY:String = "wit";
      
      private static const DEFAULT_FOOD:String = "fishes.fish1";
      
      public static const ENERGY_KEY:String = "energy";
      
      public static const CARE_KEY:String = "care";
      
      private static const DEFAULT_TOY:String = "petToys.peine1";
      
      public static const NEGATION_KEY:String = "negation";
      
      public static const FOOD_KEY:String = "food";
      
      private static const DEFAULT_CARE:String = "petCare.jabon1";
      
      public static const LOVE_KEY:String = "love";
      
      public static const POWER_KEY:String = "power";
      
      private static const ACTION_KEY:String = Gaturro.ACTION_KEY;
      
      public static const GLAMOR_KEY:String = "glamor";
      
      public static const CLEANLINESS_KEY:String = "cleanliness";
      
      public static const TOY_KEY:String = "toy";
       
      
      private var colors1:Array;
      
      private var colors2:Array;
      
      private var colors3:Array;
      
      private var colors4:Array;
      
      public var _type:String;
      
      private var source:CustomAttributeHolder;
      
      private var colors:Array;
      
      private var _asset:MovieClip;
      
      private var _petType:String;
      
      private var children:Array;
      
      public function PetMovieClip(param1:CustomAttributeHolder, param2:String = null)
      {
         super();
         this.source = param1;
         this._petType = param2;
         this._asset = this._getAssetByType(param1.attributes["type"]);
         addChild(this._asset);
         this.init();
      }
      
      private function updateAttributes(param1:CustomAttributesEvent) : void
      {
         var _loc2_:CustomAttribute = null;
         for each(_loc2_ in param1.attributes)
         {
            this.attempt(_loc2_.key);
         }
      }
      
      private function petActionChange(param1:CustomAttributeEvent) : void
      {
         if(!this.isIdle)
         {
            return;
         }
         switch(param1.attribute.value)
         {
            case AvatarPetState.EATING:
               this.eat(DEFAULT_FOOD);
               break;
            case AvatarPetState.PLAYING:
               this.haveFun(DEFAULT_TOY);
               break;
            case AvatarPetState.CLEANING:
               this.clean(DEFAULT_CARE);
         }
      }
      
      private function lovePet(param1:CustomAttributeEvent) : void
      {
         var _loc2_:String = param1.attribute.value as String;
         if(_loc2_)
         {
            this.haveFun(_loc2_);
         }
      }
      
      private function carePet(param1:CustomAttributeEvent) : void
      {
         var _loc2_:String = param1.attribute.value as String;
         if(_loc2_)
         {
            this.clean(_loc2_);
         }
      }
      
      override public function gotoAndPlay(param1:Object, param2:String = null) : void
      {
         this._asset.gotoAndPlay(param1);
      }
      
      private function init() : void
      {
         this.children = InternalClipUtil.gatherPlaceholders(this._asset);
         this.colors = DisplayUtil.getAllByName(this._asset,AvatarPet.COLOR);
         this.colors1 = DisplayUtil.getAllByName(this._asset,AvatarPet.COLOR1);
         this.colors2 = DisplayUtil.getAllByName(this._asset,AvatarPet.COLOR2);
         this.colors3 = DisplayUtil.getAllByName(this._asset,AvatarPet.COLOR3);
         this.colors4 = DisplayUtil.getAllByName(this._asset,AvatarPet.COLOR4);
         this.evalColor();
         this.initClothes();
         this.initEvents();
         if(this.pet)
         {
            this.idle();
         }
      }
      
      private function petStateChange(param1:Event) : void
      {
         if(this.isIdle)
         {
            this.idle();
         }
      }
      
      private function whenTheFoodIsLoaded(param1:DisplayObject) : void
      {
         DisplayUtil.empty(this._asset.food);
         this._asset.food.addChild(param1);
         this._asset.gotoAndPlay(AvatarClipState.EAT);
      }
      
      public function idle() : void
      {
         if(this.currentLabel == AvatarClipState.EAT || this.currentLabel == AvatarClipState.PLAY || this.currentLabel == AvatarClipState.CLEAN)
         {
            return;
         }
         if(!this.pet || this.pet.state === AvatarPetState.SATISFIED)
         {
            this._asset.gotoAndStop(AvatarClipState.STAND);
         }
         else if(this.pet.state == AvatarPetState.HUNGRY)
         {
            this._asset.gotoAndPlay(AvatarClipState.HUNGRY);
         }
         else if(this.pet.state == AvatarPetState.SAD)
         {
            this._asset.gotoAndPlay(AvatarClipState.SAD);
         }
         else if(this.pet.state == AvatarPetState.DIRTY)
         {
            this._asset.gotoAndPlay(AvatarClipState.DIRTY);
         }
      }
      
      override public function gotoAndStop(param1:Object, param2:String = null) : void
      {
         if(param1 === AvatarClipState.STAND)
         {
            this.idle();
         }
         else
         {
            this._asset.gotoAndStop(param1);
         }
      }
      
      private function eatFish(param1:CustomAttributeEvent) : void
      {
         var _loc2_:String = param1.attribute.value as String;
         if(_loc2_)
         {
            this.eat(_loc2_);
         }
      }
      
      private function initEvents() : void
      {
         this.source.addCustomAttributeListener(FOOD_KEY,this.eatFish);
         this.source.addCustomAttributeListener(CARE_KEY,this.carePet);
         this.source.addCustomAttributeListener(TOY_KEY,this.lovePet);
         this.source.addCustomAttributeListener(NEGATION_KEY,this.negation);
         this.source.addCustomAttributeListener(ENERGY_KEY,this.petStateChange);
         this.source.addCustomAttributeListener(AvatarPet.COLOR,this.evalColor);
         this.source.addCustomAttributeListener(ACTION_KEY,this.petActionChange);
         this.source.addEventListener(CustomAttributesEvent.CHANGED,this.updateAttributes);
      }
      
      private function attempt(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         if(param1 === ACTION_KEY || param1 === AvatarPet.COLOR)
         {
            return;
         }
         if(param1 === "arm")
         {
            this.setAsset(this._asset.brazo1.pet_arm,"arm");
            this.setAsset(this._asset.brazo2.pet_arm,"arm");
         }
         else if(param1 === "leg")
         {
            this.setAsset(this._asset.pata1.pet_leg,"leg");
            this.setAsset(this._asset.pata2.pet_leg,"leg");
         }
         else if(param1 === "cloth")
         {
            this.setAsset(this._asset.panza.pet_cloth,"cloth");
         }
         else
         {
            for each(_loc2_ in this.children)
            {
               if(_loc2_.name === param1)
               {
                  this.setAsset(_loc2_,param1);
               }
            }
         }
      }
      
      public function get isIdle() : Boolean
      {
         return !this.pet || this.pet.nextTile === null;
      }
      
      private function get pet() : AvatarPet
      {
         return this.source as AvatarPet;
      }
      
      public function walk() : void
      {
         this._asset.gotoAndPlay(AvatarClipState.WALK);
      }
      
      private function whenTheCareIsLoaded(param1:DisplayObject) : void
      {
         DisplayUtil.empty(this._asset.food);
         this._asset.food.addChild(param1);
         this._asset.gotoAndPlay(AvatarClipState.CLEAN);
      }
      
      private function negation(param1:CustomAttributeEvent) : void
      {
         this._asset.gotoAndPlay(AvatarClipState.NEGATION);
      }
      
      public function dispose() : void
      {
         if(!this.source)
         {
            return;
         }
         this.children = null;
         this.colors = null;
         this._asset = null;
         this.source.removeCustomAttributeListener(FOOD_KEY,this.eatFish);
         this.source.removeCustomAttributeListener(CARE_KEY,this.carePet);
         this.source.removeCustomAttributeListener(TOY_KEY,this.lovePet);
         this.source.removeCustomAttributeListener(NEGATION_KEY,this.negation);
         this.source.removeCustomAttributeListener(ENERGY_KEY,this.petStateChange);
         this.source.removeCustomAttributeListener(ACTION_KEY,this.petActionChange);
         this.source.removeCustomAttributeListener(AvatarPet.COLOR,this.evalColor);
         this.source.removeEventListener(CustomAttributesEvent.CHANGED,this.updateAttributes);
         this.source = null;
      }
      
      private function initClothes() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.source.attributes)
         {
            this.attempt(_loc1_);
         }
      }
      
      private function add(param1:DisplayObject, param2:MovieClip) : void
      {
         if(!this.source)
         {
            return;
         }
         DisplayUtil.empty(param2);
         param2.addChild(param1 || new MissingAssetMC());
      }
      
      private function _getAssetByType(param1:String) : MovieClip
      {
         switch(this._petType)
         {
            case "penguin":
               return new PenguinMC();
            case "mulita":
               return new MulitaMC();
            case "mono":
               return new MonkeyMC();
            case "koala":
               return new KoalaMC();
            case "dragon":
               return new DragonMC();
            default:
               return new PenguinMC();
         }
      }
      
      private function clean(param1:String) : void
      {
         libs.fetch(param1,this.whenTheCareIsLoaded);
      }
      
      private function eat(param1:String) : void
      {
         libs.fetch(param1,this.whenTheFoodIsLoaded);
      }
      
      private function evalColor(param1:Event = null) : void
      {
         var _loc2_:ColorTransform = new ColorTransform();
         if(this.source.attributes.color)
         {
            _loc2_.color = this.source.attributes.color;
         }
         var _loc3_:DisplayObject = null;
         for each(_loc3_ in this.colors)
         {
            _loc3_.transform.colorTransform = _loc2_;
         }
         _loc2_ = new ColorTransform();
         if(this.source.attributes.color1)
         {
            _loc2_.color = this.source.attributes.color1;
         }
         for each(_loc3_ in this.colors1)
         {
            _loc3_.transform.colorTransform = _loc2_;
         }
         _loc2_ = new ColorTransform();
         if(this.source.attributes.color2)
         {
            _loc2_.color = this.source.attributes.color2;
         }
         for each(_loc3_ in this.colors2)
         {
            _loc3_.transform.colorTransform = _loc2_;
         }
         _loc2_ = new ColorTransform();
         if(this.source.attributes.color3)
         {
            _loc2_.color = this.source.attributes.color3;
         }
         for each(_loc3_ in this.colors3)
         {
            _loc3_.transform.colorTransform = _loc2_;
         }
         _loc2_ = new ColorTransform();
         if(this.source.attributes.color4)
         {
            _loc2_.color = this.source.attributes.color4;
         }
         for each(_loc3_ in this.colors4)
         {
            _loc3_.transform.colorTransform = _loc2_;
         }
      }
      
      private function setAsset(param1:MovieClip, param2:String) : void
      {
         var _loc3_:String = this.source.attributes[param2] as String;
         if(_loc3_)
         {
            libs.fetch(_loc3_,this.add,param1);
         }
         else
         {
            DisplayUtil.empty(param1);
         }
      }
      
      private function haveFun(param1:String) : void
      {
         libs.fetch(param1,this.whenTheToyIsLoaded);
      }
      
      override public function get currentLabel() : String
      {
         return this._asset.currentLabel;
      }
      
      private function whenTheToyIsLoaded(param1:DisplayObject) : void
      {
         DisplayUtil.empty(this._asset.food);
         this._asset.food.addChild(param1);
         this._asset.gotoAndPlay(AvatarClipState.PLAY);
      }
   }
}
