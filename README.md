# Reverbify README

## Contributions

Pawan Somavarpu (Release 20%, Overall 22%). 
- Created and set up Tab Bar Controller and made the working Navbar.
- Setup structure for the project on Storyboard (sample pages for the different screens navigated to from the Navbar).
- Created README
- Created AllPlaylistViewController, made each song clickable 
  - Handled constraints
- Created playlist class in order to store multiple playlists per user
- Created skeleton class for PlaylistViewController

Misbah Imtiaz (Release 40%, Overall 34%).
- Created the splash page and splash page logo animation.
- Created API for audio processing and implemented downloading of songs. Functionality include modifiying pitch, adding bass, and applying a possibility of 11 reverb filters. Returns a singed url of the mp3 file stored on AWS S3 bucket and hosted with Docker and Google cloud platform. 
  - This is publicly available and documented at https://github.com/theMisbahnator/Reverbify

- Created the UI for the add songs page, this was functional and even made a post request to the api to download the finished product, merge conflicts 
  with storyboard prevented it from being done in time. 
- Finished Add Song page to pull songs from Youtube using custom API and able to modify pitch, reverb and base boost
  - Handled constraints for this page

- Set up playing song controller, allowing songs to be played using AV framework
  - Added functionality to pause, play, and skip to different parts of songs using slider
  - Handled constraints for this page

Ayush Patel (Release 20%, Overall 22%).
- Created the login and sign up pages.
- Set up segues beetween login and sign up pages.

- Setup Firebase to allow user authentication.
- Setup Firebase Realtime Database to upload and pull songs for Home Page and All songs page

- Finished Settings page
- Finished Change password page
  - Uses Firebase to change password while authenticating the user (ensures current password entered is correct)
- Resolved merge conflicts

Vu Bui (Release 20%, Overall 22%).
- Created home page and set up the associated view controllers.
- Set up Table View Controllers to display different scrollable elements on the home page.
- Heavily revamped home page to create scrollable elements for different categories (recently played playlists/songs, recently downloaded songs)
  - Handled constraints
- Resolved merge conflicts

## Deviations
- We worked ahead and implemented most functionality for a song, from downloading the song all the way to playing the song
- We are not pulling playlist data from firebase yet, so playlist data on home page is static data
- We did not implement notifications yet, mainly because not sure if we still want them
- There are some very minor bugs with playing a song, but that feature was intended for final release anyhow


- We did not implement all the sections of the home page as we were not able to make it dynamic to be able to find "recently" played songs.
- Merge conflicts prevented us from merging the main add songs functionality in time
- We did not make the homepage dynamic in the sense that it displays data retreived from the API just yet.
- We were not able to fully finish all songs page
- Constraints were not added to any of the pages, Sign up page is clear victim of this
