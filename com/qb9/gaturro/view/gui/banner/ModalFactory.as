package com.qb9.gaturro.view.gui.banner
{
   import com.qb9.flashlib.tasks.*;
   import com.qb9.gaturro.external.roomObjects.*;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.service.events.gui.PartyInviteFriendsBanner;
   import com.qb9.gaturro.view.components.banner.albumHalloween2018.AlbumHalloween2018Banner;
   import com.qb9.gaturro.view.components.banner.albumHalloween2018.HalloweenBoosterRewardBanner;
   import com.qb9.gaturro.view.components.banner.albumMonster2019.AlbumMonster2019Banner;
   import com.qb9.gaturro.view.components.banner.albumMonster2019.MonsterBoosterRewardBanner;
   import com.qb9.gaturro.view.components.banner.albumXmas2018.AlbumXmas2018Banner;
   import com.qb9.gaturro.view.components.banner.albumXmas2018.XmasBoosterRewardBanner;
   import com.qb9.gaturro.view.components.banner.albummundial2018.AlbumMundial2018Banner;
   import com.qb9.gaturro.view.components.banner.albummundial2018.BoosterRewardBanner;
   import com.qb9.gaturro.view.components.banner.alert.SkinableAlertBanner;
   import com.qb9.gaturro.view.components.banner.asteroids.AsteroidsRewardsBanner;
   import com.qb9.gaturro.view.components.banner.boca.BocaCups;
   import com.qb9.gaturro.view.components.banner.boca.BocaPenalesMatcher;
   import com.qb9.gaturro.view.components.banner.boca.BocaTorneoInscripcion;
   import com.qb9.gaturro.view.components.banner.boca.BocaTorneoIntroduccionBanner;
   import com.qb9.gaturro.view.components.banner.boca.BocaTriviaBanner;
   import com.qb9.gaturro.view.components.banner.camera.*;
   import com.qb9.gaturro.view.components.banner.christmasLetter.*;
   import com.qb9.gaturro.view.components.banner.cinema.*;
   import com.qb9.gaturro.view.components.banner.codeBurner.*;
   import com.qb9.gaturro.view.components.banner.colorpicker.ColorPickerModal;
   import com.qb9.gaturro.view.components.banner.colorpicker.ColorPickerModal2;
   import com.qb9.gaturro.view.components.banner.craft.*;
   import com.qb9.gaturro.view.components.banner.dressingRoom.Babosas2018Banner;
   import com.qb9.gaturro.view.components.banner.dressingRoom.DressingRoomBanner;
   import com.qb9.gaturro.view.components.banner.dressingRoom.LookGeneratorBanner;
   import com.qb9.gaturro.view.components.banner.dressingRoom.LooksAnimalesBanner;
   import com.qb9.gaturro.view.components.banner.dressingRoom.LooksColegioBanner;
   import com.qb9.gaturro.view.components.banner.dressingRoom.VestidorTematicoBanner;
   import com.qb9.gaturro.view.components.banner.dressingRoom.WearBuilderBanner;
   import com.qb9.gaturro.view.components.banner.dressingRoom.WearBuilderBanner2;
   import com.qb9.gaturro.view.components.banner.emoting.ActionConfigurationBanner;
   import com.qb9.gaturro.view.components.banner.emoting.EmotingConfigurationBanner;
   import com.qb9.gaturro.view.components.banner.fannysreward.FannysRewardBanner;
   import com.qb9.gaturro.view.components.banner.gatoons.*;
   import com.qb9.gaturro.view.components.banner.gatubers.GatubersBillboardBanner;
   import com.qb9.gaturro.view.components.banner.gatubers.GatubersLiveBanner;
   import com.qb9.gaturro.view.components.banner.gift.*;
   import com.qb9.gaturro.view.components.banner.globe.*;
   import com.qb9.gaturro.view.components.banner.goblin.*;
   import com.qb9.gaturro.view.components.banner.halloweenRewards.HalloweenRewardsBanner;
   import com.qb9.gaturro.view.components.banner.halloweenTeam.HalloweenTeamSelectorBanner;
   import com.qb9.gaturro.view.components.banner.houseKick.HouseKickModal;
   import com.qb9.gaturro.view.components.banner.instrumento.InstrumentoBanner;
   import com.qb9.gaturro.view.components.banner.itemConsumer.ItemConsumerBanner;
   import com.qb9.gaturro.view.components.banner.navidad2017.NavidadRewardsBanner;
   import com.qb9.gaturro.view.components.banner.newYear.*;
   import com.qb9.gaturro.view.components.banner.noria.*;
   import com.qb9.gaturro.view.components.banner.olympic.*;
   import com.qb9.gaturro.view.components.banner.park.*;
   import com.qb9.gaturro.view.components.banner.partyBillboard.PartyBillboardBanner;
   import com.qb9.gaturro.view.components.banner.partyElite.PartyEliteWinnerSelectorBanner;
   import com.qb9.gaturro.view.components.banner.partyPlanner.PartyPlanner;
   import com.qb9.gaturro.view.components.banner.passport.*;
   import com.qb9.gaturro.view.components.banner.photoTrip.*;
   import com.qb9.gaturro.view.components.banner.piano.*;
   import com.qb9.gaturro.view.components.banner.quest.*;
   import com.qb9.gaturro.view.components.banner.recicle.RecycleBanner;
   import com.qb9.gaturro.view.components.banner.reyes2018.ReyesRewardBanner;
   import com.qb9.gaturro.view.components.banner.river.RiverCups;
   import com.qb9.gaturro.view.components.banner.river.RiverPenalesMatcher;
   import com.qb9.gaturro.view.components.banner.river.RiverTriviaBanner;
   import com.qb9.gaturro.view.components.banner.serenito.EmojiMakerBanner;
   import com.qb9.gaturro.view.components.banner.serenito.seretubers.SeretubersCreatorBanner;
   import com.qb9.gaturro.view.components.banner.superhero.*;
   import com.qb9.gaturro.view.components.banner.threeKings.*;
   import com.qb9.gaturro.view.components.banner.verano2018.PoolInviteFriends;
   import com.qb9.gaturro.view.gui.banner.properties.*;
   import com.qb9.gaturro.view.gui.base.modal.*;
   import com.qb9.gaturro.view.screens.UserSettingsBanner;
   import com.qb9.mambo.net.manager.*;
   import flash.utils.*;
   
   public class ModalFactory
   {
       
      
      private var propertySetter:PropertySetter;
      
      private var propertyGetter:PropertyGetter;
      
      private var mapClass:Dictionary;
      
      public function ModalFactory(param1:GaturroRoomAPI, param2:TaskRunner, param3:NetworkManager)
      {
         super();
         this.propertySetter = new PropertySetter();
         this.setupPropertyGetter(param1,param2,param3);
         this.setupMapClass();
      }
      
      private function getModalClass(param1:String) : Class
      {
         if(this.mapClass[param1])
         {
            api.log.debug("INSTANCIANDO " + param1);
            return this.mapClass[param1];
         }
         logger.debug(this,"The modal with the name " + param1 + " isn\'t mapped");
         logger.debug(this,"te abro este banner cualquiera para no romper");
         return this.mapClass["CodeBurnerBanner"];
      }
      
      private function addPropertiess(param1:IHasPropertyTarget, param2:String = "", param3:Object = null) : void
      {
         this.propertyGetter.options = param2;
         this.propertyGetter.data = param3;
         this.propertySetter.setProperty(param1,this.propertyGetter);
      }
      
      private function setupMapClass() : void
      {
         this.mapClass = new Dictionary();
         this.mapClass["QuestBanner"] = QuestBanner;
         this.mapClass["InitializationQuestBanner"] = InitializationQuestBanner;
         this.mapClass["CompletionQuestBanner"] = CompletionQuestBanner;
         this.mapClass["SuperheroWardrobeBanner"] = SuperheroWardrobeBanner;
         this.mapClass["PhotoCabinBanner"] = PhotoCabinBanner;
         this.mapClass["PhotoTripBanner"] = PhotoTripBanner;
         this.mapClass["RepisaGatoonsBanner"] = RepisaGatoonsBanner;
         this.mapClass["SuitMachineBanner"] = SuitMachineBanner;
         this.mapClass["RepisaGatoonMonsterBanner"] = RepisaGatoonMonsterBanner;
         this.mapClass["GoblinWardrobeBanner"] = GoblinWardrobeBanner;
         this.mapClass["PhotoXmasBanner"] = PhotoXmasBanner;
         this.mapClass["ChristmasCraftingBanner"] = ChristmasCraftingBanner;
         this.mapClass["ChristmasLetterBanner"] = ChristmasLetterBanner;
         this.mapClass["NewYearCardBanner"] = NewYearCardBanner;
         this.mapClass["GiftBanner"] = GiftBanner;
         this.mapClass["GlobeSelectorBanner"] = GlobeSelectorBanner;
         this.mapClass["CraftingBanner"] = CraftingBanner;
         this.mapClass["CinemaBanner"] = CinemaBanner;
         this.mapClass["CodeBurnerBanner"] = CodeBurnerBanner;
         this.mapClass["CodeBurnerViguts"] = CodeBurnerViguts;
         this.mapClass["BetterWithPassportBanner"] = BetterWithPassportBanner;
         this.mapClass["PianoBanner"] = PianoBanner;
         this.mapClass["InstrumentoBanner"] = InstrumentoBanner;
         this.mapClass["RecycleBanner"] = RecycleBanner;
         this.mapClass["ItemConsumerBanner"] = ItemConsumerBanner;
         this.mapClass["SkinableAlertBanner"] = SkinableAlertBanner;
         this.mapClass["UserSettingsBanner"] = UserSettingsBanner;
         this.mapClass["ThreeKingsInviteFriends"] = ThreeKingsInviteFriends;
         this.mapClass["ThreeKingsCommunicationBanner"] = ThreeKingsCommunicationBanner;
         this.mapClass["OlympicTeamSelectorBanner"] = OlympicTeamSelectorBanner;
         this.mapClass["HalloweenTeamSelectorBanner"] = HalloweenTeamSelectorBanner;
         this.mapClass["HalloweenRewardsBanner"] = HalloweenRewardsBanner;
         this.mapClass["NavidadRewardsBanner"] = NavidadRewardsBanner;
         this.mapClass["ReyesRewardsBanner"] = ReyesRewardBanner;
         this.mapClass["FannysRewardBanner"] = FannysRewardBanner;
         this.mapClass["AsteroidsRewardsBanner"] = AsteroidsRewardsBanner;
         this.mapClass["CodeBurnerSerenito2017"] = CodeBurnerSerenito2017;
         this.mapClass["serenitoEmojisCraftingBanner"] = SerenitoEmojisCraftingBanner;
         this.mapClass["EmojiMaker"] = EmojiMakerBanner;
         this.mapClass["SeretubersCreatorBanner"] = SeretubersCreatorBanner;
         this.mapClass["tunelFantasticoMatcher"] = FantasticTunnelMatcher;
         this.mapClass["LoveTunnelMatcher"] = LoveTunnelMatcher;
         this.mapClass["NoriaMatcher"] = NoriaMatcher;
         this.mapClass["GatubersLiveBanner"] = GatubersLiveBanner;
         this.mapClass["GatubersBillboardBanner"] = GatubersBillboardBanner;
         this.mapClass["BocaCups"] = BocaCups;
         this.mapClass["CodeBurnerBoca"] = CodeBurnerBoca;
         this.mapClass["BocaTriviaBanner"] = BocaTriviaBanner;
         this.mapClass["BocaTorneoIntroduccionBanner"] = BocaTorneoIntroduccionBanner;
         this.mapClass["BocaTorneoInscripcion"] = BocaTorneoInscripcion;
         this.mapClass["BocaPenalesMatcher"] = BocaPenalesMatcher;
         this.mapClass["HouseKickModal"] = HouseKickModal;
         this.mapClass["RiverTriviaBanner"] = RiverTriviaBanner;
         this.mapClass["RiverCups"] = RiverCups;
         this.mapClass["CodeBurnerRiver"] = CodeBurnerRiver;
         this.mapClass["RiverPenalesMatcher"] = RiverPenalesMatcher;
         this.mapClass["PartyInviteFriendsBanner"] = PartyInviteFriendsBanner;
         this.mapClass["PartyEliteWinnerSelectorBanner"] = PartyEliteWinnerSelectorBanner;
         this.mapClass["PoolInviteFriends"] = PoolInviteFriends;
         this.mapClass["PartyPlanner"] = PartyPlanner;
         this.mapClass["PartyBillboardBanner"] = PartyBillboardBanner;
         this.mapClass["EmotingConfigurationBanner"] = EmotingConfigurationBanner;
         this.mapClass["ActionConfiguration"] = ActionConfigurationBanner;
         this.mapClass["ColorPickerModal"] = ColorPickerModal;
         this.mapClass["ColorPickerModal2"] = ColorPickerModal2;
         this.mapClass["DressingRoom"] = DressingRoomBanner;
         this.mapClass["WearBuilder"] = WearBuilderBanner;
         this.mapClass["WearBuilder2"] = WearBuilderBanner2;
         this.mapClass["VestidorTematico"] = VestidorTematicoBanner;
         this.mapClass["LookGenerator"] = LookGeneratorBanner;
         this.mapClass["LooksColegio"] = LooksColegioBanner;
         this.mapClass["LooksAnimales"] = LooksAnimalesBanner;
         this.mapClass["AlbumMundial2018"] = AlbumMundial2018Banner;
         this.mapClass["BoosterRewardBanner"] = BoosterRewardBanner;
         this.mapClass["AlbumHalloween2018"] = AlbumHalloween2018Banner;
         this.mapClass["HalloweenBoosterRewardBanner"] = HalloweenBoosterRewardBanner;
         this.mapClass["AlbumXmas2018"] = AlbumXmas2018Banner;
         this.mapClass["Xmas2018BoosterRewardBanner"] = XmasBoosterRewardBanner;
         this.mapClass["AlbumMonster2019"] = AlbumMonster2019Banner;
         this.mapClass["Monster2019Booster"] = MonsterBoosterRewardBanner;
         this.mapClass["Babosas2018Banner"] = Babosas2018Banner;
      }
      
      private function setupPropertyGetter(param1:GaturroRoomAPI, param2:TaskRunner, param3:NetworkManager) : void
      {
         this.propertyGetter = new PropertyGetter();
         this.propertyGetter.roomAPI = param1;
         this.propertyGetter.taskRunner = param2;
         this.propertyGetter.networkManager = param3;
      }
      
      public function build(param1:String, param2:GaturroSceneObjectAPI, param3:String = "", param4:Object = null) : InstantiableGuiModal
      {
         this.propertyGetter.roomAPI.trackEvent("OPEN_BANNER:" + param1,"factory");
         this.propertyGetter.sceneAPI = param2;
         var _loc6_:InstantiableGuiModal;
         var _loc5_:Class;
         if((_loc6_ = new (_loc5_ = this.getModalClass(param1))()) is IHasPropertyTarget)
         {
            this.addPropertiess(_loc6_,param3,param4);
         }
         _loc6_.propertySetted();
         return _loc6_;
      }
   }
}

import com.qb9.flashlib.tasks.TaskRunner;
import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
import com.qb9.gaturro.view.gui.banner.properties.IHasNetworkManager;
import com.qb9.gaturro.view.gui.banner.properties.IHasOptions;
import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
import com.qb9.gaturro.view.gui.banner.properties.IHasSceneAPI;
import com.qb9.gaturro.view.gui.banner.properties.IHasTaskRunner;
import com.qb9.gaturro.view.gui.banner.properties.IPropertyGetter;
import com.qb9.mambo.net.manager.NetworkManager;

class PropertyGetter implements IPropertyGetter, IHasRoomAPI, IHasOptions, IHasNetworkManager, IHasTaskRunner, IHasSceneAPI
{
    
   
   private var _roomAPI:GaturroRoomAPI;
   
   private var _data:Object;
   
   private var _sceneAPI:GaturroSceneObjectAPI;
   
   private var _options:String;
   
   private var _networkManager:NetworkManager;
   
   private var _taskRunner:TaskRunner;
   
   public function PropertyGetter()
   {
      super();
   }
   
   public function set roomAPI(param1:GaturroRoomAPI) : void
   {
      this._roomAPI = param1;
   }
   
   public function get taskRunner() : TaskRunner
   {
      return this._taskRunner;
   }
   
   public function set networkManager(param1:NetworkManager) : void
   {
      this._networkManager = param1;
   }
   
   public function set data(param1:Object) : void
   {
      this._data = param1;
   }
   
   public function set sceneAPI(param1:GaturroSceneObjectAPI) : void
   {
      this._sceneAPI = param1;
   }
   
   public function get options() : String
   {
      return this._options;
   }
   
   public function propertySetted() : void
   {
   }
   
   public function set taskRunner(param1:TaskRunner) : void
   {
      this._taskRunner = param1;
   }
   
   public function get networkManager() : NetworkManager
   {
      return this._networkManager;
   }
   
   public function get sceneAPI() : GaturroSceneObjectAPI
   {
      return this._sceneAPI;
   }
   
   public function get data() : Object
   {
      return this._data;
   }
   
   public function set options(param1:String) : void
   {
      this._options = param1;
   }
   
   public function get roomAPI() : GaturroRoomAPI
   {
      return this._roomAPI;
   }
}
