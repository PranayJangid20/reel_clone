import 'package:reel_clone/features/reels/data/datasources/video_remote_data_source.dart';
import 'package:reel_clone/features/reels/domain/entities/video_entity.dart';
import 'package:reel_clone/features/reels/domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;

  VideoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<VideoEntity>> getVideos() async {
    try {
      final models = await remoteDataSource.getVideos();
      return models; // VideoModel extends VideoEntity
    } catch (e) {
      throw Exception('Failed to fetch videos: $e');
    }
  }
}
