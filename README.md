# spiral_notebook

The Spiral Notebook project mobile app, built with Flutter. 

- [How to Install](#setting-up-the-spiral-notebook-flutter-project)
- [Project Reference](#project-reference)

Other repositories associated with this project:
- Web application: https://github.com/ucla-oarc-mobile/spiral-notebook-web-public
- Server: https://github.com/ucla-oarc-mobile/spiral-notebook-server-public

## Project Reference

- Platform: Flutter
- Compatibility 
  + Android
  + iOS
- Integrations
  + Backend - Strapi API
  + Messaging - Firebase Messaging

### Notes on internal architecture

- Internal tools used
  + Caching and Persistence: Hive
  + State Management: Riverpod (v1.0.0)
    * StateProvider for simple cases
    * Manager StateNotifier class pattern + StateNotifierProvider for more complex cases

- Software design objectives
  + Favor UI solutions offered by Flutter core
  - When possible, minimize external dependencies
  - UI layer interfaces with services middleware, not API directly
  - Caching complexity reduced when possible
    + Simple models: stored directly in cache via custom Type Adapter
    + Complex models: abstracted into JSON for storage in cache
  - Streamlined file and image handling
    + No local file caching
      * Files are transient for uploading only
    + After submit, files available online via backend download
  - Clean response editing workflow via transient editing pattern
    - used for both text and file submission
    - tracks which responses have been synced with backend
    - validates responses
    - queries responses
    - bundles responses for submission to service middleware

## Setting up the Spiral Notebook Flutter Project

### 1\. Install Flutter and set up your target platform(s)

Follow the docs at the [Official Flutter Installation guide](https://docs.flutter.dev/get-started/install) to install Flutter for your OS.

### 2\. Set up your build environment and target platform(s)

**This project has only been tested with iOS and Android target platforms.**

Follow the [Official Flutter IDE and environment setup guide](https://docs.flutter.dev/get-started/test-drive) for your build environment / IDE and target platform(s) of choice.

### 3\. Create a default Flutter project

Using your preferred IDE, create a Flutter project with your new project's name. We'll be using this default project as a template for our project (more details at the [Official Flutter IDE and environment setup guide](https://docs.flutter.dev/get-started/test-drive)).
  
For example, if using your shell or Terminal, you would run:

    flutter create project_name

### 4\. Make sure your Flutter environment works for your target platform(s)

Using your preferred IDE, verify that you can run the sample project on your target platform(s) (more details at the [Official Flutter IDE and environment setup guide](https://docs.flutter.dev/get-started/test-drive)).

For example, if using your shell or Terminal, you would change to the Flutter project directory:

    cd project_name

Then verify you have a device available for running:

    flutter devices

Then you would run the app:

    flutter run

### 5\. Replace the sample project files with the files in this repository

Delete the sample project's `lib` folder and replace it with this repository's `lib` folder. Repeat this delete and replace for files from the root of this project directory such as the `pubspec.yaml`.

### 6\. Install and setup the packages for this project

***Update the package versions in `pubspec.yaml` at your own risk.* This project has only been tested with the versions of dependencies that are specified in this repository's `pubspec.yaml.`**

Install the packages used in this project in your preferred IDE. For example, if using your shell or Terminal, you would change to the Flutter project directory, then you would run:

    flutter pub get

For each package, follow the publisher's setup and configuration guides for the target platform(s) you'll be using in this project. For quick reference, here are the `pub.dev` README entries for all packages that are not published by `flutter.dev` or `fluttercommunity.dev`:

- Build dependencies
  + [image_picker | Flutter Package](https://pub.dev/packages/image_picker)
  + [file_picker | Flutter Package](https://pub.dev/packages/file_picker)
  + [flutter_riverpod | Flutter Package](https://pub.dev/packages/flutter_riverpod)
  + [hive | Dart Package](https://pub.dev/packages/hive)
    * [hive_flutter | Flutter Package](https://pub.dev/packages/hive_flutter)
  + [uuid | Dart Package](https://pub.dev/packages/uuid)
  + [firebase_core | Flutter Package](https://pub.dev/packages/firebase_core)
    * Reviewing the [Firebase Core Usage documentation](https://firebase.google.com/docs/flutter/setup) is strongly recommended
    + [firebase_messaging | Flutter Package](https://pub.dev/packages/firebase_messaging)
  + [flutter_notification_channel | Flutter Package](https://pub.dev/packages/flutter_notification_channel)

- Development dependencies
  + [flutter_launcher_icons | Dart Package](https://pub.dev/packages/flutter_launcher_icons)
  + [hive_generator | Dart Package](https://pub.dev/packages/hive_generator)
  + [build_runner | Dart Package](https://pub.dev/packages/build_runner)


### 7\. Set up the project's internal configuration files

**These files are ignored by git. Details on setting them up are provided below.**

This app requires two internal configuration files to run:

- `lib/firebase_options.dart`
  - Your Firebase configuration file generated by the Firebase backend, used for Firebase messaging
  - Reviewing the [Firebase Core Usage documentation](https://firebase.google.com/docs/flutter/setup) is strongly recommended

- `lib/local_config.dart`
  - Contains the internal app's API configuration
  - Use the sample `local_config.dart.sample` as a template for this file

