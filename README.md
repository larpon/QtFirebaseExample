<img src="https://github.com/Larpon/QtFirebase/blob/master/docs/img/logo.png" align="right"/>

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

2. Follow the instructions in [SETUP.md](https://github.com/Larpon/QtFirebase/blob/master/docs/SETUP.md) on how to setup QtFirebase

# What to expect when things are running

Congratiolations! You fought through the setup - pad yourself on the back!

When you get QtFirebaseExample running on your device for the first time things might [not look as expected](https://github.com/Larpon/QtFirebaseExample/issues/22). Some ads are missing, something fails to load, the universe implodes etc.

First off: If you have the QtFirebaseExample running and showing at least one test ad that means that QtFirebase is working. People report different results on different devices. Not everyone can load and show interstitial and reward ads. If you setup your own correct Firebase project with correct app Id's, AdUnit Id's etc. and do a release build via Google Play - things _should_ work as expected. 

But, they don't always do. 

This is kind of where we leave you off as a developer. Why?. Because your entering Google's domain - and your project's specific setup. AdMod and Firebase are (mostly) closed platforms. Any problems with Ad fill-rates and backend messaging are out of this project's scope. The QtFirebase project only provide Qt wrapper classes - that's it. If you want to know more about how things really work please refer to the official documentation of the respective projects:

Documentation:
https://firebase.google.com/docs/cpp/setup
https://developers.google.com/admob/

Troubleshooting
https://stackoverflow.com/questions/tagged/firebase%20c%2b%2b

Community
https://github.com/firebase/firebase-cpp-sdk
https://groups.google.com/forum/#!forum/google-admob-ads-sdk
