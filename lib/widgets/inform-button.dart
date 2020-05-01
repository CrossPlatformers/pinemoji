import 'package:flutter/material.dart';
import 'package:pinemoji/shared/custom-box-shadow.dart';

class InformButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: size.width - 100,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(21.5),
            boxShadow: [
              CustomBoxShadow(
                  color: Theme.of(context).primaryColorDark,
                  offset: new Offset(3, 3),
                  blurRadius: 2.0,
                  blurStyle: BlurStyle.outer),
              CustomBoxShadow(
                  color: Theme.of(context).primaryColorDark,
                  offset: new Offset(-1, 3),
                  blurRadius: 2.0,
                  blurStyle: BlurStyle.outer),
              CustomBoxShadow(
                  color: Colors.white,
                  offset: new Offset(1, -0.2),
                  blurRadius: 5.0,
                  blurStyle: BlurStyle.outer),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Durum Bildir",
                style: TextStyle(
                  color: Color(0xFF26315F),
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
