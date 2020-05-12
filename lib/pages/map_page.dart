import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lc;
import 'package:pinemoji/models/emoji.dart';
import 'package:pinemoji/models/request.dart';
import 'package:pinemoji/pages/material.dart';
import 'package:pinemoji/repositories/company_repository.dart';
import 'package:pinemoji/repositories/map_repository.dart';
import 'package:pinemoji/repositories/request_repository.dart';
import 'package:pinemoji/services/authentication-service.dart';
import 'package:pinemoji/widgets/header-widget.dart';
import 'package:pinemoji/widgets/search_bar.dart';
import 'package:pinemoji/widgets/feature_shower.dart';

class MapPage extends StatefulWidget {
  final bool isNormalUser;

  MapPage({this.isNormalUser});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  String _query = 'dokuz eylül hastanesi izmir';

  CameraPosition _lastCameraPosition;

  CameraTargetBounds _cameraTargetBounds;

  lc.Location location;

  bool isSearchMode = false;

  RequestRepository requestRepository = RequestRepository();

  LatLngBounds lastLatLngBounds;

  double _mapButtonVisibility = 1;

  List<Request> lastRequestList = [];

  List<String> lastEmojiIdList;

  String lastSelectedPin = "Acil Destek";

  Timer _debounce;
  Timer _debounceNested;
  bool closeList = true;
  bool showHeader = true;

  @override
  void initState() {
    super.initState();
    handleLocation();
    if (widget.isNormalUser) {
      lastEmojiIdList = null;
      lastSelectedPin = null;
      closeList = false;
      showHeader = false;
    }
    handleMapIdleRequest();
    getCurrentLocationMarkers();
  }

  @override
  void dispose() {
    MapRepository.clear();
    super.dispose();
  }

  setStateIfMounted(VoidCallback cb) {
    if (mounted) {
      setState(() {
        cb();
      });
    }
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
                          height: widget.isNormalUser
                              ? (MediaQuery.of(context).size.height / 8 - 40)
                              : MediaQuery.of(context).size.height / 8,
                        ),
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: widget.isNormalUser,
                            child: GoogleMap(
                              myLocationButtonEnabled: false,
                              myLocationEnabled: true,
                              zoomControlsEnabled: false,
                              onCameraMove: (CameraPosition cameraPosition) {
                                _lastCameraPosition = cameraPosition;
//                              cameraPosition.
//                              print('northeast : ${_cameraTargetBounds.bounds.northeast.latitude.toString()} ${_cameraTargetBounds.bounds.northeast.longitude.toString()}');
//                              print('northeast : ${_cameraTargetBounds.bounds.southwest.latitude.toString()} ${_cameraTargetBounds.bounds.southwest.longitude.toString()}');
                              },
                              onCameraIdle: () async {
                                GoogleMapController controller =
                                    await _controller.future;
                                lastLatLngBounds =
                                    await controller.getVisibleRegion();
                                handleMapIdleRequest();
                              },
                              cameraTargetBounds: _cameraTargetBounds,
                              mapType: MapType.normal,
                              initialCameraPosition: _lastCameraPosition,
                              onMapCreated:
                                  (GoogleMapController controller) async {
                                String mapStyle = await rootBundle.loadString(
                                    'assets/map_style/standart.json');
                                controller.setMapStyle(mapStyle);
                                _controller.complete(controller);
                              },
                              markers: MapRepository.markers,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: GradientAppBar(
                        isNormalUser: widget.isNormalUser,
                        barHeight: widget.isNormalUser ? 155 : 280,
                        onPinChange: onPinChange,
                        onFilterChange: onFilterChange,
                        title: !isSearchMode
                            ? Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, left: 8),
                                    child: Container(
                                      width: 150,
                                      child: HeaderWidget(
                                        title: "Malzemeler",
                                        isDarkTeheme: true,
                                      ),
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () => setStateIfMounted(() {
                                  //     isSearchMode = true;
                                  //   }),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(8.0),
                                  //     child: Icon(
                                  //       Icons.search,
                                  //       color: Color(0xffC7CAD1),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              )
                            : SearchBar(
                                onChanged: (String text) {
                                  _query = text;
                                },
                              ),
                      ),
                    ),
                    widget.isNormalUser
                        ? Container()
                        : Positioned(
                            right: 8,
                            bottom: closeList ? 60 : 90,
                            child: AnimatedOpacity(
                              opacity: _mapButtonVisibility,
                              duration: Duration(milliseconds: 800),
                              child: FloatingActionButton.extended(
                                onPressed: () {
                                  getCurrentLocationMarkers();
                                  if (_mapButtonVisibility == 1 && mounted) {
                                    setStateIfMounted(() {
                                      _mapButtonVisibility = 0;
                                    });
                                  }
                                },
                                label: Text(
                                  'Bu Bölgede Ara',
                                  style: TextStyle(fontSize: 12),
                                ),
                                icon: Icon(
                                  Icons.search,
                                  size: 20,
                                ),
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                  ],
                  fit: StackFit.expand,
                ),
              ),
              Container(
                height: closeList
                    ? 50
                    : MediaQuery.of(context).size.height / 3 - 70,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: closeList ? 100 : MediaQuery.of(context).size.height / 3,
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
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setStateIfMounted(() {
                          closeList = !closeList;
                          Future.delayed(Duration(milliseconds: 100)).then(
                              (val) => setStateIfMounted(
                                  () => {showHeader = closeList}));
                        });
                      },
                      child: Padding(
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
                    ),
                    if (!showHeader)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
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
                      ),
                    if (!showHeader)
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: lastRequestList.length,
                          itemBuilder: (context, index) {
                            Request request = lastRequestList.elementAt(index);
                            Emoji emoji = CompanyRepository()
                                .getEmojiList()
                                .firstWhere((element) {
                              return element.id == request.emoji;
                            }, orElse: () {
                              print('No matching element.');
                              return null;
                            });
                            return GestureDetector(
                              onTap: () {
                                Marker marker =
                                    MapRepository.getMarker(request.id);
                                animateCamera(marker.position);
                              },
                              child: HospitalConditionCard(
                                hospitalName: request.locationName ??
                                    'print locationName',
                                emoji: emoji.info ?? 'info',
                                emojiDescription:
                                    emoji.description ?? 'description',
                                index: index,
                              ),
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

  void handleMapIdleRequest() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (_mapButtonVisibility == 0 && mounted) {
        setStateIfMounted(() {
          _mapButtonVisibility = 1;
        });
      }
      if (_debounceNested?.isActive ?? false) _debounceNested.cancel();
      _debounceNested = Timer(const Duration(milliseconds: 5000), () {
        if (_mapButtonVisibility == 1 && mounted) {
          setStateIfMounted(() {
            _mapButtonVisibility = 0;
          });
        }
      });
    });
  }

//  Future<void> searchAndGo() async {
//    PlaceDetails placeDetails =
//        await MapRepository.getPlaceDetailsFromName(_query);
//    LatLng latLang = MapRepository.getLatLngFromPlaceDetails(placeDetails);
//    var list = MarkerType.values.toList();
//    list.shuffle();
//    setStateIfMounted(() {
//      MapRepository.addMarker(placeDetails, markerType: list.first);
//    });
//    final GoogleMapController controller = await _controller.future;
////    LatLng(37.43296265331129, -122.08832357078792)
//    await controller.animateCamera(CameraUpdate.newLatLngZoom(latLang, 16));
//    await Future.delayed(Duration(milliseconds: 400));
//    await controller.animateCamera(CameraUpdate.scrollBy(0, -50));
//    requestRepository.addRequest(Request(
//      location: latLang,
//    ));
//  }

  getCurrentLocationMarkers() async {
    if (widget.isNormalUser)
      await Future.delayed(Duration(
        milliseconds: 2000,
      ));
    lastRequestList = await MapRepository.getCurrentLocationMarkers(
      latLngBounds: lastLatLngBounds,
      option: lastSelectedPin,
      emojiIdList: lastEmojiIdList,
    );
    setStateIfMounted(() {
      lastRequestList.length;
    });
    await Future.delayed(Duration(milliseconds: 300));
    FeatureDiscovery.discoverFeatures(context, ['marker']);
//    print(lastRequestList.length);
//    print(MapRepository.markers.length);
  }

  void handleLocation() async {
    final zoom = 13.0;
    if (AuthenticationService.verifiedUser.location != null) {
      _lastCameraPosition = CameraPosition(
          target: AuthenticationService.verifiedUser.location, zoom: zoom);
      return;
    }
    location = lc.Location();
    lc.PermissionStatus hasPermission = await location.hasPermission();
    if (hasPermission == lc.PermissionStatus.granted) {
      lc.LocationData locationData = await location.getLocation();
      _lastCameraPosition = CameraPosition(
        target: LatLng(locationData.latitude, locationData.longitude),
        zoom: zoom,
      );
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(
          CameraUpdate.newLatLngZoom(_lastCameraPosition.target, zoom));
      await Future.delayed(Duration(milliseconds: 400));
      await controller.animateCamera(CameraUpdate.scrollBy(0, -50));
    } else {
      lc.PermissionStatus requestPermission =
          await location.requestPermission();
      if (requestPermission == lc.PermissionStatus.granted) {
        handleLocation();
      }
    }
    if (_lastCameraPosition == null) {
      //40.0903484,30.4452252,6z
      _lastCameraPosition = CameraPosition(
        target: LatLng(40.0903484, 30.4452252),
        zoom: zoom,
      );
    }
  }

  Function onFilterChange(List<String> filters) {
//    print(filters.toString());
    lastEmojiIdList = filters;
    getCurrentLocationMarkers();
  }

  onPinChange(String currentPin) {
//    print(currentPin.toString());
    lastSelectedPin = currentPin;
    getCurrentLocationMarkers();
  }

  void animateCamera(LatLng latLang) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(latLang, 20));
  }
}

class GradientAppBar extends StatelessWidget {
  final Widget title;
  final double barHeight;
  final bool isNormalUser;

  final GetFilters onFilterChange;

  final Function(String) onPinChange;

  GradientAppBar({
    this.title,
    this.onFilterChange,
    this.onPinChange,
    this.isNormalUser,
    this.barHeight = 280,
  });

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
              if (Navigator.canPop(context))
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              Expanded(child: title),
              if (!Navigator.canPop(context))
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          content: Profile(size: MediaQuery.of(context).size),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/default-profile.png"),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          if (!isNormalUser)
            ConditionFilter(
              state: "Acil Destek",
              onPinChange: onPinChange,
            ),
          if (!isNormalUser)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StockFilter(
                  onFilterChange: onFilterChange,
                ),
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
  const FilterEntry(this.name, this.emoji, this.id);

  final String name;
  final String emoji;
  final String id;
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
    const FilterEntry('Tıbbi Maske', '😷', "1"),
    const FilterEntry('N95 Maske', '😷', "2"),
    const FilterEntry('Siperlik / Gözlük', '🥽', "3"),
    const FilterEntry('Eldiven', '🧤', "4"),
    const FilterEntry('Tek Kullanımlık Önlük', '🥼', "5"),
    const FilterEntry('Solunum Cihazı', '⚗', "6"),
  ];

  List<String> _filters = <String>[];

  setStateIfMounted(VoidCallback cb) {
    if (mounted) {
      setState(() {
        cb();
      });
    }
  }

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
    final bool isActive = _filters.contains(filter.id);
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
          selected: _filters.contains(filter.id),
          onSelected: (bool value) {
            setStateIfMounted(() {
              if (value) {
                _filters.add(filter.id);
              } else {
                _filters.removeWhere((String name) {
                  return name == filter.id;
                });
              }
            });
            getFilters();
          },
        ),
      ),
    );
  }

  Color disabledColor() => Color(0xffC7CAD1);

  Color activeColor() => Color(0xffF93963);

  @override
  void initState() {
    super.initState();
    _filters.add(_cast.first.id);
    if (widget.onFilterChange != null) {
      widget.onFilterChange(_filters);
    }
  }

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
  final Function(String) onPinChange;
  final String state;

  const ConditionFilter({Key key, this.onPinChange, this.state})
      : super(key: key);

  @override
  _ConditionFilterState createState() => _ConditionFilterState();
}

class _ConditionFilterState extends State<ConditionFilter> {
  List<ConditionFilterModel> conditionFilterModels = [
    ConditionFilterModel(
      text: 'Acil Destek',
      imagePath: 'assets/pins/red.png',
    ),
    ConditionFilterModel(
      text: 'Azalıyor !',
      imagePath: 'assets/pins/yellow.png',
    ),
    ConditionFilterModel(
      text: 'Yeterli',
      imagePath: 'assets/pins/blue.png',
    ),
  ];

  setStateIfMounted(VoidCallback cb) {
    if (mounted) {
      setState(() {
        cb();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      conditionFilterModels.forEach((element) {
        if (widget.state == element.text) {
          element.isActive = true;
          // if (widget.onPinChange != null) widget.onPinChange(element.text);
        } else {
          element.isActive = false;
        }
      });
    } else {
      conditionFilterModels.first.isActive = true;
      // if (widget.onPinChange != null) widget.onPinChange(conditionFilterModels.first.text);
    }
  }

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
            setStateIfMounted(() {
              current.isActive = true;
            });
            if (widget.onPinChange != null) {
              widget.onPinChange(current.text);
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
              ),
            ),
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
            conditionFilterModel.pinCount != null
                ? Text(
                    conditionFilterModel.pinCount.toString() + " pin",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFC7CAD1),
                    ),
                  )
                : Text(""),
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

  final int index;

  const HospitalConditionCard({
    Key key,
    @required this.hospitalName,
    @required this.emojiDescription,
    @required this.emoji,
    this.index,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
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
                    ).showFeature(
                      context,
                      title: 'Harita',
                      description:
                          'Hastane isimlerene basarak haritadaki pinleri daha yakından görün!',
                      featureId: 'marker',
                      show: (index == 0),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        hospitalName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    Text(
                      emoji,
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        emojiDescription,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
