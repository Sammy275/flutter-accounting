class Account {
  final String id;
  final String accountName;
  final String accountType;

  const Account({
    required this.id,
    required this.accountName,
    required this.accountType,
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['account_id'].toString(),
      accountName: map['account_name'],
      accountType: map['account_type'],
    );
  }
}
