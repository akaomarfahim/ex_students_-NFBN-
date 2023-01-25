import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

import '../__text_styles.dart';

myTextBox(
        {required TextEditingController controller,
        int maxLine = 1,
        int minLines = 1,
        bool enable = true,
        bool obsecureText = false,
        bool required = true,
        bool keyValueCheckFirebase = false,
        bool numbersOnly = false,
        Color? backgroundColor = Colors.white70,
        Color? floatingLabelColor,
        Color? labelColor,
        Color? prefixIconColor,
        String? hint,
        String? label,
        String? denyCharsString = '',
        String? customErrorText,
        double borderRadius = 6,
        IconData? prefixIcon,
        String? Function(String?)? customValidate,
        void Function(String)? onChanged,
        Widget? suffixIcon,
        EdgeInsets? padding = const EdgeInsets.all(8),
        EdgeInsets? margin = const EdgeInsets.only(bottom: 6),
        TextInputType textInputType = TextInputType.multiline,
        TextInputAction? textInputAction,
        InputBorder? inputBorder = InputBorder.none,
        TextAlign textAlign = TextAlign.start,
        TextStyle textStyle = TextStyleFor.photoSlideTextField}) =>
    Container(
      margin: margin,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: TextFormField(
              controller: controller,
              keyboardType: textInputType,
              minLines: minLines,
              maxLines: maxLine,
              enableIMEPersonalizedLearning: true,
              enableInteractiveSelection: true,
              enableSuggestions: true,
              enabled: enable,
              readOnly: !enable,
              onChanged: onChanged,
              textAlign: textAlign,
              obscureText: obsecureText,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: textInputAction,
              style: textStyle,
              validator: (customValidate == null)
                  ? (value) => (required && value.isEmptyOrNull)
                      ? 'field must be filled'
                      : (value!.contains(RegExp(keyValueCheckFirebase ? '[\\. | \\[ | \\] | \\# | \$ ]' : denyCharsString ?? '')) && keyValueCheckFirebase)
                          ? 'value must not containes $denyCharsString'
                          : (customErrorText != null)
                              ? customErrorText
                              : null
                  : customValidate,
              inputFormatters: numbersOnly
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : [FilteringTextInputFormatter.deny(RegExp(keyValueCheckFirebase ? '[\\. | \\[ | \\] | \\# | \$ ]' : denyCharsString ?? ''))],
              decoration: InputDecoration(
                  // if level is givent;. OnClick => label and text doesn't align with the icon verticaly peroperly.
                  hintText: hint,
                  labelText: label,
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(color: labelColor),
                  // floatingLabelBehavior: FloatingLabelBehavior.never,
                  floatingLabelStyle: TextStyle(color: floatingLabelColor, fontFamily: 'Nunito', fontSize: 13, fontWeight: FontWeight.bold),
                  isCollapsed: true,
                  hintMaxLines: 1,
                  errorMaxLines: 1,
                  isDense: true,
                  prefixIcon: Icon(prefixIcon),
                  prefixIconColor: prefixIconColor,
                  prefixIconConstraints: (prefixIcon != null) ? const BoxConstraints.tightFor(width: 35) : const BoxConstraints.tightFor(width: 10),
                  contentPadding: padding,
                  fillColor: backgroundColor,
                  filled: (backgroundColor != null) ? true : false,
                  border: inputBorder,
                  // alignLabelWithHint: true,
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  enabled: true,
                  suffixIcon: (suffixIcon == null)
                      ? IconButton(onPressed: () => {controller.clear(), HapticFeedback.mediumImpact()}, icon: Icon(Icons.clear_rounded, size: 18, color: Colors.red.shade800))
                      : suffixIcon))),
    );
