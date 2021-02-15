import 'package:ag_viewer/blocs/bloc.dart';
import 'package:ag_viewer/repositories/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TweetBloc extends Bloc {
  TweetBloc(this.apiRepository);

  final TwitterApi apiRepository;

  Future<String> initTweet() async {
    return apiRepository.getTweetData();
  }

  @override
  void dispose() {}
}

final tweetProvider = Provider(
  (ref) => TweetBloc(TwitterApi()),
);
