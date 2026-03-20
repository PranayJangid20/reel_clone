import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Service to handle caching of video files for seamless playback.
class VideoCacheManager {
  static const key = "customCacheKey";

  /// Custom cache manager to store videos. We can adjust maxAge and maxNrOfCacheObjects.
  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );

  /// Preloads a video by downloading it if it isn't already cached.
  static Future<void> preloadVideo(String url) async {
    try {
      final fileInfo = await instance.getFileFromCache(url);
      if (fileInfo == null) {
        // Download and cache the file
        await instance.downloadFile(url);
        debugPrint('Preloaded video: $url');
      } else {
        debugPrint('Video already cached: $url');
      }
    } catch (e) {
      debugPrint('Failed to preload video $url: $e');
    }
  }
}
