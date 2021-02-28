import 'package:ag_viewer/blocs/webview_bloc.dart';
import 'package:ag_viewer/constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 拡張版video_playerを使ってhlsを再生する実装
/// tweetのviewと共存できる・PinPができない・background再生ができる
class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VideoPlayerController _controller;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://fms2.uniqueradio.jp/agqr10/aandg1.m3u8',
        videoPlayerOptions: VideoPlayerOptions(observeAppLifecycle: false))
      ..initialize().then((_) {
        setState(() => initialized = true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bkColor,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final playerWidth = constraints.constrainWidth();
          final playerHeight =
              playerWidth * (1 / _controller.value.aspectRatio);
          final twBoxHeight = constraints.constrainHeight() - playerHeight;
          return Column(
            children: [
              Stack(
                children: [
                  _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : const SizedBox(height: 0),
                  Align(
                    alignment: Alignment.center,
                    child: initialized
                        ? playerTapLayer(playerWidth, playerHeight)
                        : const SizedBox(),
                  ),
                ],
              ),
              initialized
                  ? SizedBox(
                      height: twBoxHeight,
                      child: const TweetBox(),
                    )
                  : const SizedBox(),
            ],
          );
        }),
      ),
    );
  }

  Widget playerTapLayer(double w, double h) {
    return _controller.value.isPlaying
        ? GestureDetector(
            child: Container(
              width: w,
              height: h,
              color: const Color(0x00000000),
              child: const SizedBox(),
            ),
            onTap: () async {
              if (_controller.value.isPlaying) {
                await _controller.pause();
                setState(() {});
              }
            },
          )
        : GestureDetector(
            child: Container(
              width: w,
              height: h,
              color: const Color(0x66000000),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 56,
              ),
            ),
            onTap: () async {
              if (!_controller.value.isPlaying) {
                await _controller.initialize().then((value) async {
                  await _controller.play();
                  setState(() {});
                });
              }
            },
          );
  }
}

class TweetBox extends StatelessWidget {
  const TweetBox();

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrl:
          'https://www.uniqueradio.jp/_common/twitter/twitter-inc2.html',
      onWebViewCreated: (InAppWebViewController controller) {
        context.read(webviewProvider).state = controller;
      },
    );
  }
}

/// webviewを使ってhlsを再生する実装
/// tweetのviewと共存できる・PinPができる・background再生ができない
// import 'package:ag_viewer/constants.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage();

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Constants.bkColor,
//       body: SafeArea(
//         child: LayoutBuilder(builder: (context, constraints) {
//           final playerWidth = constraints.constrainWidth();
//           final playerHeight = playerWidth * (9 / 16);
//           final twBoxHeight = constraints.constrainHeight() - playerHeight;
//           return Column(
//             children: [
//               SizedBox(
//                 width: playerWidth,
//                 height: playerHeight,
//                 child: const PlayerBox(),
//               ),
//               SizedBox(
//                 height: twBoxHeight,
//                 child: const TweetBox(),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }

// class PlayerBox extends StatelessWidget {
//   const PlayerBox();

//   @override
//   Widget build(BuildContext context) {
//     return InAppWebView(
//       initialFile: 'assets/hls.html',
//       initialOptions: InAppWebViewGroupOptions(
//         ios: IOSInAppWebViewOptions(
//           allowsInlineMediaPlayback: true,
//           allowsBackForwardNavigationGestures: false,
//         ),
//         android: AndroidInAppWebViewOptions(),
//       ),
//     );
//   }
// }

// class TweetBox extends StatelessWidget {
//   const TweetBox();

//   @override
//   Widget build(BuildContext context) {
//     return const InAppWebView(
//       initialUrl:
//           'https://www.uniqueradio.jp/_common/twitter/twitter-inc2.html',
//     );
//   }
// }
