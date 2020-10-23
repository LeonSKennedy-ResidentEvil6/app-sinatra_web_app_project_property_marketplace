# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
    -> Sinatra web application framework is used to build this application

- [x] Use ActiveRecord for storing information in a database
    -> Class objects and their associations are mapped to the database tables using ActiveRecord

- [x] Include more than one model class (e.g. User, Post, Category)
    -> This application has three model classes: User, Property, and UserProperty

- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts)
    -> A user has many properties and has many Userproperties

- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User)
    -> A property belongs to a user
    -> A user_property belongs to a user
    -> A user_property belongs to a property

- [x] Include user accounts with unique login attribute (username or email)
    -> A user can log in with a username and a correct password
    -> A user can log in either as a seller or a buyer

- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying
    -> A user as a buyer can create, read, update, and destory a user account and an offer
    -> A user as a seller can create, read, update, and destory a user account and a property

- [x] Ensure that users can't modify content created by other users
    -> A user as a seller or buyer can only edit their own profile
    -> A user as a seller can only edit their own property and offers made to that property
    -> A user as a buyer can only edit their own offers

- [x] Include user input validations
    -> User input validations are defined in each model classes
    -> A valid username and a correct password are required to successfully log in
    -> Name, username, email, and password are required to successfully sign up

- [x] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
    -> The application uses rack flash gem to display flash messages, errors, or status

- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code
    -> The README.md file in this application has all required components

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
