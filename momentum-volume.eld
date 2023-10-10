Inputs:
    FastLength(20),             // Length of the fast moving average
    SlowLength(50),             // Length of the slow moving average
    VolumeThreshold(20000),     // Minimum volume required
    ConsecutiveBars(5),         // Number of consecutive bars with fast above slow
    StopLossPct(0.5),           // Reduced stop loss percentage
    ProfitTargetPct(1.5);       // Reduced profit target percentage

Variables:
    FastMA(0),                  // Fast moving average
    SlowMA(0),                  // Slow moving average
    LongCondition(false),       // Condition for entering a long position
    EntryPriceValue(0),        // Entry price for the trade
    ConsecutiveBarsCount(0);    // Count of consecutive bars with fast above slow

FastMA = Average(Close, FastLength);
SlowMA = Average(Close, SlowLength);

LongCondition = (FastMA > SlowMA) and (Volume >= VolumeThreshold);

// Buy condition
If LongCondition and MarketPosition <> 1 then
    Buy ("LongEntry") next bar at Market;

If MarketPosition = 1 then
Begin
    EntryPriceValue = AvgEntryPrice;
    SetStopLoss(EntryPriceValue * (1 - StopLossPct / 100));
    SetProfitTarget(EntryPriceValue * (1 + ProfitTargetPct / 100));
End;

// Sell condition for exiting a long position
If MarketPosition = 1 and (FastMA < SlowMA or Close <= EntryPriceValue * (1 - StopLossPct / 100)) then
    Sell ("LongExit") next bar at Market;

// Add a filter condition for consecutive bars
If FastMA > SlowMA then
    ConsecutiveBarsCount = ConsecutiveBarsCount + 1
else
    ConsecutiveBarsCount = 0;

// Update LongCondition based on consecutive bars count
If ConsecutiveBarsCount >= ConsecutiveBars then
    LongCondition = true
else
    LongCondition = false;
