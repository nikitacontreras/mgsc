package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.view.world.avatars.AvatarDresser;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class EasterRoomView extends GaturroRoomView
   {
       
      
      private var dresser:AvatarDresser;
      
      private var bannedCostumes:Array;
      
      private var allowedTransports:Array;
      
      private var ears2:Object;
      
      private var theets:Object;
      
      private var ears:Object;
      
      private var theets2:Object;
      
      public function EasterRoomView(param1:GaturroRoom, param2:TaskRunner, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         this.dresser = new AvatarDresser();
         this.ears = {
            "name":"gorroOrejasVerde_on",
            "pack":"easterCostumes",
            "part":"hats"
         };
         this.theets = {
            "name":"dientesConejov_on",
            "pack":"easterCostumes",
            "part":"mouths"
         };
         this.ears2 = {
            "name":"gorroOrejasRosa_on",
            "pack":"easterCostumes",
            "part":"hats"
         };
         this.theets2 = {
            "name":"dientesConejom_on",
            "pack":"easterCostumes",
            "part":"mouths"
         };
         this.allowedTransports = ["nubeChocoB","nubeChocoN"];
         this.bannedCostumes = ["conejoBlanco","conejoMarron","conejoPlata","conejoOro","invisible","hide"];
         super(param1,param3,param4,param5);
      }
      
      private function removeTransport() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.allowedTransports)
         {
            if(this.dresser.userIsWearing(_loc1_))
            {
               return;
            }
         }
         this.dresser.removeCloth("transport");
      }
      
      private function addHiddenObjects() : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         logger.debug(this,"addHiddenObject");
         var _loc1_:MovieClip = getChildByName("hidden") as MovieClip;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.numChildren)
         {
            _loc6_ = _loc1_.getChildAt(_loc3_) as MovieClip;
            if(getQualifiedClassName(_loc6_).indexOf("trofeo") != -1)
            {
               logger.debug(this,"addingObject",_loc6_);
               _loc6_.visible = false;
               _loc2_.push(_loc6_);
            }
            _loc3_++;
         }
         var _loc4_:Object = api.JSONDecode(api.getProfileAttribute("hiddenPascuas2018") as String);
         _loc5_ = ArrayUtil.choice(_loc2_) as MovieClip;
         if(Boolean(_loc4_) && Boolean(_loc4_[getQualifiedClassName(_loc5_)]))
         {
            return;
         }
         _loc5_.visible = true;
         _loc5_.buttonMode = true;
         _loc5_.addEventListener(MouseEvent.CLICK,this.givePrize);
      }
      
      private function hasRabbitCostume() : Boolean
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.bannedCostumes)
         {
            if(this.dresser.userIsWearing(_loc1_))
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this.addHiddenObjects();
         this.removeTransport();
         this.easterCostume();
         this.cleanPterodactiloWalking();
      }
      
      override protected function checkIfTileSelected(param1:MouseEvent) : void
      {
         if(api.getSession("pterodactilo"))
         {
            return;
         }
         super.checkIfTileSelected(param1);
      }
      
      private function givePrize(param1:MouseEvent) : void
      {
         var trophy:MovieClip = null;
         var e:MouseEvent = param1;
         trophy = e.currentTarget as MovieClip;
         trophy.visible = false;
         trophy.removeEventListener(MouseEvent.CLICK,this.givePrize);
         api.showModal("ENCONTRASTE  UNA ESTATUA MISTERIOSA","easter." + getQualifiedClassName(trophy),"FELICITACIONES");
         logger.debug(this,"api.setProfileAttribute","hiddenPascuas2018/" + getQualifiedClassName(trophy));
         api.setProfileAttribute("hiddenPascuas2018/" + getQualifiedClassName(trophy),true);
         setTimeout(function():void
         {
            api.giveUser("easter." + getQualifiedClassName(trophy),1);
         },1000);
      }
      
      private function easterCostume() : void
      {
         logger.debug(this,"easterCostume");
         if(this.hasRabbitCostume())
         {
            return;
         }
         if(api.userAvatar.attributes.gender_male)
         {
            this.dresser.changeClothUser(this.ears);
            this.dresser.changeClothUser(this.theets);
         }
         else
         {
            this.dresser.changeClothUser(this.ears2);
            this.dresser.changeClothUser(this.theets2);
         }
      }
      
      private function cleanPterodactiloWalking() : void
      {
         api.setSession("pterodactilo",false);
      }
      
      override public function dispose() : void
      {
         this.dresser = null;
         super.dispose();
      }
   }
}
