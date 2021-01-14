import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/ui/pet_detail.dart';
import 'package:pet_finder/utils.dart' as utils;

class PetWidget extends StatelessWidget {
  final Pet pet;

  final bool last;
  final bool showAsColumn;

  final bool isExpanded;

  final bool tiny;
  const PetWidget(
      {Key key,
      this.pet,
      this.last = false,
      this.showAsColumn = false,
      this.isExpanded,
      this.tiny = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetDetail(pet)),
        );
      },
      child: Container(
        width: showAsColumn ? size.width : size.width * 0.6,
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        margin: EdgeInsets.only(
          right: showAsColumn
              ? 0
              : !last
                  ? 16
                  : 0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[200],
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            if (showAsColumn)
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: pet?.avatar == null
                  ? AssetImage('assets/sample/animal.jpg')
                  : CachedNetworkImageProvider(
                      Apis.avatarDirUrl + pet.avatar,
                    ),
              radius: showAsColumn
                  ? 40
                  : tiny
                      ? 20
                      : 25,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          pet.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: showAsColumn
                                ? 18
                                : tiny
                                    ? 12
                                    : 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: showAsColumn ? 12 : 6,
                      ),
                      Container(
                        width: showAsColumn ? 18 : 16,
                        height: showAsColumn ? 18 : 16,
                        child: pet.gender == 'male'
                            ? Image.asset(
                                'assets/icons/male.png',
                                color: Colors.blue,
                              )
                            : Image.asset(
                                'assets/icons/female.png',
                                color: Colors.pink,
                              ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: tiny ? 0 : 6,
                  ),
                  Text(
                    "Alaska",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: showAsColumn ? 14 : 12,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  if (showAsColumn)
                    Row(
                      children: [
                        Icon(
                          Icons.timelapse_outlined,
                          size: 12,
                          color: Colors.grey[700],
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          pet.age != null
                              ? pet.age.toString() + " months"
                              : 'Uknow age',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
            SizedBox(
              width: 12,
            ),
            if (showAsColumn)
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _showDeleteDialog(context, pet.name),
                    child: Container(
                      margin: const EdgeInsets.only(top: 25),
                      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5),
                      child: Icon(
                        Icons.clear,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  _showDeleteDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("Delete confirm."),
          content: Text(
            "Are you sure to delete $name?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black54),
          ),
          actions: <Widget>[
            ButtonTheme(
              //minWidth: double.infinity,
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
                color: Colors.grey[400],
                textColor: const Color(0xffffffff),
              ),
            ),
            ButtonTheme(
              //minWidth: double.infinity,
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _deletePet();
                  EasyLoading.showToast("Deleted!",
                      duration: new Duration(seconds: 1));
                },
                child: Text('Delete'),
                color: Theme.of(context).primaryColor,
                textColor: const Color(0xffffffff),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePet() async {
    print('delete');
  }
}
