import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../widgets/transaction_entry_modal_widget.dart';

import '../../../helpers/network_request_maker.dart';

import '../../../providers/accounts.dart';
import '../../../providers/transactions.dart';

import '../../../common/widgets/main_drawer.dart';

/// Screen that displays the general journal
class MainJournalScreen extends StatefulWidget {
  /// route name for the MainJournalScreen
  static const routeName = 'main-journal-screen/';

  /// Constructor for MainJournalScreen
  const MainJournalScreen({Key? key}) : super(key: key);

  @override
  State<MainJournalScreen> createState() => _MainJournalScreenState();
}

class _MainJournalScreenState extends State<MainJournalScreen> {
  List<TableRow> _getTableRowsWidgetList(List<Transaction> transactionList) {
    List<TableRow> tableRowList = [];

    tableRowList = transactionList
        .map((transaction) => TableRow(children: [
              _generateCenterAlignedTextWidget(
                  transaction.transactionDate.toString()),
              _generateCenterAlignedTextWidget(
                  transaction.debitEntry!.accountDetail!.accountName.toString()),
              _generateCenterAlignedTextWidget(
                  transaction.creditEntry!.accountDetail!.accountName.toString()),
              _generateCenterAlignedTextWidget(
                  transaction.debitEntry!.amount.toString()),
            ]))
        .toList();

    return tableRowList;
  }

  void _performJournalTransaction(
    String debitAccountId,
    String creditAccountId,
    String debitEntryType,
    String creditEntryType,
    double amount,
  ) async {
    if (debitAccountId == creditAccountId) {
      return;
    }

    final postRequestDataBody = json.encode({
      'description': '',
      'debit': [
        {
          'transaction_type': 'Debit',
          'account_id': debitAccountId,
          'amount': amount,
          'entry_type': debitEntryType,
        },
      ],
      'credit': [
        {
          'transaction_type': 'Credit',
          'account_id': creditAccountId,
          'amount': amount,
          'entry_type': creditEntryType,
        },
      ],
    });

    try {
      await NetworkRequestMaker.postJsonDataInRequest(
          'journalEntry/create-entry', postRequestDataBody);
    } catch (error) {
      print(error);
    }

    setState(() {});

    Navigator.of(context).pop();
  }

  void _startTransactionEntryProcedure() async {
    final AccountProvider accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    await accountProvider.loadAccountsFromServer();
    final accountsList = accountProvider.accountsList;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => TransactionEntryModalWidget(
        accountsList: accountsList,
        performTransaction: _performJournalTransaction,
      ),
    );
  }

  Text _generateCenterAlignedTextWidget(String text, [TextStyle? textStyle]) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entries'),
      ),
      drawer: const MainDrawer(currentScreenName: MainJournalScreen.routeName),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            TransactionProvider transactionProvider =
                Provider.of<TransactionProvider>(context, listen: false);

            TextStyle columnHeaderTextStyle = const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            );

            return FutureBuilder(
              future: transactionProvider.loadCurrentJournalEntriesFromServer(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final currentTransactionsList =
                    transactionProvider.currentTransactionList;
                currentTransactionsList.sort(
                    (prevTransaction, nextTransaction) => prevTransaction
                        .transactionDate
                        .compareTo(nextTransaction.transactionDate));

                return Table(
                  border: TableBorder.all(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  children: [
                    TableRow(children: [
                      _generateCenterAlignedTextWidget(
                        'Date',
                        columnHeaderTextStyle,
                      ),
                      _generateCenterAlignedTextWidget(
                        'Debit Account',
                        columnHeaderTextStyle,
                      ),
                      _generateCenterAlignedTextWidget(
                        'Credit Account',
                        columnHeaderTextStyle,
                      ),
                      _generateCenterAlignedTextWidget(
                        'Amount',
                        columnHeaderTextStyle,
                      ),
                    ]),
                    ..._getTableRowsWidgetList(currentTransactionsList),
                  ],
                );
              },
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startTransactionEntryProcedure,
        child: const Icon(Icons.add),
      ),
    );
  }
}
