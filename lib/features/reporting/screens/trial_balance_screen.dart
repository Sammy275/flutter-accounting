import 'package:flutter/material.dart';

import '../../t_account/models/account.dart';

import '../../../helpers/network_request_maker.dart';

class TrialBalanceScreen extends StatelessWidget {
  TrialBalanceScreen({Key? key}) : super(key: key);

  List<TrialBalanceEntry> trialBalanceEntryList = [];
  double totalDebit = 0.0;
  double totalCredit = 0.0;

  Future _loadTrialBalanceDataFromServer() async {
    try {
      final trialBalanceData =
          await NetworkRequestMaker.getResponseInJson('trialBalance');
      totalDebit =
          double.parse(trialBalanceData['transactions']['debit'].toString());
      totalCredit =
          double.parse(trialBalanceData['transactions']['credit'].toString());
      final rawTrialBalanceEntryList =
          trialBalanceData['trialBalanceEntries'] as List;
      trialBalanceEntryList = rawTrialBalanceEntryList
          .map((trialBalanceEntry) =>
              TrialBalanceEntry.fromMap(trialBalanceEntry))
          .toList();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      rethrow;
    }
  }

  List<TableRow> _getTrialBalanceEntryTableRowList(
      List<TrialBalanceEntry> trialBalanceEntryList) {
    List<TableRow> trialBalanceEntryTableRowList = [];
    for (final trialBalanceEntry in trialBalanceEntryList) {
      if (trialBalanceEntry.isDebit) {
        trialBalanceEntryTableRowList.add(TableRow(children: [
          Text(
            trialBalanceEntry.account.accountName,
          ),
          Text(
            trialBalanceEntry.balance.toString(),
            textAlign: TextAlign.center,
          ),
          const Text(
            '---',
            textAlign: TextAlign.center,
          ),
        ]));
      } else {
        trialBalanceEntryTableRowList.add(TableRow(children: [
          Text(
            trialBalanceEntry.account.accountName,
          ),
          const Text(
            '---',
            textAlign: TextAlign.center,
          ),
          Text(
            trialBalanceEntry.balance.toString(),
            textAlign: TextAlign.center,
          ),
        ]));
      }
    }
    return trialBalanceEntryTableRowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trial Balance')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _loadTrialBalanceDataFromServer(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                child:
                    Text('Could not generate trial balance. Please try again'),
              );
            }

            return SingleChildScrollView(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  const TableRow(
                    children: [
                      Text(
                        'Account',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Debit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Credit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const TableRow(
                    children: [
                      Text(''),
                      Text(''),
                      Text(''),
                    ],
                  ),

                  ..._getTrialBalanceEntryTableRowList(trialBalanceEntryList),

                  const TableRow(
                    children: [
                      Text(''),
                      Text(''),
                      Text(''),
                    ],
                  ),

                  TableRow(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        totalDebit.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        totalCredit.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TrialBalanceEntry {
  final Account account;
  final double balance;
  final bool isDebit;

  const TrialBalanceEntry(
      {required this.account, required this.balance, required this.isDebit});

  factory TrialBalanceEntry.fromMap(Map<String, dynamic> map) {
    return TrialBalanceEntry(
      account: Account(
        id: map['account_id'],
        accountName: map['account_name'],
        accountType: map['account_type'],
      ),
      balance: double.parse(map['balance'].toString()),
      isDebit: map['is_debit'],
    );
  }
}
