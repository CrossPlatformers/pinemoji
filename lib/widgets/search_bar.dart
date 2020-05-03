import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final void Function(String text) onChanged;
  final bool backButton;

  const SearchBar({Key key, @required this.onChanged, this.backButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (backButton)
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC7CAD1).withOpacity(.5)),
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: TextField(
                  style: TextStyle(color: Color(0xffC7CAD1)),
                  decoration: InputDecoration(
                    hintText: "Search",
                    fillColor: Color(0xffC7CAD1),
                    focusColor: Color(0xffC7CAD1),
                    hoverColor: Color(0xffC7CAD1),
                    hintStyle: TextStyle(color: Color(0xffC7CAD1), fontStyle: FontStyle.italic),
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: Color(0xffC7CAD1),
                        ),
                      ],
                    ),
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}