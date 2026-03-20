import 'package:reel_clone/features/reels/domain/entities/video_entity.dart';

/// Abstract interface for fetching video data.
abstract class VideoRepository {
  /// Fetches a list of videos to be displayed in the reels feed.
  Future<List<VideoEntity>> getVideos();
}
