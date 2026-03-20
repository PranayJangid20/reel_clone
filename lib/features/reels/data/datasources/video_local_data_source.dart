import 'package:reel_clone/features/reels/data/models/video_model.dart';

abstract class VideoLocalDataSource {
  Future<List<VideoModel>> getVideos();
}

class VideoLocalDataSourceImpl implements VideoLocalDataSource {
  @override
  Future<List<VideoModel>> getVideos() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Returning some dummy network videos.
    // Providing public, standard vertical/short clips suitable for Reels.
    final List<Map<String, dynamic>> dummyData = [
      {
        'id': '1',
        'videoUrl':
            'https://cdn.pixabay.com/video/2024/05/31/214669_large.mp4',
        'description': 'Beautiful blazing fire 🔥. Perfect for cozy nights.',
        'likes': 1540,
        'username': '@fire_lover',
      },
      {
        'id': '2',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        'description': 'The great escape into nature 🌲.',
        'likes': 2309,
        'username': '@nature_hiker',
      },
      {
        'id': '3',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        'description': 'Having fun, letting loose 🎉',
        'likes': 990,
        'username': '@fun_times',
      },
      {
        'id': '4',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        'description': 'Driving through the winding roads 🚗.',
        'likes': 415,
        'username': '@car_enthusiast',
      },
      {
        'id': '5',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
        'description': 'Sometimes we just have those days... 🌧️',
        'likes': 98,
        'username': '@real_talk',
      },
    ];

    return dummyData.map((json) => VideoModel.fromJson(json)).toList();
  }
}
