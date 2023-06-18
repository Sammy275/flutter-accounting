import '../../t_account/models/account.dart';

class Entry {
  final String id;
  final Account? accountDetail;
  final String entryType;
  final String transactionType;
  final double amount;
  final bool isDebit;

  const Entry({
    required this.id,
    required this.accountDetail,
    required this.entryType,
    required this.transactionType,
    required this.amount,
    required this.isDebit,
  });

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      id: map['id'].toString(),
      accountDetail: Account.fromMap(map['Account']),
      entryType: map['entry_type'],
      transactionType: map['transaction_type'],
      amount: double.parse(map['amount']),
      isDebit: map['transaction_type'] == 'Debit',
    );
  }
}