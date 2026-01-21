import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pheditor/design/inner_shadow_painter.dart';
import 'package:pheditor/design/pallete.dart';

enum FieldType { name, email, pass, confirmPass }

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final FieldType type;

  final Color _textColor = Pallete.secondaryGreyText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.type,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: CustomPaint(
          foregroundPainter: InnerShadowPainter(
            borderRadius: 8,
            shadows: const [
              InnerShadow(
                color: Color.fromRGBO(227, 227, 227, 0.2),
                blurRadius: 40,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF131313),
              image: const DecorationImage(
                image: AssetImage('assets/neon.jpg'),
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF87858F), width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nameText(),
                    style: TextStyle(
                      color: Pallete.secondaryGreyText,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextFormField(
                    controller: controller,
                    cursorColor: _textColor,
                    obscureText: _shouldObscure(),
                    obscuringCharacter: '*',
                    keyboardType: keyboardType,
                    validator: validator,
                    style: TextStyle(
                      color: Pallete.primaryWhiteText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hint: Text(
                        _placeholderText(),
                        style: TextStyle(
                          color: Pallete.secondaryGreyText,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      filled: false,
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor, width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Pallete.primaryWhiteText,
                          width: 2,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Pallete.error,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Pallete.error,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _nameText() {
    switch (type) {
      case FieldType.name:
        return 'Имя';
      case FieldType.email:
        return 'e-mail';
      case FieldType.pass:
        return 'Пароль';
      case FieldType.confirmPass:
        return 'Подтверждение пароля';
    }
  }

  String _placeholderText() {
    switch (type) {
      case FieldType.name:
        return 'Введите ваше имя';
      case FieldType.email:
        return 'Ваша электронная почта';
      default:
        return '8-16 символов';
    }
  }

  bool _shouldObscure() {
    return type == FieldType.pass || type == FieldType.confirmPass;
  }
}
