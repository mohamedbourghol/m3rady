/*
import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m3rady/core/models/media/media.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:wakelock/wakelock.dart';

class WVideoPlayerAdvanced extends StatefulWidget {
  WVideoPlayerAdvanced.media(this.media);

  /// Set media
  final Media media;

  @override
  _WVideoPlayerAdvancedState createState() => _WVideoPlayerAdvancedState();
}

class _WVideoPlayerAdvancedState extends State<WVideoPlayerAdvanced>
    with WidgetsBindingObserver {
  late BetterPlayerController betterPlayerController;
  late BetterPlayerDataSource betterPlayerDataSource;
  bool isRetrying = false;
  int maxRetry = 3;
  int currentRetry = 0;

  @override
  void initState() {
    super.initState();

    /// Observer
    WidgetsBinding.instance?.addObserver(this);

    // To keep the screen on
    Wakelock.enable();

    /// Set BetterPlayer Data Source
    setBetterPlayerDataSource();

    /// Set controller
    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: false,
        allowedScreenSleep: false,
        autoDispose: false,
        fullScreenByDefault: false,
        autoDetectFullscreenDeviceOrientation: false,
        aspectRatio: 1,
        fullScreenAspectRatio:
            (widget.media.width! > widget.media.height! ? null : 0.5),
        showPlaceholderUntilPlay: true,
        placeholder: widget.media.thumbnailImageUrl == null
            ? null
            : CachedNetworkImage(
                imageUrl: widget.media.thumbnailImageUrl!,
                fit: BoxFit.cover,
              ),
        deviceOrientationsOnFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableRetry: true,
          enableOverflowMenu: false,
          enableMute: false,
        ),
        errorBuilder: (context, error) {
          /// Retry
          if (currentRetry < maxRetry) {
            retryPlayer();
          }

          /// Error
          return Center(
            child: InkWell(
              onTap: () async {
                print('try');
                await retryPlayer();
              },
              child: Icon(
                Icons.error,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          );
        },
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );
  }

  /// Retry player
  Future retryPlayer() async {
    if ((betterPlayerController.isVideoInitialized() == true) &&
        isRetrying == false) {
      isRetrying = true;
      await betterPlayerController.clearCache();
      setBetterPlayerDataSource(
        useCache: false,
      );
      await betterPlayerController.retryDataSource();
      await betterPlayerController.pause();
      currentRetry++;
      isRetrying = false;
    }
  }

  /// Set BetterPlayer Data Source
  void setBetterPlayerDataSource({
    bool useCache = false,
  }) {
    /// Set data source
    betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.media.mediaUrl,
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: useCache,
        key: "${config["videoCacheKey"]}.${widget.media.id}",
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 10 * 1024 * 1024,
        maxCacheFileSize: 10 * 1024 * 1024,
      ),
      bufferingConfiguration: BetterPlayerBufferingConfiguration(
        minBufferMs: 50,
        maxBufferMs: 13107200,
        bufferForPlaybackMs: 50,
        bufferForPlaybackAfterRebufferMs: 50,
      ),
    );
  }

  /// Re setup data source with the new url
  void reSetBetterPlayerDataSource() {
    /// If url changed
    if (betterPlayerController.betterPlayerDataSource?.url !=
        widget.media.mediaUrl) {
      setBetterPlayerDataSource(
        useCache: false,
      );

      betterPlayerController.setupDataSource(betterPlayerDataSource);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Set BetterPlayer Data Source (if url changed)
    reSetBetterPlayerDataSource();

    return BetterPlayer(
      key: Key("${config["videoPlayerKey"]}.${widget.media.id}"),
      controller: betterPlayerController,
    );
  }

  @override
  void didChangeAppLifecycleState(state) {
    super.didChangeAppLifecycleState(state);

    /// Video
    if (betterPlayerController.isVideoInitialized() == true) {
      if (state == AppLifecycleState.resumed) {
        ///
      } else if (state == AppLifecycleState.inactive) {
        /// Pause
        if (betterPlayerController.isPlaying() == true) {
          betterPlayerController.pause();
        }
      } else if (state == AppLifecycleState.detached) {
        /// Pause
        if (betterPlayerController.isPlaying() == true) {
          betterPlayerController.pause();
        }
      } else if (state == AppLifecycleState.paused) {
        /// Pause
        if (betterPlayerController.isPlaying() == true) {
          betterPlayerController.pause();
        }
      }
    }
  }

  @override
  void dispose() {
    /// Observer
    WidgetsBinding.instance?.removeObserver(this);

    /// Video
    if (betterPlayerController.isVideoInitialized() == true) {
      if (betterPlayerController.isPlaying() == true) {
        betterPlayerController.pause();
      }
    }

    // To let the screen turn off again
    Wakelock.disable();

    betterPlayerController.dispose();

    super.dispose();
  }
}
*/
