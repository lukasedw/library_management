# Library Management System

## Overview

This Ruby on Rails application provides a comprehensive solution for managing a library's book inventory and user borrowings. It features distinct interfaces and functionalities for two types of users: Librarians and Members. Additionally, it includes a RESTful API for CRUD operations on authors, genres and books. It is possible to borrow a book if you are a member and return it if you are a librarian.

## Technology Stack

- **Backend**: Ruby on Rails
- **Database**: PostgreSQL
- **API**: RESTful API with Grape
- **Testing**: RSpec

## Getting Started

Clone the repository and install the dependencies and run db setup:

```
bundle install
rails db:setup
```

Copy the `.env.development` file and rename it to `.env.development.local` and the PostgreSQL database credentials.
Do the same process for the `.env.test`.

Then add the `RAILS_MASTER_KEY` env to your system or IDE, or create a master key file `config/master.key` and add the following key:

```
f6b166af694ff3d7cd51202c6542cc34
```

**[Postman collection](https://www.postman.com/restless-rocket-938874/workspace/library-system/collection/27430268-24c1f1a7-dfef-4b87-8346-b4971332149a?action=share&creator=27430268)**


### Prerequisites

- Ruby 3.2.2
- PostgreSQL 13+
