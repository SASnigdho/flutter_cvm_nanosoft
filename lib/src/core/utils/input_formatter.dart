import 'package:flutter/services.dart';

class InputFormatter {
  static final name = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]')),
    LengthLimitingTextInputFormatter(20),
  ];

  static final password = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(20),
  ];

  static final dob = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(10),
  ];

  static final phone = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(14),
  ];

  static final amount = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(5),
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
  ];

  static final email = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(20),
  ];

  static final note = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(500),
  ];
}
