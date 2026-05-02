final _nameRegExp = RegExp(r'^[a-zA-Z ]+$');

const nameMaxLength = 20;
const nameMinLength = 3;

const passwordMaxLength = 20;
const passwordMinLength = 6;

const mobileMaxLength = 14;
const mobileMinLength = 11;

const emailMaxLength = 100;
const emailMinLength = 3;

const noteMaxLength = 500;
const noteMinLength = 3;

class Validator {
  static String? name(String? v) {
    if (v == null || v == '') return 'Name is required.';

    if (!_nameRegExp.hasMatch(v)) return 'Invalid characters in name.';

    if (v.length > nameMaxLength) {
      return 'Name should not exceed $nameMaxLength characters.';
    }

    if (v.length < nameMinLength) {
      return 'Name should be at least $nameMinLength characters.';
    }

    return null;
  }

  static String? firstName(String? v) {
    if (v == null || v == '') return 'First name is required.';

    if (!_nameRegExp.hasMatch(v)) return 'Invalid characters in first name.';

    if (v.length > nameMaxLength) {
      return 'First name should not exceed $nameMaxLength characters.';
    }

    if (v.length < nameMinLength) {
      return 'First name should be at least $nameMinLength characters.';
    }

    return null;
  }

  static String? lastName(String? v) {
    if (v == null || v == '') return 'Last name is required.';

    if (!_nameRegExp.hasMatch(v)) return 'Invalid characters in last name.';

    if (v.length > nameMaxLength) {
      return 'Last name should not exceed $nameMaxLength characters.';
    }
    if (v.length < nameMinLength) {
      return 'Last name should be at least $nameMinLength characters.';
    }

    return null;
  }

  static String? dob(String? v) {
    if (v == null || v == '') return 'Date of birth code is required.';

    if (v.length > 10) {
      return 'Date of birth code should not exceed 10 characters.';
    }

    if (v.length < 3) {
      return 'Date of birth code should be at least 3 characters.';
    }

    return null;
  }

  static String? amount(String? v) {
    if (v == null || v == '' || v.trim() == '') return 'Amount is required.';

    if (int.parse(v) > 50000) {
      return 'Amount should not exceed 50,000.';
    }

    if (int.parse(v) < 100) {
      return 'Amount should be at least 100.';
    }

    return null;
  }

  static String? note(String? v) {
    if (v == null || v == '') return 'Note is required.';

    if (!_nameRegExp.hasMatch(v)) return 'Invalid characters in note.';

    if (v.length > noteMaxLength) {
      return 'Note should not exceed $noteMaxLength characters.';
    }

    if (v.length < noteMinLength) {
      return 'Note should be at least $noteMinLength characters.';
    }

    return null;
  }

  static String? address(String? v) {
    if (v == null || v == '') return 'Address is required.';

    if (!_nameRegExp.hasMatch(v)) return 'Invalid characters in address.';

    if (v.length > noteMaxLength) {
      return 'Address should not exceed $noteMaxLength characters.';
    }

    if (v.length < noteMinLength) {
      return 'Address should be at least $noteMinLength characters.';
    }

    return null;
  }

  static String? accountType(String? v) {
    if (v == '' || v == null) {
      return 'Account type is required.';
    }

    return null;
  }

  static String? addressLabel(String? v) {
    if (v == '' || v == null) {
      return 'Address label is required.';
    }

    return null;
  }

  static String? company(String? v) {
    if (v == null || v == '') return null;

    if (!_nameRegExp.hasMatch(v)) return 'Invalid characters in company name.';

    if (v.length > 100) return 'Company name should not exceed 50 characters.';

    if (v.length < 3) return 'Company name should be at least 3 characters.';

    return null;
  }

  static String? street(String? v) {
    if (v == null || v == '') return 'Street address is required.';

    if (v.length > 100) {
      return 'Street address should not exceed 100 characters.';
    }

    if (v.length < 3) return 'Street address should be at least 3 characters.';

    return null;
  }

  static String? apartment(String? v) {
    if (v == null || v == '') return null;

    if (v.length > 100) return 'Apartment should not exceed 50 characters.';

    if (v.length < 3) return 'Apartment should be at least 3 characters.';

    return null;
  }

  static String? city(String? v) {
    if (v == null || v == '') return 'Town / city name is required.';

    if (v.length > 50) return 'City name should not exceed 50 characters.';

    if (v.length < 3) return 'City name should be at least 3 characters.';

    return null;
  }

  static String? state(String? v) {
    if (v == null || v == '') return 'State is required.';

    if (v.length > 100) return 'State should not exceed 100 characters.';

    if (v.length < 3) return 'State should be at least 3 characters.';

    return null;
  }

  static String? postCode(String? v) {
    if (v == null || v == '') return 'Post code is required.';

    if (v.length > 10) return 'Post code should not exceed 10 characters.';

    if (v.length < 3) return 'Post code should be at least 3 characters.';

    return null;
  }

  static String? mobile(String? v) {
    if (v == null || v == '') return 'Mobile is required.';

    if (v.length > mobileMaxLength) {
      return 'Mobile should not exceed $mobileMaxLength digit.';
    }

    if (v.length < mobileMinLength) {
      return 'Mobile should be at least $mobileMinLength digit.';
    }

    return null;
  }

  static String? email(String? v) {
    if (v == null || v == '') return 'Email is required.';

    if (v.length > emailMaxLength) {
      return 'Email should not exceed $emailMaxLength characters.';
    }

    if (v.length < emailMinLength) {
      return 'Email should be at least $emailMinLength characters.';
    }

    final pattern = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );

    final isMatch = pattern.hasMatch(v);
    if (isMatch == false) return 'Enter e valid email address.';

    return null;
  }

  static String? country(String? v) {
    if (v == null || v == '') return 'Country is required.';

    if (v.length > 20) return 'Country should not exceed 20 characters.';

    if (v.length < 3) return 'Country should be at least 3 characters.';

    return null;
  }

  static String? password(String? v) {
    if (v == null || v == '') return 'Password is required.';

    if (v.length > passwordMaxLength) {
      return 'Password should not exceed $passwordMaxLength characters.';
    }

    if (v.length < passwordMinLength) {
      return 'Password should be at least $passwordMinLength characters.';
    }

    return null;
  }

  static String? confirmPassword(String? password, String? confirmPassword) {
    if (password == null || password == '') return 'Password is required.';

    if (confirmPassword == null || confirmPassword == '') {
      return 'Confirm password is required.';
    }

    if (password != confirmPassword) {
      return 'New password and confirm password is not matched.';
    }

    if (password.length > passwordMaxLength) {
      return 'Password should not exceed $passwordMaxLength characters.';
    }

    if (password.length < passwordMinLength) {
      return 'Password should be at least $passwordMinLength characters.';
    }

    return null;
  }
}
