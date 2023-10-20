package com.qb9.gaturro.view.gui.map
{
   import assets.MapMC;
   import assets.RankingMC;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.net.requests.ranking.RankingDataRequest;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.components.DropDown;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.world.core.RoomLink;
   import com.qb9.mambo.world.core.events.RoomEvent;
   import com.qb9.mines.mobject.Mobject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextFormat;
   import flash.ui.Mouse;
   
   public final class MapGuiModal extends BaseGuiModal
   {
      
      private static const DEFAULT_INITIAL_Y:int = 6;
      
      private static const URI:String = "map/newMap2.swf";
      
      private static const DEFAULT_INITIAL_X:int = 12;
       
      
      private var mapLoaded:Boolean;
      
      private const TIME_ALL:String = region.getText("RANKING HISTÓRICO");
      
      private var loader:Loader;
      
      private const FRIENDS_TRUE:String = region.getText("LOS MEJORES ENTRE TUS AMIGOS");
      
      private var gameName:String = "";
      
      private const TIME_WEEK:String = region.getText("ESTA SEMANA");
      
      private const FRIENDS_FALSE:String = region.getText("LOS MEJORES ENTRE TODOS");
      
      private var hasPassport:Boolean;
      
      private var table:RankingMC;
      
      private var room:GaturroRoom;
      
      private var map:MovieClip;
      
      private var gamesConfig:Object;
      
      private var configLoaded:Boolean;
      
      private const TIME_MONTH:String = region.getText("ESTE MES");
      
      private var asset:MapMC;
      
      private var toRoom:Boolean = false;
      
      public function MapGuiModal(param1:Boolean, param2:GaturroRoom = null, param3:String = "")
      {
         super();
         this.room = param2;
         this.hasPassport = param1;
         this.gameName = param3;
         this.init();
      }
      
      private function init() : void
      {
         Telemetry.getInstance().trackScreen("map");
         this.asset = new MapMC();
         this.asset.close.addEventListener(MouseEvent.CLICK,_close);
         addChild(this.asset);
         this.gamesConfig = Config.data;
         this.configLoaded = true;
         this.addMap();
      }
      
      private function hideRankLines() : void
      {
         this.table.names.visible = false;
         this.table.scores.visible = false;
         this.table.score.visible = false;
         this.table.scoreTitle.visible = false;
         this.table.loading.visible = true;
         var _loc1_:DropDown = DropDown(this.table.phFriends.getChildAt(0));
         var _loc2_:DropDown = DropDown(this.table.phTime.getChildAt(0));
         _loc1_.visible = false;
         _loc2_.visible = false;
      }
      
      private function extractRoomLink() : RoomLink
      {
         var _loc1_:RoomLink = null;
         var _loc2_:Coord = null;
         if(this.map.coord)
         {
            _loc2_ = Coord.fromArray(this.map.coord);
         }
         else
         {
            _loc2_ = Coord.create(DEFAULT_INITIAL_X,DEFAULT_INITIAL_Y);
         }
         this.map.removeEventListener(Event.SELECT,this.whenSectionIsSelected);
         return new RoomLink(_loc2_,this.hasPassport ? this.map.withPassportId : this.map.id);
      }
      
      private function whenSectionIsSelected(param1:Event) : void
      {
         if(!this.map.id)
         {
            return;
         }
         if(!settings.minigames.enableRanking)
         {
            this.doAction();
            return;
         }
         if(this.checkIfShowRank())
         {
            this.gameName = String(this.map.itemName.split("_")[1]);
            this.showGamePanel();
         }
         else
         {
            this.doAction();
         }
      }
      
      private function showMap() : void
      {
         this.map.gameData.visible = false;
         region.setText(this.asset.label.field,"GATU-MAPA");
         this.asset.label.field.text = api.serverName;
         this.map.addEventListener(MouseEvent.ROLL_OVER,this.toggleMouse);
         this.map.addEventListener(MouseEvent.ROLL_OUT,this.toggleMouse);
         this.map.addEventListener(Event.SELECT,this.whenSectionIsSelected);
      }
      
      private function doAction(param1:Boolean = false) : void
      {
         this.toRoom = true;
         var _loc2_:RoomLink = this.extractRoomLink();
         this.saveMapState();
         if(_loc2_.roomId == 0 && param1)
         {
            this.room.startMinigame(this.gameName);
            return;
         }
         this.executeRoomChange(_loc2_);
      }
      
      private function checkIfShowRank() : Boolean
      {
         var _loc2_:String = null;
         var _loc1_:String = String(this.map.itemName.substr(0,2));
         if(this.map.itemName != "" && _loc1_ == "g_")
         {
            for each(_loc2_ in settings.minigames.noRanking)
            {
               if(this.map.itemName == "g_" + _loc2_)
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      private function toggleMouse(param1:Event) : void
      {
         if(param1.type === MouseEvent.ROLL_OVER)
         {
            Mouse.hide();
         }
         else
         {
            Mouse.show();
         }
      }
      
      private function saveMapState() : void
      {
         var _loc1_:String = api.getSession("map_state") as String;
         if(_loc1_)
         {
            api.setProfileAttribute("map_state",_loc1_);
         }
      }
      
      private function get info() : LoaderInfo
      {
         return this.loader.contentLoaderInfo;
      }
      
      override public function dispose() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:DropDown = null;
         var _loc4_:DropDown = null;
         Mouse.show();
         this.info.removeEventListener(IOErrorEvent.IO_ERROR,_close);
         this.info.removeEventListener(Event.COMPLETE,this.whenMapIsLoaded);
         this.loader = null;
         this.asset.close.removeEventListener(MouseEvent.CLICK,_close);
         this.asset = null;
         if(!this.toRoom)
         {
            if(!this.room.hasOwner)
            {
               _loc1_ = this.room.id.toString();
               _loc2_ = this.room.name;
            }
            else if(this.room.ownedByUser)
            {
               _loc1_ = TrackActions.MY_HOME;
               _loc2_ = null;
            }
            else
            {
               _loc1_ = TrackActions.OTHER_HOME;
               _loc2_ = null;
            }
            Telemetry.getInstance().trackScreen(_loc1_);
         }
         this.room = null;
         net.removeEventListener(GaturroNetResponses.RANKING,this.showRankingData);
         if(this.table)
         {
            if(this.table.phFriends.numChildren > 0)
            {
               _loc3_ = DropDown(this.table.phFriends.getChildAt(0));
               _loc3_.removeEventListener(Event.CHANGE,this.chooseFromDropDown);
            }
            if(this.table.phTime.numChildren > 0)
            {
               (_loc4_ = DropDown(this.table.phTime.getChildAt(0))).removeEventListener(Event.CHANGE,this.chooseFromDropDown);
            }
         }
         if(this.map)
         {
            this.map.removeEventListener(MouseEvent.ROLL_OVER,this.toggleMouse);
            this.map.removeEventListener(MouseEvent.ROLL_OUT,this.toggleMouse);
            this.map.removeEventListener(Event.SELECT,this.whenSectionIsSelected);
            this.removeGameListeners();
            if("dispose" in this.map)
            {
               this.map.dispose();
            }
            this.map = null;
         }
         super.dispose();
      }
      
      private function whenMapIsLoaded(param1:Event) : void
      {
         this.mapLoaded = true;
         this.checkAllLoaded();
      }
      
      private function showGamePanel() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         this.map.gameData.visible = true;
         region.setText(this.asset.label.field,"MINI-JUEGOS");
         region.setText(this.map.gameData.playNow.field,"JUGAR");
         this.map.gameData.playNow.addEventListener(MouseEvent.CLICK,this.playGame);
         region.setText(this.map.gameData.visit.field,"VISITAR");
         this.map.gameData.visit.addEventListener(MouseEvent.CLICK,this.visitGame);
         this.map.gameData.backToMap.addEventListener(MouseEvent.CLICK,this.backGame);
         this.map.removeEventListener(MouseEvent.ROLL_OVER,this.toggleMouse);
         this.map.removeEventListener(MouseEvent.ROLL_OUT,this.toggleMouse);
         region.setText(this.map.gameData.title,this.map.names["g_" + this.gameName].name);
         this.map.gameData.title.visible = true;
         DisplayUtil.empty(this.map.gameData.ph);
         if(this.map.loaderInfo.applicationDomain.hasDefinition(this.gameName))
         {
            _loc1_ = this.map.loaderInfo.applicationDomain.getDefinition(this.gameName);
            _loc2_ = MovieClip(new _loc1_());
            if(_loc2_)
            {
               this.map.gameData.ph.addChild(_loc2_);
            }
         }
         Mouse.show();
         this.addRank();
         this.loadGameData();
      }
      
      private function showRankLines() : void
      {
         this.table.names.visible = true;
         this.table.scores.visible = true;
         this.table.score.visible = true;
         this.table.scoreTitle.visible = true;
         this.table.loading.visible = false;
         var _loc1_:DropDown = DropDown(this.table.phFriends.getChildAt(0));
         var _loc2_:DropDown = DropDown(this.table.phTime.getChildAt(0));
         _loc1_.visible = true;
         _loc2_.visible = true;
      }
      
      private function executeRoomChange(param1:RoomLink) : void
      {
         if(this.room)
         {
            this.room.changeTo(param1);
         }
         dispatchEvent(new RoomEvent(RoomEvent.CHANGE_ROOM,param1));
      }
      
      private function chooseFromDropDown(param1:Event) : void
      {
         this.loadGameData();
      }
      
      private function loadGameData() : void
      {
         var _loc1_:DropDown = DropDown(this.table.phFriends.getChildAt(0));
         var _loc2_:DropDown = DropDown(this.table.phTime.getChildAt(0));
         var _loc3_:String = "WEEK";
         if(_loc2_.selectedIndex != -1)
         {
            _loc3_ = _loc2_.value == this.TIME_WEEK ? "WEEK" : (_loc2_.value == this.TIME_MONTH ? "MONTH" : "NONE");
         }
         var _loc4_:* = false;
         if(_loc1_.selectedIndex != -1)
         {
            _loc4_ = _loc1_.value == this.FRIENDS_TRUE;
         }
         this.hideRankLines();
         if(this.gameName == "tumbaBeach")
         {
            this.gameName = "tumba";
         }
         logger.info("Request for rankings --> game " + this.gameName);
         net.addEventListener(GaturroNetResponses.RANKING,this.showRankingData);
         net.sendAction(new RankingDataRequest(this.gameName,_loc3_,_loc4_,10));
      }
      
      private function showRankingData(param1:NetworkManagerEvent) : void
      {
         var _loc5_:Mobject = null;
         net.removeEventListener(GaturroNetResponses.RANKING,this.showRankingData);
         this.map.gameData.ranking.addChild(this.table);
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:int = 0;
         this.table.score.text = "0";
         for each(_loc5_ in param1.mobject.getMobjectArray("ranking"))
         {
            _loc4_++;
            if(_loc4_ <= 10)
            {
               _loc2_ += _loc4_.toString() + ". " + _loc5_.getString("username") + "\n";
               _loc3_ += _loc5_.getInteger("score").toString() + "\n";
            }
         }
         this.table.score.text = param1.mobject.getInteger("currentUserScore").toString();
         this.table.names.text = _loc2_;
         this.table.scores.text = _loc3_;
         this.showRankLines();
      }
      
      private function instantPlayGame() : void
      {
         this.room.startMinigame(this.gameName);
      }
      
      private function removeGameListeners() : void
      {
         this.map.gameData.playNow.removeEventListener(MouseEvent.CLICK,this.playGame);
         this.map.gameData.visit.removeEventListener(MouseEvent.CLICK,this.visitGame);
         this.map.gameData.backToMap.removeEventListener(MouseEvent.CLICK,this.backGame);
      }
      
      private function playGame(param1:Event) : void
      {
         this.removeGameListeners();
         this.saveMapState();
         this.instantPlayGame();
      }
      
      private function visitGame(param1:MouseEvent) : void
      {
         var _loc2_:RoomLink = this.extractRoomLink();
         this.executeRoomChange(_loc2_);
      }
      
      private function checkAllLoaded() : void
      {
         if(this.configLoaded && this.mapLoaded)
         {
            this.whenAllLoaded();
         }
      }
      
      override protected function get openSound() : String
      {
         return "mapa1";
      }
      
      private function whenAllLoaded() : void
      {
         this.map = this.loader.content as MovieClip;
         this.map.setConfig(this.gamesConfig);
         this.map.acquireAPI(api);
         if(this.gameName == "")
         {
            this.showMap();
         }
         else
         {
            this.showGamePanel();
         }
         this.asset.ph.addChild(this.map);
      }
      
      private function addRank() : void
      {
         var _loc2_:DropDown = null;
         this.table = new RankingMC();
         var _loc1_:TextFormat = this.table.names.getTextFormat();
         _loc2_ = new DropDown();
         _loc2_.width = 270;
         _loc2_.add(this.FRIENDS_TRUE);
         _loc2_.add(this.FRIENDS_FALSE);
         _loc2_.textField.setStyle("embedFonts",true);
         _loc2_.textField.setStyle("textFormat",_loc1_);
         _loc2_.dropdown.setRendererStyle("embedFonts",true);
         _loc2_.dropdown.setRendererStyle("textFormat",_loc1_);
         _loc2_.addEventListener(Event.CHANGE,this.chooseFromDropDown);
         DisplayUtil.empty(this.table.phFriends);
         this.table.phFriends.addChild(_loc2_);
         _loc2_ = new DropDown();
         _loc2_.width = 270;
         _loc2_.add(this.TIME_WEEK);
         _loc2_.add(this.TIME_ALL);
         _loc2_.add(this.TIME_MONTH);
         _loc2_.textField.setStyle("embedFonts",true);
         _loc2_.textField.setStyle("textFormat",_loc1_);
         _loc2_.dropdown.setRendererStyle("embedFonts",true);
         _loc2_.dropdown.setRendererStyle("textFormat",_loc1_);
         _loc2_.addEventListener(Event.CHANGE,this.chooseFromDropDown);
         this.table.phTime.addChild(_loc2_);
         DisplayUtil.empty(this.map.gameData.ranking);
         this.map.gameData.ranking.addChild(this.table);
      }
      
      override protected function get closeSound() : String
      {
         return "mapa2";
      }
      
      override public function close() : void
      {
         this.saveMapState();
         super.close();
      }
      
      private function backGame(param1:Event) : void
      {
         this.removeGameListeners();
         this.map.gameData.visible = false;
         this.showMap();
      }
      
      private function addMap() : void
      {
         this.loader = new Loader();
         this.info.addEventListener(IOErrorEvent.IO_ERROR,_close);
         this.info.addEventListener(Event.COMPLETE,this.whenMapIsLoaded);
         var _loc1_:String = URLUtil.versionedPath(URI);
         var _loc2_:String = URLUtil.getUrl(_loc1_);
         this.loader.load(new URLRequest(_loc2_));
      }
   }
}

class Config
{
   
   public static var data:Object = {"data":{
      "anteojos2019":{
         "name":"ANTEOJOS ESPECIALES",
         "id":51690070,
         "coord":[9,8]
      },
      "gatucine":{
         "name":"MASCOTAS 2",
         "id":61688,
         "coord":[11,7]
      },
      "mobile":{
         "name":"¡JUEGA EN TU TELÉFONO!",
         "id":25357,
         "coord":[15,7]
      },
      "naves":{
         "name":"TRANSPORTES ESPACIALES",
         "id":25369,
         "coord":[9,7]
      },
      "presidentes2019":{
         "name":"¡MANIFIÉSTATE!",
         "id":25357,
         "coord":[6,8]
      },
      "peluqueria2019":{
         "name":"PEINADOS DEGRADÉ",
         "id":25375,
         "coord":[8,4]
      },
      "pikachu":{
         "name":"¡AYUDA A RESOLVER EL CASO!",
         "id":25358,
         "coord":[11,6]
      },
      "navidad_refrito_2019":{
         "name":"¡FELIZ NAVIDAD!",
         "id":47983,
         "coord":[7,9]
      },
      "summer2020":{
         "name":"¡HELADO, HELADO!",
         "id":25370,
         "coord":[12,3]
      },
      "easter19_2":{
         "name":"NUEVA COLECCIÓN DE PASCUAS",
         "id":51690078,
         "coord":[5,5]
      },
      "easter19_1":{
         "name":"COCINA UN HUEVO",
         "id":51690555,
         "coord":[10,11]
      },
      "easter19_3":{
         "name":"LIBERA HUEVITOS",
         "id":51690568,
         "coord":[11,11]
      },
      "pelos":{
         "name":"PEINADOS EXCLUSIVOS",
         "id":42038,
         "coord":[5,10]
      },
      "influencers2019":{
         "name":"¡GATUTORES!",
         "id":51688983,
         "coord":[5,9]
      },
      "gatufashionCool":{
         "name":"REMERAS COOL",
         "id":25374,
         "coord":[12,6]
      },
      "nurseryHospital":{
         "name":"¡GUARDERÍA!",
         "id":51689785,
         "coord":[7,12]
      },
      "shoppingCool":{
         "name":"VESTIDOR: BEBES",
         "id":42038,
         "coord":[8,7]
      },
      "espacioParque":{
         "name":"¡¡JUNTA LOS SQUISHIES!!",
         "id":51690076,
         "coord":[18,6]
      },
      "nik2019":{
         "name":"¡¡CUMPLE NIK!!",
         "id":51690477,
         "coord":[6,8]
      },
      "carnaval2020":{
         "name":"VOLVIÓ EL CARNAVAL!",
         "id":51689577,
         "coord":[9,8]
      },
      "carnavalFiesta":{
         "name":"¡ARMA TU CARNAVAL!",
         "id":51688753,
         "coord":[10,8]
      },
      "juegosParque":{
         "name":"¡JUEGA EN CARNAVAL!",
         "id":51688342,
         "coord":[6,8]
      },
      "rosedal2019":{
         "name":"ROSEDAL DE LA AMISTAD!",
         "id":51690477,
         "coord":[4,7]
      },
      "sanValPark":{
         "name":"¡CASAMIENTO!",
         "id":51683119,
         "coord":[7,9]
      },
      "sanValShop":{
         "name":"AYUDA A ISTIVI CUPIDO",
         "id":25362,
         "coord":[19,8]
      },
      "sanValFlower":{
         "name":"FLORERIA",
         "id":35342,
         "coord":[18,10]
      },
      "sanValNoria":{
         "name":"PASEO DEL AMOR",
         "id":51688280,
         "coord":[9,10]
      },
      "campamento19lago":{
         "name":"LAGO DEL ROSEDAL",
         "id":51690476,
         "coord":[1,6]
      },
      "campamento19":{
         "name":"NUEVA MISION PIRATA",
         "id":51690474,
         "coord":[8,7]
      },
      "misionGlobo":{
         "name":"MISIÓN EN EL PARQUE",
         "id":32540,
         "coord":[8,10]
      },
      "gatufashion2019":{
         "name":"GATUFASHION RENOVADO",
         "id":25374,
         "coord":[12,6]
      },
      "reyes":{
         "name":"LLEGARON LOS REYES",
         "id":69403,
         "coord":[10,9]
      },
      "ny2019":{
         "name":"¡FELIZ 2019!",
         "id":25371,
         "coord":[12,8]
      },
      "guerraNavidad2018":{
         "name":"¡DEFENDE LA NAVIDAD!",
         "id":51690416,
         "coord":[6,9]
      },
      "navidad2018":{
         "name":"¡MISIÓN NAVIDEÑA!",
         "id":47983,
         "coord":[6,9]
      },
      "kdaCostumes2018":{
         "name":"¡LLEGO EL NUEVO SHOW!",
         "id":51688698,
         "coord":[9,10]
      },
      "catalogoBanderas2018":{
         "name":"¡UNION LATINOAMERICANA!",
         "id":51684582,
         "coord":[5,12]
      },
      "catalogoBebes2018":{
         "name":"COLECCIÓN DE BEBÉS",
         "id":25357,
         "coord":[18,8]
      },
      "ninjaJapon":{
         "name":"¡NINJAS!",
         "id":51687540,
         "coord":[10,11]
      },
      "atlantis":{
         "name":"MISTERIO EN LAS PROFUNDIDADES",
         "id":38341,
         "coord":[12,6]
      },
      "gatupacks":{
         "name":"¡GATUPACK LATINO!",
         "id":51689177,
         "coord":[10,9]
      },
      "fiestaHalloween2018":{
         "name":"¡NOCHE DE HALLOWEEN!",
         "id":51683338,
         "coord":[6,8]
      },
      "gatitoHw18":{
         "name":"TU SOBRE DIARIO",
         "id":47981,
         "coord":[6,11]
      },
      "portonHalloween2018":{
         "name":"EL PORTÓN CEDIÓ...!",
         "id":47964,
         "coord":[17,8]
      },
      "hadaHw18":{
         "name":"¡AYUDA AL HADA!",
         "id":54298,
         "coord":[18,9]
      },
      "bosqueHw18":{
         "name":"¡PELIGRO!",
         "id":43032,
         "coord":[4,10]
      },
      "misionBrujo":{
         "name":"¡AYUDA AL BRUJO!",
         "id":56280,
         "coord":[5,10]
      },
      "calderoHalloween2018":{
         "name":"¡AH... EL CALDERO!",
         "id":43121,
         "coord":[5,11]
      },
      "magosHalloween2018":{
         "name":"¡AYUDA A LOS MAGOS!",
         "id":51689644,
         "coord":[10,9]
      },
      "mantis":{
         "name":"¡PLANETA CIRKUIT!",
         "id":69407,
         "coord":[9,4]
      },
      "profesiones2018":{
         "name":"¡A TRABAJAR!",
         "id":69398,
         "coord":[8,8]
      },
      "dailyBonus":{
         "name":"¡GATITO REGALÓN!",
         "id":25370,
         "coord":[3,10]
      },
      "escuela":{
         "name":"FICHÍN ESCOLAR",
         "id":51684582,
         "coord":[5,6]
      },
      "MercadoUrbanoShop":{
         "name":"¡MERCADO URBANO!",
         "id":42038,
         "coord":[7,9]
      },
      "peinados2018":{
         "name":"¡RENUEVA TU PELAJE!",
         "id":25375,
         "coord":[8,3]
      },
      "lab":{
         "name":"¡LAB DE DISEÑO!",
         "id":72746,
         "coord":[6,9]
      },
      "vigutsShortcut":{
         "name":"¡CONSIGUE VIGUTS!",
         "id":51689177,
         "coord":[12,8],
         "countries":["AR"]
      },
      "showroom":{
         "name":"¡COLECCIÓN ARCOIRIS!",
         "id":51689177,
         "coord":[6,10]
      },
      "vestidoresShop":{
         "name":"¡VESTIDORES!",
         "id":48443,
         "coord":[7,9]
      },
      "espacioGatubers":{
         "name":"¡ESPACIO GATUBERS!",
         "id":32950,
         "coord":[12,9]
      },
      "pintureriaShop":{
         "name":"¡PINTURERÍA!",
         "id":69138,
         "coord":[6,9]
      },
      "ladybug":{
         "name":"BUSCANDO BICHITOS",
         "id":25358,
         "coord":[9,7]
      },
      "supervillanos":{
         "name":"¡GUARIDA SUPERVILLANOS!",
         "id":51688178,
         "coord":[6,9]
      },
      "flanys":{
         "name":"¡BUBBLE FLANYS!",
         "id":25358,
         "coord":[6,8]
      },
      "bocaGenerico":{
         "name":"¡NUEVOS ACCESORIOS!",
         "id":51689003,
         "coord":[12,10]
      },
      "riverGenerico":{
         "name":"¡NUEVOS ACCESORIOS!",
         "id":51689814,
         "coord":[12,10]
      },
      "riverCancha":{
         "name":"MONUMENTAL",
         "id":51689814,
         "coord":[10,5]
      },
      "bocaCancha":{
         "name":"BOMBONERA",
         "id":51689003,
         "coord":[9,5]
      },
      "animales2018":{
         "name":"¡ESENCIAS ANIMALES!",
         "id":37747,
         "coord":[5,7]
      },
      "misionCorona":{
         "name":"¡TESORO PIRATA!",
         "id":25364,
         "coord":[10,10]
      },
      "fortCat":{
         "name":"¡FORTGAT!",
         "id":25361,
         "coord":[16,6]
      },
      "city1":{
         "name":"TU CIUDAD",
         "id":25355
      },
      "city2":{
         "name":"TU CIUDAD",
         "id":25356,
         "coord":[9,8]
      },
      "city3":{
         "name":"TU CIUDAD",
         "id":25363
      },
      "city4":{
         "name":"TU CIUDAD",
         "id":25362
      },
      "city5":{
         "name":"TU CIUDAD",
         "id":31739
      },
      "beach1":{
         "name":"TU PLAYA",
         "id":25361,
         "coord":[16,9]
      },
      "beach2":{
         "name":"TU PLAYA",
         "id":25360
      },
      "beach3":{
         "name":"TU PLAYA",
         "id":25364
      },
      "beach4":{
         "name":"BALNEARIO \'EL FARO\'",
         "id":38341
      },
      "snow1":{
         "name":"NIEVE",
         "id":25367
      },
      "snow2":{
         "name":"JUEGOS DE NIEVE",
         "id":25368
      },
      "snow3":{
         "name":"DESPEGUE",
         "id":25369
      },
      "park1":{
         "name":"PARQUE",
         "id":25357
      },
      "park2":{
         "name":"PARQUE",
         "id":25358
      },
      "plaza":{
         "name":"PLAZA",
         "id":45419,
         "coord":[12,7]
      },
      "parkLove":{
         "name":"ROSEDAL",
         "id":38318,
         "coord":[1,1]
      },
      "parkDark":{
         "name":"BOSQUE EMBRUJADO",
         "id":43032,
         "coord":[4,9]
      },
      "parkDark2":{
         "name":"BOSQUE EMBRUJADO",
         "id":43032,
         "coord":[4,9]
      },
      "hotelEmbrujado":{
         "name":"HOTEL EMBRUJADO",
         "id":51683129,
         "coord":[21,10]
      },
      "bruja":{
         "name":"CABAÑA DE ANGÉLICA",
         "id":43121,
         "coord":[5,3]
      },
      "parkDiversion":{
         "name":"PARQUE DE DIVERSIONES",
         "id":51688279,
         "coord":[6,11]
      },
      "museo":{
         "name":"MUSEO",
         "id":42325,
         "coord":[6,11]
      },
      "sky1":{
         "name":"TERRAZA PH",
         "id":25371
      },
      "sky2":{
         "name":"CABLES",
         "id":31820
      },
      "sky3":{
         "name":"TERRAZA MODERNA",
         "id":25370,
         "coord":[8,9]
      },
      "casamiento":{
         "name":"¡CASAMIENTO!",
         "id":51683119,
         "coord":[10,9]
      },
      "escuelaNueva":{
         "name":"¡ESCUELA!",
         "id":51684582,
         "coord":[6,12]
      },
      "unicef":{
         "name":"PLANETA UNICEF",
         "id":47731,
         "coord":[7,11]
      },
      "museo":{
         "name":"MUSEO DE CIENCIAS",
         "id":42325,
         "coord":[6,11]
      },
      "estadio":{
         "name":"ESTADIO",
         "id":45698,
         "coord":[10,7]
      },
      "egipto":{
         "name":"DISCOTECA",
         "id":56280,
         "coord":[15,9]
      },
      "muelle":{
         "name":"MUELLE",
         "id":33168,
         "coord":[15,9]
      },
      "isla":{
         "name":"ISLA",
         "id":33764,
         "coord":[12,6]
      },
      "aeropuerto":{
         "name":"AEROPUERTO",
         "id":54163,
         "coord":[16,10]
      },
      "space":{
         "name":"AL ESPACIO",
         "id":51686897,
         "coord":[7,10]
      },
      "cottage":{
         "name":"REFUGIO",
         "id":25376,
         "coord":[12,4]
      },
      "veterinaria":{
         "name":"VETERINARIA",
         "id":43657,
         "coord":[8,6]
      },
      "cine":{
         "name":"CINE",
         "id":61688,
         "coord":[15,10]
      },
      "hospital":{
         "name":"HOSPITAL",
         "id":51688107,
         "coord":[9,10]
      },
      "gatubersGallery":{
         "name":"ESPACIO GATUBER",
         "id":32950,
         "coord":[12,7]
      },
      "flowerStore":{
         "name":"FLORERIA",
         "id":35342,
         "coord":[22,11]
      },
      "hairdressing":{
         "name":"PELUQUERIA",
         "id":25375,
         "coord":[8,4]
      },
      "laboratorioDiseno":{
         "name":"LABORATORIO DE DISEÑO",
         "id":72746,
         "coord":[7,4]
      },
      "edificio":{
         "name":"EDIFICIO",
         "id":25362,
         "coord":[10,3]
      },
      "giftstore":{
         "name":"TIENDA-REGALOS",
         "id":31755,
         "coord":[17,3]
      },
      "compraVenta":{
         "name":"COMPRA-VENTA",
         "id":33860,
         "coord":[7,6]
      },
      "tecno":{
         "name":"TECNOLOGÍA",
         "id":45583,
         "coord":[7,11]
      },
      "fashion":{
         "name":"GATU-FASHION",
         "id":25374,
         "coord":[12,6]
      },
      "shopping":{
         "name":"¡GATUSHOPPING!",
         "id":25362,
         "coord":[13,11]
      },
      "bar":{
         "name":"BAR",
         "id":26580,
         "coord":[11,4]
      },
      "g_snowPenguin":{
         "name":"PECES BAJO EL AGUA",
         "id":25368,
         "coord":[19,7]
      },
      "g_findthecat":{
         "name":"VEO-VEO",
         "id":25368,
         "coord":[16,5]
      },
      "g_match":{
         "name":"¡LLUVIA DE METEORITOS!",
         "id":42739,
         "coord":[14,11]
      },
      "g_snowball":{
         "name":"BOLA DE NIEVE",
         "id":25369,
         "coord":[18,5]
      },
      "g_spacehunters":{
         "name":"¡CAZADORES LUNARES!",
         "id":42736,
         "coord":[13,8]
      },
      "g_whackacat2":{
         "name":"¡NAVES ABDUCIENDO!",
         "id":25370,
         "coord":[5,7]
      },
      "g_jetpack":{
         "name":"EXPEDICIÓN NATURALEZA",
         "id":68114,
         "coord":[12,7]
      },
      "g_cooking":{
         "name":"COCINA",
         "id":26580,
         "coord":[4,7]
      },
      "g_petvet":{
         "name":"SALITA DE ANIMALES",
         "id":43657,
         "coord":[6,7]
      },
      "g_butterflies":{
         "name":"MARIPOSAS",
         "id":32540,
         "coord":[12,10]
      },
      "g_driving":{
         "name":"GATURRO AL VOLANTE",
         "id":31739,
         "coord":[11,10]
      },
      "g_snowwar":{
         "name":"GUERRA DE NIEVE",
         "id":25369,
         "coord":[13,4]
      },
      "g_bibliotecav2":{
         "name":"BIBLIOTECA REVUELTA",
         "id":47985,
         "coord":[11,10]
      },
      "g_dressers":{
         "name":"VISTIENDO A GATURRO",
         "id":69633,
         "coord":[12,7]
      },
      "g_matematica":{
         "name":"TRÁFICO LIVIANO",
         "id":70155,
         "coord":[11,9]
      },
      "g_skate":{
         "name":"CARRERA EN SKATE",
         "id":25355,
         "coord":[9,10]
      },
      "g_ingredientes":{
         "name":"GATU CHEF",
         "id":47985,
         "coord":[9,10]
      },
      "g_runjump":{
         "name":"TRIATLÓN",
         "id":45698,
         "coord":[8,6]
      },
      "g_personajes":{
         "name":"DESAFÍO LECTOR",
         "id":47985,
         "coord":[4,7]
      },
      "g_turismo":{
         "name":"TURISMO ARITMÉTICO",
         "id":70155,
         "coord":[16,10]
      },
      "g_colourcode":{
         "name":"MISIÓN CLAVE",
         "id":70155,
         "coord":[4,8]
      },
      "g_jumprope":{
         "name":"SALTAR LA SOGA",
         "id":25364,
         "coord":[2,4]
      },
      "g_clima":{
         "name":"NUBE CON ARCOIRIS",
         "id":68114,
         "coord":[14,10]
      },
      "g_ecofotos":{
         "name":"ECOFOTOS",
         "id":69633,
         "coord":[17,6]
      },
      "g_maquinadeltiempo":{
         "name":"VIAJE EN EL TIEMPO",
         "id":69633,
         "coord":[6,10]
      },
      "g_fracciones":{
         "name":"FRACCIONES",
         "id":70155,
         "coord":[14,4]
      },
      "g_naturalessupermercado":{
         "name":"SUPER",
         "id":68114,
         "coord":[8,9]
      },
      "g_islandPlatform":{
         "name":"CATACUMBAS",
         "id":33769,
         "coord":[12,6]
      },
      "g_speed":{
         "name":"GATRIX",
         "id":33770,
         "coord":[7,8]
      },
      "g_geocat":{
         "name":"CIENCIAS GEOGRÁFICAS",
         "id":42382,
         "coord":[8,11]
      },
      "g_planes":{
         "name":"AVIONCITOS",
         "id":25371,
         "coord":[5,3]
      },
      "g_baby":{
         "name":"CUIDANDO A GATURRIN",
         "id":25363,
         "coord":[14,8]
      },
      "g_misiongps":{
         "name":"MISIÓN GPS",
         "id":73066,
         "coord":[11,10]
      },
      "g_petrolling":{
         "name":"MINIPARQUE",
         "id":43657,
         "coord":[10,7]
      },
      "g_islandcannon":{
         "name":"¡ECO-BOMBAS!",
         "id":33764,
         "coord":[15,7]
      },
      "g_tumba":{
         "name":"TEMPLO ISLEÑO",
         "id":37747,
         "coord":[11,9]
      },
      "g_islandhunters":{
         "name":"TESOROS",
         "id":33770,
         "coord":[18,9]
      },
      "g_platformDream":{
         "name":"¡EL SUEÑO DE AGATHA!",
         "id":25358,
         "coord":[19,3]
      },
      "g_treasurehunters":{
         "name":"TESOROS",
         "id":25361,
         "coord":[15,9]
      },
      "g_climbing":{
         "name":"¡TREPAR Y ATRAPAR!",
         "id":25377,
         "coord":[15,6]
      },
      "g_temperaturas":{
         "name":"EL ACLIMATADOR",
         "id":68114,
         "coord":[15,6]
      },
      "g_skateJump":{
         "name":"¡PIRUETAS EN SKATE!",
         "id":25360,
         "coord":[5,2]
      },
      "g_fruitbouncer":{
         "name":"!FRUTAS LOCAS",
         "id":25360,
         "coord":[8,9]
      },
      "g_ratonBala":{
         "name":"RATON ESTRELLADO",
         "id":25356,
         "coord":[4,10]
      },
      "g_bouncer":{
         "name":"¡BOUNCER!",
         "id":51688342,
         "coord":[6,3]
      },
      "g_dance":{
         "name":"¡DANCE!",
         "id":39006,
         "coord":[19,10]
      },
      "g_decathlon":{
         "name":"¡DECATHLON!",
         "id":45698,
         "coord":[15,7]
      },
      "g_dungeon":{
         "name":"DUNGEON!",
         "id":51689646,
         "coord":[18,10]
      },
      "g_extraterrestres":{
         "name":"¡LIMPIANDO SMOG!",
         "id":51684239,
         "coord":[11,11]
      },
      "g_flymetothemoon":{
         "name":"CENA DE SAN VALENTIN",
         "id":51688280,
         "coord":[11,10]
      },
      "g_huesos":{
         "name":"BUSCANDO HUESOS",
         "id":33767,
         "coord":[12,7]
      },
      "g_jetpackSpace":{
         "name":"EXPEDICION ESPACIAL",
         "id":51687464,
         "coord":[8,10]
      },
      "g_mascotaball":{
         "name":"MASCOTABALL",
         "id":51688342,
         "coord":[6,3]
      },
      "g_penales":{
         "name":"PENALES",
         "id":45698,
         "coord":[4,8]
      },
      "g_penguin":{
         "name":"PENGUIN",
         "id":25368,
         "coord":[18,7]
      },
      "g_petglamor":{
         "name":"PET GLAMOUR",
         "id":43657,
         "coord":[9,9]
      },
      "g_petpower":{
         "name":"PET POWER",
         "id":51688342,
         "coord":[6,3]
      },
      "g_petwit":{
         "name":"PET WIT",
         "id":43657,
         "coord":[9,9]
      },
      "g_pirates":{
         "name":"PIRATES",
         "id":43019,
         "coord":[6,10]
      },
      "g_matatopos":{
         "name":"MATATOPOS",
         "id":51688342,
         "coord":[6,3]
      },
      "g_letras":{
         "name":"LETRAS",
         "id":51684596,
         "coord":[6,7]
      },
      "g_martillo":{
         "name":"MARTILLO",
         "id":51688342,
         "coord":[6,3]
      },
      "g_supershake":{
         "name":"PELEA COMO HEROE",
         "id":56076,
         "coord":[5,11]
      },
      "g_termometro":{
         "name":"TERMÓMETRO",
         "id":51684582,
         "coord":[5,6]
      },
      "g_accesibilidad":{
         "name":"ACCESIBILIDAD",
         "id":25356,
         "coord":[17,12]
      },
      "g_aquawoman":{
         "name":"AQUAWOMAN",
         "id":38355,
         "coord":[8,6]
      },
      "g_basket":{
         "name":"BASKET",
         "id":51688342,
         "coord":[6,3]
      },
      "g_inflaglobo":{
         "name":"INFLAGLOBO",
         "id":51688342,
         "coord":[6,3]
      },
      "g_ball":{
         "name":"JUEGUITO",
         "id":45698,
         "coord":[4,7]
      },
      "g_penales":{
         "name":"PENALES",
         "id":45698,
         "coord":[10,10]
      },
      "g_cars":{
         "name":"AUTOS DE COLORES",
         "id":31820
      },
      "g_penguin":{
         "name":"PINGUINO",
         "id":25364,
         "coord":[16,6]
      },
      "g_tumbaBeach":{
         "name":"TEMPLO SECRETO",
         "id":25364,
         "coord":[8,5]
      },
      "s_bazar_deco":{
         "name":"DECO",
         "id":43001,
         "coord":[8,3]
      },
      "s_bazar_deco":{
         "name":"DECO",
         "id":43001,
         "coord":[8,3]
      },
      "s_bazar_muebles":{
         "name":"MUEBLES",
         "id":42038,
         "coord":[3,9]
      },
      "s_bazar_juguetes":{
         "name":"JUGUETES",
         "id":42038,
         "coord":[8,3]
      },
      "s_bazar_hogar":{
         "name":"HOGAR",
         "id":43001,
         "coord":[2,10]
      },
      "s_bazar_showroom":{
         "name":"EXCLUSIVOS",
         "id":25378,
         "coord":[15,8]
      },
      "s_fashion_boy":{
         "name":"ROPA CHICOS",
         "id":25374,
         "coord":[3,9]
      },
      "s_fashion_girl":{
         "name":"ROPA CHICAS",
         "id":25374,
         "coord":[16,9]
      },
      "s_fashion_vip":{
         "name":"ROPA VIP",
         "id":34642,
         "coord":[7,9]
      },
      "s_snow_clothes":{
         "name":"ABRIGOS",
         "id":25367,
         "coord":[12,8]
      },
      "s_street_transport":{
         "name":"TRANSPORTES",
         "id":66835,
         "coord":[6,5]
      },
      "s_regalos":{
         "name":"REGALOS",
         "id":31755,
         "coord":[15,9]
      },
      "s_beach_pezca":{
         "name":"PESCA",
         "id":25361,
         "coord":[17,10]
      },
      "s_beach_anteojos":{
         "name":"ANTEOJOS",
         "id":25361,
         "coord":[4,4]
      },
      "s_compraventa":{
         "name":"EL COMPRA-VENTA",
         "id":33860,
         "coord":[7,6]
      },
      "s_pets":{
         "name":"ARTÍCULOS MASCOTA",
         "id":43657,
         "coord":[8,6]
      },
      "s_bar":{
         "name":"COMIDA",
         "id":26580
      },
      "s_tecno":{
         "name":"TECNOLOGÍA",
         "id":45583,
         "coord":[7,11]
      },
      "s_flores":{
         "name":"FLORERIA",
         "id":35342,
         "coord":[19,9]
      },
      "s_belleza":{
         "name":"BELLEZA",
         "id":25375
      },
      "mascotasDisfraces":{
         "name":"NUEVOS DISFRACES",
         "id":69138,
         "coord":[5,5]
      }
   }};
    
   
   public function Config()
   {
      super();
   }
}
