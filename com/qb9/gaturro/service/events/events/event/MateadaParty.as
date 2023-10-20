package com.qb9.gaturro.service.events.events.event
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.service.events.events.BaseEvent;
   import com.qb9.gaturro.world.core.elements.HolderRoomSceneObject;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class MateadaParty extends BaseEvent
   {
       
      
      private var canGiveMate:Boolean = true;
      
      private var holders:Array;
      
      private var currentMateHolder:int = -1;
      
      private var mates:int = 0;
      
      private const MAX_MATES:int = 6;
      
      private var holderDefinition:String = "cbse/props.holder";
      
      public function MateadaParty(param1:EventsService)
      {
         super(param1);
         this.setupMesssages();
      }
      
      private function endSession() : void
      {
         var _loc1_:int = 0;
         this.canGiveMate = false;
         if(eventService.imHost)
         {
            api.showModal("FIN DE LA RONDA ELIGE UN PREMIO:","information","¡COMPARTE UN MATE CON LOS TUYOS!");
            setTimeout(api.openCatalog,3000,"cbsePremiosMateada");
            eventService.dispose();
            this.canGiveMate = false;
         }
         else
         {
            _loc1_ = 1 + Math.random() * 4;
            api.showAwardModal("¡FIN DE LA RONDA.\nTOMA TU PREMIO!","cbse/props.mate" + _loc1_.toString());
            eventService.dispose();
            setTimeout(this.exit,2100);
         }
      }
      
      private function onGiveMate(param1:Object) : void
      {
         var user:String = null;
         var message:Object = param1;
         if(this.mates == this.MAX_MATES)
         {
            this.exit();
         }
         if(eventService.imHost && this.canGiveMate)
         {
            user = this.recipientUser();
            if(Boolean(user) && this.canGiveMate)
            {
               this.canGiveMate = false;
               api.setAvatarAttribute("action","showObject.cbse/props.termo");
               audio.addLazyPlay("sirve_mate");
               setTimeout(function():void
               {
                  api.setAvatarAttribute("action","sit");
                  api.sendMessage("receiveMate",{"username":user});
               },3000);
            }
            else
            {
               api.showModal("INVITA AL MENOS UN AMIGO PARA LA RONDA Y PÍDELE QUE SE SIENTE","information");
            }
         }
      }
      
      private function onMateReceived(param1:Object) : void
      {
         var username:String;
         var message:Object = param1;
         this.mates += 1;
         username = String(message.params.username);
         if(api.user.username == username)
         {
            api.setAvatarAttribute("action","drink.cbse/props.mate1");
            audio.addLazyPlay("toma_mate");
            setTimeout(function():void
            {
               api.setAvatarAttribute("action","sit");
            },3000);
         }
         setTimeout(function():void
         {
            canGiveMate = true;
            if(mates == MAX_MATES)
            {
               endSession();
            }
         },6000);
      }
      
      private function findNextReceiver() : RoomSceneObject
      {
         var _loc2_:HolderRoomSceneObject = null;
         ++this.currentMateHolder;
         var _loc1_:int = this.currentMateHolder;
         while(_loc1_ < this.currentMateHolder + this.holders.length)
         {
            _loc2_ = this.holders[_loc1_ % this.holders.length] as HolderRoomSceneObject;
            if(_loc2_.full)
            {
               this.currentMateHolder = _loc1_;
               return _loc2_.children[0] as RoomSceneObject;
            }
            _loc1_++;
         }
         return null;
      }
      
      private function recipientUser() : String
      {
         var _loc1_:RoomSceneObject = this.findNextReceiver();
         return !!_loc1_ ? (_loc1_ as Avatar).username : null;
      }
      
      private function setupMesssages() : void
      {
         messages = new Dictionary();
         messages["giveMate"] = this.onGiveMate;
         messages["receiveMate"] = this.onMateReceived;
      }
      
      private function exit() : void
      {
         api.changeRoomXY(51688753,5,5);
      }
      
      private function grabHolders(param1:Array) : void
      {
         var so:SceneObject = null;
         var roomSceneObjects:Array = param1;
         this.holders = new Array();
         for each(so in roomSceneObjects)
         {
            if(so.name == this.holderDefinition)
            {
               this.holders.push(so);
            }
         }
         this.holders.sort(function(param1:Object, param2:Object):int
         {
            return param1.attributes.holder_id <= param2.attributes.holder_id ? -1 : 1;
         });
      }
      
      override public function configureSceneObjects(param1:Array) : void
      {
         this.grabHolders(param1);
      }
   }
}
