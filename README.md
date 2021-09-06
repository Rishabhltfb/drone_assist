# Drone Assist

<br>
  <img src="/assets/img/1.png" width="80%" height="400px">
 <br>
  It is an assistant application for both Android/IOS phones.As the name suggests this app assist drone pilots during various flights as a checklist assitant and guide them through all checkpoints involved in that particualar checklist.Application is voice controlled therefore it read out the checkpoints and ask pilot whether that checkpoint is achieved or completed. If voice command given by pilot is yes, it move forward to next checkpoint otherwise it waits for it to get completed.App also map all the checklist of a user to their account and store their data over cloud so that their data is not lost even after they change their device.App also record the timestamp and gps location of the device after checklist is finished.

## Features

-   Simple signin/signup using google.
-   Assistant read out all the checkpoints one by one for better assistance.
-   Voice response input by pilot to interact during the flight.
-   Cloud database to store data.
-   Timestamp and GPS location tracking for every flight.

### Plugins Used

-   [flutter_tts](https://pub.dev/packages/flutter_tts): Plugin to convert text to speech
-   [speech_to_text](https://pub.dev/packages/speech_to_text): Plugin to convert speech to text
-   [provider](https://pub.dev/packages/provider): Plugin to manage the flow of data inside the app
-   [firebase_auth](https://pub.dev/packages/firebase_auth): Plugin for firebase authentication
-   [cloud_firestore](https://pub.dev/packages/cloud_firestore): Plugin to integrate firebase cloud database
-   [google_sign_in](https://pub.dev/packages/google_sign_in): Plugin to integrate google signin with firebase

### Getting Started

<br>
  <img src="/assets/img/2.png" width="80%" height="400px">
 <br>
-   clone this repository.

```
git clone https://github.com/Rishabhltfb/drone_assist.git
```

-   download flutter from flutter : https://flutter.dev/docs/get-started/install
-   install flutter and dart plugins for your text editor.
-   open project in your preferred text editor and download all dependencies from pubspec.yaml (automatically downloaded during first run or type command flutter pub get)
-   run project using command:

```
flutter run
```

A few resources to get you started if this is your first Flutter project:

-   [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
-   [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
