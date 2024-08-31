import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'bill.dart';

class SharedPrefsHelper {
  static const String _billsKey = 'bills';

  static Future<void> saveBills(List<Bill> bills) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(bills.map((bill) => bill.toJson()).toList());
    await prefs.setString(_billsKey, jsonData);
  }

  static Future<List<Bill>?> loadBills() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_billsKey);
    if (jsonData != null) {
      final List<dynamic> data = jsonDecode(jsonData);
      return data.map((billJson) => Bill.fromJson(billJson)).toList();
    }
    return null;
  }
}
