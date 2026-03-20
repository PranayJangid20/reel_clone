import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reel_clone/features/reels/presentation/cubit/reel_cubit.dart';
import 'package:reel_clone/features/reels/presentation/cubit/reel_state.dart';
import 'package:reel_clone/features/reels/presentation/widgets/reel_video_item.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Fetch initial list of videos when screen loads
    context.read<ReelCubit>().loadVideos();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<ReelCubit, ReelState>(
        builder: (context, state) {
          if (state is ReelInitial || state is ReelLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is ReelError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (state is ReelLoaded) {
            if (state.videos.isEmpty) {
              return const Center(
                child: Text(
                  'No reels found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: state.videos.length,
              onPageChanged: (index) {
                // Inform Cubit about page change to handle auto-play and preloading
                context.read<ReelCubit>().onPageChanged(index);
              },
              itemBuilder: (context, index) {
                final video = state.videos[index];
                // Check if this particular video item is currently focused
                final isFocused = state.currentIndex == index;

                return ReelVideoItem(video: video, isFocused: isFocused);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
