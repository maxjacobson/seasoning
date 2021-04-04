# Seasoning

Your couch away from your couch.

Deploying to: <http://seasoning.herokuapp.com/> aka <https://www.seasoning.tv>

## Kebabs, snakes, and camels

- Use kebab case in routes
- Use camel case for typescript variables
- Use snake case in ruby variables
- Use snake case in the serialized API data

## Setup

Pretty typical Rails stuff.

Some specific call outs:

- Make sure to `cp .env.development .env.development.local` and fill it out
- Make sure to run `rails db:seed`
- To build the front-end assets you'll need to run this in a separate terminal tab: `bin/vite dev`

## Environment variables

For some features to work in development, you'll need to create an `.env.development.local` file, filling in any of the blank values in `.env.development`.
