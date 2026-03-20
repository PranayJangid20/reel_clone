import 'dart:io';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
import 'package:reel_clone/core/services/video_cache_manager.dart';
import 'package:reel_clone/features/reels/domain/entities/video_entity.dart';
import 'package:reel_clone/features/reels/presentation/widgets/reel_ui_overlay.dart';
import 'package:reel_clone/features/reels/presentation/widgets/reel_dummy_captions.dart';

class ReelVideoItem extends StatefulWidget {
  final VideoEntity video;
  final bool isFocused;

  const ReelVideoItem({
    super.key,
    required this.video,
    required this.isFocused,
  });

  @override
  State<ReelVideoItem> createState() => _ReelVideoItemState();
}

class _ReelVideoItemState extends State<ReelVideoItem> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _handleInitialization();
  }

  @override
  void didUpdateWidget(covariant ReelVideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Auto-play/pause logic based on visibility (isFocused)
    if (_isInitialized && _controller != null) {
      if (widget.isFocused && !oldWidget.isFocused) {
        _controller!.play();
      } else if (!widget.isFocused && oldWidget.isFocused) {
        _controller!.pause();
        _controller!.seekTo(Duration.zero); // Optional: reset when out of view
      }
    }
  }

  Future<void> _handleInitialization() async {
    try {
      // 1. Check if the video is available in cache
      final fileInfo = await VideoCacheManager.instance.getFileFromCache(
        widget.video.videoUrl,
      );

      File videoFile;
      if (fileInfo != null) {
        videoFile = fileInfo.file;
        debugPrint('Playing from cache: ${widget.video.videoUrl}');
      } else {
        // Fallback to downloading it if not preloaded
        debugPrint('Downloading to cache: ${widget.video.videoUrl}');
        final file = await VideoCacheManager.instance.getSingleFile(
          widget.video.videoUrl,
        );
        videoFile = file;
      }

      // 2. Initialize VideoPlayerController with the local file
      _controller = VideoPlayerController.file(videoFile)
        ..setLooping(true)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });

            // If it initializes while already focused, play immediately
            if (widget.isFocused) {
              _controller!.play();
            }
          }
        });
    } catch (e) {
      debugPrint('Error initializing video video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Tap to pause/play
        if (_controller != null && _isInitialized) {
          setState(() {
            if (_controller!.value.isPlaying) {
              _controller!.pause();
            } else {
              _controller!.play();
            }
          });
        }
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video Player Layer
            _hasError
                ? const Center(
                    child: Text(
                      'Failed to load video',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : _isInitialized && _controller != null
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),

            // Gradient Overlay to ensure text readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),

            // Play Icon Layer when paused manually
            if (_isInitialized &&
                _controller != null &&
                !_controller!.value.isPlaying &&
                widget.isFocused)
              Center(
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 80,
                ),
              ),

            // Dummy Captions Overlay
            if (_isInitialized && _controller != null)
              ReelDummyCaptions(controller: _controller!),

            // Custom UI Overlay Layer (Username, description, buttons)
            ReelUiOverlay(video: widget.video),
          ],
        ),
      ),
    );
  }
}
