package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.world.houseInteractive.silo.SiloManager;
   
   public class FarmRequest
   {
       
      
      private var config:Object;
      
      private var variety:int;
      
      private var typesAvailable:Array;
      
      private var crops:Object;
      
      private var _pedido:Object;
      
      private var slots:int;
      
      private var types:Array;
      
      public function FarmRequest(param1:Object, param2:Object, param3:int, param4:Object = null)
      {
         super();
         this.config = param1;
         this.crops = param2;
         this.variety = param1.variety;
         this.slots = param1.slots;
         this.types = [];
         this.typesAvailable = [];
         this._pedido = new Object();
         this._pedido.id = param3;
         if(!param4)
         {
            this.generate();
         }
         else
         {
            this.readAttribute(param4);
         }
      }
      
      private function cropInfoByName(param1:String) : Array
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.crops)
         {
            if(_loc2_.name == param1)
            {
               return [_loc2_.price,_loc2_.xp];
            }
         }
         return [0,0];
      }
      
      public function get pedido() : Object
      {
         if(!this._pedido)
         {
            this.generate();
         }
         return this._pedido;
      }
      
      private function removeTypeFromTypesAvailable(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.typesAvailable.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.typesAvailable[_loc2_].length)
            {
               if((_loc4_ = this.typesAvailable[_loc2_])[_loc3_] == param1)
               {
                  _loc4_.splice(_loc3_,1);
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private function cropPrice(param1:int) : int
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.crops)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_.price;
            }
         }
         return 0;
      }
      
      private function readAttribute(param1:Object) : void
      {
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc2_:Array = String(param1).split("|");
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_.length)
         {
            _loc7_ = new Object();
            _loc8_ = _loc2_[_loc6_].split(",");
            for each(_loc9_ in _loc8_)
            {
               _loc11_ = _loc9_.split(":");
               _loc7_[_loc11_[0]] = _loc11_[1];
            }
            _loc3_.push(_loc7_);
            _loc10_ = this.cropInfoByName(_loc7_.type);
            _loc4_ += _loc10_[0] * _loc7_.amount;
            _loc5_ += _loc10_[1] * _loc7_.amount;
            _loc6_++;
         }
         this._pedido.crops = _loc3_;
         this._pedido.coins = _loc4_;
         this._pedido.xp = _loc5_;
      }
      
      private function cropXp(param1:int) : int
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.crops)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_.xp;
            }
         }
         return 0;
      }
      
      private function typesAvailableArray(param1:int) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Array = [];
         switch(param1)
         {
            case 0:
               _loc3_ = 1;
               _loc4_ = Math.ceil(this.variety * 0.4);
               break;
            case 1:
               _loc3_ = 1;
               _loc4_ = Math.ceil(this.variety * 0.8);
               break;
            case 2:
               _loc3_ = Math.ceil(this.variety * 0.4);
               _loc4_ = this.variety;
               break;
            case 3:
               _loc3_ = Math.ceil(this.variety * 0.6);
               _loc4_ = this.variety;
         }
         var _loc5_:int = _loc3_;
         while(_loc5_ <= _loc4_)
         {
            _loc2_.push(_loc5_);
            _loc5_++;
         }
         if(_loc3_ == _loc4_)
         {
            return [_loc3_];
         }
         return _loc2_;
      }
      
      public function toString() : String
      {
         if(!this._pedido.crops)
         {
            return "farmRequest not loaded";
         }
         var _loc1_:* = "";
         var _loc2_:int = 0;
         while(_loc2_ < this._pedido.crops.length)
         {
            _loc1_ += "type:" + this._pedido.crops[_loc2_].type + ",";
            _loc1_ += "amount:" + this._pedido.crops[_loc2_].amount;
            _loc1_ += "|";
            _loc2_++;
         }
         return _loc1_.substring(0,_loc1_.length - 1);
      }
      
      public function isReady(param1:SiloManager) : Boolean
      {
         var _loc5_:Object = null;
         var _loc2_:Array = this._pedido.crops;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_];
            if(param1.cropHasQty(_loc5_.type.split(".")[1],_loc5_.amount))
            {
               _loc3_++;
            }
            _loc4_++;
         }
         return _loc3_ >= _loc2_.length;
      }
      
      private function cropName(param1:int) : String
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.crops)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_.name;
            }
         }
         return "NO NAME????";
      }
      
      public function generate() : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:Number = NaN;
         this.types = [];
         this.typesAvailable = [];
         var _loc1_:int = Math.ceil(Math.random() * this.slots);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.typesAvailable.push(this.typesAvailableArray(_loc2_));
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.typesAvailable.length)
         {
            _loc8_ = Math.floor(Math.random() * this.typesAvailable[_loc3_].length);
            _loc9_ = int(this.typesAvailable[_loc3_][_loc8_]);
            this.removeTypeFromTypesAvailable(_loc9_);
            this.types.push(_loc9_);
            _loc3_++;
         }
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < this.types.length)
         {
            _loc10_ = new Object();
            _loc11_ = this.config.cantMax - this.config.cantMin;
            _loc10_.amount = Math.ceil(this.config.cantMin + Math.random() * _loc11_);
            _loc10_.type = this.cropName(this.types[_loc7_]);
            _loc4_.push(_loc10_);
            _loc5_ += this.cropPrice(this.types[_loc7_]) * _loc10_.amount;
            _loc6_ += this.cropXp(this.types[_loc7_]) * _loc10_.amount;
            _loc7_++;
         }
         this._pedido.crops = _loc4_;
         this._pedido.coins = _loc5_;
         this._pedido.xp = _loc6_;
      }
   }
}
