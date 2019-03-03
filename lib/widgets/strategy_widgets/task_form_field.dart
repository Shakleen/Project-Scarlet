import 'package:flutter/material.dart';
import '../../widgets/helper/ensure-visible.dart';

class TaskFormField extends StatelessWidget {
  final FocusNode focusNode;
  final String initialValue, fieldHint, formKey;
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
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: TextFormField(
          focusNode: focusNode,
          autofocus: false,
          decoration: _buildInputDecorations(context),
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
          style: Theme.of(context)
              .textTheme
              .subhead
              .copyWith(color: Theme.of(context).secondaryHeaderColor),
        ),
      ),
    );
  }

  String _validate(String value) {
    if (value.contains("'")) return "Can not contain ' character";
  }

  _onSaved(String value) {
    formData[formKey] = value.length > 0 ? value : null;
  }

  InputDecoration _buildInputDecorations(BuildContext context) {
    return InputDecoration(
      labelText: formKey,
      labelStyle: Theme.of(context).textTheme.subhead,
      helperText: fieldHint,
      alignLabelWithHint: true,
    );
  }
}
