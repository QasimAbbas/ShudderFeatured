# ShudderFeatured

## Description

![https://github.com/QasimAbbas/ShudderFeatured/Assets/view.png](ShudderFeatured/Assets/view.png "Logo Title Text 1")

### Purpose

This is a recreation of the Shudder application's Featured View.  This view takes images from the Flickr API and displays them in Carousels.

### Structure
This project is designing using the Model-View-Controller design pattern as can be seen in xcode project.

To create sections, an array of strings can be given inside of**FeaturedTableViewController**, which is the controller of this appliation, in the **addCollectionSearchSetToDataCollection** method inside **viewDidLoad** and from that array, **API** handles creating sections.  

**DataCollection** handles all of the storage of the storage and organization of sections and items in each section.  Sections are represented as CarouselSets and items are represented as CarouselItems.  A CarouselItem is a single item that diplays the image but can contain any other data needed for the item.  A CarouselSet contains an array of CarouselItems with a name, which acts as a section. DataCollection contains an array of CarouselSets.

The way this project calls to Flickr API is created and managed with requests that first get the list of 25 results for each *word* that is given to **addCollectionSearchSetToDataCollection** and then calls to recieve all the images. and load them into CarouselItems and CarouselSets.  All calls are done on separate threads to speed up calls and increase energy efficiency over a longer period of time.

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
* Xcode - Integerated development environment
* Swiftlint - Linter that handles swift syntax/code smells/other various swift structures for consistency and readability of code
* Jazzy - Documentation generator that creates a layout to view documentation as well as catch methods/properties that have not been documented.

### Documentation
Jazzy cli is used to generate the documentation.

Please open the **index.html**, located in *ShudderFeatured/docs/* in a browser to view all the documentation in a visual web page.

### Potential Issues
Flickr API is called on multiple threads to create more efficiency of network and energy fromt the amount of calls that needs to be created.  This also provides speed increase in speed as well.  Unfortunately this creates many calls to the server, 1 for each *section* and then for each *image* which can cause **rate limiting** and not be able to recieve all the data and sections upon consecutive calls.  **All data may not be recieved or loaded into Carousels including sections and individual items due to this issue!**

