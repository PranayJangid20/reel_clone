import 'package:equatable/equatable.dart';

/// Represents a single Reel/Video item.
class VideoEntity extends Equatable {
  final String id;
  final String videoUrl;
  final String description;
  final int likes;
  final String username;

  const VideoEntity({
    required this.id,
    required this.videoUrl,
    required this.description,
    required this.likes,
    required this.username,
  });

  @override
  List<Object?> get props => [id, videoUrl, description, likes, username];
}
