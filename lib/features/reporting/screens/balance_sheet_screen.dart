import 'package:flutter/material.dart';

import '../../t_account/models/account.dart';
import '../../../helpers/network_request_maker.dart';

class BalanceSheetScreen extends StatelessWidget {
  BalanceSheetScreen({Key? key}) : super(key: key);

  List<BalanceSheetEntity> _assetEntitiesList = [];
  List<BalanceSheetEntity> _liabilitiesEntitiesList = [];

  double totalAssetAmount = 0.0;
  double totalLiabilitiesAmount = 0.0;
  double totalEquityAmount = 0.0;

  Future _loadBalanceSheetDataFromServer() async {
    try {
      final trialBalanceData =
          await NetworkRequestMaker.getResponseInJson('generateBalanceSheet');
      totalAssetAmount = double.parse(trialBalanceData['assets'].toString());
      totalLiabilitiesAmount =
          double.parse(trialBalanceData['liabilities'].toString());
      totalEquityAmount = double.parse(trialBalanceData['equity'].toString());

      _assetEntitiesList = (trialBalanceData['transactions']['assets'] as List)
          .map((incomeStatementEntity) =>
              BalanceSheetEntity.fromMap(incomeStatementEntity))
          .toList();
      _liabilitiesEntitiesList =
          (trialBalanceData['transactions']['liabilities'] as List)
              .map((incomeStatementEntity) =>
                  BalanceSheetEntity.fromMap(incomeStatementEntity))
              .toList();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      rethrow;
    }
  }

  List<TableRow> _getIncomeStatementEntityTableRowList(
      List<BalanceSheetEntity> balanceSheetEntitiesList) {
    List<TableRow> balanceSheetEntryTableRowList = [];

    for (final balanceSheetEntity in balanceSheetEntitiesList) {
      balanceSheetEntryTableRowList.add(TableRow(children: [
        Text(
          balanceSheetEntity.account.accountName,
          textAlign: TextAlign.center,
        ),
        Text(
          balanceSheetEntity.amount.toString(),
          textAlign: TextAlign.left,
        ),
      ]));
    }

    return balanceSheetEntryTableRowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Balance Sheet')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _loadBalanceSheetDataFromServer(),
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

            return ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('Assets', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('Liabilities', style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),

                const SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Table(
                        children: _getIncomeStatementEntityTableRowList(
                            _assetEntitiesList),
                      ),
                    ),
                    Expanded(
                      child: Table(
                        children: [..._getIncomeStatementEntityTableRowList(
                            _liabilitiesEntitiesList),
                        TableRow(
                          children: [
                           const Text('Ending OC'),
                            Text(totalEquityAmount.toString()),
                          ],
                        )],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),

                Row(
                  children: [
                    const Text('Total Assets', style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(width: 10.0),
                    Text(totalAssetAmount.toString(), style: const TextStyle(fontWeight: FontWeight.bold),),

                    // const Expanded(child: SizedBox.shrink()),
                    const SizedBox(width: 40.0),

                    const Text('Total Liabilities', style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(width: 10.0),
                    Text((totalLiabilitiesAmount + totalEquityAmount).toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BalanceSheetEntity {
  final Account account;
  final double amount;

  const BalanceSheetEntity({
    required this.account,
    required this.amount,
  });

  factory BalanceSheetEntity.fromMap(Map<String, dynamic> map) {
    return BalanceSheetEntity(
      account: Account(
        id: map['account_id'],
        accountName: map['account_name'],
        accountType: map['account_type'],
      ),
      amount: double.parse(map['amount'].toString()),
    );
  }
}
