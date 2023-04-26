![tv set logo](logo.png)

# Seasoning

Your couch away from your couch.

Deploying to: <http://seasoning.herokuapp.com/> aka <https://www.seasoning.tv>

Demo: <https://www.youtube.com/watch?v=4aB6LbN2ff8>

## Setup

1. Install ruby, node, and postgres
1. Run `cp .env.development .env.development.local` and fill out `.env.development.local`
1. Run `npm install`
1. Run `rails db:setup`

Then to start things up, run these two commands in two separate terminal tabs:

1. `rails server`
1. `bin/vite dev` -- this is technically optional, but it will enable hot module reloading which is nice

And visit <http://localhost:3000>
