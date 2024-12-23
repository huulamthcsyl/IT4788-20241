String getMaterialIcon(String material_type){
  switch (material_type){
    case "PDF":
      return "assets/img/pdf_icon.png";
    case "XLSX":
      return "assets/img/xlsx_icon.png";
    case "PPT":
      return "assets/img/ppt_icon.png";
    case "DOC":
      return "assets/img/doc_icon.png";
    case "TXT":
      return "assets/img/txt_icon.png";
    default:
      return "assets/img/unknown_icon.png";
  }
}