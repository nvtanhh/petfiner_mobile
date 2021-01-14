import 'package:pet_finder/core/models/post.dart';

class PostsList {
  List<Post> posts;

  PostsList({this.posts});

  factory PostsList.fromJson(List<dynamic> parsedJson) {
    List<Post> pets =
        parsedJson.map((circleJson) => Post.fromJson(circleJson)).toList();

    return new PostsList(posts: pets);
  }
}
