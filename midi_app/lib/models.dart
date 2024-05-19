class MidiFile {
  final List<MidiTrack> tracks;
  final int ticksPerBeat;

  MidiFile({required this.tracks, required this.ticksPerBeat});
}

class MidiTrack {
  final List<MidiEvent> events;

  MidiTrack({required this.events});
}

class MidiEvent {
  final int deltaTime;
  final String type;
  final int? noteNumber;
  final int? velocity;

  MidiEvent(
      {required this.deltaTime,
      required this.type,
      this.noteNumber,
      this.velocity});
}
