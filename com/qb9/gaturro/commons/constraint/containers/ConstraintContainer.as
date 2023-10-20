package com.qb9.gaturro.commons.constraint.containers
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   
   public class ConstraintContainer extends AbstractConstraintContainer
   {
       
      
      private var _id:String;
      
      private var constraint:AbstractConstraint;
      
      public function ConstraintContainer(param1:String, param2:Boolean)
      {
         super(param2);
         this._id = param1;
      }
      
      override public function addConstraint(param1:AbstractConstraint) : void
      {
         this.constraint = param1;
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         return this.constraint.accomplish(param1);
      }
      
      override public function observe(param1:Function) : void
      {
         this.observer = param1;
         this.constraint.observe(this.changed);
      }
      
      override protected function changed() : void
      {
         if(observer != null)
         {
            observer(this);
         }
      }
      
      override public function unobserve() : void
      {
         this.constraint.unobserve();
      }
      
      private function onChanged() : void
      {
         this.changed();
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      override public function dispose() : void
      {
         trace(this + " > dispose > _id = [" + this._id + "]");
         this.constraint.dispose();
         super.dispose();
      }
   }
}
