import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mule/config/app_theme.dart';

class NumberCodeForm extends StatefulWidget {
  final int numberOfFields;
  final TextEditingController controller;
  final double spacing;
  final EdgeInsets padding;
  final Function validator;

  NumberCodeForm({
    @required this.numberOfFields,
    @required this.controller,
    this.spacing,
    this.padding,
    this.validator,
  });

  @override
  State<StatefulWidget> createState() => NumberCodeFormState();
}

class NumberCodeFormState extends State<NumberCodeForm> {
  final List<TextEditingController> _controllerList = [];
  final FocusScopeNode _formFocus = FocusScopeNode();

  Widget _singleNumberField() {
    TextEditingController controller = TextEditingController();
    controller.addListener(() {
      // Go to next field when typed a character
      _applyToController();
    });

    _controllerList.add(controller);

    return Expanded(
        child: TextFormField(
      inputFormatters: [LengthLimitingTextInputFormatter(1)],
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      controller: controller,
      validator: widget.validator,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.lightBlue,
          ),
        ),
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: AppTheme.lightGrey.withOpacity(0.5),
        ),
      ),
      onEditingComplete: () => _formFocus.nextFocus(),
    ));
  }

  Widget _buildNumberFields(int numberOfFields, double spacing) {
    List<Widget> fields = [];

    for (int i = 0; i < numberOfFields; i++) {
      fields.add(_singleNumberField());
      fields.add(SizedBox(
        width: spacing,
      ));
    }
    fields.removeLast();

    return FocusScope(
      node: _formFocus,
      child: Row(
        children: fields,
      ),
    );
  }

  _clearForm() {
    _controllerList.forEach((controller) => controller.text = "");
  }

  _applyToController() {
    String formContent =
        _controllerList.map((controller) => controller.text).toList().join();
    // String validatorMessage;

    // try {
    //   validatorMessage = widget.validator(formContent);
    // } catch (_) {
    //   // Catch validator not implemented
    //   validatorMessage = null;
    // }
    // if (validatorMessage == null) {
    //   widget.controller.text = formContent;
    // } else {
    //   _clearForm();
    // }
    widget.controller.text = formContent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: _buildNumberFields(widget.numberOfFields, widget.spacing),
    );
  }
}
