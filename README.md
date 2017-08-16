<img src="https://github.com/Larpon/QtFirebase/blob/master/logo.png" align="right"/>

# QtFirebaseExample
Example Qt app for the QtFirebase project

# Quick start


1. Clone the example app and the [QtFirebase](https://github.com/Larpon/QtFirebase) project

  * **Clone example project**
  
    ```
    cd /path/to/projects
    git clone git@github.com:Larpon/QtFirebaseExample.git
    ```
  * **Clone the QtFirebase project**
  
    Clone into the "extensions" folder or into other folder of your choice
    ```
    cd /path/to/projects/QtFirebaseExample/extensions
    git clone git@github.com:Larpon/QtFirebase.git
    ```

2. Download and unzip the latest 4.x Firebase C++ SDK from Google.

  ```
  cd /path/to/download
  wget https://dl.google.com/firebase/sdk/cpp/firebase_cpp_sdk_4.0.1.zip
  unzip firebase_cpp_sdk_4.0.1.zip -d /path/to/sdk
  ```

3. Add symlink OR set `QTFIREBASE_SDK_PATH` variable

  If you have multiple projects using QtFirebase it's a space-saver to have the Firebase C++ SDK (~832 MB) in one place.

  So you can either symlink the Firebase C++ SDK to the default search path OR set the `QTFIREBASE_SDK_PATH` variable to the absolute path of the SDK in the `.pro` file for the app build.

  * **Symlink**
  
    ```
    ln -s /path/to/sdk/firebase_cpp_sdk /path/to/projects/QtFirebaseExample/extensions/QtFirebase/firebase_cpp_sdk
    ```

  * **`QTFIREBASE_SDK_PATH` variable**
  
    Open the example project with QtCreator `/path/to/projects/QtFirebaseExample/QtFirebaseExample.pro`
    Navigate to the `App.pro` (sub)project file in the Project pane
    ```
    QtFirebaseExample
    |_...
    |_App
        |_App.pro
    ```
    Locate the lines:
    ```
    # NOTE QTFIREBASE_SDK_PATH can be symlinked to match $$PWD/firebase_cpp_sdk
    QTFIREBASE_CONFIG += analytics admob
    # include QtFirebase
    include(../extensions/QtFirebase/qtfirebase.pri)
    ```
    Change it to match your path(s)
    ```
    QTFIREBASE_SDK_PATH = /path/to/sdk/firebase_cpp_sdk
    QTFIREBASE_CONFIG += analytics admob
    # include QtFirebase
    include(../extensions/QtFirebase/qtfirebase.pri) # <- /path/to/QtFirebase/qtfirebase.pri
    ```
    
4. Almost done
  
  **Android notes**
  
  The project needs gradle and the Android NDK (r10d +) to build on Android.
  
  * Enable gradle in your Project build options in QtCreator.
  * Edit path in `/path/to/projects/QtFirebaseExample/extensions/QtFirebase/src/android/gradle.properties`
  * Edit path in `/path/to/projects/QtFirebaseExample/extensions/QtFirebase/src/android/local.properties`
    
  **iOS Notes**
  
  The project uses CocoaPods to build on iOS.
  
  * [Install CocoaPods](http://stackoverflow.com/questions/20755044/how-to-install-cocoa-pods) on your Mac host if you haven't already.
  * Run `pod install`:
   ```
   # cd /path/to/QtFirebase/src/ios/CocoaPods
   # From our example:
   cd /path/to/projects/QtFirebaseExample/extensions/QtFirebase/src/ios/CocoaPods
   pod install
   ```
  * Run `make_ios_joined_statics.sh` from the QtFirebase project root:
   ```
   cd /path/to/QtFirebase/
   ./make_ios_joined_statics.sh
   ```
  * Verify that a set of `lib<name>.a` exists in `/path/to/sdk/firebase_cpp_sdk/libs/ios`
   ```
   cd /path/to/sdk/firebase_cpp_sdk/libs/ios/
   ls | grep lib
   
   libadmob.a
   libanalytics.a
   libapp.a
   libremote_config.a
   ```
   This step is important as the `make_ios_joined_statics.sh` uses `libtool` to join each of the static libs used from each supported architecture into one combined static lib to link against. We have yet to find out why this is necessary for the project to run properly.
   
5. Push the *Run* button

  If you build for Android or iOS you should see output like the following in the "General Messages" tab of QtCreator
  ```
  Project MESSAGE: QtFirebase: configuring build for supported Firebase target platform...
  Project MESSAGE: No QTFIREBASE_SDK_PATH path sat. Using default (firebase_cpp_sdk) /path/to/projects/QtFirebaseExample/extensions/QtFirebase/firebase_cpp_sdk
  Project MESSAGE: QtFirebase Android base
  Project MESSAGE: QtFirebase including Analytics
  Project MESSAGE: QtFirebase including AdMob
  Project MESSAGE: This project is using private headers and will therefore be tied to this specific Qt module build version.
  Project MESSAGE: Running this project against other versions of the Qt modules may crash at any arbitrary point.
  Project MESSAGE: This is not a bug, but a result of using Qt internals. You have been warned!
  ```

  If you are building for Desktop target the output should be something like this:
  ```
  Project MESSAGE: QtFirebase: configuring build for non-supported Firebase target platform...
  ```
