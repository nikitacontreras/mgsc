package com.qb9.gaturro.view.gui.profile
{
   import assets.InventoryProfileTabsMC;
   import assets.MedalMC;
   import assets.ProfileMC;
   import com.qb9.flashlib.lang.filter;
   import com.qb9.flashlib.math.Random;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.net.secure.SecureResponseErrorEvent;
   import com.qb9.gaturro.net.secure.SecureWebServicePutImage;
   import com.qb9.gaturro.user.GaturroUser;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.user.inventory.WearableInventorySceneObject;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.inventory.BaseInventoryTabsModal;
   import com.qb9.gaturro.view.gui.base.inventory.HouseYoInventoryWidget;
   import com.qb9.gaturro.view.gui.base.inventory.InventoryWidget;
   import com.qb9.gaturro.view.gui.base.inventory.InventoryWidgetEvent;
   import com.qb9.gaturro.view.gui.base.inventory.OwnedNpcInventoryWidget;
   import com.qb9.gaturro.view.gui.base.inventory.PassportInventoryWidget;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.world.core.avatar.ownednpc.OwnedNpcFactory;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.attributes.CustomAttributeHolder;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.user.inventory.events.InventoryEvent;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import config.PassportControl;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   
   public final class ProfileModal extends BaseGuiModal
   {
      
      private static const COLS:uint = 9;
      
      private static const CHARACTER_SCALE:Number = 1.3;
      
      private static const ROWS:uint = 6;
       
      
      private const CATEGORY_HEAD:int = 0;
      
      private var ownedNpcPh:Sprite;
      
      private var tabModal:BaseInventoryTabsModal;
      
      private var lastSound:int = 0;
      
      private const CATEGORY_ACCESORIOS:int = 2;
      
      private const CATEGORY_ZAPATOS:int = 3;
      
      private var profile:GaturroProfile;
      
      private var holder:CustomAttributeHolder;
      
      private var character:Gaturro;
      
      private const CATEGORY_PASSPORT:int = 6;
      
      private const CATEGORY_TRANSPORTES:int = 4;
      
      private const NUM_TABS:int = 7;
      
      private const CATEGORY_OWNEDNPC:int = 5;
      
      private const CATEGORY_CUERPO:int = 1;
      
      private var avatar:UserAvatar;
      
      private var asset:ProfileMC;
      
      public function ProfileModal(param1:UserAvatar, param2:GaturroProfile)
      {
         super();
         this.avatar = param1;
         this.profile = param2;
         this.init();
      }
      
      override protected function get closeSound() : String
      {
         return null;
      }
      
      private function clockOnOwnedNpcPh(param1:MouseEvent) : void
      {
         this.unselectOwnedNpc();
         var _loc2_:int = 0;
         while(_loc2_ < this.tabModal.tabNumber)
         {
            this.tabModal.widgets[_loc2_].updateSelected();
            _loc2_++;
         }
      }
      
      private function trackClothesChange(param1:CustomAttributes, param2:CustomAttributes) : void
      {
         var _loc5_:CustomAttribute = null;
         var _loc6_:String = null;
         var _loc7_:CustomAttribute = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc3_:Array = param1.toArray();
         var _loc4_:Array = param2.toArray();
         for each(_loc5_ in _loc3_)
         {
            _loc6_ = String(_loc5_.key);
            for each(_loc7_ in _loc4_)
            {
               if(_loc5_.key != "arm")
               {
                  if(_loc5_.key != "armFore")
                  {
                     if(_loc5_.key != "armBack")
                     {
                        if(_loc5_.key != "ownednpc")
                        {
                           if(_loc5_.key == _loc7_.key)
                           {
                              if(!_loc5_.equals(_loc7_))
                              {
                                 if(_loc5_.value != "")
                                 {
                                    _loc8_ = (_loc5_.value as String).split(".");
                                    _loc9_ = (_loc9_ = (_loc9_ = TrackActions.CHANGE_CLOTHES) + (_loc8_[0] != null ? ":" + _loc8_[0] : TrackActions.NO_PACK)) + (_loc8_[1] != null ? ":" + _loc8_[1] : TrackActions.NO_NAME);
                                    Telemetry.getInstance().trackEvent(TrackCategories.AVATAR,_loc9_);
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function init() : void
      {
         var obj:Sprite = null;
         var widget:InventoryWidget = null;
         var widgets:Array = null;
         var i:int = 0;
         var medal:MedalMC = null;
         this.asset = new ProfileMC();
         addChild(this.asset);
         GuiUtil.addOverlay(this);
         this.loadBackground(this.asset.bgHolder,int(api.getAvatarAttribute("profileBackground")));
         this.asset.bgBtn.addEventListener(MouseEvent.CLICK,this.onBgBtnClick);
         this.asset.btnColorSelect.addEventListener(MouseEvent.CLICK,this.onBtnColorSelectClick);
         this.holder = new Holder(this.avatar);
         this.character = new Gaturro(this.holder);
         this.character.scaleX = this.character.scaleY = CHARACTER_SCALE;
         this.character.addEventListener(MouseEvent.CLICK,this.removeCloth);
         for each(obj in this.character.placeholders)
         {
            obj.buttonMode = true;
         }
         widgets = [];
         i = 0;
         while(i < this.NUM_TABS)
         {
            if(i == this.CATEGORY_OWNEDNPC)
            {
               widget = new OwnedNpcInventoryWidget(COLS,ROWS,false,this.isOwnedNpcActive);
            }
            else if(i == this.CATEGORY_PASSPORT)
            {
               widget = new PassportInventoryWidget(COLS,ROWS,false,this.isWearing);
            }
            else
            {
               widget = new HouseYoInventoryWidget(COLS,ROWS,false,this.isWearing);
            }
            widget.addEventListener(InventoryWidgetEvent.SELECTED,this.toggleFromEvent);
            widget.addEventListener(InventoryWidgetEvent.UNSELECTED,this.toggleFromEvent);
            widgets.push(widget);
            i++;
         }
         this.tabModal = new BaseInventoryTabsModal(widgets,new InventoryProfileTabsMC(),16);
         this.tabModal.selectTab(2);
         with(this.asset)
         {
            username.text = user.username.toUpperCase();
            coins.text = int(profile.coins).toString();
            setupLevels();
            avatarPh.addChild(character);
            itemsPh.addChild(tabModal);
            close.addEventListener(MouseEvent.CLICK,_closeModal);
            listo.addEventListener(MouseEvent.CLICK,applyChanges);
            ownedNpcPh = new Sprite();
            avatarPh.addChild(ownedNpcPh);
            ownedNpcPh.x = character.x + 40;
            ownedNpcPh.y = character.y + 12;
            ownedNpcPh.buttonMode = true;
            ownedNpcPh.addEventListener(MouseEvent.CLICK,clockOnOwnedNpcPh);
            checkOwnedNpc();
         }
         if(this.avatar.isCitizen)
         {
            medal = new MedalMC();
            this.asset.medalPh.addChild(medal);
            if(api.hasPassportType("boca"))
            {
               medal.gotoAndStop(2);
            }
            if(api.hasPassportType("river"))
            {
               medal.gotoAndStop(3);
            }
         }
         user.club.getInsignia(this.asset.club_ph);
         this.generateItems();
      }
      
      private function isBeingUsed(param1:WearableInventorySceneObject) : Boolean
      {
         var _loc3_:String = null;
         var _loc2_:Object = param1.providedAttributes;
         for(_loc3_ in _loc2_)
         {
            if(this.holder.attributes[_loc3_] !== _loc2_[_loc3_])
            {
               return false;
            }
         }
         return true;
      }
      
      private function addToPh(param1:DisplayObject, param2:Object) : void
      {
         if(param1)
         {
            param2.asset.addChild(param1);
            (param1 as MovieClip).gotoAndStop(param2.frame);
         }
      }
      
      private function onSendAvatarComplete(param1:Event) : void
      {
         var _loc2_:SecureWebServicePutImage = SecureWebServicePutImage(param1.target);
         this.disposeImageService(_loc2_);
      }
      
      private function toggleFromEvent(param1:InventoryWidgetEvent) : void
      {
         var _loc3_:WearableInventorySceneObject = null;
         var _loc2_:GaturroInventorySceneObject = param1.item as GaturroInventorySceneObject;
         if(_loc2_ is WearableInventorySceneObject)
         {
            _loc3_ = param1.item as WearableInventorySceneObject;
            this.toggle(_loc3_);
         }
         else if(_loc2_.attributes[OwnedNpcFactory.OWNED_NPC_NAME_ATTR])
         {
            this.toggleOwnedNpc(_loc2_);
         }
      }
      
      private function checkOwnedNpc() : void
      {
         var _loc1_:GaturroInventorySceneObject = OwnedNpcFactory.getItemActive();
         if(_loc1_)
         {
            OwnedNpcFactory.addAssetByItem(_loc1_,this.ownedNpcPh);
         }
      }
      
      private function onBtnColorSelectClick(param1:MouseEvent) : void
      {
         api.instantiateBannerModal("ColorPickerModal");
      }
      
      private function selectOwnedNpc(param1:GaturroInventorySceneObject) : void
      {
         OwnedNpcFactory.activeOwnedNpc(this.holder,param1);
         DisplayUtil.empty(this.ownedNpcPh);
         OwnedNpcFactory.addAssetByItem(param1,this.ownedNpcPh);
      }
      
      override public function dispose() : void
      {
         var i:int;
         if(!this.asset)
         {
            return;
         }
         this.inventory.removeEventListener(InventoryEvent.ITEM_ADDED,this.generateItems);
         this.inventory.removeEventListener(InventoryEvent.ITEM_REMOVED,this.generateItems);
         this.asset.niveles_gris.removeEventListener(MouseEvent.CLICK,this.showPassPort);
         this.asset.btnColorSelect.removeEventListener(MouseEvent.CLICK,this.onBtnColorSelectClick);
         this.asset.bgBtn.removeEventListener(MouseEvent.CLICK,this.onBgBtnClick);
         this.holder.dispose();
         this.holder = null;
         this.avatar = null;
         this.profile = null;
         i = 0;
         while(i < this.tabModal.tabNumber)
         {
            this.tabModal.widgets[i].dispose();
            this.tabModal.widgets[i] = null;
            i++;
         }
         this.character.removeEventListener(MouseEvent.CLICK,this.removeCloth);
         this.character.dispose();
         this.character = null;
         with(this.asset)
         {
            close.removeEventListener(MouseEvent.CLICK,_closeModal);
            listo.removeEventListener(MouseEvent.CLICK,applyChanges);
         }
         DisplayUtil.remove(this.asset);
         this.asset = null;
         this.ownedNpcPh.removeEventListener(MouseEvent.CLICK,this.clockOnOwnedNpcPh);
         super.dispose();
      }
      
      private function disposeImageService(param1:SecureWebServicePutImage) : void
      {
         param1.removeEventListener(Event.COMPLETE,this.onSendAvatarComplete);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onPutImageError);
      }
      
      private function loadBackground(param1:MovieClip, param2:int = 0) : void
      {
         api.libraries.fetch(settings.yoBackgroundsPath,this.addToPh,{
            "asset":param1,
            "frame":param2
         });
      }
      
      private function _closeModal(param1:Event) : void
      {
         audio.addLazyPlay("yo_no");
         close();
      }
      
      private function onPutImageError(param1:SecureResponseErrorEvent) : void
      {
         var _loc2_:SecureWebServicePutImage = SecureWebServicePutImage(param1.target);
         this.disposeImageService(_loc2_);
      }
      
      private function itemHasAttr(param1:Object, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param1[param2[_loc3_]])
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function onBgBtnClick(param1:Event) : void
      {
         api.showBannerModal("profileBackgrounds",new GaturroSceneObjectAPI(null,new Sprite(),api.room));
      }
      
      private function findUsedItem(param1:String) : WearableInventorySceneObject
      {
         var _loc2_:WearableInventorySceneObject = null;
         for each(_loc2_ in this.usedElements)
         {
            if(param1 in _loc2_.providedAttributes)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function generateItems(param1:Event = null) : void
      {
         var _loc4_:Object = null;
         var _loc6_:Object = null;
         var _loc10_:String = null;
         var _loc11_:Number = NaN;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this.NUM_TABS)
         {
            _loc2_.push([]);
            _loc3_++;
         }
         var _loc7_:Array = filter(this.inventory.itemsGrouped,this.hasAnyWearable);
         var _loc8_:int = this.CATEGORY_HEAD;
         _loc3_ = 0;
         while(_loc3_ < _loc7_.length)
         {
            _loc6_ = (_loc4_ = _loc7_[_loc3_])[0].attributes;
            if(this.itemHasAttr(_loc6_,["wear_neck","wear_accesories","wear_mouths"]))
            {
               _loc8_ = this.CATEGORY_ACCESORIOS;
            }
            if(this.itemHasAttr(_loc6_,["wear_head","wear_hairs","wear_hats"]))
            {
               _loc8_ = this.CATEGORY_HEAD;
            }
            if(_loc6_["vehicle"])
            {
               _loc8_ = this.CATEGORY_TRANSPORTES;
            }
            if(_loc6_["wear_foot"])
            {
               _loc8_ = this.CATEGORY_ZAPATOS;
            }
            if(this.itemHasAttr(_loc6_,["wear_leg","wear_arm","wear_armFore","wear_armBack","wear_gloveFore","wear_gloveBack","wear_gripFore","wear_gripBack","wear_cloth"]))
            {
               _loc8_ = this.CATEGORY_CUERPO;
            }
            _loc2_[_loc8_].push(_loc4_);
            _loc3_++;
         }
         var _loc9_:String = "";
         _loc7_ = GaturroUser(this.avatar.user).house.items;
         _loc3_ = 0;
         while(_loc3_ < _loc7_.length)
         {
            _loc4_ = _loc7_[_loc3_];
            if(OwnedNpcFactory.isOwnedNpcItem(_loc4_ as CustomAttributeHolder))
            {
               _loc10_ = String((_loc4_ as CustomAttributeHolder).attributes[OwnedNpcFactory.OWNED_NPC_ID_ATTR]);
               if(_loc9_.indexOf(_loc10_) >= 0)
               {
                  if((_loc11_ = Number(_loc4_.id)) > 0)
                  {
                     GaturroUser(this.avatar.user).house.remove(_loc11_);
                  }
               }
               else
               {
                  _loc9_ += ";" + _loc10_;
               }
            }
            _loc3_++;
         }
         _loc7_ = GaturroUser(this.avatar.user).house.items;
         _loc3_ = 0;
         while(_loc3_ < _loc7_.length)
         {
            _loc4_ = _loc7_[_loc3_];
            if(OwnedNpcFactory.isOwnedNpcItem(_loc4_ as CustomAttributeHolder))
            {
               _loc2_[this.CATEGORY_OWNEDNPC].push([_loc4_]);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.NUM_TABS)
         {
            this.tabModal.widgets[_loc3_].elements = _loc2_[_loc3_];
            _loc3_++;
         }
      }
      
      private function setupLevels() : void
      {
         if(this.avatar.isCitizen)
         {
            api.levelManager.refreshStats();
            this.asset.niveles_gris.visible = false;
            this.asset.comp_txt.text = "NIVEL " + api.levelManager._levelCompetitive.toString();
            this.asset.soc_txt.text = "NIVEL " + api.levelManager._levelSocial.toString();
            this.asset.explo_txt.text = "NIVEL " + api.levelManager._levelExplorer.toString();
            this.asset.soc_carga.gotoAndStop(api.levelManager.getProgress(api.userAvatar.attributes.socialSkills));
            this.asset.comp_carga.gotoAndStop(api.levelManager.getProgress(api.userAvatar.attributes.competitiveSkills));
            this.asset.explo_carga.gotoAndStop(api.levelManager.getProgress(api.userAvatar.attributes.explorerSkills));
         }
         else
         {
            this.asset.niveles_gris.visible = true;
            this.asset.niveles_gris.addEventListener(MouseEvent.CLICK,this.showPassPort);
         }
      }
      
      private function showPassPort(param1:MouseEvent) : void
      {
         api.showBannerModal("niveles");
      }
      
      private function get usedElements() : Array
      {
         var _loc2_:Array = null;
         var _loc3_:InventoryWidget = null;
         var _loc1_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < this.tabModal.tabNumber)
         {
            _loc3_ = this.tabModal.widgets[_loc4_];
            if(!(_loc3_ is OwnedNpcInventoryWidget))
            {
               _loc2_ = filter(_loc3_.elements,this.isBeingUsed);
               _loc1_ = _loc1_.concat(_loc2_);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      private function unselect(param1:WearableInventorySceneObject) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1.providedAttributes)
         {
            this.holder.attributes[_loc2_] = "";
         }
      }
      
      private function toggle(param1:WearableInventorySceneObject) : void
      {
         if(this.isWearing(param1))
         {
            this.unselect(param1);
         }
         else
         {
            this.select(param1);
         }
      }
      
      private function get inventory() : GaturroInventory
      {
         return GaturroUser(this.avatar.user).visualizer;
      }
      
      override protected function keyboardSubmit() : void
      {
         this.applyChanges();
      }
      
      private function hasAnyWearable(param1:Array) : Boolean
      {
         var _loc2_:int = int(param1.length - 1);
         while(_loc2_ >= 0)
         {
            if(param1[_loc2_] is WearableInventorySceneObject === false)
            {
               param1.splice(_loc2_,1);
            }
            _loc2_--;
         }
         return param1.length > 0;
      }
      
      private function isOwnedNpcActive(param1:GaturroInventorySceneObject) : Boolean
      {
         if(OwnedNpcFactory.isThisOwnedNpcActive(this.holder,param1))
         {
            return true;
         }
         return false;
      }
      
      private function unselectOwnedNpc() : void
      {
         OwnedNpcFactory.emptyOwnedNpcToHolder(this.holder);
         DisplayUtil.empty(this.ownedNpcPh);
      }
      
      private function applyChanges(param1:Event = null) : void
      {
         this.avatar.attributes.merge(this.holder.attributes);
         audio.addLazyPlay("yo_si");
         close();
      }
      
      private function removeCloth(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:WearableInventorySceneObject = null;
         var _loc5_:int = 0;
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this.character)
         {
            _loc3_ = _loc2_.name;
            _loc2_ = _loc2_.parent;
            if(_loc3_.indexOf("color") !== 0)
            {
               if(Boolean(_loc3_) && _loc3_ in this.holder.attributes)
               {
                  if(_loc4_ = this.findUsedItem(_loc3_))
                  {
                     logger.debug(this,_loc4_);
                     this.unselect(_loc4_);
                     _loc5_ = 0;
                     while(_loc5_ < this.tabModal.tabNumber)
                     {
                        if("updateSelected" in this.tabModal.widgets[_loc5_])
                        {
                           this.tabModal.widgets[_loc5_].updateSelected();
                        }
                        _loc5_++;
                     }
                     break;
                  }
                  this.holder.attributes[_loc3_] = "";
               }
            }
         }
      }
      
      private function toggleOwnedNpc(param1:GaturroInventorySceneObject) : void
      {
         if(this.isOwnedNpcActive(param1))
         {
            this.unselectOwnedNpc();
         }
         else
         {
            this.selectOwnedNpc(param1);
         }
      }
      
      private function isWearing(param1:WearableInventorySceneObject) : Boolean
      {
         return ArrayUtil.contains(this.usedElements,param1);
      }
      
      private function select(param1:WearableInventorySceneObject) : void
      {
         var _loc3_:String = null;
         var _loc4_:WearableInventorySceneObject = null;
         var _loc5_:* = undefined;
         var _loc2_:Object = param1.providedAttributes;
         for(_loc3_ in _loc2_)
         {
            if(PassportControl.isVipPack(_loc2_[_loc3_]) && !api.user.isCitizen)
            {
               api.textMessageToGUI("ESTE OBJETO REQUIERE PASAPORTE");
               this.unselect(param1);
               return;
            }
            if(_loc4_ = this.findUsedItem(_loc3_))
            {
               this.unselect(_loc4_);
            }
         }
         this.holder.attributes.mergeObject(_loc2_);
         while((_loc5_ = Random.randint(1,4)) === this.lastSound)
         {
         }
         this.lastSound = _loc5_;
         audio.addLazyPlay("yo" + _loc5_);
      }
   }
}

import assets.MissingAssetMC;
import assets.ProfileButtonMC;
import com.qb9.flashlib.interfaces.IDisposable;
import com.qb9.flashlib.utils.DisplayUtil;
import com.qb9.gaturro.globals.libs;
import com.qb9.mambo.user.inventory.InventorySceneObject;
import flash.display.DisplayObject;

class Cell extends ProfileButtonMC implements IDisposable
{
   
   private static const WIDTH:uint = 43;
   
   private static const HEIGHT:uint = 40;
   
   private static const MARGIN:int = 2;
    
   
   private var _item:InventorySceneObject;
   
   public function Cell()
   {
      super();
      buttonMode = true;
      ph.mouseEnabled = false;
      ph.mouseChildren = false;
   }
   
   private function add(param1:DisplayObject) : void
   {
      param1 ||= new MissingAssetMC();
      this.resize(param1);
      ph.addChild(param1);
   }
   
   public function set selected(param1:Boolean) : void
   {
      gotoAndStop(param1 ? 2 : 1);
   }
   
   public function set item(param1:InventorySceneObject) : void
   {
      DisplayUtil.empty(ph);
      this._item = param1;
      visible = param1 !== null;
      if(visible)
      {
         libs.fetch(param1.name,this.add);
      }
   }
   
   public function get item() : InventorySceneObject
   {
      return this._item;
   }
   
   private function resize(param1:DisplayObject) : void
   {
      var _loc2_:Number = WIDTH - 2 * MARGIN;
      var _loc3_:Number = HEIGHT - 2 * MARGIN;
      var _loc4_:Number = _loc2_ / param1.width;
      var _loc5_:Number = _loc3_ / param1.height;
      param1.scaleX = param1.scaleY = Math.min(_loc4_,_loc5_);
      param1.x = width / 2;
      param1.y = (height + param1.height) / 2;
   }
   
   public function get selected() : Boolean
   {
      return currentFrame === 2;
   }
   
   public function dispose() : void
   {
      this.item = null;
   }
}

import com.qb9.mambo.core.objects.BaseCustomAttributeDispatcher;
import com.qb9.mambo.world.avatars.UserAvatar;

class Holder extends BaseCustomAttributeDispatcher
{
    
   
   public function Holder(param1:UserAvatar)
   {
      super();
      _attributes = param1.attributes.clone(this);
   }
}
