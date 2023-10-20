package com.qb9.gaturro.service.events.gui
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.interaction.InteractionTypes;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class InvitationBallon extends Sprite
   {
      
      public static const TYPE_POOL:String = "poolInvite";
      
      public static const BILLBOARD_CLICKED:String = "bannerClicked";
      
      public static const TYPE_PARTY:String = "partyInvite";
       
      
      private var partyData:EventData;
      
      private var following:Gaturro;
      
      private var gaturro:Gaturro;
      
      private var type:String;
      
      public var customData:String;
      
      public function InvitationBallon(param1:Gaturro, param2:String = "partyInvite", param3:String = "party2017/props.inviter")
      {
         super();
         logger.info(this,"PartyInvitationBillboard");
         this.gaturro = param1;
         addEventListener(Event.ADDED_TO_STAGE,this.whenAddedToStage);
         api.libraries.fetch(param3,this.addPartyInviter);
         this.type = param2;
      }
      
      private function update(param1:Event) : void
      {
         if(!this.following || !stage)
         {
            return;
         }
         this.x = this.following.localToGlobal(new Point(0,0)).x;
         this.y = this.following.localToGlobal(new Point(0,0)).y;
      }
      
      private function addPartyInviter(param1:DisplayObject) : void
      {
         var inviter:MovieClip = null;
         var ds:DisplayObject = param1;
         inviter = ds as MovieClip;
         inviter.name = "inviter";
         this.addChild(inviter);
         inviter.mouseEnabled = true;
         inviter.mouseChildren = false;
         inviter.buttonMode = true;
         this.follow(this.gaturro);
         switch(this.type)
         {
            case TYPE_PARTY:
               try
               {
                  this.partyData = EventData.fromString(this.gaturro.attrs[EventsAttributeEnum.EVENT_ATTR]);
                  inviter.gotoAndStop(this.partyData.type);
                  if(this.partyData.host != api.user.username)
                  {
                     this.addEventListener(MouseEvent.CLICK,this.onPartyInviterClick);
                  }
               }
               catch(error:Error)
               {
                  logger.debug(error);
                  break;
               }
         }
         api.roomView.infoLayer.addChild(this);
      }
      
      private function onPartyInviterClick(param1:Event) : void
      {
         logger.debug(this,"onPartyInviterClick");
         api.trackEvent("FIESTAS:INVITER:CLICK_GLOBO",this.partyData.host);
         api.inviteToParty(this.gaturro.attrs[EventsAttributeEnum.EVENT_ATTR]);
      }
      
      public function follow(param1:Gaturro) : void
      {
         this.following = param1;
      }
      
      public function customize(param1:String) : void
      {
         (this.getChildByName("inviter") as MovieClip).gotoAndStop(param1);
         this.customData = param1;
         this.addEventListener(MouseEvent.CLICK,this.onClickBalloon);
      }
      
      private function onClickBalloonInteraction(param1:MouseEvent) : void
      {
         var _loc2_:String = String((this.following as Object).parent.displayName);
         if(api.user.username != _loc2_)
         {
            if(this.customData == InteractionTypes.SALVAR)
            {
               api.setAvatarAttribute("action","flag");
            }
            if(this.customData == InteractionTypes.REVIVIR)
            {
               if(!api.isCitizen)
               {
                  api.textMessageToGUI("NO TIENES LA MAGIA PASAPORTERA");
                  return;
               }
               api.setAvatarAttribute("action","flag");
            }
            api.room.proposeInteraction(this.customData,_loc2_);
            api.roomView.infoLayer;
            this.dispose();
         }
      }
      
      private function onClickBalloon(param1:Event) : void
      {
         switch(this.customData)
         {
            case "river":
               api.trackEvent("RIVER:PILETA:SALVAVIDAS","click");
               api.changeRoomXY(69404,4,10);
               break;
            case "boca":
               api.trackEvent("BOCA:PILETA:SALVAVIDAS","click");
               api.changeRoomXY(69405,4,10);
         }
      }
      
      private function onMouseOut(param1:Event) : void
      {
      }
      
      private function onMouseOver(param1:Event) : void
      {
      }
      
      public function interactionCustomize(param1:String) : void
      {
         (this.getChildByName("inviter") as MovieClip).gotoAndStop(param1);
         this.customData = param1;
         this.addEventListener(MouseEvent.CLICK,this.onClickBalloonInteraction);
      }
      
      protected function whenAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.whenAddedToStage);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(Event.ENTER_FRAME,this.update);
      }
      
      public function dispose() : void
      {
         logger.info(this,"dispose()");
         removeEventListener(MouseEvent.CLICK,this.onClickBalloonInteraction);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         removeEventListener(Event.ENTER_FRAME,this.update);
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         DisplayUtil.remove(this);
      }
   }
}
