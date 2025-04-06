# Recipe Coding Exercise

### Summary: Include screen shots or a video of your app highlighting its features
In debug mode there are three tabs at the top to demonstrate loading, error, and empty states along with a button to purge the image cache. These elements are not included in Release mode for production environments.
| Video Demo | Home Image | Empty State | Error State |
|:-------:|:-------:|:-------:|:-------:|
|<video src="https://github.com/user-attachments/assets/16c19e0a-cb3c-422f-9acb-2357af16f2d0"/>|![home](https://github.com/user-attachments/assets/bb9bcef8-e2b8-4902-b3e4-4aae579b15c5)|![empty](https://github.com/user-attachments/assets/70812765-3b13-4b61-9a72-24d1c587835c)|![error](https://github.com/user-attachments/assets/0f944904-fff5-4ada-90d9-7f232c00f39c)|

### Focus Areas:
1. The image downloading and caching mechanism was the most involved portion. I focused on it to show proficiency beyond UI work.
2. Testing is always important when shipping a new product and maintaining a flow of innovation. I've used a couple different testing frameworks in the past but Swift Testing was a new one to me here.

### Time Spent:
I spent 10-15 hours, majority of it was learning parts of SwiftUI, SwiftData, and Swift Testing.

### Trade-offs and Decisions:
I didn't use a view model and instead everything was called from the view.

### Weakest Part of the Project:
The weakest part would be error handling. Most of the errors are ignored or generically surfaced in the UI. Ideally it would have retries or UI showing failure instead of spinners that never stop on poor network connections.

### Additional Information:
I originally learned UIKit and developed with that for a couple years but recently I've been in React Native. This project took me longer to complete as I spent time learning SwiftData and getting more familair with SwiftUI.
