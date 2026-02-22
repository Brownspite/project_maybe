import 'package:flutter/material.dart';

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const VangtiChaiScreen(),
    );
  }
}

class VangtiChaiScreen extends StatefulWidget {
  const VangtiChaiScreen({super.key});

  @override
  State<VangtiChaiScreen> createState() => _VangtiChaiScreenState();
}

class _VangtiChaiScreenState extends State<VangtiChaiScreen> {
  int _amount = 0;
  final List<int> _noteValues = [500, 100, 50, 20, 10, 5, 2, 1];

  void _onDigitPressed(int digit) {
    setState(() {
      if (_amount < 1000000) {
        _amount = _amount * 10 + digit;
      }
    });
  }

  void _onClear() {
    setState(() {
      _amount = 0;
    });
  }

  Map<int, int> _calculateChange() {
    int remaining = _amount;
    final Map<int, int> result = {};
    for (final note in _noteValues) {
      result[note] = remaining ~/ note;
      remaining = remaining % note;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VangtiChai',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: isLandscape ? _buildLandscape() : _buildPortrait(),
      ),
    );
  }

  // ── PORTRAIT ──
  // Top: centered "Taka: X"
  // Below: [change table (left) | 3-col keypad (right)]
  Widget _buildPortrait() {
    return Column(
      children: [
        _buildAmountRow(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: _buildChangeTable(),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: _buildKeypad3Col(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── LANDSCAPE ──
  // Top: centered "Taka: X"
  // Below: [change table (left) | 4-col keypad (right)]
  Widget _buildLandscape() {
    return Column(
      children: [
        _buildAmountRow(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: _buildChangeTable(),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: _buildKeypad4Col(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          'Taka: $_amount',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildChangeTable() {
    final change = _calculateChange();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _noteValues.map((note) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text(
            '$note: ${change[note]}',
            style: const TextStyle(fontSize: 15),
          ),
        );
      }).toList(),
    );
  }

  // Portrait 3-col keypad:
  // [ 1 ][ 2 ][ 3 ]
  // [ 4 ][ 5 ][ 6 ]
  // [ 7 ][ 8 ][ 9 ]
  // [ 0 ][  CLEAR  ]
  Widget _buildKeypad3Col() {
    return Column(
      children: [
        _keyRow([1, 2, 3]),
        _keyRow([4, 5, 6]),
        _keyRow([7, 8, 9]),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _digitBtn(0)),
              const SizedBox(width: 5),
              Expanded(flex: 2, child: _clearBtn()),
            ],
          ),
        ),
      ],
    );
  }

  // Landscape 4-col keypad:
  // [ 1 ][ 2 ][ 3 ][ 4 ]
  // [ 5 ][ 6 ][ 7 ][ 8 ]
  // [ 9 ][ 0 ][  CLEAR  ]
  Widget _buildKeypad4Col() {
    return Column(
      children: [
        _keyRow([1, 2, 3, 4]),
        _keyRow([5, 6, 7, 8]),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _digitBtn(9)),
              const SizedBox(width: 5),
              Expanded(child: _digitBtn(0)),
              const SizedBox(width: 5),
              Expanded(flex: 2, child: _clearBtn()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _keyRow(List<int> digits) {
    return Expanded(
      child: Row(
        children: [
          for (int i = 0; i < digits.length; i++) ...[
            Expanded(child: _digitBtn(digits[i])),
            if (i < digits.length - 1) const SizedBox(width: 5),
          ]
        ],
      ),
    );
  }

  Widget _digitBtn(int digit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: SizedBox.expand(
        child: ElevatedButton(
          onPressed: () => _onDigitPressed(digit),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDDDDDD),
            foregroundColor: Colors.black87,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            '$digit',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  Widget _clearBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: SizedBox.expand(
        child: ElevatedButton(
          onPressed: _onClear,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDDDDDD),
            foregroundColor: Colors.black87,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.zero,
          ),
          child: const Text(
            'CLEAR',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}