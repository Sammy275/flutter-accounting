import 'dart:convert';

import 'package:accounting_app/features/t_account/widgets/t_account_summary_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/create_account_modal_widget.dart';

import '../../journal/models/transaction.dart';

import '../../../common/widgets/main_drawer.dart';
import '../../../helpers/network_request_maker.dart';
import '../../../providers/accounts.dart';
import '../../../providers/transactions.dart';

class DisplayAccountMainScreen extends StatefulWidget {
  static const routeName = 't-account-main-screen/';
  const DisplayAccountMainScreen({Key? key}) : super(key: key);

  @override
  State<DisplayAccountMainScreen> createState() =>
      _DisplayAccountMainScreenState();
}

class _DisplayAccountMainScreenState extends State<DisplayAccountMainScreen> {
  void _createNewAccountInDatabase(
      String accountName, String accountType) async {
    if (accountName.isEmpty || accountType.isEmpty) {
      return;
    }

    final postRequestDataBody = json.encode({
      'accountName': accountName,
      'accountType': accountType,
    });

    try {
      await NetworkRequestMaker.postJsonDataInRequest(
          'accounts/createAccount', postRequestDataBody);
    } catch (error) {
      print(error);
    }

    setState(() {});

    Navigator.of(context).pop();
  }

  void _startNewAccountCreationProcess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => CreateAccountModalWidget(
          createAccountCallBack: _createNewAccountInDatabase),
    );
  }

  void _openTAccountDisplayWidget(
    String accountIdOfTappedTile,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => TAccountSummaryDisplayWidget(
          accountIdOfTappedTile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      drawer: const MainDrawer(
          currentScreenName: DisplayAccountMainScreen.routeName),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Builder(builder: (context) {
          AccountProvider accountProvider =
              Provider.of<AccountProvider>(context, listen: false);

          return FutureBuilder(
            future: accountProvider.loadActiveAccountsFromServer(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasError) {
                return const Center(child: CircularProgressIndicator());
              }

              final accountsList = accountProvider.accountsList;
              accountsList.sort((prevAccount, nextAccount) =>
                  prevAccount.accountType.compareTo(nextAccount.accountType));

              return ListView.builder(
                itemCount: accountsList.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 2,
                        color: Colors.black26,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    title: Text(accountsList[index].accountName),
                    subtitle: Text(accountsList[index].accountType),
                    onTap: () => _openTAccountDisplayWidget(
                      accountsList[index].id,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewAccountCreationProcess(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
