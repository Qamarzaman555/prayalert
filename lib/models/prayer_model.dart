import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerModel {
  String? prayerName;
  Timestamp? timestamp;
  bool? onOff;

  PrayerModel({
    this.prayerName,
    this.timestamp,
    this.onOff,
  });

  PrayerModel.fromJson(Map<String, dynamic> json) {
    prayerName = json['prayerName'];
    timestamp = json['timestamp'];
    onOff = json['onOff'];
  }

  Map<String, dynamic> toJson() {
    return {
      'prayerName': prayerName,
      'timestamp': timestamp,
      'onOff': onOff,
    };
  }
}
