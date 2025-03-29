import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warudu_web_app/colors.dart';

class ValidatedInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final double borderRadius;
  final bool isMultiline;
  final bool isNumeric;
  final bool isPassword;
  final Color borderColor;
  final Color fillColor;
  final Color labelColor;
  
  const ValidatedInputField({
    Key? key,
    required this.label,
    required this.controller,
    this.borderRadius = 25,
    this.isMultiline = false,
    this.isNumeric = false,
    this.isPassword = false,
    this.borderColor = coral,
    this.fillColor = cream,
    this.labelColor = coral,
  }) : super(key: key);

  @override
  _ValidatedInputFieldState createState() => _ValidatedInputFieldState();
}

class _ValidatedInputFieldState extends State<ValidatedInputField> {
  bool _obscureText = true;

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo sin completar';
    }
    if (widget.isNumeric && double.tryParse(value) == null) {
      return 'Solo se permiten números';
    }
    if (widget.isPassword && value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          widget.label,
          textAlign: TextAlign.start,
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: widget.labelColor,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          maxLines: widget.isMultiline ? 6 : 1,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.fillColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: 4),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: 4),
            ),
            errorStyle: GoogleFonts.inter(
              color: Colors.red,
              fontSize: 14,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: widget.borderColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          validator: _validator,
        ),
      ],
    );
  }
}