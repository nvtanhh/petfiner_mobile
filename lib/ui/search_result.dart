import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/core/models/posts_list.dart';
import 'package:pet_finder/ui/widgets/post_widget.dart';
import 'package:pet_finder/utils.dart';
import 'package:pet_finder/core/services/my_location.dart';

import 'package:http/http.dart' as http;

class SearchResult extends StatefulWidget {
  final PetCategory category;

  final String query;

  SearchResult({this.category, this.query});

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<Post> _myPosts;
  bool _error = false;
  List<Post> _filteredPosts;
  bool filterAdoption = false, filterMating = false, filterDisappear = false;

  @override
  void initState() {
    super.initState();
    _searchPost();
  }

  @override
  Widget build(BuildContext context) {
    String query = widget.query ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.category == null
              ? 'Search Result'
              : (widget.category == PetCategory.HAMSTER
                      ? "Hamster"
                      : widget.category == PetCategory.CAT
                          ? "Cat"
                          : widget.category == PetCategory.OTHER
                              ? "Bunny"
                              : "Dog") +
                  " Category",
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.grey[800],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.more_horiz,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.query != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Query: $query',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          if (_myPosts != null)
            Padding(
              padding: EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 5),
              child: Wrap(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildFilter("Adoption", filterAdoption),
                  buildFilter("Mating", filterMating),
                  buildFilter("Disappear", filterDisappear),
                ],
              ),
            ),
          Expanded(
            child: _filteredPosts != null
                ? _filteredPosts.length != 0
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredPosts.length,
                        itemBuilder: (context, index) => PostWidget(
                              post: _filteredPosts[index],
                              index: null,
                              from: "search_",
                            ))
                    : Center(
                        child: Text('No Data Found!'),
                      )
                : _error
                    ? Center(child: Text('ERROR! Please try again!'))
                    : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  Widget buildFilter(String name, bool selected) {
    return GestureDetector(
      onTap: () => _filter(name),
      child: Container(
        margin: EdgeInsets.only(right: 5, bottom: 5),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            width: 1,
            color: selected ? Colors.transparent : Colors.grey[300],
          ),
          boxShadow: [
            BoxShadow(
              color:
                  selected ? Colors.blue[300].withOpacity(0.5) : Colors.white,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
          color: selected ? Colors.blue[300] : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.grey[800],
              ),
            ),
            selected
                ? Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  int getCategoryId(PetCategory category) {
    switch (category) {
      case PetCategory.DOG:
        return 1;
        break;
      case PetCategory.CAT:
        return 2;
        break;
      case PetCategory.OTHER:
        return 4;
        break;
      case PetCategory.HAMSTER:
        return 3;
        break;
    }
    return 4;
  }

  _searchPost() async {
    String token = await getStringValue('token');
    int categoryId = getCategoryId(widget.category);

    Map<String, String> queryParams = {
      if (MyLocation().haveData) 'Lat': MyLocation().lat?.toString() ?? '',
      if (MyLocation().haveData) 'Lon': MyLocation().long?.toString() ?? '',
      if (widget.query != null && widget.query.isNotEmpty)
        'SearchQuery': widget.query,
      if (categoryId != null) 'PetCategoryId': categoryId.toString(),
    };
    String queryString = (queryParams != null)
        ? '?' + Uri(queryParameters: queryParams).query
        : '';
    try {
      http.Response response = await http.get(
        Apis.getPostUrl + queryString,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        PostsList postsList = PostsList.fromJson(parsedJson);
        _myPosts = postsList.posts;
        setState(() {
          _filteredPosts = postsList.posts;
        });
        print(_filteredPosts.length);
      } else if (response.statusCode == 500) {
        _onError();
        showError('Server error, please try again latter.');
      }
    } on TimeoutException catch (e) {
      _onError();
      showError(e.toString());
    } on SocketException catch (e) {
      _onError();
      showError(e.toString());
    }
  }

  void _onError() {
    if (!_error)
      setState(() {
        _error = true;
      });
  }

  _filter(String s) {
    if (_myPosts.length != 0) {
      switch (s) {
        case 'Adoption':
          filterAdoption = !filterAdoption;
          break;
        case 'Mating':
          filterMating = !filterMating;
          break;
        case 'Disappear':
          filterDisappear = !filterDisappear;
          break;
        default:
      }
      setState(() {
        _filteredPosts = _myPosts.where((post) => _isMatching(post)).toList();
      });
    }
  }

  bool _isMatching(Post post) {
    switch (post.postCategory) {
      case PostCategory.Adoption:
        return filterAdoption;
        break;
      case PostCategory.Mating:
        return filterMating;
        break;
      case PostCategory.Disappear:
        return filterDisappear;
        break;
      default:
        return true;
    }
  }
}
