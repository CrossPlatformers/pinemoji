import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pinemoji/repositories/map_repository.dart';
import 'package:pinemoji/widgets/search_bar.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String _query = 'dokuz eylül hastanesi izmir';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) async {
                    String mapStyle = await rootBundle
                        .loadString('assets/map_style/standart.json');
                    controller.setMapStyle(mapStyle);
                    _controller.complete(controller);
                  },
                  markers: MapRepository.markers,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: GradientAppBar(
                    title: SearchBar(
                      onChanged: (String text) {
                        _query = text;
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: FloatingActionButton.extended(
                    onPressed: searchAndGo,
                    label: Text('To the lake!'),
                    icon: Icon(Icons.directions_boat),
                  ),
                ),
              ],
              fit: StackFit.expand,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Text('malzeme stok durumu'),
          ),
        ],
      ),
    );
  }

  Future<void> searchAndGo() async {
    PlaceDetails placeDetails =
        await MapRepository.getPlaceDetailsFromName(_query);
    LatLng latLang = MapRepository.getLatLngFromPlaceDetails(placeDetails);
    var list = MarkerType.values.toList();
    list.shuffle();
    setState(() {
      MapRepository.addMarker(placeDetails, markerType: list.first);
    });
    final GoogleMapController controller = await _controller.future;
//    LatLng(37.43296265331129, -122.08832357078792)
    await controller.animateCamera(CameraUpdate.newLatLngZoom(latLang, 16));
    await Future.delayed(Duration(milliseconds: 400));
    await controller.animateCamera(CameraUpdate.scrollBy(0, -150));
  }
}

class GradientAppBar extends StatelessWidget {
  final Widget title;
  final double barHeight = 270.0;

  GradientAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(child: title),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Malzemeler',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StockFilter(),
            ),
          ),
          ConditionFilter(),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color(0xff26315F),
              Color(0xff26315F).withOpacity(.8),
              Colors.transparent,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1),
            stops: [0.3, .8, 1],
            tileMode: TileMode.clamp),
      ),
    );
  }
}

class FilterEntry {
  const FilterEntry(this.name, this.emoji);

  final String name;
  final String emoji;
}

typedef Function GetFilters(List<String> filters);

class StockFilter extends StatefulWidget {
  final GetFilters onFilterChange;

  const StockFilter({Key key, this.onFilterChange}) : super(key: key);

  @override
  State createState() => StockFilterState();
}

class StockFilterState extends State<StockFilter> {
  final List<FilterEntry> _cast = <FilterEntry>[
    const FilterEntry('Tıbbi Maske', '😷'),
    const FilterEntry('N95 Maske', '😷'),
    const FilterEntry('Siperlik / Gözlük', '🥽'),
    const FilterEntry('Eldiven', '🧤'),
    const FilterEntry('Önlük', '🥼'),
    const FilterEntry('Solunum Cihazı', '⚗'),
  ];

  List<String> _filters = <String>[];

  getFilters() {
    if (widget.onFilterChange != null) {
      widget.onFilterChange(_filters);
    }
    return _filters;
  }

  Iterable<Widget> get filterWidgets sync* {
    for (FilterEntry actor in _cast) {
      yield buildFilterChips(actor);
    }
  }

  Widget buildFilterChips(FilterEntry filter) {
    final bool isActive = _filters.contains(filter.name);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: FilterChip(
          backgroundColor: Colors.transparent,
          shape: StadiumBorder(
              side: BorderSide(
                  color: isActive ? activeColor() : disabledColor())),
          avatar: CircleAvatar(
            child: Text(
              filter.emoji,
              style: TextStyle(fontSize: 20, height: 1.25),
              textAlign: TextAlign.start,
            ),
            backgroundColor: Colors.transparent,
          ),
          label: Text(
            filter.name,
            style: TextStyle(color: isActive ? activeColor() : disabledColor()),
          ),
          elevation: 0,
          pressElevation: 0,
          checkmarkColor: activeColor(),
          selectedColor: Colors.transparent,
          selectedShadowColor: activeColor(),
          disabledColor: Colors.transparent,
          showCheckmark: false,
          shadowColor: Colors.transparent,
          selected: _filters.contains(filter.name),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(filter.name);
              } else {
                _filters.removeWhere((String name) {
                  return name == filter.name;
                });
              }
            });
          },
        ),
      ),
    );
  }

  Color disabledColor() => Color(0xffC7CAD1);

  Color activeColor() => Color(0xffF93963);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        runSpacing: 0,
        spacing: 0,
        direction: Axis.vertical,
        children: filterWidgets.toList(),
      ),
    );
  }
}

class ConditionFilter extends StatefulWidget {
  final Function(String) onFilterChange;

  const ConditionFilter({Key key, this.onFilterChange}) : super(key: key);

  @override
  _ConditionFilterState createState() => _ConditionFilterState();
}

class _ConditionFilterState extends State<ConditionFilter> {
  List<ConditionFilterModel> conditionFilterModels = [
    ConditionFilterModel(
      text: 'Acil Destek',
      imagePath: 'assets/pins/red.png',
      pinCount: 50,
      isActive: true,
    ),
    ConditionFilterModel(
      text: 'Azalıyor!',
      imagePath: 'assets/pins/yellow.png',
      pinCount: 500,
    ),
    ConditionFilterModel(
      text: 'Yeterli',
      imagePath: 'assets/pins/blue.png',
      pinCount: 100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: conditionFilterModels.map((current) {
        return GestureDetector(
          onTap: () {
            conditionFilterModels.forEach((element) {
              element.isActive = false;
            });
            setState(() {
              current.isActive = true;
            });
            if (widget.onFilterChange != null) {
              widget.onFilterChange(current.text);
            }
          },
          child: ConditionFilterItem(
            conditionFilterModel: current,
          ),
        );
      }).toList(),
    );
  }
}

class ConditionFilterModel {
  final String imagePath;
  final String text;
  bool isActive;

  final int pinCount;

  ConditionFilterModel({
    @required this.imagePath,
    @required this.text,
    @required this.pinCount,
    this.isActive = false,
  });
}

class ConditionFilterItem extends StatelessWidget {
  const ConditionFilterItem({
    this.disabledColor = Colors.transparent,
    this.activeColor = const Color(0xffD71773),
    this.conditionFilterModel,
  });

  final ConditionFilterModel conditionFilterModel;
  final Color disabledColor;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: conditionFilterModel.isActive
              ? Color(0xffD71773)
              : Color(0xFFC7CAD1),
        ),
      ),
      padding: EdgeInsets.all(8),
      height: size.width / 4,
      width: size.width / 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            conditionFilterModel.text,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color(0xFFC7CAD1),
            ),
          ),
          Text(
            conditionFilterModel.pinCount.toString(),
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color(0xFFC7CAD1),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
              child: Image.asset(
            conditionFilterModel.imagePath,
          )),
        ],
      ),
    );
  }
}
