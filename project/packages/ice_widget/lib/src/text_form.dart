import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cut_corners_border.dart';

class TextForm extends StatefulWidget {
  final String inputLabel;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final TextInputType textInputType;
  final VoidCallback? onEditingCompleted;
  final TextEditingController controller;

  const TextForm(
      {Key? key,
      required this.inputLabel,
      required this.controller,
      this.validator,
      this.onTap,
      this.onEditingCompleted,
      this.textInputType = TextInputType.text})
      : super(key: key);

  @override
  TextFormState createState() => TextFormState();
}

class TextFormState extends State<TextForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;
  bool get isValid => _isValid;
  final FocusNode _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isValid = _formKey.currentState!.validate();
        });
      } else {
        widget.onTap?.call();
      }
    });
    widget.controller.addListener(() {
      setState(() {
        _isValid = widget.validator?.call(widget.controller.text) != null;
        if (_isValid) {
          _formKey.currentState!.save();
        }
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
            border: const CutCornersBorder(
              borderSide: BorderSide(width: 0.5),
            ),
            labelText: widget.inputLabel,
            suffixIcon: Icon(Icons.check,
                color: _isValid
                    ? Theme.of(context).primaryColor
                    : Colors.transparent),
          ),
          keyboardType: widget.textInputType,
          //validator: widget.validator,
          focusNode: _focusNode,
          controller: widget.controller,
          onEditingComplete: widget.onEditingCompleted,
          onSaved: (value) {
            setState(() {
              _formKey.currentState!.validate();
            });
          },
          inputFormatters: [LengthLimitingTextInputFormatter(21)],
        ));
  }
}
