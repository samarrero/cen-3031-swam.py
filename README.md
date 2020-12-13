# swam.py Group Project for CEN 3031

## Imprint Genius Client Dashboard powered by Flutter and Firebase

## Instructions

1. Set up development
	1. Clone the repository
		1. It contains the database and swampy directories 
	2. Download Android Studio and install Flutter (comes with Dart)
	3. In Android Studio, open up the swampy directory

2. Set up Firebase
	1. Create a Firebase project on https://console.firebase.google.com/ 
	1. Add a web app
	2. Set swampy/web/index.html’s firebaseConfig’s value to the Firebase SDK snippet’s firebaseConfig value
	3. In the sidebar, go under Develop and click on Cloud Firestore and create a database
	4. Populate the database with main.py located in the repo’s database folder. You will need a key.json file to run the script
		1. On Firebase, click on the gear next to Project Overview and then Project Settings. 
		2. Then click on the Service Accounts tab, Firebase Admin SDK, select Python, and Generate new private key. Download and save the file to the repo’s database folder as key.json
	7. Add a user (for admin powers on web app) through Authentication in the sidebar
		1. Use email/password under Sign-in method and create the user through the Users Tab
	8. In Android Studio set Chrome (web) as the device and run!
