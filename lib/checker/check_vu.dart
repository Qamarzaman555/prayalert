import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/reminder_model.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 50,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.5),
          color: value ? AppColors.selectedSwitchColor : AppColors.greyColor,
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(2.5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Checker extends StatefulWidget {
  final bool onOff;
  final Timestamp timestamp;
  final String id;
  final Function(bool) onToggle;

  const Checker({
    super.key,
    required this.onOff,
    required this.timestamp,
    required this.id,
    required this.onToggle,
  });

  @override
  State<Checker> createState() => _CheckerState();
}

class _CheckerState extends State<Checker> {
  @override
  Widget build(BuildContext context) {
    return CustomSwitch(
      value: widget.onOff,
      onChanged: (bool value) {
        ReminderModel reminderModel = ReminderModel();
        reminderModel.onOff = value;
        reminderModel.timestamp = widget.timestamp;

        FirebaseFirestore.instance
            .collection('Notifications')
            .doc(widget.id)
            .update(reminderModel.toJson())
            .then((_) {
          widget.onToggle(value);
        });
      },
    );
  }
}
