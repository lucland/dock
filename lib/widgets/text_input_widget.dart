import 'package:dockcheck_web/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/theme.dart';

class TextInputWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final void Function(String)? onSubmit;
  final bool isRequired;
  final bool isError;
  final bool isPassword;
  final bool isEnabled; // New parameter
  final String? errorMessage;
  final void Function(String)? onChanged;

  const TextInputWidget({
    Key? key,
    this.title = '',
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.onSubmit,
    this.isRequired = false,
    this.isError = false,
    this.isPassword = false,
    this.isEnabled = true, // Default value set to true
    this.errorMessage,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color borderColor = isError ? DockColors.danger110 : DockColors.iron100;
    if (!isEnabled) {
      borderColor =
          Colors.grey; // Change the borderColor when it is not enabled
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != '')
          Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: DockTheme.h2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isRequired)
                Text(
                  '*',
                  style: DockTheme.h2.copyWith(color: DockColors.danger100),
                ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 11.5),
              hintText: title,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
              errorText: isError ? errorMessage : null,
            ),
            cursorColor: DockColors.iron100,
            keyboardType: keyboardType,
            controller: controller,
            obscureText: isPassword,
            onSubmitted: onSubmit ?? (value) {},
            onChanged:
                isEnabled ? onChanged : null, // Disable input if not enabled
            enabled: isEnabled, // Use the isEnabled parameter
          ),
        ),
      ],
    );
  }
}
