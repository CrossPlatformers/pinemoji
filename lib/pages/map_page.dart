import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as lc;
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

  CameraPosition _lastCameraPosition;

  CameraTargetBounds _cameraTargetBounds;

  lc.Location location;

  bool isSearchMode = false;

  @override
  void initState() {
    super.initState();
    handleLocation();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                        ),
                        Expanded(
                          child: GoogleMap(
                            myLocationButtonEnabled: false,
                            myLocationEnabled: true,
                            onCameraMove: (CameraPosition cameraPosition) {
                              _lastCameraPosition = cameraPosition;
//                              cameraPosition.
//                              print('northeast : ${_cameraTargetBounds.bounds.northeast.latitude.toString()} ${_cameraTargetBounds.bounds.northeast.longitude.toString()}');
//                              print('northeast : ${_cameraTargetBounds.bounds.southwest.latitude.toString()} ${_cameraTargetBounds.bounds.southwest.longitude.toString()}');
                            },
                            onCameraIdle: () async {
                              GoogleMapController controller =
                                  await _controller.future;
                              LatLngBounds visibleRegion =
                                  await controller.getVisibleRegion();
                              handleMapIdleRequest(visibleRegion);
                            },
                            cameraTargetBounds: _cameraTargetBounds,
                            mapType: MapType.normal,
                            initialCameraPosition: _lastCameraPosition ??
                                CameraPosition(
                                    target: LatLng(38.9637, 35.2433), zoom: 5),
                            onMapCreated:
                                (GoogleMapController controller) async {
                              String mapStyle = await rootBundle
                                  .loadString('assets/map_style/standart.json');
                              controller.setMapStyle(mapStyle);
                              _controller.complete(controller);
                            },
                            markers: MapRepository.markers,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: GradientAppBar(
                        title: !isSearchMode
                            ? Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
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
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      isSearchMode = true;
                                    }),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.search,
                                        color: Color(0xffC7CAD1),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SearchBar(
                                onChanged: (String text) {
                                  _query = text;
                                },
                              ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 50,
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
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Malzeme Stok Durumu',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff26315F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 1,
                            width: 170,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).primaryColor,
                                  Colors.white
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Hastane',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Color(0xff26315F).withOpacity(.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Malzeme',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Color(0xff26315F).withOpacity(.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return HospitalConditionCard(
                            hospitalName: 'DokuzEylül',
                            emoji: '😷',
                            emojiDescription: 'N95 Maske',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleMapIdleRequest(LatLngBounds visibleRegion) {
     var contains = visibleRegion
        .contains(_lastCameraPosition.target);
    print(contains);
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
    await controller.animateCamera(CameraUpdate.scrollBy(0, -50));
  }

  void handleLocation() async {
    location = lc.Location();
    lc.PermissionStatus hasPermission = await location.hasPermission();
    if (hasPermission == lc.PermissionStatus.granted) {
      lc.LocationData locationData = await location.getLocation();
      _lastCameraPosition = CameraPosition(
        target: LatLng(locationData.latitude, locationData.longitude),
        zoom: 15,
      );
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(
          CameraUpdate.newLatLngZoom(_lastCameraPosition.target, 11));
      await Future.delayed(Duration(milliseconds: 400));
      await controller.animateCamera(CameraUpdate.scrollBy(0, -50));
    } else {
      lc.PermissionStatus requestPermission =
          await location.requestPermission();
      if (requestPermission == lc.PermissionStatus.granted) {
        handleLocation();
      }
    }
  }
}

class GradientAppBar extends StatelessWidget {
  final Widget title;
  final double barHeight = 280.0;

  GradientAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      height: getHeight(statusbarHeight, context),
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
          SizedBox(
            height: 8,
          ),
          ConditionFilter(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StockFilter(),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color(0xff26315F),
              Color(0xff26315F).withOpacity(.7),
              Colors.transparent,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1),
            stops: [0.3, .8, 1],
            tileMode: TileMode.clamp),
      ),
    );
  }

  double getHeight(double statusbarHeight, BuildContext context) {
    return MediaQuery.of(context).size.height > 600
        ? statusbarHeight + barHeight
        : barHeight - 50;
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
            style: TextStyle(
                color: isActive ? activeColor() : disabledColor(),
                fontSize: 12),
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
          behavior: HitTestBehavior.opaque,
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
    this.conditionFilterModel,
  });

  final ConditionFilterModel conditionFilterModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedOpacity(
      opacity: conditionFilterModel.isActive ? 1 : .3,
      duration: Duration(milliseconds: 300),
      child: Container(
        padding: EdgeInsets.all(8),
        height: size.width / 4,
        width: size.width / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Image.asset(
              conditionFilterModel.imagePath,
            )),
            SizedBox(
              height: 5,
            ),
            Text(
              conditionFilterModel.text,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Color(0xFFC7CAD1),
              ),
            ),
            Text(
              conditionFilterModel.pinCount.toString(),
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Color(0xFFC7CAD1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HospitalConditionCard extends StatelessWidget {
  final String hospitalName;

  final String emojiDescription;

  final String emoji;

  const HospitalConditionCard({
    Key key,
    @required this.hospitalName,
    @required this.emojiDescription,
    @required this.emoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
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
                  SizedBox(
                    width: 8,
                  ),
                  Text(hospitalName),
                ],
              ),
              Row(
                children: [
                  Text(
                    emoji,
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(emojiDescription),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
