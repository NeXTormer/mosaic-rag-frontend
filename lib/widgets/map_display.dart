import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

class MapDisplay extends StatefulWidget {
  const MapDisplay({super.key});

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(
            47.0593287234262, 15.458694016069696), // Center the map over London
        initialZoom: 12,
      ),
      children: [
        TileLayer(
          tileProvider: CancellableNetworkTileProvider(),
          // Bring your own tiles
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
          userAgentPackageName: 'eu.ows.mosaicrs', // Add your app identifier
          // And many more recommended properties!
        ),
      ],
    );
  }
}
