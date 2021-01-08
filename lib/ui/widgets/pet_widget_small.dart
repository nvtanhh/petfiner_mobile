import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/ui/pet_detail.dart';

class PetWidget extends StatelessWidget {
  final Pet pet;

  final bool last;
  final bool showAsColumn;
  const PetWidget(
      {Key key, this.pet, this.last = false, this.showAsColumn = false})
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
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
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
                blurRadius: 3,
                offset: Offset(2, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(pet.defaultImageUrl),
              radius: showAsColumn ? 35 : 25,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      pet.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: showAsColumn ? 18 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Alaska",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: showAsColumn ? 16 : 12,
                    ),
                  ),
                ],
              ),
            ),
            if (showAsColumn)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Icon(
                      Icons.clear,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
