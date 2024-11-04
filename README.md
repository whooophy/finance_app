# README

This README would normally document whatever steps are necessary to get the
application up and running.

## FLOW:
There are three main entities: user, team, and stock.

- A user has a user history that is used to record the history of top-ups, transfers, and balance receipts. The user asset balance represents the total balance of the user's assets.

- A team is an entity that contains multiple users, where the total team balance is the sum of the balances of the users associated with it.

- A stock is an asset that is traded, and the last trade price of the stock will be continuously updated via an API that connects every 10 minutes.

Users who wish to register must first register at the create endpoint (using the key from the superadmin) and then be assigned to a specific team. Registered users can top up to add funds, transfer funds if they have available balance, and receive funds from other users.

Additionally, users can purchase available assets, which will initially have a pending status and will change to 'buy' once confirmed. All endpoints are available in Postman

Things you may want to cover:

* Ruby version

```bash
 ruby 3.0.2p107 (2021-07-07 revision 0db68f0233) [x86_64-linux-gnu] 
```

* System dependencies
```bash
Rails:
Version: ~> 7.0.8, specifically >= 7.0.8.6.

PostgreSQL Adapter:
Gem: pg
Version: ~> 1.1.

Web Server:
Gem: puma
Version: ~> 5.0.

Task Scheduler:
Gem: whenever (for scheduling tasks).

Environment Variables:
Gem: dotenv-rails (for managing environment variables).

Debugging:
Gem: debug (for debugging in development and test environments).
```

* Configuration
```
The configuration is in the .env file. You can modify it according to your system.
```

* Database creation

```
rails db:create
```

* Database initialization
```
rails db:migrate (run migration)
rails db:seed (seeding data)
```

* Services (job queues, cache servers, search engines, etc.)

```
bundle exec rake stocks:update (sync latest price trade stock)
```

* API Documentation
```
You can import the attached Postman file into Postman
```

