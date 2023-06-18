import './entry.dart';

/// A PODO class to represent journal entries
class Transaction {
  final int id;
  final DateTime transactionDate;
  final Entry? creditEntry;
  final Entry? debitEntry;

  /// Constructor for [Transaction]
  const Transaction({
    required this.id,
    required this.transactionDate,
    required this.creditEntry,
    required this.debitEntry,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['transaction_id'],
      transactionDate: DateTime.parse(map['transaction_date']),
      creditEntry: Entry.fromMap(map['entries'][0]),
      debitEntry: Entry.fromMap(map['entries'][1]),
    );
  }
}