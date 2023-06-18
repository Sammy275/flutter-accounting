import 'package:flutter/material.dart';

import '../../journal/models/transaction.dart';

class TAccountSummaryDisplayWidget extends StatelessWidget {
  final String accountId;
  final List<Transaction> transactionsList;
  const TAccountSummaryDisplayWidget(this.accountId, this.transactionsList,
      {Key? key})
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Builder(builder: (context) {
            final transactionSummaryList =
                _getTransactionsSummaryOfAccount(accountId, transactionsList);

            TextStyle columnHeaderTextStyle = const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            );

            return Table(
                border: TableBorder.all(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(3.0),
                ),
                children: [
                  TableRow(children: [
                    _generateCenterAlignedTextWidget(
                        'Debit', columnHeaderTextStyle),
                    _generateCenterAlignedTextWidget(
                        'Credit', columnHeaderTextStyle),
                  ]),
                  ..._generateTransactionSummaryTableRowList(
                      transactionSummaryList),
                ]);
          }),
        ),
      ),
    );
  }
}
