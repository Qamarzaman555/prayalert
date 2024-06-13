import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class Utils {
  static toastMessage(
      {required BuildContext context,
      required String text,
      IconData icon = Icons.info}) {
    try {
      DelightToastBar(
        autoDismiss: true,
        position: DelightSnackbarPosition.top,
        builder: (context) {
          return ToastCard(
            leading: Icon(
              icon,
              size: 28,
            ),
            title: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          );
        },
      ).show(context);
    } catch (e) {
      return e;
    }
  }
}

Image customImage(String imagePath, {double? height, width}) {
  return Image(
    height: height ?? 20.0,
    width: width ?? 20.0,
    image: AssetImage(imagePath),
  );
}

extension EmptySpace on num {
  SizedBox get spaceY => SizedBox(
        height: toDouble(),
      );
  SizedBox get spaceX => SizedBox(
        width: toDouble(),
      );
}
