# BrowseIn - Offline-First Social Media Feed

## Overview
BrowseIn is a simplified social media app prototype that supports offline-first functionality using Hive for local storage and Firebase Firestore for real-time synchronization. Users can create posts, like posts, and view a feed that syncs automatically when an internet connection is available. Cloudinary is used for image storage due to Firebase Storage's subscription model.

## Features
- Offline-first feed with Hive for local storage.
- Firebase Firestore for real-time post and like synchronization.
- Cloudinary for image uploads.
- Conflict resolution when offline changes clash with Firebase updates.
- Seamless UI experience when switching between online and offline modes.

## Tech Stack
- **Flutter** (UI & State Management)
- **Hive** (Offline data persistence)
- **Firebase Firestore** (Real-time database)
- **Cloudinary** (Image storage)
- **Firebase Authentication** (User management)
- **GetIt & Injectable** (Dependency injection)
- **Bloc** (State management)

## 📽️ App Demo
Below is a recorded demonstration of the app in action:

[🎥 Watch the Video](https://drive.google.com/file/d/1XhIplG4wBTZvuuujNqo6Ys7aivyV2QMA/view?usp=sharing)


## App Architecture
The app follows an opinionated clean architecture.

### Core
* Contains any core functionality needed throughout the app
* Such as network, database interaction, some re-usable widgets

### Features
Contains all the app features

### Data
* Holds the data classes, or entities which are used to communicate with APIs.

### Domain
* Has information about DAO (Data Access Object)

### Presentation
* The presentation layer consists of 3 parts: Screens, widgets and bloc, since we use bloc and cubit in this app.
* blocs are responsible for interacting with the firebase and getting the data, giving that data to the screens
* widgets are reusable components


## Tree Diagram
```code
lib
└───src
    ├───core
    │   ├───network (base utils for network calls)
    │   ├───persistence (hiveDB related)
    │   ├───presentation (app-wide presentation stuff)
    │   │   ├───animations 
    │   │   └───widgets (reusable widgets)
    └───features
        └───feature
            ├───data (data classes)
            │   └───models
            ├───domain (DAO and network repos)
            │   ├───persistence
            └───presentation
                ├───bloc (all bloc + cubit logics)
                ├───screens (the actual UI)
                └───widgets (reusable widgets)
```


## Firebase Setup
1. Install Firebase CLI:
   ```sh
   npm install -g firebase-tools
   ```
2. Login to Firebase:
   ```sh
   firebase login
   ```
3. Initialize Firebase:
   ```sh
   firebase init
   ```
4. Enable Firestore, Authentication.

## Installation
After cloning this repository, migrate to ```browsein-social-media``` folder. Then, follow below steps:
- Create Firebase Project and setup through Firebase CLI
- Make Firestore Rules
  Then execute below commands to run your app:
```bash
  flutter pub get
  open -a simulator (to run iOS Simulator)
  flutter run
```

## Offline-First Implementation
- Posts are first saved in **Hive**.
- If the user is offline, the post remains in local storage.
- Once online, pending posts sync with Firebase Firestore.
- Likes are also stored locally and updated in Firebase when back online.

## License
This project is open-source under the MIT License.

## Feedback
If you have any feedback, please reach out to me at ragulsarma@gmail.com