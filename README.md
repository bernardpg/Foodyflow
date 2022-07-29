# Foodyflow 

[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/Naereen/StrapDown.js/blob/master/LICENSE)
[![Swift version](https://img.shields.io/badge/Swift-5.0-orange)](https://developer.apple.com/swift/)
[![App version](https://img.shields.io/badge/version-1.0.0-blue)](https://apple.co/3xVk2Aj)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)](https://www.apple.com/tw/ios/ios-15/)

<p align="center">
  <img width="200" height="200" src="https://imgur.com/HoysHgq.png">
</p>

Foodyflow is an easy-to-use application providing users to manage their refrigerators and shopping lists, create their recipes, share them with others, as well as bookmark their favorite recipes.


<p align= "center">
<a href="https://apps.apple.com/jp/app/%E9%A3%9F%E5%85%89/id1630662293?l=en"><img src="https://user-images.githubusercontent.com/77667003/170689371-cf5b869d-5748-4683-b336-96010464b568.png" width="120" height="40" border="0"></a>
</p>


 
## :strawberry: Features & Screenshots


### Recipes
#### all recipes 
- Browse all recipes by users created.

![allrecipes](https://github.com/bernardpg/Foodyflow/blob/main/Screenshots/RecipePage.png)




#### own recipes 
- Users could manage their own and bookmark recipes. 
- <img src="https://github.com/bernardpg/Foodyflow/blob/main/Screenshots/MyOwnRecipe.gif" width = "200" height = "433"/>

### Refrigerator
- Users can manage their own food by days.

![Refrigerator](https://github.com/bernardpg/Foodyflow/blob/main/Screenshots/RefrigeAdd.png)

### Profile 
- Users could change their avatar and refrigerators names.

![Profile](https://github.com/bernardpg/Foodyflow/blob/main/Screenshots/PersonalPage.gif)


### Shopping List
- The detail page shows the rating, reviews, opening hours, comment area, and navigating route of the coffee shop.

![Shopping List](https://github.com/bernardpg/Foodyflow/blob/main/Screenshots/shoplistAdd.png)






## Techniques

• Implemented **MVC** architecture to separate responsibilities of objects.
• Combined completion handler with **Dispatch Semaphore**
to render the order of fetching data.
• Applied **Auto Layout programmatically, Storyboard** and
**Xib** to configure self-resizing layouts in multiple screen sizes.
• Created custom **expandable TableView** to show both custom and
bookmark recipes.
• Imported **SnapKit** to accelerate Auto Layout in multiple screen sizes.
• Implemented **unit test** for stability.
• Managed authentication via **Apple Sign in / Sign up** on Firebase.

## Libraries
- [SnapKit](https://github.com/SnapKit/SnapKit)
- [SwiftLint](https://github.com/realm/SwiftLint)
- [Kingfisher](https://github.com/onevcat/Kingfisher)
- [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)
- [LZViewPager](https://github.com/ladmini/LZViewPager)
- [PKHUD](https://github.com/pkluz/PKHUD)
- [BTNavigationDropdownMenu](https://github.com/PhamBaTho/BTNavigationDropdownMenu)

## Requirements
- iOS 15.0+
- Xcode 13.0+

## Release Notes

| Version | Date | Notes |
|:-------------:|:-------------:|:-------------:|
| 1.0.2 | 2022.08.04 | Enum TableView (estimated schedule) |
| 1.0.1 | 2022.07.28 | Bug fixed on recipes |
| 1.0.0 | 2022.07.21 | Released on App Store |

## Contact

[YenCheng Huang](mailto:pghuang720@gmail.com)

[![Ask Me Anything !](https://img.shields.io/badge/Ask%20me-anything-1abc9c.svg)](https://GitHub.com/Naereen/ama)


