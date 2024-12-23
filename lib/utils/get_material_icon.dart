String getMaterialIcon(String materialType) {
  switch (materialType.toLowerCase()) {
    case "pdf":
      return "assets/img/pdf_icon.png";
    case "xlsx":
      return "assets/img/xlsx_icon.png";
    case "xls":
      return "assets/img/xlsx_icon.png";
    case "pptx":
      return "assets/img/ppt_icon.png";
    case "ppt":
      return "assets/img/ppt_icon.png";
    case "docx":
      return "assets/img/doc_icon.png";
    case "doc":
      return "assets/img/doc_icon.png";
    case "txt":
      return "assets/img/txt_icon.png";
    case "png":
      return "assets/img/image_icon.png";
    case "jpg":
      return "assets/img/image_icon.png";
    case "jpeg":
      return "assets/img/image_icon.png";
    default:
      return "assets/img/unknown_icon.png";
  }
}