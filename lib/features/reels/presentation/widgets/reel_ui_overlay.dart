import 'package:flutter/material.dart';
import 'package:reel_clone/features/reels/domain/entities/video_entity.dart';

class ReelUiOverlay extends StatelessWidget {
  final VideoEntity video;

  const ReelUiOverlay({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 16,
      right: 16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Left side: User info and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  video.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  video.description,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Right side: Action buttons (Likes, Comments, Share)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(Icons.favorite, video.likes.toString()),
              const SizedBox(height: 16),
              _buildActionButton(Icons.comment, '120'), // Mocked comment count
              const SizedBox(height: 16),
              _buildActionButton(Icons.share, 'Share'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        // Handle button tap
      },
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
