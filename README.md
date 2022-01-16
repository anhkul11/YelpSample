# YelpSample
YelpSample using MVVM architect, simple app that allow user to search and fetch bussiness from Yelp services.
- Search View

## **1. Architecture**
It's written in MVVM. It's quite similar to the traditional version, just that using cummunicate protocols helps us make the responsibility clearer, easy to test and scale up.

## **2. Code structure**

Surveys
This consists of files being used in the main target.

- Commons: Extend some existing classes/structs such as UIViewController, UITableViewCell...
- Configs: Configs file, Constants...
- Models: Declare the models/entities used in the app.
- Services: All the API services to interact with Yelp APIs. Each service is responsible for sending the request to BE and parsing the response or handling failures.
- Screens: Every screen's MVVM components are located in this folder.
- Coordinator: Contains Coordinators responsible for routing in app.
- Resouces: Assets.

- LocalPods
The libs that can be shared between the main target and unit/UI test target are located in LocalPods such as RxSwift, KingFisher...

## **3. Third-party libraries**
Below is the list of third-party libraries that I use in the project:

- **RxSwift/RxCocoa**: It is this project's backbone to seamlessly manipulate UI events (binding between ViewModel and View) as well as API requests/responses. By transforming everything to a sequence of events, it not only makes the logic more understandable and concise but also helps us get rid of the old approach like adding target, delegates, closures which we might feel tedious sometimes.
- **RxDataSources**: Extension of RxSwift, use to binding datasource in tableview, collectionview.
- **KingFisher**: Quick and easy download image from internet with elegant caching approach.
- **Alamofire**: an HTTP networking library written in Swift. Use to handle all URL requests.

## **4. Build the project on local**
- After cloning the repo, please run `pod install` from your terminal then open `42Race.xcworkspace` and try to build the project using Xcode 12+.
It should work without any additional steps.

## **5. Checklist**
- [x] Programming language: Swift

- [x] Design app's architecture: MVVM
 
- [ ] Unit tests

Thanks and have a nice day!
