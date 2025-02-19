import 'package:ag_viewer/blocs/bloc.dart';
import 'package:ag_viewer/blocs/user_bloc.dart';
import 'package:ag_viewer/models/favorite_object.dart';
import 'package:ag_viewer/models/program_object.dart';
import 'package:ag_viewer/repositories/ag_api.dart';
import 'package:ag_viewer/repositories/ag_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class AgBloc extends Bloc {
  AgBloc(this.apiRepository, this.fsRepository);

  final AgApi apiRepository;
  final AgFirestore fsRepository;

  final BehaviorSubject<List<List<ProgramObject>>> _programController =
      BehaviorSubject<List<List<ProgramObject>>>.seeded([]);
  Sink<List<List<ProgramObject>>> get _inPrograms => _programController.sink;
  ValueStream<List<List<ProgramObject>>> get outPrograms =>
      _programController.stream;

  final BehaviorSubject<List<FavoriteObject>> _favoriteController =
      BehaviorSubject<List<FavoriteObject>>.seeded([]);
  Sink<List<FavoriteObject>> get _inFavorites => _favoriteController.sink;
  ValueStream<List<FavoriteObject>> get outFavorites =>
      _favoriteController.stream;

  Future<void> initPrograms() async {
    _inFavorites.add([]);
    _inFavorites.add(await fsRepository.fetchFavorites());

    final programs = await apiRepository.getProgramData(type: ProgramType.all);
    final sortedPrograms = <List<ProgramObject>>[
      <ProgramObject>[],
      <ProgramObject>[],
      <ProgramObject>[],
      <ProgramObject>[],
      <ProgramObject>[],
      <ProgramObject>[],
      <ProgramObject>[],
    ];
    final irrPrograms = <ProgramObject>[];
    for (var i = 0; i < programs.length; i++) {
      for (var j = 0; j < programs[i].length; j++) {
        if (programs[i][j].from.hour >= 6) {
          sortedPrograms[i].add(programs[i][j]);
        } else {
          if (i - 1 < 0) {
            irrPrograms.add(programs[i][j]);
          } else {
            sortedPrograms[i - 1].add(programs[i][j]);
          }
        }
      }
    }
    sortedPrograms[6] = sortedPrograms[6] + irrPrograms;
    _inPrograms.add(sortedPrograms);
  }

  Future<void> addFavorite(ProgramObject program) async {
    final doc = await fsRepository.fetchFavorite();
    final favorite = FavoriteObject(
      title: program.title,
      favoriteId: doc.id,
      userId: UserBloc.fireUser.uid,
      subscribed: true,
      program: program,
    );
    final _favorites = _favoriteController.value;
    _favorites.add(favorite);
    _inFavorites.add(_favorites);
    await doc.set(favorite.toDocument(program));
  }

  Future<void> deleteFavorite(ProgramObject program) async {
    final _favorites = _favoriteController.value;
    final index = _favorites.indexWhere((e) => e.isEqualTo(program));
    final target = _favorites[index];
    _favorites.removeAt(index);
    _inFavorites.add(_favorites);
    await fsRepository.deleteFavorite(target);
  }

  @override
  void dispose() {
    _programController.close();
    _favoriteController.close();
  }
}

final agProvider = Provider(
  (ref) => AgBloc(AgApi(), AgFirestore()),
);
