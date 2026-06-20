abstract final class AuthValidationMessages {
  static const emailRequired = '이메일을 입력해주세요.';
  static const emailInvalid = '올바른 이메일 형식을 입력해주세요.';
  static const passwordRequired = '비밀번호를 입력해주세요.';

  static String passwordMinLength(int minLength) =>
      '비밀번호는 $minLength자리 이상이어야 합니다.';
}

abstract final class AuthErrorMessages {
  static const network = '네트워크 연결을 확인해주세요.';
  static const loginFailed =
      '로그인에 실패했습니다. 이메일과 비밀번호를 확인해주세요.';
}

abstract final class AuthErrorPatterns {
  static const socketException = 'SocketException';
  static const connectionRefused = 'Connection refused';
  static const connectionError = 'connection error';
  static const dioException = 'DioException';
}
