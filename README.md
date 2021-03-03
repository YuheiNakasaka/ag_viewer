# AGViewer

It's simply alternative to the official A&G+ iOS App. This is built by Flutter + Firebase. It has been only tested on iOS because unofficial A&G app for Android is already existed on Google Play Store.

You can:

- watch live streaming with few loading time.
- listen live streaming with background mode.
- view tweets with #agqr hashtag.
- view the latest program list.
- receive notifications when the broadcast time of programs you have set as favorites approaches.

![0](https://user-images.githubusercontent.com/1421093/109797796-45378000-7c5d-11eb-8fe5-6b52e72f5e4a.jpg)
![1](https://user-images.githubusercontent.com/1421093/109797799-47014380-7c5d-11eb-9cd5-46614a4c513b.jpg)
![2](https://user-images.githubusercontent.com/1421093/109797803-48327080-7c5d-11eb-926f-d537706ae8ef.jpg)

# Setup
## Firebase Settings
It's required to place a `GoogleService-Info.plist` to `ios/Runner/`.

Read [setup page](https://firebase.google.com/docs/ios/setup) to ready for `GoogleService-Info.plist`.

And deploy firebase services.

```
$ cd functions/
$ firebase deploy --project default
```
