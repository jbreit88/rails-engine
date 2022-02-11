# Rails Engine: Turing 2110 BE Mod 2

![languages](https://img.shields.io/github/languages/top/jbreit88/rails-engine?color=red)
[![Ruby](https://github.com/jbreit88/rails-engine/actions/workflows/tests.yml/badge.svg)](https://github.com/jbreit88/rails-engine/actions/workflows/tests.yml)
![PRs](https://img.shields.io/github/issues-pr-closed/jbreit88/rails-engine)
![rspec](https://img.shields.io/gem/v/rspec?color=blue&label=rspec)
![simplecov](https://img.shields.io/gem/v/simplecov?color=blue&label=simplecov) <!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/contributors-1-orange.svg?style=flat)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

## About
- Project requirements can be found [Here](https://backend.turing.edu/module3/projects/rails_engine_lite/)
- Rails Engine is a project for developing and exposing various endpoints of an API.

## Database Schema
- See image below for project database schema:

![image](https://user-images.githubusercontent.com/88853324/153454294-299b52b8-367b-4441-9938-25b3336be8ed.png)

## Requirements and Setup (for Unix based systems):

### Ruby and Rails
- Ruby Version 2.7.2
- Rails Version 5.2.6

### Gems
- RSpec, Pry, SimpleCov, JSON API Serializer, RuboCop, FactoryBot, Faker, Should Matchers
- 
### Setup
1. Clone this repository:
On your local machine open a terminal session and enter the following commands for SSH or HTTPS to clone the repositiory.


- using ssh key <br>
`$ git clone git@github.com:jbreit88/rails-engine.git`

- using https <br>
`$ git clone https://github.com/jbreit88/rails-engine.git`

Once cloned, you'll have a new local copy in the directory you ran the clone command in.

2. Change to the project directory:<br>
In terminal, use `$cd` to navigate to the Relational Rails project directory.

`$ cd rails-engine`

3. Install required Gems utilizing Bundler: <br>
In terminal, use Bundler to install any missing Gems. If Bundler is not installed, first run the following command.

`$ gem install bundler`

If Bundler is already installed or after it has been installed, run the following command.

`$ bundle install`

There should be be verbose text diplayed of the installation process that looks similar to below. (this is not an actual copy of what will be output).

```
$bundle install
Using rake 13.0.6
Using concurrent-ruby 1.1.9
Using i18n 1.9.1
Using minitest 5.15.0
Using thread_safe 0.3.6
Using tzinfo 1.2.9
Using activesupport 5.2.6
Using builder 3.2.4
Using erubi 1.10.0
Using mini_portile2 2.7.1
Using racc 1.6.0
...
Using ruby-progressbar 1.11.0
Using unicode-display_width 2.1.0
Using rubocop 1.25.0
Using rubocop-rails 2.13.2
Using shoulda-matchers 5.1.0
Using simplecov-html 0.12.3
Using simplecov_json_formatter 0.1.3
Using simplecov 0.21.2
Using spring 2.1.1
Using spring-watcher-listen 2.0.1
Bundle complete! 18 Gemfile dependencies, 81 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```
If there are any errors, verify that bundler, Rails, and your ruby environment are correctly setup.

4. Database Migration<br>
Before using the web application you will need to setup your databases locally by running the following command

`$ rails db: {:drop, :create, :migrate, :seed}`

Then, to finish database set up, run the command

`$ rails db:schema:dump`

5. Startup and Access<br>
Finally, in order to use this API, you will have to start the server locally and access the app through a web browser or other program capable of connecting with and API endpoint. For this you can try [Postman](https://www.postman.com/downloads/)

- Start server
`$ rails s`
    
At this point the API endpoints should be available. Use the endpoints outlined in the next section to return the desired data. If you encounter any errors or are unable to connect with the API, please confirm you followed the steps above and that your environment is properly set up.

## API Endpoints
- All enpoints will be accessing the API from the base URI `http://localhost:3000/api/v1...`

### Merchants Endpoints
- `get http://localhost:3000/api/v1/merchants` : Returns all merchant data.
```json
  {
    "data": [
        {
            "id": "1",
            "type": "merchant",
            "attributes": {
                "name": "Schroeder-Jerde"
            }
        },
        {
            "id": "2",
            "type": "merchant",
            "attributes": {
                "name": "Klein, Rempel and Jones"
            }
        }
      ]
   }
   ```
- `get http://localhost:3000/api/v1/merchants/:merchant_id` : Returns data on merchant associated with ID
```json
{
    "data": {
        "id": "42",
        "type": "merchant",
        "attributes": {
            "name": "Glover Inc"
        }
    }
}
```
- `get http://localhost:3000/api/v1/merchants/:merchant_id/items` : Returns all items associated with the merchant ID
```json
{
    "data": [
        {
            "id": "2425",
            "type": "item",
            "attributes": {
                "name": "Item Excepturi Rem",
                "description": "Perferendis reprehenderit fugiat sit eos. Corporis ipsum ut. Natus molestiae quia rerum fugit quis. A cumque doloremque magni.",
                "unit_price": 476.82,
                "merchant_id": 99
            }
        }
      ]
   }
 ```
 - `get http://localhost:3000/api/v1/merchants/find?name=iLl` : Returns a single record for the parameter query passed for :name. Can be an exact or partial match
 ```json
 {
    "data": [
        {
            "id": "28",
            "type": "merchant",
            "attributes": {
                "name": "Schiller, Barrows and Parker"
            }
        }
    ]
}
```
- `get http://localhost:3000/api/v1/merchants/find_all?name=ILL` : Returns all merchant records with a partial match to the name query string.
```json
{
    "data": [
        {
            "id": "28",
            "type": "merchant",
            "attributes": {
                "name": "Schiller, Barrows and Parker"
            }
        },
        {
            "id": "13",
            "type": "merchant",
            "attributes": {
                "name": "Tillman Group"
            }
        }
     ]
  }
```

 ### Item Endpoints
 - `get http://localhost:3000/api/v1/items` : Returns all item records in database.
 ```json
 {
    "data": [
        {
            "id": "4",
            "type": "item",
            "attributes": {
                "name": "Item Nemo Facere",
                "description": "Sunt eum id eius magni consequuntur delectus veritatis. Quisquam laborum illo ut ab. Ducimus in est id voluptas autem.",
                "unit_price": 42.91,
                "merchant_id": 1
            }
        },
        {
            "id": "5",
            "type": "item",
            "attributes": {
                "name": "Item Expedita Aliquam",
                "description": "Voluptate aut labore qui illum tempore eius. Corrupti cum et rerum. Enim illum labore voluptatem dicta consequatur. Consequatur sunt consequuntur ut officiis.",
                "unit_price": 687.23,
                "merchant_id": 1
            }
        }
     ]
  }
 ```
 - `get http://localhost:3000/api/v1/items/:item_id` : Returns item information for item associated with the passed ID
 ```json
 {
    "data": {
        "id": "179",
        "type": "item",
        "attributes": {
            "name": "Item Qui Veritatis",
            "description": "Totam labore quia harum dicta eum consequatur qui. Corporis inventore consequatur. Illum facilis tempora nihil placeat rerum sint est. Placeat ut aut. Eligendi perspiciatis unde eum sapiente velit.",
            "unit_price": 906.17,
            "merchant_id": 9
        }
    }
}
```
- `post http://localhost:3000/api/v1/items` : Create an Item record.
```json
{
    "data": {
        "id": "2521",
        "type": "item",
        "attributes": {
            "name": "Shiny Itemy Item",
            "description": "It does a lot of things real good.",
            "unit_price": 123.45,
            "merchant_id": 43
        }
    }
}
```
- `delete http://localhost:3000/api/v1/items/:item_id` : Remove Item record associated with the passed ID
- `put http://localhost:3000/api/v1/items/:item_id` : Update the attributes of an Item record
- `get http://localhost:3000/api/v1/items/:item_id/merchant` : Returns the Merchant data for the item ID
```json
{
    "data": {
        "id": "11",
        "type": "merchant",
        "attributes": {
            "name": "Pollich and Sons"
        }
    }
}
```
- `get http://localhost:3000/api/v1/items/find?name=hArU` : Find single item record by partial or exact name match. Pass param in as :name.
```json
{
    "data": [
        {
            "id": "1209",
            "type": "item",
            "attributes": {
                "name": "Item At Harum",
                "description": "Fuga et aut libero veniam tenetur. Ex eligendi modi libero aut numquam at. Velit dolores non ut cupiditate aut consequatur. Maiores quas vel qui aut et voluptatum. Qui consequatur illo.",
                "unit_price": 841.97,
                "merchant_id": 55
            }
        }
    ]
}
```
- `get http://localhost:3000/api/v1/items/find?min_price=50` : Returns all items with a value greater than :min_price. Can also use :max_price and search for anything less than that value.
```json
{
    "data": [
        {
            "id": "587",
            "type": "item",
            "attributes": {
                "name": "Item Animi In",
                "description": "Eum necessitatibus eos aliquid consequuntur. Occaecati ut quia et. Vel molestiae eum beatae ut nostrum. Beatae rem cumque autem.",
                "unit_price": 50.03,
                "merchant_id": 29
            }
        }
    ]
}
```
- `get http://localhost:3000/api/v1/items/find_all?name=haru` : Returns all item records matching the partial or full name passed in the name param.
```json
{
    "data": [
        {
            "id": "1209",
            "type": "item",
            "attributes": {
                "name": "Item At Harum",
                "description": "Fuga et aut libero veniam tenetur. Ex eligendi modi libero aut numquam at. Velit dolores non ut cupiditate aut consequatur. Maiores quas vel qui aut et voluptatum. Qui consequatur illo.",
                "unit_price": 841.97,
                "merchant_id": 55
            }
        },
        {
            "id": "1344",
            "type": "item",
            "attributes": {
                "name": "Item Aut Harum",
                "description": "Illum ducimus officia possimus est. Rerum sed quia omnis necessitatibus. A sed cupiditate blanditiis ut minus sed.",
                "unit_price": 513.97,
                "merchant_id": 59
            }
        }
     ]
  }
```


## **Authors** ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/jbreit88"><img src="https://avatars.githubusercontent.com/u/88853324?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Brad (he/him)</b></sub></a><br /><a href="https://github.com/jbreit88/rails-engine/commits?author=jbreit88" title="Code">💻</a> <a href="#ideas-jbreit88" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/jbreit88/rails-engine/commits?author=jbreit88" title="Tests">⚠️</a> <a href="https://github.com/jbreit88/rails-engine/pulls?q=is%3Apr+reviewed-by%3Ajbreit88" title="Reviewed Pull Requests">👀</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification.
<!--


# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
