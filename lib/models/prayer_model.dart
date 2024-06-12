import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerModel {
  String? prayerName;
  Timestamp? timestamp;
  bool? onOff;
  int? sortOrder;
  int? minutesBefore;

  PrayerModel({
    this.prayerName,
    this.timestamp,
    this.onOff,
    this.sortOrder,
    this.minutesBefore,
  });

  PrayerModel.fromJson(Map<String, dynamic> json) {
    prayerName = json['prayerName'];
    timestamp = json['timestamp'];
    onOff = json['onOff'];
    sortOrder = json['sortOrder'];
    minutesBefore = json['minutesBefore'];
  }

  Map<String, dynamic> toJson() {
    return {
      'prayerName': prayerName,
      'timestamp': timestamp,
      'onOff': onOff,
      'sortOrder': sortOrder,
      'minutesBefore': minutesBefore,
    };
  }
}
