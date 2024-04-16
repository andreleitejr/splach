import 'package:flutter/material.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/input_button.dart';

Future<DateTime?> selectDateTime(BuildContext context,
    {bool showTime = false, DateTime? initialDate}) async {
  final DateTime currentDate = DateTime.now();
  DateTime? pickedDateTime;

  pickedDateTime = await showDatePicker(
    helpText: 'Selecione a data de aniversário',
    confirmText: 'Confirmar',
    cancelText: 'Cancelar',
    context: context,
    initialDate:
        DateTime(currentDate.year - 18, currentDate.month, currentDate.day),
    firstDate: DateTime(1900, 1, 1),
    lastDate:
        DateTime(currentDate.year - 18, currentDate.month, currentDate.day),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: ThemeColors.primary,
          ),
        ),
        child: child!,
      );
    },
  );
  if (pickedDateTime != null && showTime) {
    // ignore: use_build_context_synchronously
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDate),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: ThemeColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      pickedDateTime = DateTime(
        pickedDateTime.year,
        pickedDateTime.month,
        pickedDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
  }

  return pickedDateTime;
}

class DateInput extends StatelessWidget {
  final DateTime? date;
  final String hintText;
  final Function(DateTime) onDateSelected;
  final String? error;
  final bool showTime;
  final DateTime? initialDate;
  final bool enabled;
  final bool openDatePicker;

  DateInput({
    super.key,
    this.date,
    // required this.controller,
    required this.hintText,
    required this.onDateSelected,
    this.error,
    this.showTime = false,
    this.initialDate,
    this.enabled = true,
    this.openDatePicker = true,
  });

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (date != null) {
      controller.text = date!.toMonthlyAndYearFormattedString();
    }

    final focus = FocusScope.of(context);
    return InputButton(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.datetime,
      hintText: hintText,
      onTap: () async {
        final date = await selectDateTime(
          context,
          showTime: showTime,
          initialDate: initialDate,
        );

        if (date != null) onDateSelected(date);

        focus.requestFocus(FocusNode());
      },
    );
  }
}
