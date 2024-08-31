import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:upi_india/upi_india.dart';
import 'bill.dart';
import 'shared_prefs_helper.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class BillProvider with ChangeNotifier {
  List<Bill> _bills = [];

  List<Bill> get bills => _bills;

  void addBill(Bill bill) {
    _bills.add(bill);
    scheduleNotification(bill);
    SharedPrefsHelper.saveBills(_bills);
    notifyListeners();
  }

  void payBill(Bill bill) async {
    UpiIndia _upiIndia = UpiIndia();

    UpiResponse response = await _upiIndia.startTransaction(
      app: UpiApp.googlePay,
      receiverUpiId: bill.vendorUPI,
      receiverName: bill.name,
      transactionRefId: "Bill_${bill.name}_${DateTime.now().millisecondsSinceEpoch}",
      transactionNote: 'Bill Payment',
      amount: bill.amount,
    );

    if (response.status == UpiPaymentStatus.SUCCESS) {
      _bills.remove(bill);
      SharedPrefsHelper.saveBills(_bills);
      notifyListeners();
    }
  }

  void loadBills() async {
    _bills = await SharedPrefsHelper.loadBills() ?? [];
    notifyListeners();
  }

  void scheduleNotification(Bill bill) {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    tz.initializeTimeZones();

    // Convert dueDate to time zone-aware TZDateTime
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(bill.dueDate, tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'bill_reminder_channel', // id
      'Bill Reminder', // title
      channelDescription: 'Reminds you of upcoming bills', // description as a named argument
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

     flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Bill Reminder',
      'Your bill ${bill.name} is due soon',
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
  }
}
