import '../__colors.dart';
import '../__text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget_default/__button.dart';
import '../widget_default/__textbox.dart';

Future<bool?> homeExitDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('you want to exit from this application.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('No')),
          TextButton(onPressed: () => SystemNavigator.pop(), child: const Text('Yes')),
        ],
      ),
    );

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  bool barrierDismissible = true,
  String title = 'Are you sure?',
  String? data1 = '',
  String? data2 = '',
  String buttonLabel1 = 'cancel',
  String buttonLabel2 = 'confirm',
  bool hideCancelButton = false,
}) async {
  bool? confirm;
  await showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title, style: TextStyle(fontFamily: 'RobotoSlab', fontSize: 14)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 26),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            content: SingleChildScrollView(
                child: ListBody(children: [
              if (data1 != null) Text(data1, style: TextStyleFor.dialogdescription),
              if (data2 != null) Text(data2, style: TextStyleFor.dialogdescription),
            ])),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!hideCancelButton)
                    Expanded(
                        child: myButton(
                            label: buttonLabel1,
                            elevation: 0,
                            isLoadingComplete: true,
                            background: MyColors.negative,
                            splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                            action: () {
                              confirm = false;
                              Navigator.pop(context);
                            })),
                  if (!hideCancelButton) const SizedBox(width: 10),
                  Expanded(
                      child: myButton(
                          label: buttonLabel2,
                          elevation: 0,
                          isLoadingComplete: true,
                          background: MyColors.positive,
                          splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                          action: () {
                            confirm = true;
                            Navigator.pop(context);
                          }))
                ],
              )
            ]);
      });

  return confirm;
}

Future<String> showTextBoxDialog(
    {required BuildContext context,
    String presetValue = '',
    bool keyValueCheckFirebase = false,
    bool barrierDismissible = true,
    String? title,
    String data = '',
    String textBoxHint = ''}) async {
  String value = presetValue;
  final valueController = TextEditingController();
  valueController.text = value;

  await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title ?? '', style: TextStyleFor.dialogTitle),
            // titlePadding: (title != null) ? const EdgeInsets.only(top: 20, left: 16) : EdgeInsets.zero,
            // contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            // buttonPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            actionsPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            content: SingleChildScrollView(
                child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: ListBody(children: [
                Text(
                  data,
                  style: TextStyleFor.dialogdescription,
                ),
                const SizedBox(height: 10),
                myTextBox(
                    controller: valueController,
                    required: true,
                    keyValueCheckFirebase: keyValueCheckFirebase,
                    maxLine: 1,
                    minLines: 1,
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    hint: textBoxHint,
                    backgroundColor: Colors.white,
                    borderRadius: 4,
                    textStyle: const TextStyle(fontFamily: 'RobotoSlab', fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, fontSize: 14),
                    inputBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 0.1)))
              ]),
            )),
            actions: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Expanded(
                    child: myButton(
                        label: 'CANCEL',
                        elevation: 0,
                        borderRadius: 0,
                        isLoadingComplete: true,
                        background: MyColors.negative,
                        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                        action: () {
                          Navigator.pop(context);
                        })),
                Expanded(
                    child: myButton(
                        label: 'SAVE',
                        elevation: 0,
                        borderRadius: 0,
                        isLoadingComplete: true,
                        background: MyColors.positive,
                        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                        action: () {
                          value = valueController.text;
                          Navigator.pop(context);
                        }))
              ])
            ]);
      });
  return value;
}
