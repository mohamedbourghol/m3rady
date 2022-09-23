import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/models/media/media.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wakelock/wakelock.dart';

class WVideoPlayer extends StatefulWidget {
  /// Set media
  Media? media;

  /// Set player settings
  Map settings = {
    "isAutoPlay": true,
    "isLoop": true,
    "wakeLock": true,
    "isLoading": false,
    "isHasError": false,
    "isControlsIsShown": true,
    "isFullscreen": false.obs,
    "val": 1.0.obs,

  };

  WVideoPlayer();

  WVideoPlayer.media(
    this.media,
  );

  @override
  _WVideoPlayerState createState() => _WVideoPlayerState();
}

class _WVideoPlayerState extends State<WVideoPlayer>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;


  @override
  void initState() {

    /// Observer
    WidgetsBinding.instance?.addObserver(this);

    /// Set media and variables if not set
    if (widget.media == null && Get.arguments['media'] != null) {
      widget.media = Get.arguments['media'];
    }

    /// Maximum videos cache
    if (GlobalVariables.videoPlayerControllers.length >=
        config['videoPlayerMaximumCachedVideos']) {
      GlobalVariables.videoPlayerSettings.clear();
    }

    /// Set settings from globals
    if (GlobalVariables.videoPlayerSettings.containsKey(widget.media?.id)) {
      widget.settings = GlobalVariables.videoPlayerSettings[widget.media!.id];
    } else {
      /// Set global settings
      GlobalVariables.videoPlayerSettings[widget.media!.id] = widget.settings;
    }

    /// Set Fullscreen Orientation
    if (GlobalVariables
            .videoPlayerSettings[widget.media!.id]['isFullscreen'].value ==
        true) {
      SystemChrome.setPreferredOrientations(fullscreenOrientation());
    }

    // To keep the screen on
    if (GlobalVariables.videoPlayerSettings[widget.media!.id]['wakeLock'] ==
        true) {
      Wakelock.enable();
    }
    if(
    _controller == null &&
        GlobalVariables.videoPlayerControllers.containsKey(widget.media?.id)) {
      _controller = GlobalVariables.videoPlayerControllers[widget.media?.id];
      //  play();

    }
    else{
      //play();
      print('111');
    }

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(state) {
    super.didChangeAppLifecycleState(state);

    /// Video
    if (_controller?.value.isInitialized == true) {

      if (state == AppLifecycleState.resumed) {
        ///
      } else if (state == AppLifecycleState.inactive) {
        /// Pause
        if (_controller?.value.isPlaying == true) {
          setState(() {
            GlobalVariables.videoPlayerSettings[widget.media!.id]
                ['isControlsIsShown'] = true;
            _controller?.pause();
          });
        }
      } else if (state == AppLifecycleState.detached) {
        /// Pause
        if (_controller?.value.isPlaying == true) {
          setState(() {
            GlobalVariables.videoPlayerSettings[widget.media!.id]
                ['isControlsIsShown'] = true;
            _controller?.pause();
          });
        }
      } else if (state == AppLifecycleState.paused) {
        /// Pause
        if (_controller?.value.isPlaying == true) {
          setState(() {
            GlobalVariables.videoPlayerSettings[widget.media!.id]
                ['isControlsIsShown'] = true;
            _controller?.pause();
          });
        }
      }
    }
  }

  /// Get Fullscreen Orientation
  List<DeviceOrientation> fullscreenOrientation() {
    return [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ];
    /*
    if (widget.media != null &&
        widget.media?.width != null &&
        widget.media?.height != null &&
        widget.media!.width! > widget.media!.height!) {
      return [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
    }

    return [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ];*/
  }

  /// Pop callback
  Future<bool> _willPopCallback() async {
    return true;
  }


  void play(){



      /// Maximum videos cache
      if (GlobalVariables
          .videoPlayerControllers.length >=
          config[
          'videoPlayerMaximumCachedVideos']) {
        GlobalVariables.videoPlayerControllers
            .clear();
      }

      /// Check if controller exits in the globals
      if (GlobalVariables.videoPlayerControllers
          .containsKey(widget.media?.id)) {
        _controller =
        GlobalVariables.videoPlayerControllers[
        widget.media?.id];
      } else {
        /// Get and set video
        _controller = VideoPlayerController.network(
          widget.media!.mediaUrl,
        );

        /// After initialize
        _controller!
          ..initialize().then((_) {
            setState(() {
              GlobalVariables.videoPlayerSettings[
              widget.media!.id]
              ['isLoading'] = false;

              /// Loop
              _controller!.setLooping(
                  GlobalVariables
                      .videoPlayerSettings[
                  widget.media!
                      .id]['isLoop'] ==
                      true);


            });
          }).onError((error, stackTrace) {
            setState(() {
              GlobalVariables.videoPlayerSettings[
              widget.media!.id]
              ['isLoading'] = false;
              GlobalVariables.videoPlayerSettings[
              widget.media!.id]
              ['isHasError'] = true;
            });
          });

        /// Set controller
        GlobalVariables.videoPlayerControllers[
        widget.media!.id] = _controller!;
      }

  }

  @override
  Widget build(BuildContext context) {



    return WillPopScope(
      onWillPop: _willPopCallback,
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: (_controller != null &&
                  _controller?.value.isInitialized == true &&
                  GlobalVariables.videoPlayerSettings[widget.media!.id]
                          ['isHasError'] ==
                      false)
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    /// Player && buttons && fullscreen
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        /// Player && buttons
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            /// Player
                            GestureDetector(
                              child: VisibilityDetector(
                                key: Key(
                                    "VisibilityDetector.${widget.media?.id}"),
                                onVisibilityChanged:
                                    (VisibilityInfo visibility) {
                                  if (visibility.visibleFraction == 0 &&
                                      this.mounted) {
                                    /// Pause player
                                    if (_controller?.value.isInitialized ==
                                            true &&
                                        _controller?.value.isPlaying == true) {
                                      setState(() {
                                        GlobalVariables.videoPlayerSettings[
                                                widget.media!.id]
                                            ['isControlsIsShown'] = true;
                                        _controller?.pause();
                                      });
                                    }
                                  }
                                },
                                child: VideoPlayer(
                                  _controller!,

                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  if (_controller!.value.isInitialized) {
                                    /// Toggle controls
                                    GlobalVariables.videoPlayerSettings[widget
                                            .media!.id]['isControlsIsShown'] =
                                        !GlobalVariables.videoPlayerSettings[
                                                widget.media!.id]
                                            ['isControlsIsShown'];

                                    /// If not playing
                                    if (_controller!.value.isPlaying == false) {
                                      GlobalVariables.videoPlayerSettings[widget
                                          .media!
                                          .id]['isControlsIsShown'] = true;
                                    }
                                  }
                                });
                              },
                              onDoubleTap: () {
                                /// Toggle play
                                setState(() {
                                  if (_controller!.value.isInitialized) {
                                    /// If not playing
                                    if (_controller!.value.isPlaying == false) {
                                      _controller?.play();
                                      GlobalVariables.videoPlayerSettings[widget
                                          .media!
                                          .id]['isControlsIsShown'] = false;
                                    } else {
                                      _controller?.pause();
                                      GlobalVariables.videoPlayerSettings[widget
                                          .media!
                                          .id]['isControlsIsShown'] = true;
                                    }
                                  }
                                });
                              },
                            ),

                            /// Play button
                            Visibility(
                              visible: GlobalVariables
                                          .videoPlayerSettings[widget.media!.id]
                                      ['isControlsIsShown'] ==
                                  true,
                              child: Container(
                                width: 70,
                                height: 70,
                                child: FloatingActionButton(
                                  heroTag: null,
                                  backgroundColor: Colors.black54,
                                  onPressed: () {
                                    setState(
                                      () {
                                        _controller!.value.isPlaying
                                            ? _controller!.pause()
                                            : _controller!.play();

                                        /// Hide controls if playing
                                        if (_controller!.value.isPlaying) {
                                          GlobalVariables.videoPlayerSettings[
                                                  widget.media!.id]
                                              ['isControlsIsShown'] = false;
                                        }
                                      },
                                    );
                                  },
                                  child: Icon(
                                    _controller!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        /// Fullscreen
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                           if(GlobalVariables
                                               .videoPlayerSettings[widget.media!.id]['val'].value==1.0)
                                             {
                                               GlobalVariables
                                                   .videoPlayerSettings[widget.media!.id]['val'].value=0.0;
                                             }
                                           else{
                                             GlobalVariables
                                                 .videoPlayerSettings[widget.media!.id]['val'].value=1.0;
                                           }
                                  _controller!.setVolume(GlobalVariables
                                      .videoPlayerSettings[widget.media!.id]['val'].value);
                                           setState(() {

                                           });
                                },
                                child: Icon(
                                  GlobalVariables
                                      .videoPlayerSettings[widget.media!.id]['val'].value==1?
                                  Icons.volume_up :
                                      Icons.volume_off,
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  /// Change screen
                                  if (GlobalVariables
                                      .videoPlayerSettings[widget.media!.id]
                                  ['isFullscreen']
                                      .value ==
                                      true) {
                                    /// Set fullscreen
                                    GlobalVariables
                                        .videoPlayerSettings[widget.media!.id]
                                    ['isFullscreen']
                                        .value = false;

                                    /// Back
                                    Get.back();
                                  } else {
                                    /// Set fullscreen
                                    GlobalVariables
                                        .videoPlayerSettings[widget.media!.id]
                                    ['isFullscreen']
                                        .value = true;

                                    /// Go to fullscreen
                                    Get.toNamed(
                                      '/player/video/media',
                                      arguments: {
                                        "media": widget.media,
                                      },
                                    );
                                  }
                                },
                                child: GlobalVariables.videoPlayerSettings[widget
                                    .media!.id]['isControlsIsShown'] ==
                                    false
                                    ? SizedBox()
                                    : Obx(
                                      () => Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Icon(
                                      GlobalVariables
                                          .videoPlayerSettings[widget
                                          .media!
                                          .id]['isFullscreen']
                                          .value ==
                                          true
                                          ? Icons.fullscreen_exit
                                          : Icons.fullscreen,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),

                    /// Scroll bar
                    Visibility(
                      visible:
                          GlobalVariables.videoPlayerSettings[widget.media!.id]
                                  ['isControlsIsShown'] ==
                              true,
                      child: Container(
                        height: 8,
                        child: VideoProgressIndicator(
                          _controller!,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            backgroundColor: Colors.white,
                            playedColor: Colors.orange,
                            bufferedColor: Colors.grey.shade200,
                          ),
                          padding: const EdgeInsets.only(
                            bottom: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      /// Image
                      (widget.media != null &&
                              widget.media?.thumbnailImageUrl != null)
                          ? CachedNetworkImage(
                              imageUrl: widget.media!.thumbnailImageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.black12,
                              ),
                              fadeInDuration: Duration(microseconds: 500),
                            )
                          : SizedBox(),

                      /// Error
                      (GlobalVariables.videoPlayerSettings[widget.media!.id]
                                  ['isHasError'] ==
                              true)
                          ? Icon(
                              Icons.error,
                              size: Get.width / 6,
                              color: Colors.grey.withOpacity(0.5),
                            )
                          : SizedBox(),

                      /// Loading || Play button
                      (GlobalVariables.videoPlayerSettings[widget.media!.id]
                                      ['isLoading'] ==
                                  true ||
                              GlobalVariables
                                          .videoPlayerSettings[widget.media!.id]
                                      ['isHasError'] ==
                                  true)
                          ? Visibility(
                              visible: GlobalVariables
                                          .videoPlayerSettings[widget.media!.id]
                                      ['isLoading'] ==
                                  true,
                              child: CircularProgressIndicator(
                                color: Colors.black45,
                              ),
                            )
                          : Container(
                              width: 70,
                              height: 70,
                              child: FloatingActionButton(
                                heroTag: null,
                                backgroundColor: Colors.black54,
                                onPressed: () {
                                  /// Set loading
                                  setState(() {
                                    GlobalVariables.videoPlayerSettings[
                                        widget.media!.id]['isLoading'] = true;
                                  });

                                  /// Maximum videos cache
                                  if (GlobalVariables
                                          .videoPlayerControllers.length >=
                                      config[
                                          'videoPlayerMaximumCachedVideos']) {
                                    GlobalVariables.videoPlayerControllers
                                        .clear();
                                  }

                                  /// Check if controller exits in the globals
                                  if (GlobalVariables.videoPlayerControllers
                                      .containsKey(widget.media?.id)) {
                                    _controller =
                                        GlobalVariables.videoPlayerControllers[
                                            widget.media?.id];
                                    /// Auto play
                                    if (GlobalVariables
                                        .videoPlayerSettings[
                                    widget.media!.id]
                                    ['isAutoPlay'] ==
                                        true) {
                                      GlobalVariables.videoPlayerSettings[
                                      widget.media!.id]
                                      ['isControlsIsShown'] = false;
                                      _controller!.play();
                                    } else {
                                      GlobalVariables.videoPlayerSettings[
                                      widget.media!.id]
                                      ['isControlsIsShown'] = true;
                                      _controller!.pause();
                                    }
                                  } else {
                                    /// Get and set video
                                    _controller = VideoPlayerController.network(
                                      widget.media!.mediaUrl,
                                    );


                                    /// After initialize
                                    _controller!
                                      ..initialize().then((_) {
                                        setState(() {
                                          GlobalVariables.videoPlayerSettings[
                                                  widget.media!.id]
                                              ['isLoading'] = false;

                                          /// Loop
                                          _controller!.setLooping(
                                              GlobalVariables
                                                          .videoPlayerSettings[
                                                      widget.media!
                                                          .id]['isLoop'] ==
                                                  true);

                                          /// Auto play
                                          if (GlobalVariables
                                                          .videoPlayerSettings[
                                                      widget.media!.id]
                                                  ['isAutoPlay'] ==
                                              true) {
                                            GlobalVariables.videoPlayerSettings[
                                                    widget.media!.id]
                                                ['isControlsIsShown'] = false;
                                            _controller!.play();
                                          } else {
                                            GlobalVariables.videoPlayerSettings[
                                                    widget.media!.id]
                                                ['isControlsIsShown'] = true;
                                            _controller!.pause();
                                          }
                                        });
                                      }).onError((error, stackTrace) {
                                        setState(() {
                                          GlobalVariables.videoPlayerSettings[
                                                  widget.media!.id]
                                              ['isLoading'] = false;
                                          GlobalVariables.videoPlayerSettings[
                                                  widget.media!.id]
                                              ['isHasError'] = true;
                                        });
                                      });

                                    /// Set controller
                                    GlobalVariables.videoPlayerControllers[
                                        widget.media!.id] = _controller!;
                                  }
                                },
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 50,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    /// Observer
    WidgetsBinding.instance?.removeObserver(this);

    /// Set orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // To let the screen turn off again
    if (GlobalVariables.videoPlayerSettings[widget.media!.id]['wakeLock'] ==
        true) {
      Wakelock.disable();
    }

    /// Pause player
    try {
      if (_controller?.value.isInitialized == true &&
          _controller?.value.isPlaying == true) {
        _controller?.pause();
      }
    } catch (e) {}

    /// Dispose video
    /*if (widget.isEnableCache == false) {
      _controller?.dispose();
    }*/

    super.dispose();
  }
}
