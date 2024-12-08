String fromNow(DateTime dateTime) {
  final Duration duration = DateTime.now().difference(dateTime);
  if (duration.inDays > 365) {
    return '${(duration.inDays / 365).floor()} năm trước';
  } else if (duration.inDays > 30) {
    return '${(duration.inDays / 30).floor()} tháng trước';
  } else if (duration.inDays > 0) {
    return '${duration.inDays} ngày trước';
  } else if (duration.inHours > 0) {
    return '${duration.inHours} giờ trước';
  } else if (duration.inMinutes > 0) {
    return '${duration.inMinutes} phút trước';
  } else {
    return 'Vừa xong';
  }
}