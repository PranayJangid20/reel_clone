import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reel_clone/features/reels/domain/usecases/get_videos.dart';
import 'package:reel_clone/features/reels/presentation/cubit/reel_state.dart';
import 'package:reel_clone/core/services/video_cache_manager.dart';

class ReelCubit extends Cubit<ReelState> {
  final GetVideos getVideosUseCase;

  ReelCubit({required this.getVideosUseCase}) : super(ReelInitial());

  /// Fetches the initial list of videos.
  Future<void> loadVideos() async {
    emit(ReelLoading());
    try {
      final videos = await getVideosUseCase();
      if (videos.isNotEmpty) {
        emit(ReelLoaded(videos: videos, currentIndex: 0));
        // Preload the first few videos
        _preloadAdjacentVideos(0, videos.map((e) => e.videoUrl).toList());
      } else {
        emit(const ReelError("No videos found"));
      }
    } catch (e) {
      emit(ReelError(e.toString()));
    }
  }

  /// Updates the current active index when the user scrolls.
  void onPageChanged(int index) {
    if (state is ReelLoaded) {
      final currentState = state as ReelLoaded;
      emit(currentState.copyWith(currentIndex: index));

      // Preload next videos
      _preloadAdjacentVideos(
        index,
        currentState.videos.map((e) => e.videoUrl).toList(),
      );
    }
  }

  /// Preload an array of videos ahead to prevent buffering
  void _preloadAdjacentVideos(int currentIndex, List<String> urls) {
    // We preload up to 3 videos ahead.
    for (int i = 1; i <= 3; i++) {
      int preloadIndex = currentIndex + i;
      if (preloadIndex < urls.length) {
        VideoCacheManager.preloadVideo(urls[preloadIndex]);
      }
    }
  }
}
