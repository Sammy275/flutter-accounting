import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './features/t_account/screens/display_account_main_screen.dart';
import './features/journal/screens/main_journal_screen.dart';
import './features/reporting/screens/main_report_options_screen.dart';

import './providers/accounts.dart';
import './providers/transactions.dart';

void main() {
  runApp(const MyApp());
}

/// Root Widget of the application
class MyApp extends StatelessWidget {
  /// Constructor for root widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AccountProvider()),
        ChangeNotifierProvider(create: (ctx) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'Accounting App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainJournalScreen(),
        routes: {
          DisplayAccountMainScreen.routeName: (ctx) => const DisplayAccountMainScreen(),
          MainJournalScreen.routeName: (ctx) => const MainJournalScreen(),
          MainReportOptionsScreen.routeName: (ctx) => const MainReportOptionsScreen(),
        },
      ),
    );
  }
}
