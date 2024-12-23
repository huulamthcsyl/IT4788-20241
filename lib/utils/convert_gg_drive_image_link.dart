String convertGoogleDriveLink(String link) {
  final regex = RegExp(r'd/([a-zA-Z0-9_-]+)/view');
  final match = regex.firstMatch(link);
  if (match != null && match.groupCount >= 1) {
    final fileId = match.group(1);
    return 'https://drive.google.com/uc?export=view&id=$fileId';
  }
  return link;
}