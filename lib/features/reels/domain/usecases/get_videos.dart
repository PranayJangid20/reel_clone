import 'package:reel_clone/features/reels/domain/entities/video_entity.dart';
import 'package:reel_clone/features/reels/domain/repositories/video_repository.dart';

/// Use case for retrieving the list of videos.
class GetVideos {
  final VideoRepository repository;

  GetVideos(this.repository);

  Future<List<VideoEntity>> call() async {
    return await repository.getVideos();
  }
}
