import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../journal/models/entry.dart';
import '../../journal/models/transaction.dart';

import '../../../providers/transactions.dart';

class TAccountSummaryDisplayWidget extends StatelessWidget {
  final String accountId;

  const TAccountSummaryDisplayWidget(this.accountId, {Key? key})
      : super(key: key);

  List<Map<String, dynamic>> _getTransactionsSummaryOfAccount(
    String accountId,
    List<Transaction> transactionList,
  ) {
    final List<Map<String, dynamic>> transactionSummaryList = [];

    for (final transaction in transactionList) {
      Map<String, dynamic> transactionSummary = {};

      final String accountIdOfDebitEntry =
          transaction.debitEntry?.accountDetail?.id ?? '';
      final String accountIdOfCreditEntry =
          transaction.creditEntry?.accountDetail?.id ?? '';

      if (accountIdOfDebitEntry == accountId) {
        transactionSummary['debit'] = transaction.debitEntry!.amount;
        transactionSummary['credit'] = '---';
        transactionSummaryList.add(transactionSummary);
      } else if (accountIdOfCreditEntry == accountId) {
        transactionSummary['debit'] = '---';
        transactionSummary['credit'] = transaction.creditEntry!.amount;
        transactionSummaryList.add(transactionSummary);
      }
    }

    return transactionSummaryList;
  }

  List<TableRow> _generateTransactionSummaryTableRowList(
      List<Map<String, dynamic>> transactionSummaryList) {
    List<TableRow> tableRowList = [];

    for (final transactionSummary in transactionSummaryList) {
      tableRowList.add(
        TableRow(children: [
          _generateCenterAlignedTextWidget(
              transactionSummary['debit'].toString()),
          _generateCenterAlignedTextWidget(
              transactionSummary['credit'].toString()),
        ]),
      );
    }

    return tableRowList;
  }

  Text _generateCenterAlignedTextWidget(String text, [TextStyle? textStyle]) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: textStyle,
    );
  }

  List<Entry> getFilteredEntries(
      String transactionType, List<Entry> entryList) {
    List<Entry> filteredEntryList = [];

    for (final entry in entryList) {
      if (entry.transactionType.toLowerCase() == transactionType) {
        filteredEntryList.add(entry);
      }
    }

    return filteredEntryList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Builder(builder: (context) {
            TransactionProvider transactionProvider =
                Provider.of<TransactionProvider>(context, listen: false);

            return FutureBuilder(
              future: transactionProvider.getAllEntriesByAccount(accountId),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Entry> accountEntryList = snapshot.data!;
                List<Entry> debitEntryList =
                    getFilteredEntries('debit', accountEntryList);
                List<Entry> creditEntryList =
                    getFilteredEntries('credit', accountEntryList);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Debit',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ...debitEntryList
                            .map(
                              (entry) => Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text(
                                  entry.amount.toString(),
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Credit',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ...creditEntryList
                            .map(
                              (entry) => Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text(
                                  entry.amount.toString(),
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
