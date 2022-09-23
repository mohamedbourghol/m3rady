import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/models/media/media.dart';
import 'package:m3rady/core/view/widgets/video/theme.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class WVideoPlayer1 extends StatefulWidget {
  /// Set media
  Media? media;
  File? file;
  bool? isAutoPlay;

  /// Set is loading
  bool isLoading = true;

  /// Set is has error
  bool isHasError = false;

  WVideoPlayer1({
    this.media,
    this.file,
    this.isAutoPlay = false,
  });

  WVideoPlayer1.file(
      File this.file, {
        this.isAutoPlay = false,
      });

  WVideoPlayer1.media(
      Media this.media, {
        this.isAutoPlay = false,
      });

  @override
  _WVideoPlayerState createState() => _WVideoPlayerState();
}

class _WVideoPlayerState extends State<WVideoPlayer1> {
  late VideoPlayerController _controller;
  late ImageProvider thumbnailImage;

  /// Set is play or pause is shown
  bool isPlayPauseIsShown = true;

  @override
  void initState() {
    super.initState();

    if (widget.media != null) {
      /// Get and set thumbnail
      if (widget.media!.thumbnailImageUrl != null) {
        thumbnailImage =
            NetworkImage(widget.media!.thumbnailImageUrl.toString());
      }
    }

    /// Get and set video
    _controller = (widget.media != null
        ? VideoPlayerController.network(widget.media!.mediaUrl)
        : VideoPlayerController.file(widget.file!));

    /// Add listener
    _controller.addListener(() {
      setState(() {});
    });

    /// After initialize
    _controller
      ..initialize().then((_) {
        setState(() {
          widget.isLoading = false;

          /// Loop
          _controller.setLooping(true);

          /// Auto play
          if (widget.isAutoPlay == true) {
            isPlayPauseIsShown = false;
            _controller.play();
          }
        });
      }).onError((error, stackTrace) {
        setState(() {
          widget.isLoading = false;
          widget.isHasError = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return (!widget.isHasError
        ? Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: _controller.value.isInitialized
                  ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  image: widget.media?.thumbnailImageUrl != null
                      ? DecorationImage(
                    image: thumbnailImage,
                    fit: BoxFit.cover,
                    colorFilter:
                    ColorFilter.srgbToLinearGamma(),
                  )
                      : null,
                ),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: GestureDetector(
                    child: VideoPlayer(
                      _controller,
                    ),
                    onTap: () {
                      setState(() {
                        if (_controller.value.isInitialized) {
                          isPlayPauseIsShown = !isPlayPauseIsShown;
                        }
                      });
                    },
                  ),
                ),
              )
                  : LoadingBouncingLine.circle(),
            ),
            Visibility(
              visible: (_controller.value.isInitialized &&
                  isPlayPauseIsShown == true),
              child: Container(
                width: Get.width / 7,
                height: Get.width / 7,
                child: FloatingActionButton(
                  backgroundColor: Colors.black54,
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();

                      if (_controller.value.isPlaying) {
                        isPlayPauseIsShown = !isPlayPauseIsShown;
                      }
                    });
                  },
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: Get.width / 10,
                  ),
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: _controller.value.isInitialized,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                backgroundColor: Colors.white,
                playedColor: Colors.orange,
                bufferedColor: Colors.grey.shade200,
              ),
              padding: const EdgeInsets.only(bottom: 0.2),
            ),
          ),
        ),
      ],
    )
        : Center(
      child: Icon(
        Icons.error,
        size: 50,
        color: Colors.grey.withOpacity(0.5),
      ),
    ));
  }
  @override
  void dispose() {
    /// Dispose video
    _controller.dispose();

    super.dispose();
  }
}
