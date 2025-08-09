import 'package:flutter/material.dart' show ListTile;
import 'package:flutter_map/flutter_map.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class MapPlanning extends StatefulWidget {
  const MapPlanning({super.key});

  @override
  State<MapPlanning> createState() => _MapPlanningState();
}

class _MapPlanningState extends State<MapPlanning> {
  final MapController _mapController = MapController();
  final _drawingToolsWidth = 300.0;

  // Map state
  CameraPosition _currentPosition = const CameraPosition(
    center: LatLng(45.3367881884556, 0),
    zoom: 3.0,
  );

  // Drawing state
  DrawingMode _drawingMode = DrawingMode.none;
  final List<LatLng> _polygonPoints = [];
  final List<CircleMarker> _circles = [];
  final List<Polygon> _polygons = [];
  final List<Marker> _markers = [];
  double _circleRadius = 100.0; // Default radius in meters

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _updatePosition() {
    setState(() {
      _currentPosition = CameraPosition(
        center: _mapController.camera.center,
        zoom: _mapController.camera.zoom,
      );
    });
  }

  void _handleMapTap(TapPosition tapPosition, LatLng point) {
    if (_drawingMode == DrawingMode.none) return;

    setState(() {
      switch (_drawingMode) {
        case DrawingMode.circle:
          _addCircle(point);
          break;
        case DrawingMode.marker:
          _addMarker(point);
          break;
        case DrawingMode.polygon:
          _addPolygonPoint(point);
          break;
        case DrawingMode.none:
          break;
      }
    });
  }

  void _addCircle(LatLng point) {
    _circles.add(
      CircleMarker(
        point: point,
        radius: _circleRadius,
        useRadiusInMeter: true,
        color: Colors.blue.withOpacity(0.5),
        borderColor: Colors.blue,
        borderStrokeWidth: 2,
      ),
    );
  }

  void _addMarker(LatLng point) {
    _markers.add(
      Marker(
        point: point,
        width: 40,
        height: 40,
        child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
      ),
    );
  }

  void _addPolygonPoint(LatLng point) {
    _polygonPoints.add(point);
  }

  void _clearAllDrawings() {
    setState(() {
      _circles.clear();
      _polygons.clear();
      _markers.clear();
      _polygonPoints.clear();
      _drawingMode = DrawingMode.none;
    });
  }

  void _finishPolygon() {
    if (_polygonPoints.length >= 3) {
      setState(() {
        _polygons.add(
          Polygon(
            points: List.from(_polygonPoints),
            color: Colors.green.withOpacity(0.3),
            borderColor: Colors.green,
            borderStrokeWidth: 2,
          ),
        );
        _polygonPoints.clear();
        _drawingMode = DrawingMode.none;
      });
    }
  }

  void _deleteItem(int index, DrawnItemType type) {
    setState(() {
      switch (type) {
        case DrawnItemType.marker:
          _markers.removeAt(index);
          break;
        case DrawnItemType.circle:
          _circles.removeAt(index);
          break;
        case DrawnItemType.polygon:
          _polygons.removeAt(index);
          break;
      }
    });
  }

  void _zoomToItem(dynamic item) {
    if (item is Marker) {
      _mapController.move(item.point, _currentPosition.zoom);
    } else if (item is CircleMarker) {
      _zoomToCircle(item);
    } else if (item is Polygon) {
      _zoomToPolygon(item);
    }
  }

  void _zoomToCircle(CircleMarker circle) {
    final distance = const Distance();
    final radiusInDegrees = circle.radius / 111320.0;
    final bounds = LatLngBounds(
      LatLng(
        circle.point.latitude + radiusInDegrees,
        circle.point.longitude + radiusInDegrees,
      ),
      LatLng(
        circle.point.latitude - radiusInDegrees,
        circle.point.longitude - radiusInDegrees,
      ),
    );
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }

  void _zoomToPolygon(Polygon polygon) {
    final bounds = LatLngBounds.fromPoints(polygon.points);
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentPosition.center,
            initialZoom: _currentPosition.zoom,
            minZoom: 3.0,
            maxZoom: 25.0,
            backgroundColor: Colors.black,
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) _updatePosition();
            },
            onTap: _handleMapTap,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            CircleLayer(circles: _circles),
            PolygonLayer(polygons: _polygons),
            MarkerLayer(markers: _markers),
            if (_polygonPoints.isNotEmpty) _buildCurrentPolygonLayer(),
            if (_polygonPoints.isNotEmpty) _buildPolygonPointsLayer(),
          ],
        ).clipRRect(borderRadius: BorderRadius.circular(12)),
        _buildPositionIndicator(),
      ],
    );
  }

  Widget _buildCurrentPolygonLayer() {
    return PolygonLayer(
      polygons: [
        Polygon(
          points: _polygonPoints,
          color: Colors.green.withOpacity(0.2),
          borderColor: Colors.green,
          borderStrokeWidth: 1,
        ),
      ],
    );
  }

  Widget _buildPolygonPointsLayer() {
    return MarkerLayer(
      markers: _polygonPoints
          .map(
            (point) => Marker(
              point: point,
              width: 20,
              height: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: const Icon(Icons.circle, size: 10, color: Colors.green),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPositionIndicator() {
    return Positioned(
      bottom: 12,
      left: 12,
      child: Button.secondary(
        child: Text(
          "${_currentPosition.center.latitude.toStringAsFixed(4)}, "
          "${_currentPosition.center.longitude.toStringAsFixed(4)}",
        ).muted(),
      ),
    );
  }

  Widget _buildDrawingToolsPanel() {
    return Container(
      width: _drawingToolsWidth,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.border,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Drawing Tools").large(),
          const SizedBox(height: 12),
          _buildDrawingModeButtons(),
          if (_drawingMode == DrawingMode.circle) _buildCircleRadiusControls(),
        ],
      ),
    );
  }

  Widget _buildDrawingModeButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildDrawingModeButton(
          "Select",
          DrawingMode.none,
          isActive: _drawingMode == DrawingMode.none,
        ),
        _buildDrawingModeButton(
          "Marker",
          DrawingMode.marker,
          isActive: _drawingMode == DrawingMode.marker,
        ),
        _buildDrawingModeButton(
          "Circle",
          DrawingMode.circle,
          isActive: _drawingMode == DrawingMode.circle,
        ),
        _buildDrawingModeButton(
          "Polygon",
          DrawingMode.polygon,
          isActive: _drawingMode == DrawingMode.polygon,
        ),
        Button.outline(
          onPressed: _clearAllDrawings,
          child: const Text("Clear All"),
        ),
        if (_drawingMode == DrawingMode.polygon && _polygonPoints.isNotEmpty)
          Button.outline(
            onPressed: _finishPolygon,
            child: const Text("Finish Polygon"),
          ),
      ],
    );
  }

  Widget _buildDrawingModeButton(
    String label,
    DrawingMode mode, {
    required bool isActive,
  }) {
    return Button.outline(
      onPressed: () => setState(() {
        _drawingMode = mode;
        if (mode != DrawingMode.polygon) {
          _polygonPoints.clear();
        }
      }),

      child: Text(label),
    );
  }

  Widget _buildCircleRadiusControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text("Circle Radius (meters)"),
        Slider(
          value: SliderValue.single(_circleRadius),
          min: 100,
          max: 10000,
          onChanged: (SliderValue value) {
            setState(() => _circleRadius = value.value);
          },
        ),
        Text("${_circleRadius.round()} meters"),
      ],
    );
  }

  Widget _buildDrawnItemsPanel() {
    return Container(
      width: _drawingToolsWidth,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.border,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Drawn Items").large(),
          const SizedBox(height: 12),
          if (_circles.isEmpty && _polygons.isEmpty && _markers.isEmpty)
            Text("No items drawn yet").muted(),
          Expanded(child: _buildDrawnItemsList()),
        ],
      ),
    );
  }

  Widget _buildDrawnItemsList() {
    return ListView(
      shrinkWrap: true,
      children: [
        ..._buildMarkerItems(),
        ..._buildCircleItems(),
        ..._buildPolygonItems(),
      ],
    );
  }

  List<Widget> _buildMarkerItems() {
    return _markers.asMap().entries.map((entry) {
      final index = entry.key;
      final marker = entry.value;
      return _buildDrawnItemTile(
        index: index,
        type: DrawnItemType.marker,
        icon: const Icon(Icons.location_pin, color: Colors.red),
        title: "Marker ${index + 1}",
        subtitle:
            "${marker.point.latitude.toStringAsFixed(4)}, "
            "${marker.point.longitude.toStringAsFixed(4)}",
        item: marker,
      );
    }).toList();
  }

  List<Widget> _buildCircleItems() {
    return _circles.asMap().entries.map((entry) {
      final index = entry.key;
      final circle = entry.value;
      return _buildDrawnItemTile(
        index: index,
        type: DrawnItemType.circle,
        icon: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circle.color,
          ),
        ),
        title: "Circle ${index + 1}",
        subtitle:
            "${circle.point.latitude.toStringAsFixed(4)}, "
            "${circle.point.longitude.toStringAsFixed(4)}\n"
            "Radius: ${circle.radius.round()}m",
        item: circle,
      );
    }).toList();
  }

  List<Widget> _buildPolygonItems() {
    return _polygons.asMap().entries.map((entry) {
      final index = entry.key;
      final polygon = entry.value;
      return _buildDrawnItemTile(
        index: index,
        type: DrawnItemType.polygon,
        icon: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: polygon.color,
            border: Border.all(
              color: polygon.borderColor ?? Colors.transparent,
            ),
          ),
        ),
        title: "Polygon ${index + 1}",
        subtitle: "${polygon.points.length} points",
        item: polygon,
      );
    }).toList();
  }

  Widget _buildDrawnItemTile({
    required int index,
    required DrawnItemType type,
    required Widget icon,
    required String title,
    required String subtitle,
    required dynamic item,
  }) {
    return ContextMenu(
      items: [
        MenuButton(
          onPressed: (context) => _zoomToItem(item),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(HugeIcons.strokeRoundedZoomInArea),
              Text("Zoom to"),
            ],
          ),
        ),
        MenuButton(
          onPressed: (context) => _deleteItem(index, type),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Icon(HugeIcons.strokeRoundedDelete01), Text("Delete")],
          ),
        ),
      ],
      child: ListTile(
        leading: icon,
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [_buildDrawingToolsPanel(), _buildDrawnItemsPanel()],
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9,
              child: _buildMap(),
            ),
          ),
        ],
      ),
    );
  }
}

enum DrawingMode { none, marker, circle, polygon }

enum DrawnItemType { marker, circle, polygon }

class CameraPosition {
  final LatLng center;
  final double zoom;

  const CameraPosition({required this.center, required this.zoom});
}
