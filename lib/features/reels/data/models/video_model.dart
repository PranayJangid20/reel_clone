import 'package:reel_clone/features/reels/domain/entities/video_entity.dart';

/// Data model representing a Video. Extends the Domain Entity.
class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.videoUrl,
    required super.description,
    required super.likes,
    required super.username,
  });

  /// Factory constructor to create a `VideoModel` from a JSON map.
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String,
      videoUrl: json['videoUrl'] as String,
      description: json['description'] as String,
      likes: json['likes'] as int,
      username: json['username'] as String,
    );
  }

  /// Converts a `VideoModel` into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoUrl': videoUrl,
      'description': description,
      'likes': likes,
      'username': username,
    };
  }
}
