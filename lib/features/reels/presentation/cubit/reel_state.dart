import 'package:equatable/equatable.dart';
import 'package:reel_clone/features/reels/domain/entities/video_entity.dart';

abstract class ReelState extends Equatable {
  const ReelState();

  @override
  List<Object?> get props => [];
}

class ReelInitial extends ReelState {}

class ReelLoading extends ReelState {}

class ReelLoaded extends ReelState {
  final List<VideoEntity> videos;
  final int currentIndex;

  const ReelLoaded({required this.videos, this.currentIndex = 0});

  ReelLoaded copyWith({List<VideoEntity>? videos, int? currentIndex}) {
    return ReelLoaded(
      videos: videos ?? this.videos,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [videos, currentIndex];
}

class ReelError extends ReelState {
  final String message;

  const ReelError(this.message);

  @override
  List<Object?> get props => [message];
}
