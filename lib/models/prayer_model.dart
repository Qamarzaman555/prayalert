import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerModel {
  String? prayerName;
  Timestamp? timestamp;
  bool? onOff;
  int? sortOrder;

  PrayerModel({
    this.prayerName,
    this.timestamp,
    this.onOff,
    this.sortOrder,
  });

  PrayerModel.fromJson(Map<String, dynamic> json) {
    prayerName = json['prayerName'];
    timestamp = json['timestamp'];
    onOff = json['onOff'];
    sortOrder = json['sortOrder'];
  }

  Map<String, dynamic> toJson() {
    return {
      'prayerName': prayerName,
      'timestamp': timestamp,
      'onOff': onOff,
      'sortOrder': sortOrder,
    };
  }
}
