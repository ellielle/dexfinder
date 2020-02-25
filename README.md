## DexFinder

My take on the [final project](https://www.theodinproject.com/courses/ruby-on-rails/lessons/final-project) of The Odin
Project's Rails [curriculum](https://www.theodinproject.com/courses/ruby-on-rails). Instead of building a clone of
Facebook, I've opted to create a site with similar functionality focused around trading, battling and chatting with
[Pokémon](https://en.wikipedia.org/wiki/Pok%C3%A9mon).

You can see a live build <a href="https://stark-anchorage-88765.herokuapp.com/">here</a>.

Note: This project is on a temporary hiatus until I complete enough of the coursework 
to come back and make it less ugly / add missing features.


## Features
- [x] Friending people
- [x] User authentication
- [ ] Looking up Pokemon
- [ ] Creating and maintaining a Pokedex
- [x] Creating posts, with pictures / links, similar to Facebook's timeline
- [x] Commenting on posts
- [x] OAuth 2 support (Discord)

## Requirements
* Ruby 2.6.3
* Rails 6.0.2.1
* [Yarn](https://yarnpkg.com)
* Postgres

### Getting Started
#### Database
If you do not have Postgres installed on your machine, you may follow 
[Heroku's guide](https://devcenter.heroku.com/articles/heroku-postgresql#local-setup) to getting it installed.

Afterward, ensure you have a PSQL role with the attributes LOGIN and CREATEDB. You can do so from the postgres console:
```
$ psql

To create a new user:
postgres=# CREATE ROLE role_name WITH LOGIN CREATEDB;

To edit an existing user:
postgres=# ALTER ROLE role_name WITH LOGIN CREATEDB;
```

#### Installation
Clone or download the repository, then run the following in the repo folder:
```
$ bundle install
$ rails db:create
$ rails db:migrate
$ rails db:seed
```

#### Testing
Tests can be run with the following command:
```
$ rspec
```
