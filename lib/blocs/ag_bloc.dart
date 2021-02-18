import 'package:ag_viewer/blocs/bloc.dart';
import 'package:ag_viewer/models/program_object.dart';
import 'package:ag_viewer/repositories/ag_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class AgBloc extends Bloc {
  AgBloc(this.apiRepository);

  final AgApi apiRepository;

  final BehaviorSubject<List<List<ProgramObject>>> _programController =
      BehaviorSubject<List<List<ProgramObject>>>.seeded([]);
  Sink<List<List<ProgramObject>>> get _inPrograms => _programController.sink;
  ValueStream<List<List<ProgramObject>>> get outPrograms =>
      _programController.stream;

  Future<void> initPrograms() async {
    final programs = await apiRepository.getProgramData(type: ProgramType.all);
    _inPrograms.add(programs);
  }

  @override
  void dispose() {
    _programController.close();
  }
}

final agProvider = Provider(
  (ref) => AgBloc(AgApi()),
);
