import 'package:flutter/material.dart';

import '../../t_account/models/account.dart';
import '../../../helpers/network_request_maker.dart';

class IncomeStatementScreen extends StatelessWidget {
  IncomeStatementScreen({Key? key}) : super(key: key);

  List<IncomeStatementEntity> _expenseEntitiesList = [];
  List<IncomeStatementEntity> _revenueEntitiesList = [];

  double totalRevenue = 0.0;
  double totalExpense = 0.0;
  double netIncome = 0.0;

  Future _loadIncomeStatementDataFromServer() async {
    try {
      final trialBalanceData = await NetworkRequestMaker.getResponseInJson(
          'generateIncomeStatement');
      totalExpense = double.parse(trialBalanceData['expenses'].toString());
      totalRevenue = double.parse(trialBalanceData['revenue'].toString());
      netIncome = double.parse(trialBalanceData['netIncome'].toString());

      _expenseEntitiesList = (trialBalanceData['entities']['expense'] as List)
          .map((incomeStatementEntity) =>
              IncomeStatementEntity.fromMap(incomeStatementEntity))
          .toList();
      _revenueEntitiesList = (trialBalanceData['entities']['revenue'] as List)
          .map((incomeStatementEntity) =>
              IncomeStatementEntity.fromMap(incomeStatementEntity))
          .toList();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      rethrow;
    }
  }

  List<TableRow> _getIncomeStatementEntityTableRowList(
      List<IncomeStatementEntity> incomeStatementEntitiesList) {
    List<TableRow> incomeStatementEntryTableRowList = [];

    for (final incomeStatementEntity in incomeStatementEntitiesList) {
      incomeStatementEntryTableRowList.add(TableRow(children: [
        Text(
          incomeStatementEntity.account.accountName,
        ),
        Text(
          incomeStatementEntity.amount.toString(),
          textAlign: TextAlign.right,
        ),
      ]));
    }

    return incomeStatementEntryTableRowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Income Statement')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _loadIncomeStatementDataFromServer(),
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
                        'Expense',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ..._getIncomeStatementEntityTableRowList(_expenseEntitiesList),
                  TableRow(
                    children: [
                      const Text(
                        'Total Expense',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        totalExpense.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const TableRow(
                    children: [
                      Text(
                        '',
                      ),
                      Text(
                        '',
                      ),
                    ],
                  ),

                  const TableRow(
                    children: [
                      Text(
                        'Revenue',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ..._getIncomeStatementEntityTableRowList(_revenueEntitiesList),
                  TableRow(
                    children: [
                      const Text(
                        'Total Revenue',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        totalRevenue.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const TableRow(
                    children: [
                      Text(
                        '',
                      ),
                      Text(
                        '',
                      ),
                    ],
                  ),

                  TableRow(
                    children: [
                      const Text(
                        'Net Income',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        netIncome.isNegative
                            ? '(${netIncome.toString().substring(1)})'
                            : '$netIncome',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
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

class IncomeStatementEntity {
  final Account account;
  final double amount;

  const IncomeStatementEntity({
    required this.account,
    required this.amount,
  });

  factory IncomeStatementEntity.fromMap(Map<String, dynamic> map) {
    return IncomeStatementEntity(
      account: Account(
        id: map['account_id'],
        accountName: map['account_name'],
        accountType: map['account_type'],
      ),
      amount: double.parse(map['amount'].toString()),
    );
  }
}
