import 'package:flutter/material.dart';
import '../../widgets/helper/ensure-visible.dart';

import '../../entities/task_entity.dart';
import '../../scoped_model/main_model.dart';

class TaskFormField extends StatelessWidget {
  final FocusNode focusNode;
  final String initialValue, fieldHint;
  final int labelText;
  final FocusNode nextFocusNode;
  final Map<String, dynamic> formData;

  TaskFormField({
    this.focusNode,
    this.labelText,
    this.initialValue,
    this.nextFocusNode,
    this.fieldHint,
    this.formData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: TextFormField(
          focusNode: focusNode,
          autofocus: labelText == 0 ? true : false,
          decoration: _buildInputDecorations(),
          initialValue: initialValue,
          validator: _validate,
          onSaved: _onSaved,
          maxLength: labelText == 0 ? 50 : 200,
          maxLengthEnforced: true,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          textInputAction: nextFocusNode == null
              ? TextInputAction.done
              : TextInputAction.next,
          maxLines: null,
          onFieldSubmitted: (String value) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          },
        ),
      ),
    );
  }

  String _validate(String value) {
    if (value.contains("'")) {
      return "Can not contain ' character";
    }
  }

  _onSaved(String value) {
    formData[TaskEntity.columnNames[labelText][0]] = value.length > 0 ? value : null;
  }

  InputDecoration _buildInputDecorations() {
    return InputDecoration(
      labelText: TaskEntity.columnNames[labelText][0],
      labelStyle: MainModel.labelStyle,
      helperText: fieldHint,
      alignLabelWithHint: true,
    );
  }
}
