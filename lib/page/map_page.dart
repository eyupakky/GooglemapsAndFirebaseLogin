import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evreka_technical_question/model/konteyner_model.dart';
import 'package:evreka_technical_question/util/helper.dart';
import 'package:evreka_technical_question/widget/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MapPage extends BasePage {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends BaseState<MapPage> with BasicPage {
  static final CameraPosition center = CameraPosition(
    target: LatLng(39.9030394, 32.8985798),
    zoom: 12.4746,
  );
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = center.target;
  MapType _currentMapType = MapType.normal;
  Stream<QuerySnapshot> _stream;
  QuerySnapshot snapshot;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection("konteyner").orderBy("time").snapshots();
    _stream.listen((event) {
      snapshot = event;
      addNewMarkers(snapshot);
    });
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  setMarkers() async {
    final CollectionReference postsRef = FirebaseFirestore.instance.collection('konteyner');
    var rng = new Random();
    for (var k = 0; k < 100; k++)
      for (var i = 0; i < 10; i++) {
        LatLng latLng = LatLng(_lastMapPosition.latitude + (0.0001 * i * 2), _lastMapPosition.longitude + (0.00001 * k * k));

        KonteynerModel data = KonteynerModel(
            sensorID: "Sensor ${i * 6}",
            containerID: 'Container ${i * 4}',
            time: new DateTime.now().toString(),
            rate: rng.nextInt(100),
            latLng: latLng);
        postsRef.add({
          'position': data.toJson(),
          'sensorID': data.sensorID,
          'containerID': data.containerID,
          'time': data.time,
          'rate': data.rate,
          'id': postsRef.firestore.hashCode
        });
      }
  }

  void addNewMarkers(QuerySnapshot data) async {
    _markers.clear();
    setState(() {});
    var icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), "assets/green.png");
    if (data != null && data.docs.length > 0) {
      for (int i = 0; i < data.docs.length; i++) {
        double lon = data.docs[i]['position']['longitude'];
        double lat = data.docs[i]['position']['latitude'];

        _markers.add(Marker(
          draggable: true,
          onTap: () {
            bottomDialog(data.docs[i]);
          },
          onDragEnd: (latlng) {
            KonteynerModel model = KonteynerModel(latLng: latlng);
            FirebaseFirestore.instance.collection('konteyner').doc(data.docs[i].id).update({'position': model.toJson()});
            showToast("Update successful.");
          },
          infoWindow: InfoWindow(
            title: data.docs[i]['sensorID'],
            snippet: '% ${data.docs[i]['rate']}',
          ),
          markerId: MarkerId('${data.docs[i]['id']}'),
          position: LatLng(lat, lon),
          icon: icon,
        ));
      }
    }
    setState(() {});
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Widget bottomDialog(QueryDocumentSnapshot doc) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            margin: EdgeInsets.all(30),
            padding: EdgeInsets.all(21),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      doc['sensorID'],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Container ID',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(83, 90, 114, 1)),
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      doc['containerID'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color.fromRGBO(83, 90, 114, 1)),
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Fullness Rate',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(83, 90, 114, 1)),
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '%${doc['rate']}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color.fromRGBO(83, 90, 114, 1)),
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${doc['time'].split(".")[0]}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color.fromRGBO(83, 90, 114, 1)),
                    )),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          MapsLauncher.launchCoordinates(doc['position']['latitude'], doc['position']['longitude']);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 7,
                                offset: Offset(0, 10), // changes position of shadow
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(69, 175, 35, 1).withOpacity(0.2),
                                blurRadius: 7,
                                offset: Offset(0, 12), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color.fromRGBO(69, 155, 35, 1),
                          ),
                          child: Text(
                            'NAVIGATE',
                            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 22,
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          showToast("Please hold down the container whose position you want to change and drag it to its new position.");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 7,
                                offset: Offset(0, 10), // changes position of shadow
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(69, 175, 35, 1).withOpacity(0.2),
                                blurRadius: 7,
                                offset: Offset(0, 12), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color.fromRGBO(69, 155, 35, 1),
                          ),
                          child: Text(
                            'RELOCATE',
                            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget body() {
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: center,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 50,
              height: 75,
              margin: EdgeInsets.only(left: 16),
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "asdasdasd",
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                  SizedBox(height: 16.0),
                  /*  FloatingActionButton(
                    heroTag: "asdsadddddd",
                    onPressed: setMarkers,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add_location, size: 36.0),
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  checkInternetConnection() {
    return false;
  }
}
