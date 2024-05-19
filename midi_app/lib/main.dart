import 'package:flutter/material.dart';
import 'midi_parser.dart';
import 'models.dart';

void main() {
  runApp(MidiVisualizerApp());
}

class MidiVisualizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIDI Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MidiVisualizerScreen(),
    );
  }
}

class MidiVisualizerScreen extends StatefulWidget {
  @override
  _MidiVisualizerScreenState createState() => _MidiVisualizerScreenState();
}

class _MidiVisualizerScreenState extends State<MidiVisualizerScreen> {
  MidiFile? midiFile;

  @override
  void initState() {
    super.initState();
    loadMidiFile();
  }

  Future<void> loadMidiFile() async {
    final parser = MidiParser('assets/Sketch15.midi');
    final parsedMidi = await parser.parseMidiFile();
    setState(() {
      midiFile = parsedMidi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MIDI Visualizer'),
      ),
      body: midiFile == null
          ? Center(child: CircularProgressIndicator())
          : MidiVisualizer(midiFile: midiFile!),
    );
  }
}

class MidiVisualizer extends StatelessWidget {
  final MidiFile midiFile;

  MidiVisualizer({required this.midiFile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: CustomPaint(
        size: Size(2000, 600), // Adjust size based on your MIDI file
        painter: MidiPainter(midiFile),
      ),
    );
  }
}

class MidiPainter extends CustomPainter {
  final MidiFile midiFile;

  MidiPainter(this.midiFile);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (var track in midiFile.tracks) {
      for (var event in track.events) {
        if (event.type == 'noteOn' && event.noteNumber != null) {
          final noteHeight = 10.0;
          final noteWidth = 20.0;
          final x = event.deltaTime.toDouble();
          final y = (127 - event.noteNumber!) * noteHeight;

          canvas.drawRect(
            Rect.fromLTWH(x, y, noteWidth, noteHeight),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
