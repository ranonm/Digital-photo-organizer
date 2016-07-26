# PIXBox - Digital Photo Organizer

Individual graduate course work; Elicited requirements, designed and implemented the concept of a digital photo organizer in Ruby.

## Overview
The aim of this project was to compose a software requirements specification, software design document and conceptual implementation of a single user, standalone digital photo organizing software.

The digital photo organizing software must provide the end-user with the ability to:
* Manage photos and photo albums
* Search for a photo or photos by using a keyword or group of comma-separated keywords.
* Share one photo or an entire album of photographs via email without the use of a third-party solution.
* View a single photo or a slideshow of photos from a particular photo album.
* Configure the settings for the email and slideshow globally.
* Carryout basic photo editing techniques on photos without the use of a third-party software.

This project includes:
1. The Software Requirements Specification, showcasing the elicited requirements from the client.
2. The Software Design Document, showcasing the design of the digital photo organizer based on the requirements conveyed in the Software Requirements Specification.
3. An implementation in ruby, conveying the basic concept conveyed in the Software Design Document.



## Application file structure

The entire program spans over multiple files organized in the PIXBox source directory, which has the following file structure:
* Config
  * appdata.rb
  * settings.rb
* data (Storage for the serialized data file)
* media (Storage for media files)
* support_files
  * breadcrumb.rb 
  * factories.rb
  * observer.rb
  * persistence.rb 
  * subject.rb
  * textdecor.rb
  * utilities.rb
  * viewstack.rb 
  * whichos.rb
* app.rb
* controllers.rb 
* models.rb
* views.rb


## System requirements
You need Ruby 2.2.1+ to run this project.
Please go to [Ruby-lang.org](https://www.ruby-lang.org/en/documentation/installation/) to download the latest version of Ruby.


## How to run

Run the program in your command-line terminal by:
1. Download source directory to desired location on local computer.
2. Enter source code directory.
3. Type "ruby app.rb" and press the Enter (Return on Mac) key.
