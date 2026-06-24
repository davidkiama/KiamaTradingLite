#include <Trade/Trade.mqh>

input double Lots = 1;
input double TpPercent = 1;
input double SlPercent = 2;

input double MinMaGap = 0.6;


input ENUM_TIMEFRAMES Ma1Timeframe = PERIOD_M15;
input int Ma1Period = 360;

input ENUM_TIMEFRAMES  Ma2Timeframe = PERIOD_D1;
input int Ma2Period = 15;

input ENUM_TIMEFRAMES  AtrTimeframe = PERIOD_M15;
input int Atr1Period = 10;
input int Atr2Period = 20;

input ENUM_TIMEFRAMES  RsiTimeframe = PERIOD_M15;
input int RsiPeriod = 20;


int handleMa1;
int handleMa2;
int handleAtr1;
int handleAtr2;
int handleRsi;

int barsTotal;


CTrade trade;

double ma1[];

int OnInit(){
   handleMa1 = iMA(_Symbol, Ma1Timeframe,Ma1Period, 0, MODE_SMA, PRICE_CLOSE);
   handleMa2 = iMA(_Symbol, Ma2Timeframe,Ma2Period, 0, MODE_SMA, PRICE_CLOSE);
   
   handleAtr1 = iATR(_Symbol,AtrTimeframe, Atr1Period );
   handleAtr2 = iATR(_Symbol,AtrTimeframe, Atr2Period );
   
   handleRsi = iRSI(_Symbol, RsiTimeframe, RsiPeriod, PRICE_CLOSE);

   return(INIT_SUCCEEDED);
  }


  
void OnDeinit(const int reason){
 
}
  
  
void OnTick(){

    
    
   
   int counterBuy = 0, counterSell = 0;
   for(int i = PositionsTotal()-1; i>=0; i--){
      CPositionInfo pos;
      if(pos.SelectByIndex(i)){
         if(pos.PositionType() == POSITION_TYPE_BUY){
            counterBuy++;
            
            if(pos.Profit() > 0){
               if(pos.PriceCurrent() > ma1[0]){
                  trade.PositionClose(pos.Ticket());
               }
            }
         }else if(pos.PositionType() == POSITION_TYPE_SELL){
            counterSell ++;
            if(pos.Profit() > 0){
               if(pos.PriceCurrent() < ma1[0]){
                  trade.PositionClose(pos.Ticket());
               }
            }
         }
         
      }
      
      
   }

   int bars = iBars(_Symbol, Ma1Timeframe);
   
   if(barsTotal != bars){
      barsTotal = bars;

      
      CopyBuffer(handleMa1, MAIN_LINE, 1, 1, ma1);
      
      double ma2[];
      CopyBuffer(handleMa2, MAIN_LINE, 1, 1, ma2);
      
      double atr1[];
      CopyBuffer(handleAtr1, MAIN_LINE, 1, 1, atr1);
      
      double atr2[];
      CopyBuffer(handleAtr2, MAIN_LINE, 1, 1, atr2);
      
      double rsi[];
      CopyBuffer(handleRsi, MAIN_LINE, 1, 2, rsi);
      
      double close = iClose(_Symbol, Ma1Timeframe,1);
      
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK );
      
      
      if(atr1[0] < atr2[0]){
         if(close < ma1[0] - ma1[0] * MinMaGap / 100){
           if(close > ma2[0]){
               if(rsi[1] > rsi[0]){
                  if(counterBuy < 1){
                     double tp = 0;
                     if(TpPercent > 0){
                        tp = ask + ask * TpPercent / 100;
                        
                     }
                     double sl = 0;
                     if(SlPercent > 0){
                        sl =  ask - ask * SlPercent / 100;
                     }
                     trade.Buy(Lots, _Symbol, ask, sl, tp);
                  }
               }
           }
         }
         if(close > ma1[0] + ma1[0] * MinMaGap / 100){
            if(close < ma2[0]){
               if(rsi[1] < rsi[0]){
                  if(counterSell < 1){
                     //trade.Sell(1, _Symbol);
                     double tp = 0;
                     if(TpPercent > 0){
                        tp = bid - bid * TpPercent / 100;
                        
                     }
                     double sl = 0;
                     if(SlPercent > 0){
                        sl =  bid + bid *SlPercent / 100;
                     }
                     trade.Sell(Lots, _Symbol, bid, sl, tp);
                     
                     
                  
                  }
                  
                  
               }
           }
         }
      
      }

   }
   
}

