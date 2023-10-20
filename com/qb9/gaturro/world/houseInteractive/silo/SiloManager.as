package com.qb9.gaturro.world.houseInteractive.silo
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   
   public class SiloManager
   {
       
      
      public var capacity:int = 0;
      
      public var aceleradorQty:int = 0;
      
      private var crops:com.qb9.gaturro.world.houseInteractive.silo.Crops;
      
      public var maxCapacity:int = 250;
      
      public function SiloManager()
      {
         super();
         this.crops = new com.qb9.gaturro.world.houseInteractive.silo.Crops();
      }
      
      public function cropById(param1:int) : Object
      {
         return this.crops.byId(param1);
      }
      
      public function get level() : int
      {
         return 1;
      }
      
      public function getGameNameById(param1:String) : String
      {
         var _loc3_:Object = null;
         var _loc2_:Object = settings.granjaHome.crops;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.id == param1)
            {
               return _loc3_.gameName;
            }
         }
         return "noGameName";
      }
      
      public function sellCrop(param1:String, param2:int) : void
      {
         this.crops.removeQty(param1,param2);
         this.capacity -= param2;
         api.setProfileAttribute("silo",this.attrString);
      }
      
      public function agregarAcelerador(param1:int) : void
      {
         this.aceleradorQty += param1;
         api.setProfileAttribute("silo",this.attrString);
      }
      
      private function validateCropStr(param1:String) : Boolean
      {
         var _loc3_:Object = null;
         var _loc2_:Array = param1.split(":");
         for each(_loc3_ in settings.granjaHome.crops)
         {
            if(_loc3_.id == _loc2_[0])
            {
               return true;
            }
         }
         return false;
      }
      
      public function cropByPosition(param1:int) : Object
      {
         return this.crops.byPosition(param1);
      }
      
      public function addCrop(param1:String) : void
      {
         var _loc2_:String = null;
         if(this.crops.hasCrop(param1))
         {
            this.crops.addQty(param1,1);
         }
         else
         {
            _loc2_ = this.getIdByName(param1);
            if(_loc2_ != "notFound")
            {
               this.crops.addCrop(this.createCropObj(_loc2_ + ":1"));
            }
         }
         ++this.capacity;
         api.setProfileAttribute("silo",this.attrString);
      }
      
      public function getNameById(param1:String) : String
      {
         var _loc3_:Object = null;
         var _loc2_:Object = settings.granjaHome.crops;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.id == param1)
            {
               return _loc3_.name.split(".")[1];
            }
         }
         return "noName";
      }
      
      public function get amount() : int
      {
         return this.crops.amount;
      }
      
      public function get isFull() : Boolean
      {
         return this.capacity >= this.maxCapacity;
      }
      
      public function quitarAcelerador(param1:int) : void
      {
         this.aceleradorQty -= param1;
         api.setProfileAttribute("silo",this.attrString);
      }
      
      private function get attrString() : String
      {
         var _loc1_:String = "";
         if(this.aceleradorQty > 0)
         {
            _loc1_ = "|AC:" + this.aceleradorQty.toString();
         }
         return this.crops.toString() + _loc1_;
      }
      
      public function createCropObj(param1:String) : Object
      {
         var _loc2_:Array = param1.split(":");
         var _loc3_:Object = new Object();
         _loc3_["id"] = _loc2_[0];
         _loc3_["name"] = this.getNameById(_loc3_.id);
         _loc3_["qty"] = _loc2_[1];
         _loc3_["gameName"] = this.getGameNameById(_loc3_.id);
         return _loc3_;
      }
      
      public function cropHasQty(param1:String, param2:int) : Boolean
      {
         if(this.crops.hasCrop(param1))
         {
            if(this.crops.byName(param1).qty >= param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public function cropByName(param1:String) : Object
      {
         return this.crops.byName(param1);
      }
      
      public function getIdByName(param1:String) : String
      {
         var _loc3_:Object = null;
         var _loc2_:Object = settings.granjaHome.crops;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.name.split(".")[1] == param1)
            {
               return _loc3_.id;
            }
         }
         return "notFound";
      }
      
      public function firstLoad(param1:String) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(!param1 || param1 == "")
         {
            return;
         }
         var _loc2_:Array = [];
         _loc2_ = param1.split("|");
         if(_loc2_.length > 1)
         {
            this.aceleradorQty = int(_loc2_[1].split(":")[1]);
         }
         param1 = String(_loc2_[0]);
         _loc2_ = param1.split(",");
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(this.validateCropStr(_loc2_[_loc3_]))
            {
               _loc4_ = this.createCropObj(_loc2_[_loc3_]);
               this.crops.addCrop(_loc4_);
               _loc5_ = int(_loc4_.qty);
               this.capacity += _loc5_;
            }
            _loc3_++;
         }
      }
      
      public function get qty() : uint
      {
         return this.crops.length;
      }
   }
}
