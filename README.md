# Shudder Featured View Recreation

## Description

![alt text](/Assets/view.png "Logo Title Text 1")

### Purpose

This is a reimplementation of the Shudder application's Featured View.  This view takes images from the Flickr API and displays them in Carousels.

### Structure
This project is designing using the Model-View-Controller design pattern as can be seen in xcode project.

To create sections, an array of strings can be given inside of**FeaturedTableViewController**, which is the controller of this application, in the **addCollectionSearchSetToDataCollection** method inside **viewDidLoad** and from that array, **API** handles creating sections.  

**DataCollection** handles all of the storage of the images and organization of sections and items in each section.  Sections are represented as CarouselSets and items are represented as CarouselItems.  A CarouselItem is a single item that displays the image but can contain any other data needed for the item.  A CarouselSet contains an array of CarouselItems with a name, which acts as a section. DataCollection contains an array of CarouselSets.


The way this project calls to Flickr API is created and managed with requests that first get the list of 25 results for each *word* that is given to **addCollectionSearchSetToDataCollection** and then calls to all the images. and load them into CarouselItems and CarouselSets.  All calls are done on separate threads to speed up calls and increase energy efficiency over a longer period of time.  Although this may lead to inconsistent ordering of images when calls are being received since there is not set order on when threads are finished running since some threads may be faster than others.

**BannerCollection** handles the storage and organization associated with images loading in the Banner, also known as the "Hero Carousel".  This reuses the same structure of DataCollection and all of it's corresponding calls.

Controller:
* FeaturedTableViewController - Controller that coordinates information and logic between the View and Model

View:
* Main.Storyboard - Visual Structure and Views
* CarouselCell - View

Model:
* CarouselItem - Data Class
* CarouselSet - Data Class
* DataObjects - Location of logic Data Classes and Data Structure
* API - All API calls and storage handling of data

### Tools
* Xcode - Integrated development environment
* Swiftlint - Linter that handles swift syntactic sugar/code smells/other various swift structures for consistency and readability of code
* Jazzy - Documentation generator that creates a layout to view documentation as well as catch methods/properties that have not been documented.

### Documentation
Jazzy cli is used to generate the documentation.

Please open the **index.html**, located in ***ShudderFeatured/docs/*** in a browser to view all the documentation in a visual web page.

A short demo can also be found in ***ShudderFeatured/Assets/ShudderDemo.mov***

![alt text](/Assets/documentation.png "Logo Title Text 1")

### Potential Issues and Improvements

**Flickr API** <br/>
Flickr API is called on multiple threads to create more efficiency of network and energy from the amount of calls that needs to be created.  This also provides speed increase in speed as well.  Unfortunately this creates many calls to the server, 1 for each *section* and then for each *image* which can cause **rate limiting** and not be able to receive all the data and sections upon consecutive calls.  **All data may not be received or loaded into Carousels including sections and individual items due to this issue!** A solution to this problem is batch calling and waiting for the proper rate limit times.  **This is not an issue currently present in the following data loaded being called from test**

FlickrAPI Search as documented within Flickr API takes some time to run search queries.  We are calling n amount of queries for n sections concurrently but due to FlickAPI search we may not get all the search results if the full search on the server has not been done.  This may lead to some waiting for the users and more cost of energy for the cpu to produce the call.

**Banner Carousel** <br/>
Banner Carousel is currently implemented by increasing by appending the BannerCollection Carousel by a multiplier of 5 with itself.  This is a **Temporary Solution** to the problem. A fix may be implementing a proper queue Data Structure that cycles the images and resets and saves the location of indexPaths and offsets. This current implementation has no significant impact on energy/cpu usage since the cells are dequeued when they are not in view but this may improve memory efficiency.

**Image Data** <br/>
Currently the image data is being called and downloaded on separate threads as the view is being loaded with every image being stored after downloaded.  This creates a big impact on memory with having many images stored at once.  A potential improvement of the implementation is to do the FlickAPI call of each section and download images as they come into view as well as reuse the containers as they leave the view.
