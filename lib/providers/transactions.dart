import 'package:flutter/material.dart';

import '../features/journal/models/transaction.dart';
import '../helpers/network_request_maker.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _currentTransactionList = [];
  List<Transaction> _allTransactionList = [];

  List<Transaction> get currentTransactionList {
    return [..._currentTransactionList];
  }

  List<Transaction> get allTransactionList {
    _allTransactionList.sort((prevTransaction, nextTransaction) => prevTransaction.transactionDate.compareTo(nextTransaction.transactionDate));
    return [..._allTransactionList];
  }

  Future loadCurrentJournalEntriesFromServer() async {
    try {
      final data = await NetworkRequestMaker.getResponseInJson(
        'journalEntry/current-entries',
      ) as List<dynamic>;

      _currentTransactionList =
          data.map((transaction) => Transaction.fromMap(transaction)).toList();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      throw Exception(error);
    }
  }

  Future loadAllJournalEntriesFromServer() async {
    try {
      final data = await NetworkRequestMaker.getResponseInJson(
        'journalEntry/all-entries',
      ) as List<dynamic>;

      if (data != null) {
        _allTransactionList =
            data.map((transaction) => Transaction.fromMap(transaction)).toList();
      }

    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      throw Exception(error);
    }
  }
}