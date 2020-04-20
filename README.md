# ScienceForSeniors
Science for Seniors: an AR mobile app for engaging the elderly in education through science experiments

This is a Proof of Concept mobile app that uses Augmented Reality and hands on science experiments to teach elementary level science content to older adults (60+).
While catered toward an older demographic, the app could realistically be used by all ages.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 
See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install this software and test it

#### CodeBase:
-This app is developed with Swift 5.1 and ARKit 3
-You will need xcode 11.3.1 to compile the project
-You will need RealityComposer to individually view any of the reality project files outside of the app


#### Device specs:
-iPhone 8 or up with iOS 13.2 (built around an iPhone 11 - contraints may not match to any other devices)
	-Device must support ARKit 3 and other augmented reality functionality
-Cannot be run on an emmulator due to the AR functionality not being supported with a camera

#### Other needs:
-In order to run the experiment path correctly, you will need the exact ingredients listed in the ingredients list.
	-Exact meaning same brand, same size, same packaging. THis is not sustainable - but this was a Proof of Concept.
-You will also need printed versions of the accompanying handouts for the photo recognition used in the Discover paths.
You can also optionally pull up the documents on a computer and scan from there. 

### Installing

-Download Xcode 11
-Clone or copy repository and open up in XCode

To test basic functionality:
-Run on simulator of iPhone 11 (pro or not)
-This will allow you to test the basic navigation and views in the app but none of the AR.

To test AR functionality:
-To test AR you will need an iPhone that supports ARKit and augmented reality functionality. 
-Plug in your device and build the app to it
-Open the app on you device and you can test and use the AR functionality from there.


## Authors

* **Jasmine Jans** - *Initial work*

## License

This project is not licensed and was buit as a Proof of Concept for the EduTech course in the OMSCS program at Georgia Tech.

## Acknowledgments

* To Georgia OMSCS program EdTech course

And to the following videos and tutorials:
* https://developer.apple.com/augmented-reality/
* https://www.youtube.com/watch?v=2bGa4bhOHeY
* https://www.youtube.com/watch?v=3FKzSYAGfJ0
* https://www.youtube.com/watch?v=FEqBW3cKF2k
* https://www.youtube.com/watch?v=2fJ4u9kfbVI
* https://developer.apple.com/videos/play/wwdc2019/603/
* https://developer.apple.com/videos/play/wwdc2019/604/
* https://developer.apple.com/videos/play/wwdc2019/609/
