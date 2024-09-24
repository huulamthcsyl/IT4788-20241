String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email không được để trống';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
    return 'Email không hợp lệ';
  }
  return null;
}