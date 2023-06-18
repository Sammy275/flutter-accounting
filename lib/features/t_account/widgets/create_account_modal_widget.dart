import 'package:flutter/material.dart';

class CreateAccountModalWidget extends StatefulWidget {
  final Function(String accountName, String accountType) createAccountCallBack;
  const CreateAccountModalWidget(
      {required this.createAccountCallBack, Key? key})
      : super(key: key);

  @override
  State<CreateAccountModalWidget> createState() =>
      _CreateAccountModalWidgetState();
}

class _CreateAccountModalWidgetState extends State<CreateAccountModalWidget> {
  TextEditingController accountNameController = TextEditingController();
  String accountTypeValue = 'asset';

  ElevatedButton _getCreateAccountElevatedButton() {
    final Function()? onPressedCallback;

    if (accountNameController.text.isEmpty) {
      onPressedCallback = null;
    } else {
      onPressedCallback = () => widget.createAccountCallBack(
            accountNameController.text,
            accountTypeValue,
          );
    }

    return ElevatedButton(
      onPressed: onPressedCallback,
      child: const Text('Create Account'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 150.0,
                child: TextField(
                  controller: accountNameController,
                  decoration:
                      const InputDecoration(label: Text('Account Name')),
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              DropdownButton(
                items: const [
                  DropdownMenuItem(
                    value: 'asset',
                    child: Text('Asset'),
                  ),
                  DropdownMenuItem(
                    value: 'contra_asset',
                    child: Text('Contra Asset'),
                  ),
                  DropdownMenuItem(
                    value: 'liability',
                    child: Text('Liability'),
                  ),
                  DropdownMenuItem(
                    value: 'expense',
                    child: Text('Expense'),
                  ),
                  DropdownMenuItem(
                    value: 'revenue',
                    child: Text('Revenue'),
                  ),
                  DropdownMenuItem(
                    value: 'owner_capital',
                    child: Text('Owner Capital'),
                  ),
                  DropdownMenuItem(
                    value: 'owner_drawings',
                    child: Text('Owner Withdrawal'),
                  ),
                ],
                onChanged: (selectedAccountTypeValue) {
                  accountTypeValue = selectedAccountTypeValue!;
                  setState(() {});
                },
                value: accountTypeValue,
              ),
            ],
          ),
          const Expanded(child: SizedBox.shrink()),
          _getCreateAccountElevatedButton(),
        ],
      ),
    );
  }
}
