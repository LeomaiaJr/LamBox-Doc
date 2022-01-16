import 'package:flutter/material.dart';
import 'package:lambox_doc/models/form_data.dart';
import 'package:provider/provider.dart';

class LamBoxForm extends StatefulWidget {
  LamBoxForm({
    this.iconType,
    this.textType,
    this.obscureText,
    this.keyboardType,
  });

  final IconData iconType;
  final String textType;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  _LamBoxFormState createState() => _LamBoxFormState();
}

class _LamBoxFormState extends State<LamBoxForm> {
  FocusNode _focusNode = FocusNode();
  bool _focus = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _focus = !_focus;
      });
    });
    context.read<FormData>().addFormController(controller);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: widget.obscureText,
      style: TextStyle(color: !_focus ? Color(0xff004d40) : Colors.white),
      keyboardType: widget.keyboardType,
      focusNode: _focusNode,
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
            TextStyle(color: !_focus ? Color(0xff004d40) : Colors.white),
        icon: Icon(widget.iconType,
            color: !_focus ? Color(0xff004d40) : Colors.white),
      ),
    );
  }
}
