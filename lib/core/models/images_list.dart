class ImagesList {
  List<String> images;

  ImagesList({this.images});

  factory ImagesList.fromJson(List<dynamic> parsedJson) {
    List<String> images =
        parsedJson.map((imageJson) => imageJson['Url'] as String).toList();

    return new ImagesList(images: images);
  }
  static List<dynamic> toJsonPost(List<String> imageUrls) {
    return imageUrls.map((url) => {'Url': '/Images/files/' + url}).toList();
  }

  static List<dynamic> toJsonAvatar(List<String> imageUrls) {
    return imageUrls.map((url) => {'Url': url}).toList();
  }
}
