class Bill {
  final String name;
  final double amount;
  final DateTime dueDate;
  final String vendorUPI;

  Bill({
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.vendorUPI,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        name: json['name'],
        amount: json['amount'],
        dueDate: DateTime.parse(json['dueDate']),
        vendorUPI: json['vendorUPI'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'dueDate': dueDate.toIso8601String(),
        'vendorUPI': vendorUPI,
      };
}
