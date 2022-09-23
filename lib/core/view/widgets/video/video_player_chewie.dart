// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:loading_animations/loading_animations.dart';
// import 'package:m3rady/core/models/media/media.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart';
/*
class WVideoPlayerAdvanced extends StatefulWidget {
  WVideoPlayerAdvanced.media(this.media);

  /// Set media
  final Media media;

  @override
  _WVideoPlayerAdvancedState createState() => _WVideoPlayerAdvancedState();
}

class _WVideoPlayerAdvancedState extends State<WVideoPlayerAdvanced>
    with WidgetsBindingObserver {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  /*int? id;
  String? mediaUrl;
  String? thumbnailImageUrl;
  int? width;
  int? height;*/
  bool _isWasPlaying = false;

  @override
  void initState() {
    super.initState();

    /// Observer
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    /*id = id != null ? id : widget.media.id;
    mediaUrl = mediaUrl != null ? mediaUrl : widget.media.mediaUrl;
    thumbnailImageUrl = thumbnailImageUrl != null
        ? thumbnailImageUrl
        : widget.media.thumbnailImageUrl;
    width = width != null ? width : (widget.media.width ?? 1024);
    height = height != null ? height : (widget.media.height ?? 768);*/

    /// Set video
    videoPlayerController = VideoPlayerController.network(
      widget.media.mediaUrl,
    );

    /// Set controller
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      autoPlay: false,
      looping: false,
      allowMuting: false,
      showControls: true,
      showControlsOnInitialize: false,
      allowedScreenSleep: false,
      placeholder: Center(
        child: LoadingBouncingLine.circle(),
      ),
      errorBuilder: (context, error) => Center(
        child: Icon(
          Icons.error,
          size: 50,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    return VisibilityDetector(
      key: Key('video-${widget.media.id}'),
      onVisibilityChanged: (visibilityInfo) {
        /// Pause
        if (videoPlayerController.value.isInitialized == true &&
            videoPlayerController.value.isPlaying == true) {
          videoPlayerController.pause();
        }
      },
      child: Chewie(
        key: Key('video-${widget.media.id}'),
        controller: chewieController,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(state) {
    super.didChangeAppLifecycleState(state);

    /// Video
    if (videoPlayerController.value.isInitialized == true) {
      if (state == AppLifecycleState.resumed) {
        /// Play
        if (_isWasPlaying == true) {
          _isWasPlaying = false;
          videoPlayerController.play();
        }
      } else if (state == AppLifecycleState.inactive) {
        /// Pause
        if (videoPlayerController.value.isPlaying == true) {
          _isWasPlaying = true;
          videoPlayerController.pause();
        }
      } else if (state == AppLifecycleState.detached) {
        /// Pause
        if (videoPlayerController.value.isPlaying == true) {
          _isWasPlaying = true;
          videoPlayerController.pause();
        }
      } else if (state == AppLifecycleState.paused) {
        /// Pause
        if (videoPlayerController.value.isPlaying == true) {
          _isWasPlaying = true;
          videoPlayerController.pause();
        }
      }
    }
  }

  @override
  void dispose() {
    /// Observer
    WidgetsBinding.instance?.removeObserver(this);

    /// Pause
    if (videoPlayerController.value.isInitialized == true &&
        videoPlayerController.value.isPlaying == true) {
      videoPlayerController.pause();
    }

    /// Video
    videoPlayerController.dispose();
    chewieController.dispose();

    super.dispose();
  }
}
*/