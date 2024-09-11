import 'package:flutter/material.dart';
import '../home_page/navigationbar.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BPMCalculator(),
    );
  }
}

class BPMCalculator extends StatefulWidget {
  @override
  _BPMCalculatorState createState() => _BPMCalculatorState();
}

class _BPMCalculatorState extends State<BPMCalculator> {
  List<DateTime> _tapTimes = [];
  double _bpm = 0.0;

  void _calculateBPM() {
    if (_tapTimes.length < 2) {
      setState(() {
        _bpm = 0.0;
      });
      return;
    }

    // Calculate the time difference between consecutive taps in milliseconds
    List<int> timeDiffs = [];
    for (int i = 1; i < _tapTimes.length; i++) {
      timeDiffs.add(_tapTimes[i].millisecondsSinceEpoch -
          _tapTimes[i - 1].millisecondsSinceEpoch);
    }

    // Calculate the average time difference and BPM
    double avgTimeDiff = timeDiffs.reduce((a, b) => a + b) / timeDiffs.length;
    setState(() {
      _bpm = 60000 / avgTimeDiff;
    });
  }

  void _onTap() {
    final now = DateTime.now();
    setState(() {
      _tapTimes.add(now);

      // Only keep the last 10 taps to keep the calculation stable
      if (_tapTimes.length > 10) {
        _tapTimes.removeAt(0);
      }

      _calculateBPM();
    });
  }

  // Reset the BPM calculation and tap times
  void _clearBPM() {
    setState(() {
      _tapTimes.clear();
      _bpm = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242935),

      appBar: AppBar(
        title: Text(
          'BPM Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF242935),
        centerTitle: true,  // Centers the title
        iconTheme: IconThemeData(
          color: Colors.white,  // Makes the return icon white
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SizedBox(height: 100),
            Text(
              'Beats Per Minute: ${_bpm.toInt()}',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            ),


            SizedBox(height: 50),
            // Clear button to reset BPM
            ElevatedButton(
              onPressed: _clearBPM,
              child: Text('Clear'),
            ),

            SizedBox(height: 40),
            GestureDetector(
              onTap: _onTap,
              child: Image.asset(
                'assets/images/btn_tempo.png', // Replace with your image asset
                width: 250,
                height: 250,
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomBar(),


    );
  }





}
