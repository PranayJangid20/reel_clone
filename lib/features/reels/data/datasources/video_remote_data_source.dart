import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reel_clone/features/reels/data/models/video_model.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoModel>> getVideos();
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final FirebaseFirestore _firestore;

  VideoRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<VideoModel>> getVideos() async {
    try {
      // Fetching from the 'demo_reel' collection
      final querySnapshot = await _firestore.collection('demo_reels').get();

      final videos = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return VideoModel(
          id: doc.id,
          videoUrl: data['videoUrl'] as String? ?? '',
          description: data['description'] as String? ?? '',
          likes: data['likes'] ?? 0,
          username: data['username'] as String? ?? 'Unknown User',
        );
      }).toList();

      return videos;
    } catch (e) {
      throw Exception('Failed to fetch videos from Firestore: $e');
    }
  }
}
