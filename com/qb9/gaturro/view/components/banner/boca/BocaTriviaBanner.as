package com.qb9.gaturro.view.components.banner.boca
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.flashlib.tasks.Wait;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.util.TextFieldUtil;
   import com.qb9.gaturro.util.TimeSpan;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class BocaTriviaBanner extends InstantiableGuiModal
   {
      
      public static const BOCA:String = "bocaTrivia";
      
      public static const BOCA_TELEMETRY:String = "BOCA:TRIVIA";
       
      
      protected var givePrize:MovieClip;
      
      protected var trivia:Array;
      
      protected var score:TextField;
      
      public var taskRunner:TaskRunner;
      
      protected var currentOwnedPrices:String;
      
      private var btns:Array;
      
      protected var currentScore:int = 0;
      
      protected var givePrizeBtn:MovieClip;
      
      private var options:Array;
      
      protected var prizes:MovieClip;
      
      private var maxPrizes:int = 9;
      
      public var settings:Settings;
      
      protected var totalReplys:int;
      
      private var questionY:Number = 0;
      
      protected var telemetryId:String = "BOCA:TRIVIA";
      
      protected var selectedPrize:int;
      
      protected var winToday:int;
      
      protected var query:MovieClip;
      
      protected var question:TextField;
      
      protected var intro:MovieClip;
      
      protected var asset:MovieClip;
      
      protected var next:MovieClip;
      
      protected var triviaId:String = "bocaTrivia";
      
      protected var currentQuestion:Object;
      
      public function BocaTriviaBanner(param1:String = null, param2:String = null)
      {
         this.btns = ["ans_0","ans_1","ans_2"];
         this.settings = new Settings();
         this.trivia = [];
         if(!param1 || !param2)
         {
            param1 = "BocaTriviaBanner";
            param2 = "BocaTriviaBanner";
         }
         super(param1,param2);
      }
      
      private function mouseEvent(param1:MouseEvent = null) : void
      {
         var _loc2_:MovieClip = param1.currentTarget["btn"];
         if(param1.type == MouseEvent.MOUSE_OVER)
         {
            if(_loc2_)
            {
               _loc2_.gotoAndStop("over");
            }
         }
         if(param1.type == MouseEvent.MOUSE_OUT)
         {
            if(_loc2_)
            {
               _loc2_.gotoAndStop("up");
            }
         }
      }
      
      private function hideOptions(param1:TaskEvent = null) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:Timeout = null;
         var _loc2_:Sequence = new Sequence();
         var _loc3_:Wait = new Wait(500);
         _loc2_.add(_loc3_);
         for each(_loc4_ in this.options)
         {
            _loc5_ = new Timeout(this.hideOption,100,_loc4_);
            _loc2_.add(_loc5_);
            _loc2_.addEventListener(TaskEvent.COMPLETE,this.hideQuestion);
         }
         this.taskRunner.add(_loc2_);
      }
      
      private function onOutAnswer(param1:Event = null) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("idle");
      }
      
      override public function dispose() : void
      {
         Telemetry.getInstance().trackEvent(this.telemetryId,"close","",this.totalReplys);
         super.dispose();
      }
      
      override protected function ready() : void
      {
         this.taskRunner = new TaskRunner(this);
         this.taskRunner.start();
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc1_:String = URLUtil.getUrl("cfgs/bocaTrivia.json");
         var _loc2_:LoadFile = new LoadFile(_loc1_,"json");
         this.settings.addFile(_loc2_);
         _loc2_.addEventListener(TaskEvent.COMPLETE,this.onSettingsLoaded);
         this.taskRunner.add(_loc2_);
      }
      
      protected function getQuestions() : Array
      {
         var _loc1_:Array = this.settings.trivia.concat();
         _loc1_ = ArrayUtil.shuffle(_loc1_);
         _loc1_ = ArrayUtil.shuffle(_loc1_);
         return ArrayUtil.shuffle(_loc1_);
      }
      
      protected function showPrices() : void
      {
         var _loc2_:MovieClip = null;
         this.prizes.visible = true;
         this.givePrizeBtn.visible = false;
         this.givePrizeBtn.addEventListener(MouseEvent.CLICK,this.onGivePrize);
         this.givePrizeBtn.text.text = "OK";
         var _loc1_:int = 0;
         while(_loc1_ < this.maxPrizes)
         {
            _loc2_ = this.prizes["prize_" + _loc1_] as MovieClip;
            _loc2_["reward"].gotoAndStop(_loc1_ + 1);
            _loc2_["btn"].gotoAndStop("up");
            if(this.currentOwnedPrices.charAt(_loc1_) == "1")
            {
               _loc2_["yolatengo"].visible = true;
               _loc2_.mouseChildren = false;
            }
            else
            {
               _loc2_.addEventListener(MouseEvent.CLICK,this.prizeSelected);
               _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.mouseEvent);
               _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.mouseEvent);
               _loc2_.mouseChildren = false;
               _loc2_["yolatengo"].visible = false;
               _loc2_["reward"].mouseEnabled = false;
            }
            _loc1_++;
         }
         this.prizes.text.text = this.currentOwnedPrices == "11111" ? this.settings.gui.allPrizes : this.settings.gui.fiveInRow;
      }
      
      protected function setCharAt(param1:String, param2:String, param3:int) : String
      {
         return param1.substr(0,param3) + param2 + param1.substr(param3 + 1);
      }
      
      protected function showQuestion() : void
      {
         var _loc1_:int = TextFieldUtil.countWords(this.question.text) * 200;
         var _loc2_:Tween = new Tween(this.question,500,{"alpha":1});
         var _loc3_:Wait = new Wait(_loc1_);
         var _loc4_:Sequence;
         (_loc4_ = new Sequence(_loc2_,_loc3_)).addEventListener(TaskEvent.COMPLETE,this.showOptions);
         this.taskRunner.add(_loc4_);
      }
      
      private function removeOptionListeners() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this.options)
         {
            this.removeOptionListener(_loc1_);
         }
      }
      
      protected function onSettingsLoaded(param1:Event) : void
      {
         this.trivia = this.getQuestions();
         this.next.text.text = this.settings.gui.play;
         var _loc2_:String = !!api.getAvatarAttribute(this.triviaId) ? String(api.getAvatarAttribute(this.triviaId).toString()) : "000000000:4673067238399";
         this.currentOwnedPrices = _loc2_.split(":")[0];
         var _loc3_:Date = new Date(Number(_loc2_.split(":")[1]));
         var _loc4_:Date = new Date(server.time);
         this.winToday = Math.abs(TimeSpan.fromDates(_loc3_,_loc4_).days);
         Telemetry.getInstance().trackEvent(this.telemetryId,"open");
      }
      
      protected function setupView() : void
      {
         var _loc1_:String = null;
         this.asset = view as MovieClip;
         this.query = this.asset["query"] as MovieClip;
         this.question = this.query["question"]["txt_query"];
         this.intro = this.asset["intro"] as MovieClip;
         this.next = this.asset["next"] as MovieClip;
         this.score = this.query["score"] as TextField;
         this.score.visible = false;
         this.prizes = this.asset["prizes"];
         this.prizes.visible = false;
         this.givePrizeBtn = this.prizes["select"] as MovieClip;
         this.givePrize = this.asset["givePrize"];
         this.givePrize.visible = false;
         this.question.alpha = 0;
         this.question.autoSize = TextFieldAutoSize.CENTER;
         this.question.wordWrap = true;
         this.questionY = this.question.y;
         this.options = [];
         for each(_loc1_ in this.btns)
         {
            this.query[_loc1_].alpha = 0;
            this.options.push(this.query[_loc1_]);
         }
         this.query.visible = false;
         this.next.addEventListener(MouseEvent.CLICK,this.onPlay);
      }
      
      protected function onPlay(param1:Event = null) : void
      {
         this.intro.visible = false;
         this.query.visible = true;
         this.next.visible = false;
         this.score.text = this.currentScore + this.settings.gui.score;
         this.score.visible = true;
         this.currentQuestion = this.trivia[0];
         if(this.win(this.currentScore))
         {
            Telemetry.getInstance().trackEvent(this.telemetryId,"win","",this.totalReplys);
            this.query.visible = false;
            this.showPrices();
         }
         else
         {
            this.setQuestion();
            this.setAnswers();
            this.showQuestion();
         }
      }
      
      private function prizeSelected(param1:MouseEvent = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.givePrizeBtn.visible = false;
         _loc2_ = 0;
         while(_loc2_ < this.maxPrizes)
         {
            _loc3_ = this.prizes["prize_" + _loc2_] as MovieClip;
            if(_loc3_ == param1.currentTarget && _loc3_.currentLabel != "seleccionado")
            {
               param1.currentTarget.gotoAndStop("seleccionado");
               this.givePrizeBtn.visible = true;
               this.selectedPrize = _loc2_;
            }
            else
            {
               _loc3_.gotoAndStop("activo");
            }
            _loc2_++;
         }
      }
      
      protected function hideQuestion(param1:Event = null) : void
      {
         var _loc2_:Tween = new Tween(this.question,500,{"alpha":0});
         _loc2_.addEventListener(TaskEvent.COMPLETE,this.onPlay);
         this.taskRunner.add(_loc2_);
      }
      
      override protected function onAssetReady() : void
      {
         this.setupView();
      }
      
      protected function setAnswers() : void
      {
         var _loc1_:Array = this.currentQuestion.answers;
         _loc1_ = ArrayUtil.shuffle(_loc1_);
         _loc1_ = ArrayUtil.shuffle(_loc1_);
         _loc1_ = ArrayUtil.shuffle(_loc1_);
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            this.options[_loc2_].gotoAndStop("idle");
            this.options[_loc2_].data = _loc1_[_loc2_];
            this.options[_loc2_].text.text = _loc1_[_loc2_].option.toUpperCase();
            _loc2_++;
         }
      }
      
      private function hideOption(param1:MovieClip) : void
      {
         var _loc2_:Tween = new Tween(param1,100,{"alpha":0});
         this.taskRunner.add(_loc2_);
      }
      
      private function showOption(param1:MovieClip) : void
      {
         param1.alpha = 0;
         var _loc2_:Tween = new Tween(param1,200,{"alpha":1});
         this.taskRunner.add(_loc2_);
      }
      
      protected function win(param1:int) : Boolean
      {
         if(param1 < 5)
         {
            return false;
         }
         return true;
      }
      
      protected function showOptions(param1:TaskEvent = null) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Timeout = null;
         var _loc2_:Sequence = new Sequence();
         for each(_loc3_ in this.options)
         {
            _loc4_ = new Timeout(this.showOption,500,_loc3_);
            _loc2_.add(_loc4_);
            _loc2_.addEventListener(TaskEvent.COMPLETE,this.addOptionListeners);
         }
         this.taskRunner.add(_loc2_);
      }
      
      protected function onGivePrize(param1:MouseEvent = null) : void
      {
         this.prizes.visible = false;
         this.givePrize.visible = true;
         if(this.winToday < 1)
         {
            this.givePrize.text.text = this.settings.gui.comeTomorrow;
            this.givePrize.reward.gotoAndStop("noprize");
            return;
         }
         api.giveUser(this.settings.prizes[this.selectedPrize],1);
         this.currentOwnedPrices = this.setCharAt(this.currentOwnedPrices,"1",this.selectedPrize);
         var _loc2_:String = this.currentOwnedPrices + ":" + server.time;
         api.setAvatarAttribute(this.triviaId,_loc2_);
         this.givePrize.reward.gotoAndStop(this.selectedPrize + 1);
         var _loc3_:String = String(this.settings.gui.congrats);
         _loc3_ += this.currentOwnedPrices == "11111" ? this.settings.gui.allPrizes : "\n";
         _loc3_ += this.settings.gui.allAboutBoca;
         this.givePrize.text.text = _loc3_;
         Telemetry.getInstance().trackEvent(this.telemetryId + ":PRIZE",this.settings.prizes[this.selectedPrize]);
      }
      
      private function addOptionListeners(param1:Event = null) : void
      {
         var _loc2_:MovieClip = null;
         for each(_loc2_ in this.options)
         {
            _loc2_.addEventListener(MouseEvent.CLICK,this.onSelectAnswer);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onOverAnswer);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onOutAnswer);
         }
      }
      
      protected function setQuestion() : void
      {
         this.question.text = this.currentQuestion.query.toUpperCase();
         this.question.y = this.questionY + this.question.parent.height * 0.5 - this.question.textHeight * 0.5;
      }
      
      private function onSelectAnswer(param1:Event = null) : void
      {
         ++this.totalReplys;
         if(param1.currentTarget.data.win)
         {
            param1.currentTarget.gotoAndStop("good");
            this.currentScore += 1;
            this.trivia.shift();
            if(this.trivia.length == 0)
            {
               this.trivia = this.getQuestions();
            }
         }
         else
         {
            param1.currentTarget.gotoAndStop("bad");
            this.trivia.push(this.trivia.shift());
            this.currentScore = 0;
         }
         this.removeOptionListeners();
         this.hideOptions();
      }
      
      private function removeOptionListener(param1:MovieClip) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.onSelectAnswer);
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.onOverAnswer);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.onOutAnswer);
      }
      
      private function onOverAnswer(param1:Event = null) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("over");
      }
   }
}
