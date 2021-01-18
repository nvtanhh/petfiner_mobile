class ImagesList {
  List<String> images;

  ImagesList({this.images});

  factory ImagesList.fromJson(List<dynamic> parsedJson, {bool post: false}) {
    String prefix = post ? '/Images/files/' : ' ';
    List<String> images = parsedJson
        .map((imageJson) => prefix + (imageJson['Url'] as String))
        .toList();

    return new ImagesList(images: images);
  }
  static List<dynamic> toJson(List<String> imageUrls) {
    return imageUrls.map((url) => {'Url': url}).toList();
  }

  static List<dynamic> toJsonAvatar(List<String> imageUrls) {
    return imageUrls.map((url) => {'Url': url}).toList();
  }
}
