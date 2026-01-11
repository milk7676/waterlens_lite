import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import '../database/db.dart';
import '../utils/data_importer.dart';
import 'audit_page.dart';
import 'point_list_page.dart';

class MapPage extends StatefulWidget {
  final AppDatabase database;

  const MapPage({super.key, required this.database});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  LatLng? _currentMouseLatLng;

  @override
  void initState() {
    super.initState();
    _checkAndInsertTestData();
  }

  Future<void> _checkAndInsertTestData() async {
    final count =
        await widget.database.select(widget.database.pipePoints).get();
    if (count.isEmpty) {
      // Lanzhou coordinates: 36.0611, 103.8343
      await widget.database.into(widget.database.pipePoints).insert(
            PipePointsCompanion(
              uuid: const drift.Value('test-uuid-1'),
              type: const drift.Value('test-type'),
              originLng: const drift.Value(103.8343),
              originLat: const drift.Value(36.0611),
              properties: const drift.Value('{"test": true}'),
              auditStatus: const drift.Value(0),
            ),
          );
    }
  }

  Future<void> _moveToCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请开启定位服务')),
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('定位权限被拒绝')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('定位权限被永久拒绝，请在设置中开启')),
        );
      }
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      _mapController.move(LatLng(position.latitude, position.longitude), 16.0);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('获取位置失败: $e')),
        );
      }
    }
  }

  void _addNewPoint() {
    final center = _mapController.camera.center;

    final dummyPoint = PipePoint(
      uuid: '',
      type: '',
      originLng: center.longitude,
      originLat: center.latitude,
      properties: '{}',
      auditStatus: 0,
      isDeleted: false,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AuditPage(
          point: dummyPoint,
          database: widget.database,
          isNew: true,
        ),
      ),
    );
  }

  Future<void> _importGisData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'geojson', 'xlsx', 'md'],
      );

      if (result == null || result.files.isEmpty) return;

      final filePath = result.files.single.path!;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('正在导入数据，请稍候...')),
        );
      }

      final importResult =
          await DataImporter.importFile(filePath, widget.database);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(importResult.message),
            backgroundColor: importResult.success ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导入异常: $e')),
        );
      }
    }
  }

  bool _isNewManual(PipePoint point) {
    if (point.createdAt == null) return false;
    // 只要有创建时间且在24小时内，即视为新添加数据
    // 不再校验 manual- 前缀，因为允许用户修改 UUID
    final diff = DateTime.now().difference(point.createdAt!);
    // print('Debug: UUID=${point.uuid}, CreatedAt=${point.createdAt}, Diff=${diff.inHours}h');
    return diff.inHours < 24 && diff.inHours >= 0; // Ensure not in future
  }

  Widget _buildMarkerContent(PipePoint point, bool isNew) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.location_on,
          color: isNew
              ? const Color(0xFF3498DB) // Blue for new manual points
              : (point.auditStatus == 1 ? Colors.green : Colors.grey),
          size: 40,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            point.uuid,
            style: TextStyle(
              fontSize: 10,
              color: isNew
                  ? const Color(0xFF3498DB)
                  : Colors.black, // Also color text blue
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('地图页 (兰州)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: '数据管理',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      PointListPage(database: widget.database),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'my_location',
            onPressed: _moveToCurrentLocation,
            tooltip: '我的位置',
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'add_point',
            onPressed: _addNewPoint,
            tooltip: '手动添加点位',
            child: const Icon(Icons.add_location_alt),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'import_data',
            onPressed: _importGisData,
            tooltip: '导入 GIS 数据 (GeoJSON)',
            child: const Icon(Icons.file_upload),
          ),
        ],
      ),
      body: StreamBuilder<List<PipePoint>>(
        stream: (widget.database.select(widget.database.pipePoints)
              ..where((t) => t.isDeleted.equals(false)))
            .watch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final points = snapshot.data!;

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(36.0611, 103.8343),
              initialZoom: 15.0,
              onPointerHover: (event, point) {
                setState(() {
                  _currentMouseLatLng = point;
                });
              },
            ),
            children: [
              TileLayer(
                // 使用高德地图瓦片服务 (AMap)，解决国内加载问题
                urlTemplate:
                    'https://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
                userAgentPackageName: 'com.example.waterlens_lite',
              ),
              MarkerLayer(
                markers: points.map((point) {
                  final isNew = _isNewManual(point);
                  return Marker(
                    point: LatLng(point.originLat, point.originLng),
                    width: 120,
                    height: 80,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AuditPage(
                              point: point,
                              database: widget.database,
                            ),
                          ),
                        );
                      },
                      child: Tooltip(
                        message: isNew
                            ? '新添加'
                            : (point.auditStatus == 1 ? '已核查' : '未核查'),
                        child: isNew
                            ? TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0.5, end: 1.0),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.elasticOut,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: child,
                                  );
                                },
                                child: _buildMarkerContent(point, isNew),
                              )
                            : _buildMarkerContent(point, isNew),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_currentMouseLatLng != null)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '经度: ${_currentMouseLatLng!.longitude.toStringAsFixed(6)}\n纬度: ${_currentMouseLatLng!.latitude.toStringAsFixed(6)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
