import 'package:flutter/material.dart';

import 'package:accounting_app/features/journal/screens/main_journal_screen.dart';
import 'package:accounting_app/features/reporting/screens/main_report_options_screen.dart';
import 'package:accounting_app/features/t_account/screens/display_account_main_screen.dart';



class MainDrawer extends StatelessWidget {
  final String currentScreenName;
  const MainDrawer({required this.currentScreenName, Key? key})
      : super(key: key);

  bool _isTileSelected(String screenNameOfTile) {
    return currentScreenName == screenNameOfTile;
  }

  ListTile _generateDrawerTile(
    BuildContext context,
    IconData leadingIcon,
    String titleText,
    String? onTapRouteName,
  ) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(titleText),
      onTap: () => onTapRouteName == null
          ? null
          : Navigator.of(context).pushReplacementNamed(onTapRouteName),
      selectedColor: Colors.white,
      selectedTileColor: Theme.of(context).primaryColor,
      selected:
          onTapRouteName == null ? false : _isTileSelected(onTapRouteName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _generateDrawerTile(
            context,
            Icons.book_outlined,
            'Journal',
            MainJournalScreen.routeName,
          ),
          _generateDrawerTile(
            context,
            Icons.account_balance,
            'Accounts',
            DisplayAccountMainScreen.routeName,
          ),
          _generateDrawerTile(
            context,
            Icons.report,
            'Reports',
            MainReportOptionsScreen.routeName,
          ),
        ],
      ),
    );
  }
}
