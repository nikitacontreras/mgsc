package com.qb9.gaturro.commons.quest.model
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.commons.model.config.IConfig;
   import flash.utils.Dictionary;
   
   public class QuestConfig implements IConfig
   {
       
      
      private var definitionMap:Dictionary;
      
      private var cleanDefinition:Object;
      
      public function QuestConfig()
      {
         super();
         this.definitionMap = new Dictionary();
      }
      
      public function getDefinition(param1:int) : QuestDefinition
      {
         return this.definitionMap[param1];
      }
      
      public function addDefinition(param1:QuestDefinition) : void
      {
         this.definitionMap[param1.code] = param1;
      }
      
      public function setCleanDefinition(param1:Object) : void
      {
         this.cleanDefinition = param1;
      }
      
      public function getIterator() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(this.definitionMap);
         return _loc1_;
      }
      
      public function getCleanDefinition() : Object
      {
         return this.cleanDefinition;
      }
   }
}
