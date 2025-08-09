import 'package:atheer/src/features/dashboard/presentation/widgets/map_planning.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class MiniMap extends StatefulWidget {
  const MiniMap({super.key});

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  final MapController _mapController = MapController();
  LatLng _currentCenter = const LatLng(
    51.509364,
    -0.128928,
  ); // Initial position
  double _currentZoom = 13.0;

  // Update coordinates when map moves
  void _updatePosition() {
    setState(() {
      _currentCenter = _mapController.camera.center;
      _currentZoom = _mapController.camera.zoom;
    });
  }

  @override
  void initState() {
    super.initState();
    _mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveEnd) {
        _updatePosition();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentCenter,
                  initialZoom: _currentZoom,
                  minZoom: 2.0,
                  maxZoom: 25.0,
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture) {
                      _updatePosition();
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentCenter,
                        child: const Icon(
                          HugeIcons.strokeRoundedDrone,
                          color: Colors.black,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ).clipRRect(borderRadius: BorderRadius.circular(12)),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    IconButton.secondary(
                      onPressed: () {
                        _mapController.move(
                          _mapController.camera.center,
                          _mapController.camera.zoom + 1,
                        );
                      },
                      icon: const Icon(HugeIcons.strokeRoundedSearchAdd),
                      size: ButtonSize.small,
                    ),
                    IconButton.secondary(
                      onPressed: () {
                        _mapController.move(
                          _mapController.camera.center,
                          _mapController.camera.zoom - 1,
                        );
                      },
                      icon: const Icon(HugeIcons.strokeRoundedSearchMinus),
                      size: ButtonSize.small,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: Row(
                children: [
                  Button.secondary(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return MapPlanning();
                        },
                      );
                    },
                    child: Icon(HugeIcons.strokeRoundedFullScreen),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 12,
              left: 12,
              child: Row(
                children: [
                  Button.secondary(
                    child: Text(
                      "${_currentCenter.latitude.toStringAsFixed(4)}, "
                      "${_currentCenter.longitude.toStringAsFixed(4)}",
                    ).muted(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
