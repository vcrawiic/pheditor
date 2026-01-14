class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return 'Введите корректный email';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }

    if (value.length < 8 || value.length > 16) {
      return 'Не менее 8 и не более 16 символов';
    }
    return null;
  }

  static String? Function(String?) confirmPassword(
    String Function() getPassword,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Подтвердите пароль';
      }
      if (value != getPassword()) {
        return 'Пароли не совпадают';
      }
      return null;
    };
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите имя';
    }
    if (value.length < 2 || value.length > 40) {
      return 'Не менее 2 и не более 40 символов';
    }
    return null;
  }

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'Введите ${fieldName ?? 'value'}';
    }
    return null;
  }

  static String? minLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'Введите ${fieldName ?? 'value'}';
    }

    if (value.length < length) {
      return '${fieldName ?? 'Value'} должен содержать не менее $length символов';
    }
    return null;
  }
}
