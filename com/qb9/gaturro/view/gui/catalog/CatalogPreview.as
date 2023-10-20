package com.qb9.gaturro.view.gui.catalog
{
   import assets.*;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.user.inventory.PetInventorySceneObject;
   import com.qb9.gaturro.user.inventory.UsableInventorySceneObject;
   import com.qb9.gaturro.user.inventory.WearableInventorySceneObject;
   import com.qb9.gaturro.util.StubAttributeHolder;
   import com.qb9.gaturro.view.gui.catalog.items.CatalogModalItemView;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.avatars.PetMovieClip;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import com.qb9.gaturro.world.core.avatar.pet.AvatarPet;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.attributes.delegate.CustomAttributesDelegate;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mines.mobject.MobjectCreator;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.setTimeout;
   
   public final class CatalogPreview implements IDisposable
   {
       
      
      private var petMovieClip:PetMovieClip;
      
      private var avatar:UserAvatar;
      
      private var _options:Object;
      
      private var avatarHolder:StubAttributeHolder;
      
      private var petHolder:StubAttributeHolder;
      
      private var asset:MovieClip;
      
      private var gaturro:Gaturro;
      
      private var firstLoad:Boolean = true;
      
      public function CatalogPreview(param1:MovieClip, param2:UserAvatar, param3:Object)
      {
         super();
         this.asset = param1;
         this.avatar = param2;
         this._options = param3;
         this.init();
         if(param3 == null)
         {
            this._options = {};
         }
         else
         {
            this._options = param3;
         }
      }
      
      private function replaceText(param1:String, param2:String, param3:String) : String
      {
         while(param1.indexOf(param2,1) >= 0)
         {
            param1 = param1.replace(param2,param3);
         }
         return param1;
      }
      
      private function updateAvatarHolder(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc2_:Object = param1.providedAttributes;
         if(this.avatarHolder)
         {
            for(_loc3_ in this.avatar.attributes)
            {
               if(!(_loc3_ in _loc2_))
               {
                  if(this.avatarHolder.attributes[_loc3_] !== this.avatar.attributes[_loc3_])
                  {
                     this.avatarHolder.attributes[_loc3_] = this.avatar.attributes[_loc3_];
                  }
               }
            }
         }
         else
         {
            this.avatarHolder = StubAttributeHolder.fromHolder(this.avatar);
         }
         this.avatarHolder.attributes.mergeObject(_loc2_,true);
      }
      
      private function addWallOrFloorToPreview(param1:DisplayObject, param2:Object) : void
      {
         param2["lookFor"](param2.stage);
         param2.alpha = 1;
         this.asset.visible = true;
      }
      
      private function init() : void
      {
         this.asset.visible = false;
         region.setText(this.asset.buy.text,"COMPRAR");
         if(this._options != null && this._options.currency != null)
         {
            this.asset.currency_sign.gotoAndStop(this._options.currency);
         }
      }
      
      public function dispose() : void
      {
         if(this.petHolder)
         {
            this.petHolder.dispose();
         }
         this.petHolder = null;
         if(this.petMovieClip)
         {
            this.petMovieClip.dispose();
         }
         this.petMovieClip = null;
         if(this.avatarHolder)
         {
            this.avatarHolder.dispose();
         }
         this.avatarHolder = null;
         if(this.gaturro)
         {
            this.gaturro.dispose();
         }
         this.gaturro = null;
         this.avatar = null;
         this.asset = null;
      }
      
      private function addToPreview(param1:DisplayObject) : void
      {
         DisplayUtil.empty(this.asset.preview_ph);
         this.asset.visible = true;
         if(!param1)
         {
            return;
         }
         this.asset.preview_ph.addChild(param1);
         if(param1.scaleY === 1)
         {
            GuiUtil.fit(param1,150,200,20,20);
         }
      }
      
      private function updatePreviewComponents(param1:CustomAttributes, param2:CatalogModalItemView) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Array = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         DisplayUtil.empty(this.asset.preview_ph);
         var _loc3_:MobjectCreator = new MobjectCreator();
         var _loc4_:GaturroInventorySceneObject;
         (_loc4_ = InventoryUtil.createInventoryObject(param1)).buildFromMobject(_loc3_.convert({
            "name":param2.item.name,
            "avatar":{},
            "size":[],
            "coord":[]
         }));
         if(_loc4_ is PetInventorySceneObject)
         {
            this.asset.gotoAndStop(4);
            if(!(_loc5_ = this.isPetWear(_loc4_)))
            {
               libs.fetch(param2.item.name,this.addToPreview);
            }
            else
            {
               this.updateAvatarHolder(_loc4_);
               if(!this.petHolder)
               {
                  this.petHolder = new StubAttributeHolder(new CustomAttributesDelegate(AvatarPet.PREFIX,this.avatarHolder));
               }
               if(!this.petMovieClip)
               {
                  this.petMovieClip = new PetMovieClip(this.petHolder,this._options.petType);
                  this.petMovieClip.scaleX = -1;
               }
               setTimeout(this.addToPreview,50,this.petMovieClip);
            }
         }
         else if(_loc4_ is WearableInventorySceneObject || _loc4_ is UsableInventorySceneObject)
         {
            this.asset.gotoAndStop(2);
            this.updateAvatarHolder(_loc4_);
            if(_loc6_ = this.firstLoad && _loc4_.name.split(".")[0] == "barrilete")
            {
               this.updateAvatarHolder(_loc4_);
            }
            if(!this.gaturro)
            {
               this.gaturro = new Gaturro(this.avatarHolder);
               this.gaturro.scaleX = -1;
            }
            if(_loc6_)
            {
               this.updateAvatarHolder(_loc4_);
            }
            if(Boolean(param1) && !param1.attr_action)
            {
               if(_loc4_ is UsableInventorySceneObject)
               {
                  libs.fetch(param2.item.name,this.addToPreview);
                  return;
               }
               this.gaturro.stand();
            }
            if(_loc6_)
            {
               this.updateAvatarHolder(_loc4_);
            }
            if(param1)
            {
               if("catalogScale" in param1)
               {
                  this.gaturro.scaleX = param1.catalogScale * -1;
                  this.gaturro.scaleY = param1.catalogScale;
               }
               else
               {
                  this.gaturro.scaleX = -1.73;
                  this.gaturro.scaleY = 1.73;
               }
               if("catalogY" in param1)
               {
                  this.gaturro.y = param1.catalogY;
               }
               else
               {
                  this.gaturro.y = 0;
               }
               if("attr_effect" in param1)
               {
                  if((_loc7_ = param1.attr_effect.split("."))[0] == "scale")
                  {
                     _loc8_ = parseFloat(_loc7_[1]) / 10;
                     _loc9_ = -1.73;
                     _loc10_ = 1.73;
                     if(_loc8_ == 0.7 || _loc8_ == 1)
                     {
                        this.gaturro.scaleX = _loc8_ * _loc9_;
                        this.gaturro.scaleY = _loc8_ * _loc10_;
                     }
                  }
               }
            }
            this.addToPreview(this.gaturro);
            this.firstLoad = false;
         }
         else if(_loc4_.questItem || Boolean(param1.grabbable))
         {
            this.asset.gotoAndStop(3);
            libs.fetch(param2.item.name,this.addToPreview);
         }
         else if("type" in param2.asset && (param2.asset.type == "wall" || param2.asset.type == "floor"))
         {
            if(param2.asset.type == "wall")
            {
               this.asset.gotoAndStop(5);
            }
            else
            {
               this.asset.gotoAndStop(6);
            }
            libs.fetch(param2.item.name + "_on",this.addWallOrFloorToPreview,param2.asset);
         }
         else
         {
            this.asset.gotoAndStop(1);
            libs.fetch(param2.item.name,this.addToPreview);
         }
      }
      
      private function isPetWear(param1:GaturroInventorySceneObject) : Boolean
      {
         var _loc2_:String = null;
         for(_loc2_ in param1.attributes)
         {
            if(_loc2_.indexOf("attr_pet_") >= 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function show(param1:CatalogModalItemView) : void
      {
         var _loc2_:CatalogItem = param1.item;
         this.asset.price.text = StringUtil.numberSeparator(_loc2_.price);
         var _loc3_:String = this.replaceText(_loc2_.description,"\"","\'");
         region.setText(this.asset.description,_loc3_);
         this.asset.description.text = this.replaceText(this.asset.description.text,"\"","\'");
         this.asset.description.text = this.asset.description.text.toUpperCase().replace("\'","\"");
         var _loc4_:MovieClip;
         if(!(_loc4_ = param1.asset as MovieClip) || "attributes" in _loc4_ === false)
         {
            return;
         }
         var _loc5_:CustomAttributes;
         (_loc5_ = new CustomAttributes()).mergeObject(_loc4_.attributes,true);
         this.updatePreviewComponents(_loc5_,param1);
      }
   }
}
