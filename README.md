# Reverbify README

Group number: 15
Team members: Vu Bui, Misbah Imtiaz, Ayush Patel, Pawan Somavarpu
Name of project: Reverbify
Dependencies: Xcode 10.2, Swift 4
Special Instructions:
• You have to open the file DragonWar.xcworkspace (as opposed to the file
DragonWar.xcodeprog).
• Use an iPhone 8+ Simulator
o Before running the app, run "pod install" inside the DragonWar folder
where the podfile is located
o To login with Facebook, use this test account:
email: DragonWarTest@gmail.com
password: DragonWar
o To test the connection between two players, you need to set two player
mode on, and you need to run it on an iPhone and a simulator at the same
time (or 2 simulators)

| Feature | Description | Release Planned | Release Actual | Deviations if any | who/percentage worked on |
| --- | --- | --- | --- | --- | --- |
| Loading screen | Loading animation while the app while showing the app’s logo | Alpha | Alpha | --- | Misbah (80%) Vu (20%) |
| Login/sign up Page |  User can log in with an existing account or choose to sign up for a new account | Alpha | Alpha | --- | Ayush (100%) |
| Settings Page | Shows information about the user's profile page as well as its settings | Beta | Beta | No autplay feature enabled in setting with a real effect | Aysuh (100%)|
| Home/Main music page | Shows all the user's downloaded songs as well as some functionality such as a button to add a new song, or a 3-dot to edit a song name | Beta | Beta | Not able to change a songs name after creation | Vu (100%) |
| Processing Audio | User can add a song with there requested audio effects to add reverb, bass boosting or altering pitch. The user can also change the defaulted name and publisher of song from youtube link. | Beta | Beta | --- | Misbah (100%) |
| API Interaction | being able to get and play songs from the backend along with handling responses from the backend | Beta | Beta | --- | Misbah (100) |
| Downloads page | User can see all there downloaded songs and search by title and author | Extra | Final | --- | Misbah (100) |
| Playlist Page | User can add songs to a playlist change playlist names, see the songs, and play songs from playlists | Beta | Beta | Cant change title of playlist after creation | Pawan (90%) Ayush (10%) |
| Navigation UI (hot bar at the bottom) | Switch between different pages | Alpha | Alpha | --- | Pawan (100%) |
| Persistent storage | Being able to store songs and user data with different accounts and have that stored after creation | Beta | Beta | --- | Ayush (100) |
| Streaming music | The user can stream music in and outside the app to play songs and have the songs page updated when the user comes back | Beta | Final | Can't play music outside of app, needed to use widgets | Misbah (100%) |
| Specficic song playing functionality | Being able to play and pause songs, have the ui update properly, skipping in between songs, repeating and shuffling songs | Beta | Beta | Some of the skipping features are buggy but other than that it works | Misbah (100%) |
| Guidence | what the user sees when they log in to help them understand what to do | Extra | Extra | --- | Ayush (100%) |
| Notifications | Notifying the user to come in the app daily | Beta | Final | --- | Aysuh (100%) |
| Change passwords | being able to change a users password | Beta | Final | --- | Ayush (100%) |
| Logout | logout of your account | Beta | Beta | --- | Ayush (100%) |







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
