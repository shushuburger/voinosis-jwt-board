abstract final class AuthValidationMessages {
  static const emailRequired = '이메일을 입력해주세요.';
  static const emailInvalid = '올바른 이메일 형식을 입력해주세요.';
  static const passwordRequired = '비밀번호를 입력해주세요.';

  static String passwordMinLength(int minLength) =>
      '비밀번호는 $minLength자리 이상이어야 합니다.';
}
