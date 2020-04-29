import 'package:flutter/material.dart';

class StateFilterItem extends StatelessWidget {
  StateFilterItem({this.showPerson = false});
  final bool showPerson;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.asset(
                        "assets/red-pin.png",
                        width: 24,
                      ),
                      Positioned(
                        top: 2,
                        left: 7,
                        child: Text(
                          "H",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text("Kağıthane\nDevlet H."),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "😷",
                    style: TextStyle(fontSize: 28),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text("N95\nMaske"),
                  ),
                ],
              ),
              if (showPerson)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://pbs.twimg.com/profile_images/934914103856025600/BuZEDJZS.jpg",
                      ),
                      minRadius: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text("Dr. Can\nSipahi"),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
