package com.qb9.gaturro.view.components.banner.albumMonster2019
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
   
   public class AlbumMonster2019Canvas extends FrameCanvas
   {
       
      
      private var cardsPlaced:Array;
      
      private var cardsOwned:Array;
      
      private const PREMIOS:String = "monster2019_prizes";
      
      private const PACK_PATH:String = "monster2019/album.card";
      
      private var setupFinished:Boolean;
      
      private var taskRunner:TaskRunner;
      
      private const FIGURITAS:String = "monster2019_figuritas";
      
      private var pegadasCount:int;
      
      private var config:Object;
      
      private var pageHasPrize:Boolean = false;
      
      private var page_id:int = 0;
      
      public function AlbumMonster2019Canvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         this.cardsPlaced = [];
         this.cardsOwned = [];
         this.config = {
            "groups":[{
               "name":"1",
               "countries":["Interesante... Esta dona está toda mordisqueada...\n¿Al sospechoso no le gustó, o es que se arrepintió a mitad de camino?\nSi sabemos de dónde salió, podremos seguir investigando","¡Un cocinero con bigote hace esas donas!\n\n-Investigar"]
            },{
               "name":"2",
               "countries":["La dona era de aquí y hay algunas migas sobre este vestido\nAlguien lo abandonó después de comer\nEs una prenda muy lujosa, como de fiesta","¿En qué tipo de lugar encaja este vestido?\n\n-Investigar"]
            },{
               "name":"3",
               "countries":["¡Otro traje! ¿Qué relación hay entre comidas y trajes? \nLa asistente de modas no recuerda quién se lo probó pero dice que tenía orejas de animal y que dejó pelos por todas partes\n¡Este misterio se pone intenso! ¡Y oriental!","Nuestro próximo paso debe ser aéreo...\n\n-Investigar"]
            },{
               "name":"4",
               "countries":["Ajam... Esta mesa es muy parecida a la de otro bar...\n¡Y hay restos de sushi y un puesto de comida cerca!\nNuestra hipótesis toma forma: ¡la comida es vital en este caso!","Esta mesa solo la vende el capitán del espacio\n\n-Investigar"]
            },{
               "name":"5",
               "countries":["¿Lechuga? Esto es bastante más dietético que las demás comidas\nSolo conozco un animal que come lechuguita...\n¡Presiento que estamos muy cerca de resolver el misterio!\nEs como si el sospechoso quisiera ser atrapado...","Debemos ir donde está la mascota del instituto de enseñanza\n\n-Investigar"]
            },{
               "name":"6",
               "countries":["La chica Furry (¡no le preguntamos el nombre!) era quien nos dejaba las pistas. Tenía una fiesta y se probaba trajes pero no podía parar de comer y eso le hacía sentir culpable. Por eso quiso que la descubramos.\n\n Al fin entendió que todos los cuerpos son hermosos (¡sobre todo los amarillos!) y que podía ir a la fiesta tal cual es.\n\nGracias por acompañarme. Ganaste la experiencia y los premios del detective. ¡Sigue investigando!","¡CASO RESUELTO!"]
            }],
            "prizes":{
               "page_0":"food.donaFrutilla",
               "page_1":"fiesta.vestidoStrassAzul",
               "page_2":"viajesJapon.trajeMongolFem",
               "page_3":"barEspacial.mesada",
               "page_4":"escuelaNueva.lechuga",
               "page_5":"diaNino2017/wears.itemDiaDelNino2"
            },
            "positions":{"banderas":{
               "page_0":[1],
               "page_1":[2],
               "page_2":[3],
               "page_3":[4],
               "page_4":[5],
               "page_5":[6]
            }},
            "phNames":{
               "countries":["country_A","country_B"],
               "banderas":["bandera_A"],
               "camisetas":["camiseta_A"]
            }
         };
         super(param1,param2,param3,param4);
      }
      
      private function givePrize(param1:int) : void
      {
         api.giveUser(this.config.prizes["page_" + param1]);
         api.trackEvent("FEATURES:XMAS_2018:ALBUM:RECIBE_PREMIO",this.config.prizes["page_" + param1]);
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
         api.libraries.fetch(_loc1_,this.onPrizeFetch);
      }
      
      private function onPrizeFetch(param1:DisplayObject) : void
      {
         var _loc2_:MovieClip = this.getClip("prizeTapa");
         this.pageHasPrize = this.pegadasCount >= 1;
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
         var _loc8_:MovieClip = null;
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
            this.getField(_loc1_[_loc5_]).text = _loc4_.countries[_loc5_].toUpperCase();
            _loc5_++;
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc2_.length)
         {
            trace("requesting bandera card" + this.getCardID(_loc7_,"banderas"));
            _loc8_ = this.getClip(_loc2_[_loc7_]);
            this.cleanPH(_loc8_);
            _loc6_ = this.getCardID(_loc7_,"banderas");
            this.setupCard(_loc6_,_loc8_);
            _loc7_++;
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
         this.getField(this.config.phNames.countries[0]).text = "???????????";
         this.getField(this.config.phNames.countries[1]).text = "";
         trace("EL USUARIO NO TIENE NI PUSO ESTA CARTA: " + param1);
      }
      
      private function getButton(param1:String) : SimpleButton
      {
         return view.getChildByName(param1) as SimpleButton;
      }
      
      private function setupCanvas() : void
      {
         (view.parent as MovieClip).gotoAndStop("normal");
         (view as MovieClip).gotoAndStop("cardViewer");
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
         api.trackEvent("FEATURES:XMAS_2018:ALBUM:PEGA_CARTA",_loc4_);
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
         var _loc3_:MovieClip = null;
         _loc3_ = param1 as MovieClip;
         _loc3_.buttonMode = true;
         _loc3_.alpha = 0.7;
         _loc3_.y += 7;
         var _loc4_:Sequence = new Sequence(new Tween(_loc3_,800,{
            "scaleX":1.05,
            "scaleY":1.05
         },{"transition":"easeOut"}),new Tween(_loc3_,500,{
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
         api.trackEvent("FEATURES:XMAS_2018:ALBUM:HELP","true");
         AlbumMonster2019Banner(_owner).switchCanvas("help");
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
         this.taskRunner = (owner as AlbumMonster2019Banner).taskRunner;
         api.setAvatarAttribute("action","showObjectUp.monster2019/props.albumLee");
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
