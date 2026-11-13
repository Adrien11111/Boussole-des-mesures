import 'package:flutter/widgets.dart';

import '../../application/state/app_state.dart';
import 'compare_page.dart';
import 'home_page.dart';
import 'quiz_page.dart';
import 'report_page.dart';

Widget pageFor(AppView view) => switch (view) {
      AppView.home => const HomePage(),
      AppView.quiz => const QuizPage(),
      AppView.report => const ReportPage(),
      AppView.compare => const ComparePage(),
    };
