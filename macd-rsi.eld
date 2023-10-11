Inputs:
    FastLength(12),  // Length of the fast EMA for MACD
    SlowLength(26),  // Length of the slow EMA for MACD
    SignalLength(9), // Length of the EMA for MACD signal line
    RSILength(14);   // Length of the RSI

Variables:
    MACDValue(0),
    MACDSignal(0),
    RSISignal(0),
    MACD_CrossedAbove(false),
    MACD_CrossedBelow(false),
    InLongPosition(false),
    InShortPosition(false);

// Calculate MACD
MACDValue = XAverage(Close, FastLength) - XAverage(Close, SlowLength);
MACDSignal = XAverage(MACDValue, SignalLength);

// Calculate RSI
RSISignal = RSI(Close, RSILength);

// Track MACD crossings
MACD_CrossedAbove = (MACDValue > MACDSignal and MACDValue[1] <= MACDSignal[1]);
MACD_CrossedBelow = (MACDValue < MACDSignal and MACDValue[1] >= MACDSignal[1]);

// Entry and Exit Conditions
if (MACD_CrossedAbove and RSISignal > 30 and not InLongPosition) then
begin
    Buy("Long") next bar at Market;
    InLongPosition = true;
    InShortPosition = false;
end
else if (MACD_CrossedBelow and RSISignal < 70 and not InShortPosition) then
begin
    SellShort("Short") next bar at Market;
    InShortPosition = true;
    InLongPosition = false;
end;

// Exit Conditions
if (InLongPosition and (MACD_CrossedBelow or RSISignal < 30)) then
begin
    Sell("ExitLong") next bar at Market;
    InLongPosition = false;
end
else if (InShortPosition and (MACD_CrossedAbove or RSISignal > 70)) then
begin
    BuyToCover("ExitShort") next bar at Market;
    InShortPosition = false;
end;
