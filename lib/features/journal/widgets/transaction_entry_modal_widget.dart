import 'package:flutter/material.dart';

import '../../t_account/models/account.dart';

class TransactionEntryModalWidget extends StatefulWidget {
  static const TextStyle _textStyleForModalSheet = TextStyle(
    fontSize: 21.0,
    fontWeight: FontWeight.bold,
  );

  final List<Account> accountsList;
  final Function(String, String, String, String, double) performTransaction;

  TransactionEntryModalWidget(
      {required this.accountsList, required this.performTransaction, Key? key})
      : super(key: key);

  @override
  State<TransactionEntryModalWidget> createState() =>
      _TransactionEntryModalWidgetState();
}

class _TransactionEntryModalWidgetState
    extends State<TransactionEntryModalWidget> {
  final TextEditingController amountController = TextEditingController();

  String debitEntryAccountIdValue = '';
  String debitEntryTypeValue = 'normal';

  String creditEntryAccountIdValue = '';
  String creditEntryTypeValue = 'normal';

  List<DropdownMenuItem> _getAccountDropdownItems(List<Account> accountList) {
    List<DropdownMenuItem> dropdownItemList = [];

    for (final account in accountList) {
      DropdownMenuItem dropdownItem = DropdownMenuItem(
        value: account.id,
        child: Text(account.accountName),
      );

      dropdownItemList.add(dropdownItem);
    }

    return dropdownItemList;
  }

  DropdownButton _getAccountDropDownButton(
    List<Account> accountList,
    String selectedValue,
    Function(dynamic)? onChanged,
  ) {
    if (accountList.isNotEmpty) {
      return DropdownButton(
        items: _getAccountDropdownItems(widget.accountsList),
        onChanged: onChanged,
        value: selectedValue,
      );
    }

    return DropdownButton(
      items: null,
      onChanged: null,
      value: null,
      disabledHint: const Text('No Accounts'),
    );
  }

  DropdownButton _getEntryTypeDropdownButton(
    String entryTypeValue,
    Function(dynamic)? onChanged,
  ) {
    return DropdownButton(
      items: const [
        DropdownMenuItem(
          value: 'normal',
          child: Text('Normal'),
        ),
        DropdownMenuItem(
          value: 'adjusting',
          child: Text('Adjusting'),
        ),
      ],
      onChanged: onChanged,
      value: entryTypeValue,
    );
  }

  ElevatedButton _getCreateTransactionButton() {
    final Function()? onPressedCallback;

    if (debitEntryAccountIdValue.isEmpty ||
        creditEntryAccountIdValue.isEmpty ||
        debitEntryTypeValue.isEmpty ||
        creditEntryTypeValue.isEmpty ||
        amountController.text.isEmpty) {
      onPressedCallback = null;
    } else {
      onPressedCallback = () => widget.performTransaction(
            debitEntryAccountIdValue,
            creditEntryAccountIdValue,
            debitEntryTypeValue,
            creditEntryTypeValue,
            double.parse(amountController.text),
          );
    }

    return ElevatedButton(
      onPressed: onPressedCallback,
      child: const Text('Create Transaction'),
    );
  }

  @override
  void initState() {
    creditEntryAccountIdValue =
        widget.accountsList.isEmpty ? '' : widget.accountsList[0].id;
    debitEntryAccountIdValue =
        widget.accountsList.isEmpty ? '' : widget.accountsList[0].id;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Debit',
            style: TransactionEntryModalWidget._textStyleForModalSheet,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getAccountDropDownButton(
                widget.accountsList,
                debitEntryAccountIdValue,
                (newValue) {
                  debitEntryAccountIdValue = newValue;
                  setState(() {});
                },
              ),
              _getEntryTypeDropdownButton(
                debitEntryTypeValue,
                (newValue) {
                  debitEntryTypeValue = newValue;
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Credit',
            style: TransactionEntryModalWidget._textStyleForModalSheet,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getAccountDropDownButton(
                widget.accountsList,
                creditEntryAccountIdValue,
                (newValue) {
                  creditEntryAccountIdValue = newValue;
                  setState(() {});
                },
              ),
              _getEntryTypeDropdownButton(
                creditEntryTypeValue,
                (newValue) {
                  creditEntryTypeValue = newValue;
                  setState(() {});
                },
              ),
            ],
          ),
          const Divider(
            height: 80.0,
            thickness: 2.0,
            color: Colors.black,
          ),
          Row(
            children: [
              const Text('Amount: '),
              const SizedBox(width: 10.0),
              SizedBox(
                width: 100.0,
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                ),
              )
            ],
          ),
          const Expanded(child: SizedBox.shrink()),
          Align(
            alignment: Alignment.center,
            child: _getCreateTransactionButton(),
          ),
        ],
      ),
    );
  }
}
