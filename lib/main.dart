import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const AgeCraftApp());
}

class AgeCraftApp extends StatelessWidget {
  const AgeCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgeCraft 3D',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff5b5ce2),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AgeCalculatorScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe9edff),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 130,
                height: 130,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffe9edff),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-7, -7),
                      blurRadius: 14,
                    ),
                    BoxShadow(
                      color: Color(0x405b6b9a),
                      offset: Offset(7, 7),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    'assets/icons/app_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'AgeCraft 3D',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff24254f),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Calculate your age easily',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                color: Color(0xff5b5ce2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() =>
      _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? birthDate;

  int years = 0;
  int months = 0;
  int days = 0;

  bool showResult = false;

  Future<void> selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null) return;

    setState(() {
      birthDate = selectedDate;
      showResult = false;
    });
  }

  void calculateAge() {
    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your date of birth'),
        ),
      );
      return;
    }

    final today = DateTime.now();

    int calculatedYears = today.year - birthDate!.year;
    int calculatedMonths = today.month - birthDate!.month;
    int calculatedDays = today.day - birthDate!.day;

    if (calculatedDays < 0) {
      calculatedDays += DateTime(today.year, today.month, 0).day;
      calculatedMonths--;
    }

    if (calculatedMonths < 0) {
      calculatedMonths += 12;
      calculatedYears--;
    }

    setState(() {
      years = calculatedYears;
      months = calculatedMonths;
      days = calculatedDays;
      showResult = true;
    });
  }

  void reset() {
    setState(() {
      birthDate = null;
      years = 0;
      months = 0;
      days = 0;
      showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe9edff),
      appBar: AppBar(
        title: const Text(
          'AgeCraft 3D',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: reset,
            tooltip: 'Reset',
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isMobile = screenWidth < 600;
          final isTablet = screenWidth >= 600 && screenWidth < 1000;

          final horizontalPadding = isMobile
              ? 20.0
              : isTablet
                  ? 40.0
                  : 60.0;

          final contentWidth = isMobile
              ? screenWidth
              : isTablet
                  ? 650.0
                  : 700.0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: contentWidth,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cake_rounded,
                      size: isMobile ? 75 : 95,
                      color: const Color(0xff5b5ce2),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Calculate Your Age',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 25 : 30,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff24254f),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select your date of birth',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _threeDCard(
                      child: ListTile(
                        onTap: selectDate,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        leading: const Icon(
                          Icons.calendar_month_rounded,
                          size: 30,
                          color: Color(0xff5b5ce2),
                        ),
                        title: Text(
                          birthDate == null
                              ? 'Date of birth'
                              : DateFormat('dd MMMM yyyy')
                                  .format(birthDate!),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          birthDate == null
                              ? 'Tap to select date'
                              : 'Tap to change date',
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        onPressed: calculateAge,
                        icon: const Icon(Icons.calculate_rounded),
                        label: const Text(
                          'Calculate Age',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xff5b5ce2),
                          foregroundColor: Colors.white,
                          elevation: 10,
                          shadowColor: const Color(0xff5b5ce2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    if (showResult) ...[
                      const Text(
                        'Your Age',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff24254f),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _threeDCard(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                screenWidth < 400 ? 8 : 20,
                            vertical: 28,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _resultItem(
                                  years.toString(),
                                  'Years',
                                ),
                              ),
                              _divider(),
                              Expanded(
                                child: _resultItem(
                                  months.toString(),
                                  'Months',
                                ),
                              ),
                              _divider(),
                              Expanded(
                                child: _resultItem(
                                  days.toString(),
                                  'Days',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _threeDCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffe9edff),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-7, -7),
            blurRadius: 14,
          ),
          BoxShadow(
            color: Color(0x405b6b9a),
            offset: Offset(7, 7),
            blurRadius: 14,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _resultItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xff5b5ce2),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 50,
      color: const Color(0xffc9cee7),
    );
  }
}