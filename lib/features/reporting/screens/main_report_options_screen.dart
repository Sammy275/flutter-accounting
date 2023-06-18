import 'package:flutter/material.dart';

import './income_statement_screen.dart';
import './trial_balance_screen.dart';
import './owner_equity_screen.dart';
import './balance_sheet_screen.dart';

import '../../../common//widgets/main_drawer.dart';

class MainReportOptionsScreen extends StatelessWidget {
  static const routeName = 'main-report-options-screen/';
  const MainReportOptionsScreen({Key? key}) : super(key: key);

  ListTile _generateListTile(
      BuildContext context, String titleText, Widget? screen) {
    return ListTile(
      title: Text(titleText),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => screen == null
          ? null
          : Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => screen)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      drawer: const MainDrawer(
        currentScreenName: routeName,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _generateListTile(context, 'Trial Balance', TrialBalanceScreen()),
            _generateListTile(context, 'Income Statement', IncomeStatementScreen()),
            _generateListTile(context, 'Owner Equity Statement', OwnerEquityScreen()),
            _generateListTile(context, 'Balance Sheet', BalanceSheetScreen()),
          ],
        ),
      ),
    );
  }
}
