import 'package:dockcheck_web/utils/colors.dart';
import 'package:dockcheck_web/utils/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../utils/formatter.dart';

class CalendarPickerWidget extends StatefulWidget {
  final String title;
  final bool isRequired;
  final TextEditingController controller;
  final void Function(DateTime) onChanged;
  final bool showAttachmentIcon;
  final bool showRemoveButton;
  final void Function()? onRemove;

  const CalendarPickerWidget(
      {Key? key,
      required this.title,
      this.isRequired = false,
      required this.controller,
      required this.onChanged,
      this.showAttachmentIcon = true,
      this.showRemoveButton = false,
      this.onRemove})
      : super(key: key);

  @override
  CalendarPickerWidgetState createState() => CalendarPickerWidgetState();
}

class CalendarPickerWidgetState extends State<CalendarPickerWidget> {
  String? attachedFileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final String fileName = result.files.first.name;
      setState(() {
        attachedFileName = fileName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != '')
          Row(
            children: [
              Flexible(
                child: Text(
                  widget.title,
                  style: DockTheme.h2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.isRequired)
                Text(
                  '*',
                  style: DockTheme.h2.copyWith(color: DockColors.danger100),
                ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      decoration: InputDecoration(
                        suffixIcon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: DockColors.slate100,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        hintText: widget.title,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: DockColors.slate100,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: DockColors.slate100,
                            width: 1.0,
                          ),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          widget.controller.text =
                              Formatter.formatDateTime(selectedDate);
                          widget.onChanged(selectedDate);
                        }
                      },
                    ),
                  ),
                  if (widget.showAttachmentIcon)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                        onTap: () => _pickFile(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: DockColors.slate100,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.attach_file,
                              color: DockColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (widget.showRemoveButton)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                        onTap: widget.onRemove,
                        child: Container(
                          decoration: BoxDecoration(
                            color: DockColors.danger100,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.close,
                              color: DockColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (attachedFileName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '$attachedFileName',
                    style: DockTheme.h3.copyWith(
                      color: attachedFileName != null
                          ? DockColors.success100
                          : DockColors.slate100,
                      fontSize: 15,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
