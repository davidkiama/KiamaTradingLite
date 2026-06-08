OANDA Intraday Reversal Backtester
A Python script that automates the extraction and preliminary backtesting of an intraday reversal strategy using historical OANDA forex data. It exports a formatted Excel spreadsheet for further manual trade journaling.

🚀 Quick Start

1. Install Dependencies:

Bash
pip install pandas pytz oandapyV20 openpyxl 2. Set Your OANDA API Token:

Bash
export OANDA_API_TOKEN="your_token_here"

# On Windows use: set OANDA_API_TOKEN="your_token_here"

3. Configure the Script:
   Open the script and adjust the CONFIGURATION section to set your TARGET_YEAR, TARGET_MONTH, INSTRUMENT (e.g., "EUR_USD"), and GRANULARITY (e.g., "M5").

⚙️ How It Works
The script converts data to New York local time and analyzes price action across three windows:

Session Window (00:00 - 09:30): Establishes baseline highs and lows.

Open Window (09:30 - 10:00): Determines the "Run Bias" (Bullish/Bearish) by checking if the price breaks the Session highs or lows.

Reversal Window (10:00 - 11:00): Detects if a new daily high/low is formed, and tracks if the price subsequently retraces to touch the 0.236 Fibonacci level before 11:00.

📊 Output
Running the script generates an Excel file (e.g., EUR_USD_Reversal_Strategy_2026_05.xlsx). It includes the automated algorithmic metrics alongside color-coded, blank columns specifically injected for your manual trade journaling (Execution Bias, Risk/Reward, Notes).
