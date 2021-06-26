# VhsDevTest

Setup your environment:
 
  * Register for an account at blocknative.com
  * Download and install `ngrok` to be able to use your locally running application as a blocknative webhook, i.e.
    `http://xxxxxxxx.ngrok.io/blocknative-webhook`
  * Add the following variable to your ~/.bash_profile
    `export BLOCKNATIVE_API_KEY='<your_blocknative_api_key>'`

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Add a transaction to watchlist:

http://xxxxxxx.ngrok.io/transaction?txid=<transaction_hash>

Get a list of watched transactions:

http://xxxxxxx.ngrok.io/transactions


## Useful links

  * Blocknative API: https://docs.blocknative.com/webhook-api#add-transaction-to-watch
  * Slack API: https://api.slack.com/messaging/webhooks

