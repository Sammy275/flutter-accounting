import './entry.dart';

/// A PODO class to represent journal entries
class Transaction {
  final DateTime transactionDate;
  final Entry? creditEntry;
  final Entry? debitEntry;

  /// Constructor for [Transaction]
  const Transaction({
    required this.transactionDate,
    required this.creditEntry,
    required this.debitEntry,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionDate: DateTime.parse(map['date']),
      creditEntry: Entry.fromMap(map['credit']),
      debitEntry: Entry.fromMap(map['debit']),
    );
  }
}