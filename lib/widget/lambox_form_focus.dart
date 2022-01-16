import 'package:flutter/material.dart';
import 'package:lambox_doc/models/form_data.dart';
import 'package:provider/provider.dart';

class LamBoxFormFocus extends StatefulWidget {
  LamBoxFormFocus({
    this.focus,
    this.focusNode,
    this.iconType,
    this.textType,
    this.obscureText,
    this.keyboardType,
  });

  final bool focus;
  final FocusNode focusNode;

  final IconData iconType;
  final String textType;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  _LamBoxFormFocusState createState() => _LamBoxFormFocusState();
}

class _LamBoxFormFocusState extends State<LamBoxFormFocus> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FormData>().addFormController(controller);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: widget.obscureText,
      style: TextStyle(color: !widget.focus ? Color(0xff004d40) : Colors.white),
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Color(0xff004d40),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        labelText: widget.textType,
        labelStyle:
            TextStyle(color: !widget.focus ? Color(0xff004d40) : Colors.white),
        icon: Icon(widget.iconType,
            color: !widget.focus ? Color(0xff004d40) : Colors.white),
      ),
    );
  }
}
