// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:m3rady/core/models/media/media.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart';
//
// class WVideoPlayerAdvanced extends StatefulWidget {
//   WVideoPlayerAdvanced.media(this.media);
//
//   /// Set media
//   final Media media;
//
//   @override
//   _WVideoPlayerAdvancedState createState() => _WVideoPlayerAdvancedState();
// }
//
// class _WVideoPlayerAdvancedState extends State<WVideoPlayerAdvanced> {
//   late FlickManager flickManager;
//   late String url;
//
//   @override
//   void initState() {
//     url = widget.media.mediaUrl;
//
//     /// Set video
//     flickManager = FlickManager(
//       videoPlayerController: VideoPlayerController.network(
//         widget.media.mediaUrl,
//         videoPlayerOptions: VideoPlayerOptions(
//           mixWithOthers: false,
//         ),
//       ),
//       autoInitialize: true,
//       autoPlay: false,
//     );
//
//     super.initState();
//   }
//
//   /// Set video url
//   setVideoUrl(String url) {
//     if (this.url != url) {
//       this.url = url;
//       flickManager.handleChangeVideo(
//         VideoPlayerController.network(url),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     /// Set height and width
//     if (widget.media.width == null || widget.media.height == null) {
//       widget.media.width = 1024;
//       widget.media.height = 768;
//     }
//
//     /// Set Device Orientation
//     List<DeviceOrientation> preferredDeviceOrientationFullscreen = [];
//     if (widget.media.width! > widget.media.height!) {
//       preferredDeviceOrientationFullscreen = [
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ];
//     } else {
//       preferredDeviceOrientationFullscreen = [
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ];
//     }
//
//     /// Set video url
//     setVideoUrl(widget.media.mediaUrl);
//
//     return VisibilityDetector(
//       key: ObjectKey(flickManager),
//       onVisibilityChanged: (visibility) {
//         if (visibility.visibleFraction == 0 && this.mounted) {
//           flickManager.flickControlManager?.autoPause();
//         }
//       },
//       child: Container(
//         child: FlickVideoPlayer(
//           flickManager: flickManager,
//           flickVideoWithControls: FlickVideoWithControls(
//             videoFit: BoxFit.contain,
//             controls: FlickPortraitControls(),
//           ),
//           flickVideoWithControlsFullscreen: FlickVideoWithControls(
//             videoFit: BoxFit.contain,
//             controls: FlickLandscapeControls(),
//           ),
//           preferredDeviceOrientation: [
//             DeviceOrientation.portraitUp,
//             DeviceOrientation.portraitDown,
//           ],
//           preferredDeviceOrientationFullscreen:
//               preferredDeviceOrientationFullscreen,
//           wakelockEnabled: true,
//           wakelockEnabledFullscreen: true,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     /// Video
//     if (flickManager.flickControlManager?.isFullscreen == true) {
//       flickManager.flickControlManager?.exitFullscreen();
//     }
//     flickManager.flickControlManager?.autoPause();
//     //flickManager.dispose();
//
//     super.dispose();
//   }
// }
