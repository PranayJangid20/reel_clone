import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelDummyCaptions extends StatefulWidget {
  final VideoPlayerController controller;

  const ReelDummyCaptions({super.key, required this.controller});

  @override
  State<ReelDummyCaptions> createState() => _ReelDummyCaptionsState();
}

class _ReelDummyCaptionsState extends State<ReelDummyCaptions> {
  final List<String> _dummyCaptions = [
    "Welcome to this awesome reel!",
    "Check out this amazing content...",
    "Can you believe this happened?",
    "Wait for effect...",
    "Almost there!",
    "Like and share for more!",
  ];

  String _currentCaption = "";

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateCaption);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCaption);
    super.dispose();
  }

  void _updateCaption() {
    if (!mounted) return;

    final position = widget.controller.value.position;
    // Calculate an index based on the current second (changes every 2 seconds)
    final index = (position.inSeconds / 2).floor() % _dummyCaptions.length;
    final newCaption = _dummyCaptions[index];

    if (newCaption != _currentCaption) {
      setState(() {
        _currentCaption = newCaption;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Optionally only show captions when the video is actively playing
    if (_currentCaption.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 180, // Sits above the ReelUiOverlay which is around bottom 40-160
      left: 32,
      right: 32,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _currentCaption,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
