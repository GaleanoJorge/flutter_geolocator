import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(4.6432365053459295, -74.05374202877283);
  final mp.LatLng _from = mp.LatLng(4.6432365053459295, -74.05374202877283);

  late Position currentPosition;

  var geolocator = Geolocator();
  final Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              // onCameraMove: (CameraPosition val) {
              //   print(val);
              // },
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: _onMapCreated,
              markers: _markers.values.toSet(),
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 16.0)),
          // Center(
          //   child: Container(
          //     width: 5,
          //     height: 5,
          //     color: Colors.red,
          //   ),
          // )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentPosition = position;

    // LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    // CameraPosition cameraPosition =
    //     CameraPosition(target: latLngPosition, zoom: 14.0);
    // mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    List<LatLng> points = [];
    points.add(const LatLng(4.645786261906281, -74.05308354645967));
    points.add(const LatLng(4.644555495899668, -74.05268523842096));
    points.add(const LatLng(4.643342773234623, -74.05390832573175));
    points.add(const LatLng(4.64343968418833, -74.05554950237274));
    points.add(const LatLng(4.645206468793103, -74.05086971819401));

    List<double> distances = [];

    for (int i = 0; i < points.length; i++) {
      mp.LatLng point = mp.LatLng(points[i].latitude, points[i].longitude);
      double distance = (mp.SphericalUtil.computeDistanceBetween(
              _from, point) /
          1.0);
      print("La distancia desde mi ubicación es: " + distance.toString());
      distances.add(distance);
    }

    distances.sort();
    for(double i in distances){
      print(i);
    }
    print('el más cercano es: ' + distances[0].toString());

    final Uint8List markerIcon = await getBytesFromCanvas(200, 100);

    for (int i = 0; i < points.length; i++) {
      String destiny = 'Destino ' + (i).toString();
      _markers[destiny] = Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: MarkerId(destiny + 'id visible?' + (i*2).toString()),
        position: LatLng(points[i].latitude, points[i].longitude),
        infoWindow: InfoWindow(title: destiny, snippet: destiny),
      );
    }
    

    setState(() {
      _markers['Mi Ubicación'] = const Marker(
        markerId: MarkerId('Mi Ubicación'),
        position: LatLng(4.6432365053459295, -74.05374202877283),
        infoWindow: InfoWindow(title: 'Mi Ubicación', snippet: 'Jorge Galeano'),
      );

    });
  }

  Future<Uint8List> getBytesFromCanvas(int width, int height) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = Colors.blue;
  final Radius radius = Radius.circular(20.0);
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint);
  TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
  painter.text = TextSpan(
    text: 'Doctor',
    style: TextStyle(fontSize: 25.0, color: Colors.white),
  );
  painter.layout();
  painter.paint(canvas, Offset((width * 0.5) - painter.width * 0.5, (height * 0.5) - painter.height * 0.5));
  final img = await pictureRecorder.endRecording().toImage(width, height);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}
}
