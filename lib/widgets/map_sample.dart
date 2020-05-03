import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pinemoji/repositories/map_repository.dart';
import 'package:pinemoji/widgets/search_bar.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
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
//                    String mapStyle = await rootBundle
//                        .loadString('assets/map_style/sliver.json');
//                    controller.setMapStyle(mapStyle);
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
  final double barHeight = 250.0;

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
              child: CastFilter(),
            ),
          ),
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

class CastFilter extends StatefulWidget {
  final GetFilters getFilters;

  const CastFilter({Key key, this.getFilters}) : super(key: key);

  @override
  State createState() => CastFilterState();
}

class CastFilterState extends State<CastFilter> {
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
    if (widget.getFilters != null) {
      widget.getFilters(_filters);
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
          disabledColor: Colors.blue,
          selectedColor: Colors.transparent,
          selectedShadowColor: activeColor(),
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
