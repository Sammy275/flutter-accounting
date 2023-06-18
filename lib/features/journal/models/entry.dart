import '../../t_account/models/account.dart';

class Entry {
  final String id;
  final Account? accountDetail;
  final String entryType;
  final double amount;
  final bool isDebit;

  const Entry({
    required this.id,
    required this.accountDetail,
    required this.entryType,
    required this.amount,
    required this.isDebit,
  });

  factory Entry.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return Entry(id: '23', accountDetail: null, entryType: '23', amount: 0.0, isDebit: true);
    }
    return Entry(
      id: map['entry_id'],
      accountDetail: Account.fromMap(map['Account']),
      entryType: map['entry_type'],
      amount: double.parse(map['amount']),
      isDebit: map['transaction_type'] == 'Debit',
    );
  }
}