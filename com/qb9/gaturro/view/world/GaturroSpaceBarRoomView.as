package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class GaturroSpaceBarRoomView extends GaturroRoomView
   {
       
      
      private var tragos:Array;
      
      private var textos:Object;
      
      private var posibleDrink:Array;
      
      private var editableNPC:Array;
      
      private var npcList:Array;
      
      private var spider:NpcRoomSceneObjectView;
      
      private var bartender:NpcRoomSceneObjectView;
      
      public function GaturroSpaceBarRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         this.editableNPC = ["barEspacial.charsRotativos_so","barEspacial.barman_so","barEspacial.extraterrestre3_so"];
         this.textos = {
            "randomChar1":["ACA VENGO CUANDO NO QUIERO ESTAR EN CASA","LOS GATURROS TAMBIEN SON BIENVENIDOS AQUÍ","NO TENGO SEÑAL PARA LLAMAR A MIS AMIGOS"],
            "randomChar2":["ESTE CASCO ME ENCANTA","¿YA PROBASTE LAS COMIDAS?","¡AFUERA ME VENDIERON ALGO MUUUY BARATO!"],
            "randomChar3":["VENGO SEGUIDO A ESTE BAR","NUNCA TE HABÍA VISTO","¿ERES NUEVO?"]
         };
         this.tragos = [];
         this.posibleDrink = ["barEspacial.tragoExtraterrestre1","barEspacial.tragoExtraterrestre2","barEspacial.tragoExtraterrestre3","barEspacial.tragoExtraterrestre4","barEspacial.tragoExtraterrestre5","barEspacial.tragoExtraterrestre6","barEspacial.tragoExtraterrestre1","barEspacial.tragoExtraterrestre2","barEspacial.tragoExtraterrestre3","barEspacial.tragoExtraterrestre4","barEspacial.tragoExtraterrestre5","barEspacial.tragoExtraterrestre6","barEspacial.tragoExtraterrestre1","barEspacial.tragoExtraterrestre2","barEspacial.tragoExtraterrestre3","barEspacial.tragoExtraterrestre4","barEspacial.tragoExtraterrestre5","barEspacial.tragoExtraterrestre6","barEspacial.tragoTraductor1","barEspacial.tragoTraductor2","barEspacial.tragoTraductor3"];
         super(param1,param3,param4,param5);
         this.npcList = new Array();
      }
      
      private function setupSpider() : void
      {
         this.spider.addEventListener("triggerDrinkOnTable",this.onSpiderDrink);
      }
      
      private function addToNpcList(param1:DisplayObject) : void
      {
         var _loc2_:NpcRoomSceneObjectView = param1 as NpcRoomSceneObjectView;
         if(_loc2_.object.name.indexOf("charsRotativos_so") != -1)
         {
            this.npcList.push(_loc2_);
         }
         else if(_loc2_.object.name.indexOf("barman_so") != -1)
         {
            this.bartender = _loc2_ as NpcRoomSceneObjectView;
         }
         else if(_loc2_.object.name.indexOf("extraterrestre3_so") != -1)
         {
            this.spider = _loc2_ as NpcRoomSceneObjectView;
         }
      }
      
      override protected function whenReady() : void
      {
         super.whenReady();
         this.spawnPeople();
         this.spawnDrinks();
         this.setupSpider();
      }
      
      private function whenAddedToBarman(param1:Event) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.tragos.length)
         {
            _loc3_ = this.bartender.getChildAt(0) as MovieClip;
            _loc3_["tragoPh" + _loc2_].addChild(this.tragos[_loc2_]);
            _loc2_++;
         }
         this.bartender.removeEventListener(Event.ADDED,this.whenAddedToBarman);
      }
      
      private function onSpiderDrink(param1:Event) : void
      {
         var _loc2_:String = api.getSession("tragoSecretos") as String;
         api.libraries.fetch(_loc2_,this.fetchTragoSpider);
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(_loc2_ is NpcRoomSceneObjectView && this.isEdited((_loc2_ as NpcRoomSceneObjectView).object.name))
         {
            this.addToNpcList(_loc2_);
         }
         return _loc2_;
      }
      
      private function addToBarra(param1:DisplayObject) : void
      {
         this.tragos.push(param1);
      }
      
      private function fetchBarPeople(param1:DisplayObject, param2:Object) : void
      {
         param2.npc.addChild(param1);
         (param1 as MovieClip).gotoAndStop("state" + this.randomInt(3,1));
      }
      
      private function spawnPeople() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.npcList.length)
         {
            if(Math.random() > 0.5)
            {
               this.randomizeCharacter(this.npcList[_loc1_]);
            }
            else
            {
               this.npcList[_loc1_].object.attributes.hide = 1;
            }
            _loc1_++;
         }
      }
      
      private function randomInt(param1:int, param2:int = 0) : int
      {
         return int(param2 + Math.random() * param1);
      }
      
      private function isEdited(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.editableNPC.length)
         {
            if(param1 == this.editableNPC[_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function spawnDrinks() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ <= 3)
         {
            api.libraries.fetch(this.randomizeDrinks(),this.addToBarra);
            _loc1_++;
         }
         this.bartender.addEventListener(Event.ADDED,this.whenAddedToBarman);
      }
      
      private function randomizeCharacter(param1:NpcRoomSceneObjectView) : void
      {
         var _loc2_:String = "randomChar" + this.randomInt(3,1);
         api.libraries.fetch("barEspacial." + _loc2_,this.fetchBarPeople,{"npc":param1});
         param1.object.attributes.variable1 = api.getText(this.textos[_loc2_][0]);
         param1.object.attributes.variable2 = api.getText(this.textos[_loc2_][1]);
         param1.object.attributes.variable3 = api.getText(this.textos[_loc2_][2]);
      }
      
      private function randomizeDrinks() : String
      {
         return this.posibleDrink[this.randomInt(this.posibleDrink.length - 1)];
      }
      
      private function fetchTragoSpider(param1:DisplayObject) : void
      {
         var _loc4_:int = 0;
         var _loc2_:MovieClip = this.spider.getChildAt(0) as MovieClip;
         _loc2_.gotoAndStop(0);
         var _loc3_:MovieClip = _loc2_["trago_ph"];
         if(_loc3_.numChildren > 0)
         {
            _loc4_ = _loc3_.numChildren;
            while(_loc4_ > 0)
            {
               _loc3_.removeChildAt(0);
               _loc4_--;
            }
         }
         _loc3_.addChild(param1);
         api.setSession("tragoSecretos",0);
      }
   }
}
