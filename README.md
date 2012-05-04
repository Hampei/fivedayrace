FiveDayRace
===========

** UNDER CONSTRUCTION **

The first idea for this project was the 'infinite hundred hour race': a ranking based on the last hundred hours of steps. Every hour an hour of data would be removed, while data would be added as soon as a fitbit was synced. As soon as someone overtakes someone else they get a notification of this event via iphone or android notifications.
This would suit us well in the office, since we are often quite close to each other in score and todays score is often broadcasted to the room making others try to get more steps in. We wanted a leaderboard that would allow us to take a walk, sync and take the lead. We feel this will make us work that much harder (on stepping that is, programming might suffer).

We were forced to make it a 5 day race, since the fitbit api does not supply the data on a per hour basis, but only on a per day basis. Same principle, but slightly less compelling, since you get a much bigger sawtooth action in the score, going up during the day and crashing down at midnight.

Out of cheapness I liked this to run on a single heroku dyno, without a worker doing the fetching from fitbit. I also wanted to get some experience with fitgem, asynchronous requests on heroku and using sinatra as middleware for a rails app.

So the main flow of the app is:

- users log in via fitbit oauth, tokens/secret are saved and user is registered for activities notifications.
- fitbit_callback_handler intercept calls to /fitbit/callback, which schedules handling of the events and returns.
  - next tick all the activity data for the events is fetched asynchronously. 
  - when data comes in, it is saved to the database. 
  - when all data has been handled, the new ranking is computed and messages send if users have changed position.
- phone apps get notifcations and fetch the new ranking clicks it.


app_usage
---------

- open a webview to 'fivedayrace.heroku.com/iphone_login
- Allow it to redirect to fitbit -> user logs in -> redirects to app
- app redirects to token://<app_token>
- save token and use it in all request by specifying ?app_token=<app_token>
- wait for notification to come in #TODO
- get /stats.json?app_token=<app_token>


TODO
----

- save friends of users. A user should only battle his friends from fitbit.
 - maybe add an option to hide some of the friends from fitbit.
- iphone notications
- android notifications


Local development
-----------------

create config/heroku_env.rb and fill with needed

    ENV['FITBIT_KEY'] = 'xxx'
    ENV['FITBIT_SECRET'] = 'xxx'
    ENV['SECRET_TOKEN'] = 'xxx' # for cookies Application.config.secret_token