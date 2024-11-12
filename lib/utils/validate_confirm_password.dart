String? validateConfirmPassword(String? confirmPassword, String? password) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return 'Mật khẩu xác nhận không được để trống';
  }
  if (confirmPassword != password) {
    return 'Mật khẩu xác nhận không khớp';
  }
  return null;
}