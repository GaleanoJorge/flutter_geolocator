import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  final LatLng _center = const LatLng(4.65, -74.1);

  late Position currentPosition;

  var geolocator = Geolocator();
  final Map<String, Marker> _markers = {};

  int _selectedIndex = 0;

  // ignore: prefer_final_fields
  List<Widget> _widgetOptions = <Widget>[
    const Text(
      '',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    Container(
      color: Colors.black54,
      child: AlertDialog(
        title: const Text('Alerta'),
        content: Text('Alerta de uso de Flutter en Agenda'),
        actions: [
          FlatButton(onPressed: () {}, child: const Text('OK')),
          FlatButton(onPressed: () {}, child: const Text('CERRAR')),
        ],
      ),
    ),
    Image.network(
        'https://ii.ct-stc.com/1/logos/empresas/2018/07/09/healthlife-sas-C338ED616469628A151449159thumbnail.png'),
    const Text(
      'Perfil',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        key: Key('Hola'),
        child: Center(
          child: Column(
            children: <Widget>[
              drawerBoton('message', Icons.message),
              drawerBoton('primera', Icons.price_change),
              drawerBoton('segunda', Icons.pedal_bike_outlined),
              drawerBoton('perfil', Icons.person),
              drawerBoton('calendar', Icons.calendar_today),
              drawerBoton('info', Icons.info),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: const Key('BND'),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          bottonItem(Icons.home, 'Inicio'),
          bottonItem(Icons.calendar_today, 'Agenda'),
          bottonItem(Icons.health_and_safety_outlined, 'Servicios'),
          bottonItem(Icons.settings, 'Perfil'),
        ],
        onTap: (val) {
          setState(() {
            _selectedIndex = val;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // Api de maps
      body: Stack(
        children: [
          GoogleMap(
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: _onMapCreated,
              markers: _markers.values.toSet(),
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 15.0)),
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 16.0);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
      _markers['Mi Ubicación'] = Marker(
        markerId: const MarkerId('Mi Ubicación'),
        position: latLngPosition,
        infoWindow:
            const InfoWindow(title: 'Mi Ubicación', snippet: 'Jorge Galeano'),
      );
    });
  }

  Padding drawerBoton(String message, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: () {},
        child: Row(
          children: <Widget>[
            Icon(icon),
            const SizedBox(
              width: 7.0,
            ),
            Text(
              message,
              style: const TextStyle(fontSize: 15.0),
            )
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem bottonItem(IconData icon, String message) =>
      BottomNavigationBarItem(
        icon: Icon(icon),
        label: message,
        backgroundColor: Colors.white,
      );
}
