package com.qb9.gaturro.view.components.banner.albumHalloween2018
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Loop;
   import com.qb9.flashlib.tasks.Parallel;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class AlbumHalloween2018Canvas extends FrameCanvas
   {
       
      
      private var cardsPlaced:Array;
      
      private var cardsOwned:Array;
      
      private const PREMIOS:String = "halloween2018_prizes";
      
      private const PACK_PATH:String = "halloween2018/album.card";
      
      private var setupFinished:Boolean;
      
      private var taskRunner:TaskRunner;
      
      private const FIGURITAS:String = "halloween2018_figuritas";
      
      private var pegadasCount:int;
      
      private var config:Object;
      
      private var pageHasPrize:Boolean = false;
      
      private var page_id:int = 0;
      
      public function AlbumHalloween2018Canvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         this.cardsPlaced = [];
         this.cardsOwned = [];
         this.config = {
            "groups":[{
               "name":"GRUPO A",
               "countries":["","","",""]
            },{
               "name":"GRUPO B",
               "countries":["","","",""]
            },{
               "name":"GRUPO C",
               "countries":["","","",""]
            },{
               "name":"GRUPO D",
               "countries":["","","",""]
            },{
               "name":"GRUPO E",
               "countries":["","","",""]
            },{
               "name":"GRUPO F",
               "countries":["","","",""]
            },{
               "name":"GRUPO G",
               "countries":["","","",""]
            },{
               "name":"GRUPO H",
               "countries":["","","",""]
            }],
            "prizes":{
               "page_0":"virtualGoods2.sillonCraneal",
               "page_1":"virtualGoods2.trajeEspectro",
               "page_2":"virtualGoods3.ojoBionico",
               "page_3":"virtualGoods.disfrazExtraterrestre",
               "page_4":"virtualGoods3.babosaEspacial",
               "page_5":"virtualGoods3.jibia",
               "page_6":"virtualGoods.espantapajaros",
               "page_7":"virtualGoods.disfrazBrujo"
            },
            "positions":{
               "banderas":{
                  "page_0":[1,3,5,7],
                  "page_1":[9,11,13,15],
                  "page_2":[17,19,21,23],
                  "page_3":[25,27,29,31],
                  "page_4":[33,35,37,39],
                  "page_5":[41,43,45,47],
                  "page_6":[49,51,53,55],
                  "page_7":[57,59,61,63]
               },
               "camisetas":{
                  "page_0":[2,4,6,8],
                  "page_1":[10,12,14,16],
                  "page_2":[18,20,22,24],
                  "page_3":[26,28,30,32],
                  "page_4":[34,36,38,40],
                  "page_5":[42,44,46,48],
                  "page_6":[50,52,54,56],
                  "page_7":[58,60,62,64]
               }
            },
            "phNames":{
               "countries":["country_A","country_B","country_C","country_D"],
               "banderas":["bandera_A","bandera_B","bandera_C","bandera_D"],
               "camisetas":["camiseta_A","camiseta_B","camiseta_C","camiseta_D"]
            }
         };
         super(param1,param2,param3,param4);
      }
      
      private function givePrize(param1:int) : void
      {
         api.giveUser(this.config.prizes["page_" + param1]);
         api.trackEvent("FEATURES:HALLOWEEN_2018:ALBUM:RECIBE_PREMIO",this.config.prizes["page_" + param1]);
         var _loc2_:String = api.getProfileAttribute(this.PREMIOS) as String;
         if(!_loc2_ || _loc2_ == "" || _loc2_ == " ")
         {
            api.setProfileAttribute(this.PREMIOS,param1.toString());
            return;
         }
         var _loc3_:Array = _loc2_.split(",");
         _loc3_.push(param1);
         _loc3_.sort(Array.NUMERIC);
         api.setProfileAttribute(this.PREMIOS,String(_loc3_));
      }
      
      private function cleanPH(param1:MovieClip) : void
      {
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
      }
      
      private function isArrayOk(param1:Array) : Boolean
      {
         var _loc2_:String = api.getProfileAttribute(this.FIGURITAS) as String;
         var _loc3_:String = String(param1);
         if(_loc2_ == _loc3_)
         {
            return true;
         }
         return false;
      }
      
      private function setupPrize() : void
      {
         if(this.isClaimedAlready)
         {
            this.getClip("prizeTapa").visible = false;
         }
         else
         {
            this.getClip("prizeTapa").visible = true;
            this.getClip("prizeTapa").gotoAndStop("idle");
            this.getClip("prizeTapa").buttonMode = false;
         }
         var _loc1_:String = String(this.config.prizes["page_" + this.page_id]);
         trace(_loc1_);
         api.libraries.fetch(_loc1_,this.onPrizeFetch);
      }
      
      private function onPrizeFetch(param1:DisplayObject) : void
      {
         var _loc2_:MovieClip = this.getClip("prizeTapa");
         this.pageHasPrize = this.pegadasCount >= 8;
         if(this.pageHasPrize && !this.isClaimedAlready)
         {
            _loc2_.gotoAndPlay("moving");
            _loc2_.buttonMode = true;
         }
         GuiUtil.fit(param1,280,280);
         var _loc3_:MovieClip = _loc2_.getChildByName("container") as MovieClip;
         if(_loc3_)
         {
            while(_loc3_.numChildren > 0)
            {
               _loc3_.removeChildAt(0);
            }
            _loc3_.addChild(param1);
         }
         this.setupFinished = true;
      }
      
      private function getCardID(param1:int, param2:String) : String
      {
         return this.config.positions[param2]["page_" + this.page_id][param1];
      }
      
      private function getCardID_toPosition(param1:String) : uint
      {
         var _loc2_:* = param1.split("_")[0] + "s";
         var _loc3_:Array = this.config.phNames[_loc2_];
         var _loc4_:int = 99;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] == param1)
            {
               _loc4_ = _loc5_;
            }
            _loc5_++;
         }
         return this.config.positions[_loc2_]["page_" + this.page_id][_loc4_];
      }
      
      private function addCardToAlbum(param1:String) : void
      {
         this.cardsPlaced.push(param1);
         this.cardsPlaced.sort(Array.NUMERIC);
         this.writeProfile();
      }
      
      private function fetchAndAdd(param1:DisplayObject, param2:MovieClip) : void
      {
         param2.addChild(param1);
      }
      
      override public function dispose() : void
      {
         if(this.getButton("prev_page"))
         {
            this.getButton("prev_page").removeEventListener(MouseEvent.CLICK,this.onPrevious);
         }
         if(this.getButton("next_page"))
         {
            this.getButton("next_page").removeEventListener(MouseEvent.CLICK,this.onNext);
         }
         if(this.getButton("helpButton"))
         {
            this.getButton("helpButton").removeEventListener(MouseEvent.CLICK,this.onNext);
         }
         super.dispose();
      }
      
      private function setupPage() : void
      {
         var _loc6_:String = null;
         var _loc9_:MovieClip = null;
         var _loc10_:MovieClip = null;
         this.setupCanvas();
         this.setupFinished = false;
         var _loc1_:Array = this.config.phNames.countries;
         var _loc2_:Array = this.config.phNames.banderas;
         var _loc3_:Array = this.config.phNames.camisetas;
         var _loc4_:Object = this.config.groups[this.page_id];
         this.pegadasCount = 0;
         this.getField("group_id").text = _loc4_.name;
         var _loc5_:int = 0;
         while(_loc5_ < _loc1_.length)
         {
            this.getField(_loc1_[_loc5_]).text = _loc4_.countries[_loc5_];
            _loc5_++;
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc2_.length)
         {
            trace("requesting bandera card" + this.getCardID(_loc7_,"banderas"));
            _loc9_ = this.getClip(_loc2_[_loc7_]);
            this.cleanPH(_loc9_);
            _loc6_ = this.getCardID(_loc7_,"banderas");
            this.setupCard(_loc6_,_loc9_);
            _loc7_++;
         }
         var _loc8_:int = 0;
         while(_loc8_ < _loc3_.length)
         {
            trace("requesting camiseta card" + this.getCardID(_loc8_,"camisetas"));
            _loc10_ = this.getClip(_loc3_[_loc8_]);
            this.cleanPH(_loc10_);
            _loc6_ = this.getCardID(_loc8_,"camisetas");
            this.setupCard(_loc6_,_loc10_);
            _loc8_++;
         }
         this.setupPrize();
      }
      
      private function setupCard(param1:String, param2:MovieClip) : void
      {
         if(this.alreadyInArray(param1,this.cardsPlaced))
         {
            api.libraries.fetch(this.PACK_PATH + param1,this.fetchAndAdd,param2);
            ++this.pegadasCount;
            return;
         }
         if(this.alreadyInArray(param1,this.cardsOwned))
         {
            api.libraries.fetch(this.PACK_PATH + param1,this.fetchAndSetReady,param2);
            return;
         }
         this.getField(param2.name + "_ID").text = param1;
         trace("EL USUARIO NO TIENE NI PUSO ESTA CARTA: " + param1);
      }
      
      private function getButton(param1:String) : SimpleButton
      {
         return view.getChildByName(param1) as SimpleButton;
      }
      
      private function setupCanvas() : void
      {
         if(this.page_id == 7 || this.page_id == 6)
         {
            (view.parent as MovieClip).gotoAndStop("estadio");
            (view as MovieClip).gotoAndStop("puzzleViewer");
         }
         else
         {
            (view.parent as MovieClip).gotoAndStop("normal");
            (view as MovieClip).gotoAndStop("cardViewer");
         }
      }
      
      private function onCardClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.removeEventListener(MouseEvent.CLICK,this.onCardClick);
         var _loc3_:String = String(param1.target.parent.name);
         var _loc4_:String = this.getCardID_toPosition(_loc3_).toString();
         this.taskRunner.remove(_loc2_.tween);
         _loc2_.tween = new Parallel(new Tween(_loc2_,700,{"alpha":1}),new Tween(_loc2_,1200,{
            "scaleX":1,
            "scaleY":1,
            "y":0
         },{"transition":"easeOut"}));
         this.taskRunner.add(_loc2_.tween);
         api.trackEvent("FEATURES:HALLOWEEN_2018:ALBUM:PEGA_CARTA",_loc4_);
         ++this.pegadasCount;
         this.addCardToAlbum(_loc4_);
         api.takeFromUser(this.PACK_PATH + _loc4_);
         trace("pegando la carta:" + _loc4_);
         this.setupPrize();
      }
      
      private function readProfile() : void
      {
         var _loc1_:String = api.getProfileAttribute(this.FIGURITAS) as String;
         if(!_loc1_ || _loc1_ == "" || _loc1_ == " ")
         {
            return;
         }
         if(_loc1_.substr(0,1) == "[")
         {
            _loc1_ = _loc1_.substr(1,_loc1_.length - 2);
         }
         var _loc2_:Array = _loc1_.split(",");
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(!this.alreadyInArray(_loc2_[_loc4_],this.cardsPlaced))
            {
               this.cardsPlaced.push(_loc2_[_loc4_]);
            }
            else
            {
               _loc3_ = true;
            }
            _loc4_++;
         }
         this.cardsPlaced.sort(Array.NUMERIC);
         if(_loc3_ && !this.isArrayOk(this.cardsPlaced))
         {
            trace("REESCRIBE VARIABLE");
            this.writeProfile();
         }
      }
      
      private function alreadyInArray(param1:Object, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_] == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function fetchAndSetReady(param1:DisplayObject, param2:MovieClip) : void
      {
         var _loc3_:MovieClip = param1 as MovieClip;
         _loc3_.buttonMode = true;
         _loc3_.alpha = 0.7;
         _loc3_.y += 7;
         var _loc4_:Sequence = new Sequence(new Tween(_loc3_,1200,{
            "scaleX":1.03,
            "scaleY":1.03
         },{"transition":"easeOut"}),new Tween(_loc3_,1200,{
            "scaleX":1,
            "scaleY":1
         },{"transition":"easeOut"}));
         _loc3_.tween = new Loop(_loc4_);
         this.taskRunner.add(_loc3_.tween);
         _loc3_.mouseChildren = false;
         _loc3_.addEventListener(MouseEvent.CLICK,this.onCardClick);
         param2.addChild(param1);
      }
      
      private function onHelp(param1:MouseEvent) : void
      {
         api.trackEvent("FEATURES:HALLOWEEN_2018:ALBUM:HELP","true");
         AlbumHalloween2018Banner(_owner).switchCanvas("help");
      }
      
      private function getField(param1:String) : TextField
      {
         return view.getChildByName(param1) as TextField;
      }
      
      private function getClip(param1:String) : MovieClip
      {
         return view.getChildByName(param1) as MovieClip;
      }
      
      private function writeProfile() : void
      {
         api.setProfileAttribute(this.FIGURITAS,String(this.cardsPlaced));
      }
      
      private function get isClaimedAlready() : Boolean
      {
         var _loc1_:String = api.getProfileAttribute(this.PREMIOS) as String;
         if(!_loc1_ || _loc1_ == "" || _loc1_ == " ")
         {
            return false;
         }
         var _loc2_:Array = _loc1_.split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] == this.page_id)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function onPrizeClick(param1:MouseEvent) : void
      {
         if(!this.isClaimedAlready && this.setupFinished && this.pageHasPrize)
         {
            this.getClip("prizeTapa").gotoAndPlay("open");
            setTimeout(this.givePrize,1000,this.page_id);
         }
      }
      
      override protected function setupShowView() : void
      {
         this.taskRunner = (owner as AlbumHalloween2018Banner).taskRunner;
         api.setAvatarAttribute("action","showObjectUp.halloween2018/props.albumLee");
         this.getButton("prev_page").addEventListener(MouseEvent.CLICK,this.onPrevious);
         this.getButton("next_page").addEventListener(MouseEvent.CLICK,this.onNext);
         this.getButton("helpButton").addEventListener(MouseEvent.CLICK,this.onHelp);
         this.getClip("prizeTapa").addEventListener(MouseEvent.CLICK,this.onPrizeClick);
         this.readProfile();
         this.readInventory();
         this.setupPage();
      }
      
      private function readInventory() : void
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc1_:GaturroInventory = api.user.inventory(GaturroInventory.BAG) as GaturroInventory;
         var _loc2_:Array = _loc1_.itemsGrouped;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if((_loc5_ = String((_loc4_ = _loc2_[_loc3_])[0].name)).indexOf(this.PACK_PATH) != -1)
            {
               _loc6_ = _loc5_.substr(this.PACK_PATH.length);
               this.cardsOwned.push(_loc6_);
            }
            _loc3_++;
         }
         this.cardsOwned.sort(Array.NUMERIC);
      }
      
      private function onNext(param1:MouseEvent) : void
      {
         api.stopSound("mapa");
         api.playSound("mapa");
         ++this.page_id;
         if(this.page_id >= this.config.groups.length)
         {
            this.page_id = 0;
         }
         this.setupPage();
      }
      
      private function onPrevious(param1:MouseEvent) : void
      {
         api.stopSound("mapa");
         api.playSound("mapa");
         --this.page_id;
         if(this.page_id < 0)
         {
            this.page_id = this.config.groups.length - 1;
         }
         this.setupPage();
      }
   }
}
