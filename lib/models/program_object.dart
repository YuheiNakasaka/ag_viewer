import 'package:equatable/equatable.dart';

class ProgramField {
  static const title = 'title';
  static const pfm = 'pfm';
  static const duration = 'dur';
  static const isBroadcast = 'isBroadcast';
  static const isRepeat = 'isRepeat';
  static const from = 'ft';
  static const to = 'to';
}

class ProgramObject extends Equatable {
  const ProgramObject({
    this.title,
    this.pfm,
    this.duration,
    this.isBroadcast,
    this.isRepeat,
    this.from,
    this.to,
  });

  factory ProgramObject.fromDocument(Map<String, dynamic> document) {
    return ProgramObject(
      title: document[ProgramField.title].toString(),
      pfm: document[ProgramField.pfm].toString(),
      duration: int.parse(document[ProgramField.duration].toString()),
      isBroadcast: document[ProgramField.isBroadcast] as bool,
      isRepeat: document[ProgramField.isRepeat] as bool,
      from: parseAgTimeString(document[ProgramField.from].toString()),
      to: parseAgTimeString(document[ProgramField.to].toString()),
    );
  }

  static const String clnName = 'program_v1';

  final String title;
  final String pfm;
  final int duration;
  final bool isBroadcast;
  final bool isRepeat;
  final DateTime from;
  final DateTime to;

  Map<String, Object> toDocument() {
    return {
      ProgramField.title: title,
      ProgramField.pfm: pfm,
      ProgramField.duration: duration,
      ProgramField.isBroadcast: isBroadcast,
      ProgramField.isRepeat: isRepeat,
      ProgramField.from: from,
      ProgramField.to: to,
    };
  }

  String hhmm() {
    return '${from.hour.toString().padLeft(2, '0')}:${from.minute.toString().padLeft(2, '0')}';
  }

  @override
  List<Object> get props => [
        pfm,
        duration,
        isBroadcast,
        isRepeat,
        from,
        to,
      ];

  @override
  String toString() {
    return '''Program: {
    title: $title,
    pfm: $pfm,
    duration: $duration,
    isBroadcast: $isBroadcast,
    isRepeat: $isRepeat,
    from: $from,
    to: $to,
}''';
  }
}

DateTime parseAgTimeString(String text) {
  final regex = RegExp(r'^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})');
  final m = regex.firstMatch(text);
  return DateTime.parse(
      '${m.group(1)}-${m.group(2)}-${m.group(3)} ${m.group(4)}:${m.group(5)}:00');
}
