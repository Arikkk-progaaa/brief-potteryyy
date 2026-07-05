import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'ui/screens/schedule_screen.dart';

void main() => runApp(const BriefPotteryApp());

class BriefPotteryApp extends StatelessWidget {
  const BriefPotteryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Глина — гончарная мастерская',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const ScheduleScreen(),
    );
  }
}
