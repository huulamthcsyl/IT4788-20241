String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Mật khẩu không được để trống';
  }
  return null;
}