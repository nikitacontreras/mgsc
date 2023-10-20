package com.qb9.gaturro.world.hiddenObjects
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class CrazyAnimals extends HiddenObjects
   {
       
      
      private var needToWear:Array;
      
      public function CrazyAnimals()
      {
         this.needToWear = ["mascaraTiki1_on","mascaraTiki2_on","mascaraTiki3_on","mascaraTiki4_on"];
         super();
      }
      
      private function escenciaFound(param1:int) : void
      {
         var _loc3_:Object = null;
         var _loc2_:String = api.getProfileAttribute("animales2018") as String;
         logger.debug(this,_loc2_);
         if(!_loc2_ || _loc2_ == "" || _loc2_ == " " || _loc2_ == false || _loc2_ == "false")
         {
            _loc3_ = new Object();
         }
         else
         {
            _loc3_ = api.JSONDecode(_loc2_);
         }
         if(!_loc3_.found)
         {
            _loc3_.found = new Array();
         }
         _loc3_.found.push(param1);
         _loc2_ = String(api.JSONEncode(_loc3_));
         api.setProfileAttribute("animales2018",_loc2_);
         api.setSession("esenciaFound",true);
      }
      
      override protected function configure() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         for each(_loc1_ in DisplayUtil.children(hiddenLayer,false))
         {
            if(_loc1_.name.indexOf("esenciaFound") != -1)
            {
               _loc2_ = int((_loc1_.name as String).split("esenciaFound")[1]);
               _loc1_.visible = false;
               if(this.userGranted() && !this.isEsenciaFound(_loc2_))
               {
                  logger.debug(this,"userGranted");
                  _loc1_.visible = true;
                  (_loc1_ as MovieClip).mouseEnabled = true;
                  (_loc1_ as MovieClip).buttonMode = true;
                  _loc1_.addEventListener(MouseEvent.CLICK,this.onClick);
               }
            }
         }
      }
      
      private function isEsenciaFound(param1:int) : Boolean
      {
         var _loc2_:String = api.getProfileAttribute("animales2018") as String;
         var _loc3_:Object = api.JSONDecode(_loc2_);
         if(!_loc3_ || !_loc3_.found)
         {
            return false;
         }
         var _loc4_:Array = _loc3_.found;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(param1 == _loc4_[_loc5_])
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if((param1.target.name as String).indexOf("esenciaFound") != -1)
         {
            _loc2_ = int((param1.target.name as String).split("esenciaFound")[1]);
            if(this.isEsenciaFound(_loc2_))
            {
               logger.debug(this,"ya la tenes");
            }
            else
            {
               logger.debug(this,"grabo la data de la escencia que encontre");
               api.showModal("ESENCIA ANIMAL","animales2018/props.esencia" + _loc2_.toString());
               this.escenciaFound(_loc2_);
               (param1.target as DisplayObject).visible = false;
               (param1.target as DisplayObject).removeEventListener(MouseEvent.CLICK,this.onClick);
               api.addTeamPoints("costume9");
               api.trackEvent("MISIONES:2018:ESCENCIAS",param1.target.name);
            }
         }
      }
      
      private function userGranted() : Boolean
      {
         var _loc2_:String = null;
         var _loc1_:Boolean = false;
         for each(_loc2_ in this.needToWear)
         {
            if(api.getAvatarAttribute("hats"))
            {
               _loc1_ ||= (api.getAvatarAttribute("hats") as String).split(".")[1] == _loc2_;
            }
         }
         return _loc1_;
      }
   }
}
