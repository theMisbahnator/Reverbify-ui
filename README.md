# Reverbify README

## Contributions

Pawan Somavarpu (25%). 
- Created and set up Tab Bar Controller and made the working Navbar.
- Setup structure for the project on Storyboard (sample pages for the different screens navigated to from the Navbar).
- Created README

Misbah Imtiaz (25%).
- Created the splash page and splash page logo animation.
- Created API for audio processing and implemented downloading of songs. Functionality include modifiying pitch, adding bass, and applying a possibility of 11 reverb filters. Returns a singed url of the mp3 file stored on AWS S3 bucket and hosted with Docker and Google cloud platform. 
  - This is publicly available and documented at https://github.com/theMisbahnator/Reverbify
- Created the UI for the add songs page, this was functional and even made a post request to the api to download the finished product, merge conflicts 
  with storyboard prevented it from being done in time. 

Ayush Patel (25%).
- Created the login and sign up pages.
- Set up segues beetween login and sign up pages.
- Setup firebase to allow user authentication.
- Resolved merge conflicts

Vu Bui (25%).
- Created home page and set up the associated view controllers.
- Set up Table View Controllers to display different scrollable elements on the home page.
- Resolved merge conflicts

## Deviations

- We did not implement all the sections of the home page as we were not able to make it dynamic to be able to find "recently" played songs.
- Merge conflicts prevented us from merging the main add songs functionality in time
- We did not make the homepage dynamic in the sense that it displays data retreived from the API just yet.
- We were not able to fully finish all songs page
- Constraints were not added to any of the pages, Sign up page is clear victim of this
