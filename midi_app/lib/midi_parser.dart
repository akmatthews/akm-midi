import 'dart:io';
import 'package:tekartik_midi/midi_parser.dart' as tk_parser;
import 'package:tekartik_midi/src/parser/file_parser.dart' as tk_file_parser;
import 'package:tekartik_midi/midi.dart' as tk_midi;
import 'models.dart';

class MidiParser {
  final String filePath;

  MidiParser(this.filePath);

  Future<MidiFile> parseMidiFile() async {
    final midiData = await File(filePath).readAsBytes();
    final tk_parser.MidiParser midiParser = tk_parser.MidiParser(midiData);
    final tk_file_parser.FileParser parser =
        tk_file_parser.FileParser(midiParser);
    parser.parseFile();

    final tk_midi.MidiFile midiFile = parser.file!;

    final List<MidiTrack> tracks = [];
    for (var track in midiFile.tracks) {
      final List<MidiEvent> events = [];
      int currentTime = 0;

      for (var event in track.events) {
        currentTime += event.deltaTime;
        if (event is tk_midi.NoteOnEvent || event is tk_midi.NoteOffEvent) {
          var noteEvent = event as tk_midi.NoteEvent;
          events.add(MidiEvent(
            deltaTime: currentTime,
            type: event is tk_midi.NoteOnEvent ? 'noteOn' : 'noteOff',
            noteNumber: noteEvent.note,
            velocity: noteEvent.velocity,
          ));
        } else {
          events.add(MidiEvent(
            deltaTime: currentTime,
            type: event
                .toString(), // For simplicity, using the string representation of other events
          ));
        }
      }
      tracks.add(MidiTrack(events: events));
    }

    return MidiFile(tracks: tracks, ticksPerBeat: midiFile.ppq as int);
  }
}
