# MarsRoverImages
An iOS application to discover images from NASA's Mars Rovers by day of their space mission (sol).

### Description
MarsRoverImages is a simple and user-friendly iOS application to browse images from Mars Rovers.
It contains of 2 main sections - Settings and Cameras.
- Settings Section allows user to choose a Rover (out of 4 existing), whose images will be presented in the Cameras Section.
- Cameras Section displays selected Rover's images in an elegant and simple way - grouped by Cameras: i.e. NAVCAM_LEFT (Left Navigation Camera). In the header you can see selected Rover name (basic is Curiosity), selected sol (basic is 1000) and change sol day-by-day by clicking the arrows. You can click on Camera to dive into Details screen to enjoy the images from a closer perspective.

MarsRoverImages is built using the MVVM architecture, the application logic is separated into Models, ViewModels and Views. The project is structured according to OOP principles, with comprehensive following of SOLID and enchanced to be scaled and modified in the future.

### Stack
- Language: Swift 5
- Core Framework: UIKit
- Architecture: Model-View-ViewModel (MVVM)
- Nuke: Image loading and caching
- Lottie: Image loader animation
- SkeletonView: Skeleton animation while requesting/fetching API results.
- API: NASA Mars Rover API

### Future Development

Here are some potential features that could be added/modified in the future:

- [ ] Create a class (child of UIViewController) to implement custom skeletonView and methods of its appearance/dismission, use Shimmer library to add shimmer effect. Inherit CamerasVC and DetailsVC from this class.
- [ ] Implement custom animation (blur/fade) between the header and content to replace existing simple separator.
- [ ] Review the sol change logic, i.e. implement UIPickerView to select the day (sol).
- [ ] Implement direct interaction with images in CamerasVC and DetailsVC (i.e. Zoom).
- [ ] Add Favorites Section.

### Contributions

If you'd like to contribute to this project, feel free to submit a pull request or open an issue to discuss your ideas. I am open to any suggestions or improvements that can make this project better.

### Screenshots and Demo Video

<div style="display: flex; justify-content: space-around; flex-wrap: wrap;">
    <img src="https://github.com/user-attachments/assets/1c724e53-98f4-4418-b5e4-706add291320" alt="Settings Section" width="200"/>
    <img src="https://github.com/user-attachments/assets/75759974-adff-439e-9a7b-eb67055c5b3b" alt="Camera Details" width="200"/>
    <img src="https://github.com/user-attachments/assets/9b855dfa-bb1e-43cb-b9c5-183b8b8f601c" alt="Cameras Section" width="200"/>
</div>

https://github.com/user-attachments/assets/20f6c378-6667-44e5-b9ff-6b2f260fd5d3

