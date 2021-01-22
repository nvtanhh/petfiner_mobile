import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/user.dart';
import 'package:pet_finder/navigator.dart';
import 'package:pet_finder/utils.dart';
import 'package:provider/provider.dart';

import 'import/animated_search_bar.dart';
import 'import/app_bar.dart';
import 'import/color.dart';
import 'import/font.dart';
import 'import/formart.dart';
import 'import/page_builder.dart';
import 'import/spin_loader.dart';
import 'inbox_bloc.dart';
import 'inbox_chat.dart';
import 'inbox_model.dart';
import 'package:http/http.dart' as http;

class InboxList extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(InboxList()));
  }

  @override
  _InboxListState createState() => _InboxListState();
}

class _InboxListState extends State<InboxList>
    with SingleTickerProviderStateMixin {
  InboxBloc _inboxBloc;
  // AuthBloc _authBloc;
  User user;
  List<FbInboxGroupModel> groups;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_inboxBloc == null || user == null) {
      _inboxBloc = Provider.of<InboxBloc>(context);
      await getUserFromToken();
      init();
    }
    super.didChangeDependencies();
  }

  Future<void> getUserFromToken() async {
    try {
      String token = await getStringValue('token');
      http.Response response = await http.get(
        Apis.getUserInfo,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));
      print('_loadLoggedUser: ' + response.statusCode.toString());
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        user = User.fromJson(parsedJson);
        setStringValue('loggedUserId', user.id.toString());
      } else if (response.statusCode == 500) {
        showError('Server error, please try again latter.');
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
  }

  init() async {
    await _inboxBloc.createUser(
        user.id.toString(), user.name, Apis.avatarDirUrl + user.avatar);
    final res = await _inboxBloc.getList20Inbox(user.id.toString());
    setState(() {
      groups = res;
    });
  }

  reload() async {
    final res = await _inboxBloc.getList20Inbox(user.id.toString());
    setState(() {
      groups = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        bgColor: Colors.blue,
        automaticallyImplyLeading: true,
        title: 'Messages',
        actions: [
          Center(
            child: AnimatedSearchBar(
              width: MediaQuery.of(context).size.width / 2,
              height: 40,
            ),
          ),
        ],
      ),
      body: groups != null
          ? ListView.separated(
              shrinkWrap: true,
              itemCount: groups.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InboxChat(
                              groups[index], groups[index].lastUser,
                              user: user)));
                },
                tileColor: groups[index].reader.contains(user.id.toString())
                    ? Colors.white
                    : ptBackgroundColor(context),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundImage:
                      CachedNetworkImageProvider(groups[index].image),
                ),
                title: Text(
                  groups[index].lastUser,
                  style: ptTitle().copyWith(
                      color: groups[index].reader.contains(user.id.toString())
                          ? Colors.black54
                          : Colors.black87,
                      fontSize:
                          groups[index].reader.contains(user.id.toString())
                              ? 15
                              : 16),
                ),
                subtitle: Text(
                  groups[index].lastMessage,
                  style: ptTiny().copyWith(
                      fontWeight:
                          groups[index].reader.contains(user.id.toString())
                              ? FontWeight.w400
                              : FontWeight.w500,
                      color: groups[index].reader.contains(user.id.toString())
                          ? Colors.black54
                          : Colors.black87,
                      fontSize:
                          groups[index].reader.contains(user.id.toString())
                              ? 12
                              : 13.5),
                ),
                trailing: Column(
                  children: [
                    SizedBox(height: 12),
                    Text(
                      Formart.timeByDay(DateTime.tryParse(groups[index].time)),
                      style: ptSmall().copyWith(
                          fontWeight:
                              groups[index].reader.contains(user.id.toString())
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                          color:
                              groups[index].reader.contains(user.id.toString())
                                  ? Colors.black54
                                  : Colors.black87,
                          fontSize:
                              groups[index].reader.contains(user.id.toString())
                                  ? 12
                                  : 13),
                    ),
                  ],
                ),
              ),
              separatorBuilder: (context, index) => Divider(
                height: 1,
              ),
            )
          : kLoadingSpinner,
    );
  }
}
