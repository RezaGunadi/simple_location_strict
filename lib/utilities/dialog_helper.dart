import 'package:flutter/material.dart';


import '../components/dialog/custom_confirm_alrt_dialog.dart';

class DialogHelper {
  static Future<bool> customConfirmAlrt(context,
      {@required String title,
      @required String description,
      String aditionalDescription,
      @required String leftButtonLabel,
      @required String rightButtonLabel,
      bool confirmRightButton = true}) async {
    return await showDialog(
        context: context,
        builder: (context) => CustomConfirmAlrtDialog(
              title: title,
              description: description,
              aditionalDescription: aditionalDescription ?? '',
              leftButtonLabel: leftButtonLabel,
              rightButtonLabel: rightButtonLabel,
              confirmRightButton: confirmRightButton,
            ));
  }

}
