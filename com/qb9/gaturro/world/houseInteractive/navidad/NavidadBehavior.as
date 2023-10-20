package com.qb9.gaturro.world.houseInteractive.navidad
{
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.world.GaturroHomeRoofView;
   import com.qb9.gaturro.world.houseInteractive.HomeBehavior;
   import flash.utils.setTimeout;
   
   public class NavidadBehavior extends HomeBehavior
   {
       
      
      private var today:Date;
      
      private var santaIndex:int = 0;
      
      private var textosCuantoFalta:String;
      
      private var textosRegaloSanta:Array;
      
      private var santaIndex2:int = 0;
      
      private var regaloId:int;
      
      private var isNavidad:Boolean = false;
      
      private const papaNoelEndDate:int = 28;
      
      private var roomView:GaturroHomeRoofView;
      
      private var navidad:Object;
      
      private var textIndex:int;
      
      private var textosAgradecimientoSanta:Array;
      
      private var textIndex2:int = -1;
      
      private var textosDecoracionDuende:Object;
      
      private var textosIntroDuende:Object;
      
      private const papaNoelDate:int = 24;
      
      public function NavidadBehavior()
      {
         super();
      }
      
      private function activateDuende() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         asset.chatHolder.visible = true;
         if(this.textIndex < this.textosIntroDuende[this.regaloId].length)
         {
            asset.chatHolder.dialogo.text = this.textosIntroDuende[this.regaloId][this.textIndex];
            ++this.textIndex;
         }
         else
         {
            this.navidad.yaHablo = true;
            roomAPI.setProfileAttribute("navidad/yaHablo",true);
            if(this.navidad.ultimaFecha != this.today.date && this.regaloId != settings.navidad_techo.premios.length - 1)
            {
               _loc1_ = settings.navidad_techo.premios[this.regaloId];
               roomAPI.showAwardModal(roomAPI.getText(_loc1_.nombre),_loc1_.item,_loc1_.cantidad,roomAPI.getText("AQUÍ TIENES"));
               roomAPI.trackEvent("QUESTS","TECHO","RECIBE_REGALO:" + _loc1_.item);
               if(this.regaloId == settings.navidad_techo.premios.length - 1)
               {
                  roomAPI.trackEvent("QUESTS","TECHO","RECIBIO_TODO");
               }
               this.navidad.ultimaFecha = this.today.date;
               roomAPI.setProfileAttribute("navidad/ultimaFecha",this.today.date);
               asset.chatHolder.visible = false;
               asset.character.gotoAndStop("regalo");
               setTimeout(this.backToIdle,1000);
               this.textIndex2 = 0;
            }
            else if(this.textIndex2 < 0)
            {
               asset.chatHolder.visible = false;
               ++this.textIndex2;
            }
            else
            {
               _loc2_ = roomAPI.objects.length > 6 ? 0 : 1;
               if(this.textIndex2 >= this.textosDecoracionDuende[_loc2_].length)
               {
                  asset.chatHolder.dialogo.text = this.textosCuantoFalta;
                  this.textIndex2 = -1;
               }
               else
               {
                  asset.chatHolder.dialogo.text = this.textosDecoracionDuende[_loc2_][this.textIndex2];
               }
               ++this.textIndex2;
            }
         }
      }
      
      override protected function atStart() : void
      {
         super.atStart();
         this.textosIntroDuende = [[roomAPI.getText("¡PERO QUÉ TECHO TAN BONITO Y TAN… POCO NAVIDEÑO!"),roomAPI.getText("SI LO ADORNAS, SEGURO QUE PAPÁ NOEL BAJARÁ A VERLO"),roomAPI.getText("ESO LO PONE LOCO DE CONTENTO, ES COMO UN NIÑO, POBRE"),roomAPI.getText("TE AYUDARÉ, TOMA")],[roomAPI.getText("¡HOLA!"),roomAPI.getText("TENGO MÁS DECORACIONES PARA TÍ"),roomAPI.getText("SIGUE DECORANDO"),roomAPI.getText("¡QUEDARÁ TODO FENOMENAL!")],[roomAPI.getText("¡HOLA!"),roomAPI.getText("TENGO MÁS DECORACIONES PARA TÍ"),roomAPI.getText("SIGUE DECORANDO"),roomAPI.getText("¡QUEDARÁ TODO FENOMENAL!")],[roomAPI.getText("¡HOLA!"),roomAPI.getText("TENGO MÁS DECORACIONES PARA TÍ"),roomAPI.getText("SIGUE DECORANDO"),roomAPI.getText("¡QUEDARÁ TODO FENOMENAL!")],[roomAPI.getText("¡HOLA!"),roomAPI.getText("TENGO MÁS DECORACIONES PARA TÍ"),roomAPI.getText("SIGUE DECORANDO"),roomAPI.getText("¡QUEDARÁ TODO FENOMENAL!")],[roomAPI.getText("¡ÚLTIMA ENTREGA DE GUIRNALDAS!"),roomAPI.getText("¡PRIMERA ENTREGA DE LUCECITAS!"),roomAPI.getText("¡COMPLETA LAS LUCES E ILUMINARÁS EL TEJADO!")],[roomAPI.getText("¡HOLA!"),roomAPI.getText("TENGO MÁS DECORACIONES PARA TÍ"),roomAPI.getText("SIGUE DECORANDO"),roomAPI.getText("¡QUEDARÁ TODO FENOMENAL!")],[roomAPI.getText("¡HOLA!"),roomAPI.getText("TENGO MÁS DECORACIONES PARA TÍ"),roomAPI.getText("SIGUE DECORANDO"),roomAPI.getText("¡QUEDARÁ TODO FENOMENAL!")],[roomAPI.getText("¡HOLA!"),roomAPI.getText("TENGO MÁS DECORACIONES PARA TÍ"),roomAPI.getText("SIGUE DECORANDO"),roomAPI.getText("¡QUEDARÁ TODO FENOMENAL!")],[roomAPI.getText("¡HOLA!"),roomAPI.getText("TENGO MÁS DECORACIONES PARA TÍ"),roomAPI.getText("SIGUE DECORANDO"),roomAPI.getText("¡QUEDARÁ TODO FENOMENAL!")],[roomAPI.getText("¡ÚLTIMA ENTREGA DE LUCECITAS!"),roomAPI.getText("¡PRIMERA ENTREGA DE TRINEO!"),roomAPI.getText("¡COMPLETA EL CONJUNTO CON DOS RENOS Y LISTO!")],[roomAPI.getText("¡HOLA!"),roomAPI.getText("TENGO MÁS DECORACIONES PARA TÍ"),roomAPI.getText("SIGUE DECORANDO"),roomAPI.getText("¡QUEDARÁ TODO FENOMENAL!")],[roomAPI.getText("¡MUY BIEN!"),roomAPI.getText("CON LAS LUCES, LAS GUIRNALDAS Y EL TRINEO COMPLETO"),roomAPI.getText("TU TECHO QUEDARÁ REALMENTE NAVIDEÑO")],[roomAPI.getText("AHHHH, DE SÓLO VERLO ME EMOCIONO"),roomAPI.getText("¡TE QUEDÓ IMPRESIONANTE!"),roomAPI.getText("AQUÍ TIENES ALGO PARA QUE SE LUZCA TODAVÍA MEJOR")],[roomAPI.getText("PAPÁ NOEL ESTARÁ ENCANTADÍSIMO"),roomAPI.getText("EN CUALQUIER MOMENTO RECIBIRÁS SU VISITA"),roomAPI.getText("¿QUÉ TAL SI LO ESPERAMOS JUNTOS?")]];
         this.textosDecoracionDuende = [[roomAPI.getText("APROVECHA LOS REGALOS PARA DECORAR TU TECHO"),roomAPI.getText("PAPA NOEL AMA LOS TECHOS DECORADOS")],[roomAPI.getText("ERES REBELDE Y ESO ES BUENO"),roomAPI.getText("QUÉ TANTO ACEPTAR ASÍ COMO ASÍ LO QUE A UNO LE DICEN"),roomAPI.getText("LO ÚNICO QUE OPINARÉ AL RESPECTO ES QUE…"),roomAPI.getText("SI ADORNAS TU TECHO, CREO QUE ÉSTE SE VERÁ MÁS LINDO"),roomAPI.getText("Y PAPÁ NOEL SEGURAMENTE TE VISITARÁ"),roomAPI.getText("¡TÓMALO O DÉJALO, ALLÁ TÚ!")]];
         this.textosCuantoFalta = roomAPI.getText("¡SOLO FALTAN $days DÍAS PARA QUE NOS VISITE PAPA NOEL!");
         this.textosRegaloSanta = [roomAPI.getText("JI, JUÁ, JIÉ, ESTE AÑO CAMBIÉ MI RISA, ¿TE GUSTA?"),roomAPI.getText("EY, ¿PUEDO DECIR QUE TU TECHO ES GRANDIOSO?"),roomAPI.getText("EN LAS NOCHES DE REPARTIJA DE REGALOS"),roomAPI.getText("ME GUSTA MUCHO MIRAR LOS BRILLOS DESDE ARRIBA"),roomAPI.getText("SON COMO PEQUEÑAS CIUDADES NAVIDEÑAS, ENCENDIDAS"),roomAPI.getText("ME HACE COMPAÑÍA, ¡GRACIAS!")];
         this.textosAgradecimientoSanta = [roomAPI.getText("TE DESEO DE CORAZÓN QUE PASES UNAS FELICES FIESTAS"),roomAPI.getText("QUE EL ESPÍRITU NAVIDEÑO ESTÉ CONTIGO"),roomAPI.getText("¿QUÉ ES ESE ESPÍRITU? ¡MUCHAS COSAS!"),roomAPI.getText("LA ALEGRÍA DE COMPARTIR"),roomAPI.getText("LO QUE TE DA TRANQUILIDAD"),roomAPI.getText("EL SER AMABLE CON OTROS"),roomAPI.getText("PORQUE CUALQUIER BUEN GESTO PUEDE SER UN REGALO, ¿SABÍAS?"),roomAPI.getText("¡FELICES FIESTAS, " + roomAPI.user.username)];
         this.roomView = roomAPI.roomView as GaturroHomeRoofView;
         this.today = new Date(roomAPI.serverTime);
         this.isNavidad = this.today.fullYear == 2015 && this.today.month == 11 && (this.today.date >= this.papaNoelDate && this.today.date <= this.papaNoelEndDate);
         if(this.isNavidad && this.iterateItems())
         {
            asset.gotoAndStop("santa");
         }
         else
         {
            asset.gotoAndStop("duende");
         }
         try
         {
         }
         catch(e:Error)
         {
            navidad = new Object();
            navidad.ultimaFecha = -1;
            navidad.regaloIndex = -1;
            navidad.yaHablo = false;
         }
         this.regaloId = int(this.navidad.regaloIndex);
         if(this.navidad.ultimaFecha != this.today.date)
         {
            if(this.regaloId < settings.navidad_techo.premios.length - 1)
            {
               ++this.regaloId;
               this.navidad.regaloIndex = this.regaloId;
               this.navidad.yaHablo = false;
               this.navidad.entregoSanta = false;
               roomAPI.setProfileAttribute("navidad/yaHablo",false);
               roomAPI.setProfileAttribute("navidad/regaloIndex",this.regaloId);
            }
         }
         if(this.navidad.yaHablo)
         {
            this.textIndex = 1000;
         }
         else
         {
            this.textIndex = 0;
         }
         if(this.navidad.regalo)
         {
            this.santaIndex = 10000;
         }
         asset.chatHolder.visible = false;
         if(asset.character)
         {
            asset.character.stop();
         }
         this.textosCuantoFalta = this.textosCuantoFalta.replace("$days",(this.papaNoelDate - this.today.date).toString());
      }
      
      override public function activate() : void
      {
         if(asset.currentLabel == "santa")
         {
            this.activateSanta();
         }
         else
         {
            this.activateDuende();
         }
      }
      
      private function iterateItems() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < settings.navidad_techo.premios.length - 1)
         {
            if(this.checkItem(settings.navidad_techo.premios[_loc1_].item) == false)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function checkDecoraciones() : Boolean
      {
         if(this.isNavidad && this.iterateItems())
         {
            asset.gotoAndStop("santa");
            return true;
         }
         return false;
      }
      
      private function checkItem(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.roomView.roomObjects.length)
         {
            if(this.roomView.roomObjects[_loc2_].name == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function activateSanta() : void
      {
         var _loc1_:Object = null;
         if(this.santaIndex < this.textosRegaloSanta.length)
         {
            asset.chatHolder.visible = true;
            asset.chatHolder.dialogo.text = this.textosRegaloSanta[this.santaIndex];
            ++this.santaIndex;
         }
         else if(!this.navidad.regalo || this.navidad.regalo == false)
         {
            _loc1_ = settings.navidad_techo.premios[this.regaloId];
            roomAPI.showAwardModal(roomAPI.getText(_loc1_.nombre),_loc1_.item,_loc1_.cantidad,roomAPI.getText("AQUÍ TIENES"));
            asset.chatHolder.visible = false;
            this.navidad.regalo = true;
            roomAPI.setProfileAttribute("navidad/regalo",true);
         }
         else if(this.santaIndex2 < this.textosAgradecimientoSanta.length)
         {
            asset.chatHolder.visible = true;
            asset.chatHolder.dialogo.text = this.textosAgradecimientoSanta[this.santaIndex2];
            ++this.santaIndex2;
         }
         else
         {
            asset.chatHolder.visible = !asset.chatHolder.visible;
         }
      }
      
      private function backToIdle() : void
      {
         asset.character.gotoAndStop("idle");
      }
   }
}
