import 'package:flutter/material.dart';

import '../helpers/network_request_maker.dart';
import '../features/t_account/models/account.dart';

class AccountProvider extends ChangeNotifier {
  List<Account> _accountsList = [];

  List<Account> get accountsList {
    return [..._accountsList];
  }

  Future loadAccountsFromServer() async {
    try {
      final accountsData = await NetworkRequestMaker.getResponseInJson('accounts/getAccounts') as List;
      _accountsList = accountsData.map((accountJsonObject) => Account.fromMap(accountJsonObject)).toList();

      notifyListeners();
    }
    catch (error) {
      rethrow;
    }
  }
}
