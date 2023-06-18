import 'package:flutter/material.dart';

import '../../../helpers/network_request_maker.dart';

class OwnerEquityScreen extends StatelessWidget {
  OwnerEquityScreen({Key? key}) : super(key: key);

  double originalOwnerEquity = 0.0;
  double netIncome = 0.0;
  double ownerWithdrawals = 0.0;
  double newOwnerEquity = 0.0;

  Future _loadOwnerEquityDataFromServer() async {
    try {
      final trialBalanceData = await NetworkRequestMaker.getResponseInJson(
          'generateOwnerEquityStatement');
      originalOwnerEquity =
          double.parse(trialBalanceData['ownerEquity'].toString());
      netIncome = double.parse(trialBalanceData['netIncome'].toString());
      ownerWithdrawals =
          double.parse(trialBalanceData['ownerWithdrawals'].toString());
      newOwnerEquity =
          double.parse(trialBalanceData['newOwnerEquity'].toString());
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trial Balance')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _loadOwnerEquityDataFromServer(),
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
                  TableRow(children: [
                    const Text('Beginning Balance of Owner Capital'),
                    Text(
                      '$originalOwnerEquity',
                      textAlign: TextAlign.right,
                    ),
                  ]),
                  TableRow(children: [
                    const Text('Net Income'),
                    Text(
                      netIncome.isNegative
                          ? '(${netIncome.toString().substring(1)})'
                          : '$netIncome',
                      textAlign: TextAlign.right,
                    ),
                  ]),
                  TableRow(children: [
                    const Text('Owner Withdrawals'),
                    Text(
                      '($ownerWithdrawals)',
                      textAlign: TextAlign.right,
                    ),
                  ]),
                  const TableRow(children: [
                    Text(''),
                    Text(''),
                  ]),
                  TableRow(children: [
                    const Text(
                      'Ending Balance Owner Equity',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                        newOwnerEquity.isNegative
                            ? '(${newOwnerEquity.toString().substring(1)})'
                            : '$newOwnerEquity',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
