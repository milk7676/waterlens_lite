import 'dart:io';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

import '../database/db.dart';
import '../utils/data_exporter.dart';

class PointListPage extends StatefulWidget {
  final AppDatabase database;

  const PointListPage({super.key, required this.database});

  @override
  State<PointListPage> createState() => _PointListPageState();
}

class _PointListPageState extends State<PointListPage> {
  Set<String> _selectedUuids = {};
  bool _isAllSelected = false;
  bool _showRecycleBin = false; // 是否显示回收站

  Future<String?> _pickExportExtension() async {
    return showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('选择导出格式'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('json'),
            child: const Text('JSON'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('geojson'),
            child: const Text('GeoJSON'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('xlsx'),
            child: const Text('Excel (.xlsx)'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('md'),
            child: const Text('Markdown (.md)'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSelected(List<PipePoint> allPoints) async {
    final pointsToExport = _selectedUuids.isNotEmpty
        ? allPoints.where((p) => _selectedUuids.contains(p.uuid)).toList()
        : allPoints; // 如果未选择，默认导出当前列表所有数据

    if (pointsToExport.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有可导出的数据')),
      );
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正在准备导出...')),
      );
    }

    late final ExportResult result;
    if (Platform.isAndroid || Platform.isIOS) {
      final ext = await _pickExportExtension();
      if (ext == null) {
        result = ExportResult(success: false, message: '取消导出');
      } else {
        result = await DataExporter.exportDataWithExtension(pointsToExport, ext);
      }
    } else {
      result = await DataExporter.exportData(pointsToExport);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _handleAppBarExport() async {
    final points = await (widget.database.select(widget.database.pipePoints)
          ..where((t) => t.isDeleted.equals(_showRecycleBin)))
        .get();
    await _exportSelected(points);
  }

  void _toggleSelectAll(List<PipePoint> points) {
    setState(() {
      if (_isAllSelected) {
        _selectedUuids.clear();
        _isAllSelected = false;
      } else {
        _selectedUuids = points.map((e) => e.uuid).toSet();
        _isAllSelected = true;
      }
    });
  }

  Future<void> _processSelected(List<PipePoint> allPoints, {required bool isDelete}) async {
    final pointsToProcess = allPoints.where((p) => _selectedUuids.contains(p.uuid)).toList();
    
    if (pointsToProcess.isEmpty) return;

    final actionName = _showRecycleBin 
        ? (isDelete ? '彻底删除' : '恢复') 
        : '移入回收站';
        
    final confirmMessage = _showRecycleBin
        ? (isDelete 
            ? '确定要彻底删除选中的 ${pointsToProcess.length} 条数据吗？\n（照片将被保留）\n此操作不可恢复！' 
            : '确定要恢复选中的 ${pointsToProcess.length} 条数据吗？')
        : '确定要将选中的 ${pointsToProcess.length} 条数据移入回收站吗？\n（照片将被保留）';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认$actionName'),
        content: Text(confirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: isDelete ? Colors.red : Colors.green,
            ),
            child: Text(actionName),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // 执行数据库操作
    if (_showRecycleBin) {
      if (isDelete) {
        // 彻底删除（仅删除数据库记录，保留照片）
        await (widget.database.delete(widget.database.pipePoints)
              ..where((t) => t.uuid.isIn(_selectedUuids)))
            .go();
      } else {
        // 恢复数据
        await (widget.database.update(widget.database.pipePoints)
              ..where((t) => t.uuid.isIn(_selectedUuids)))
            .write(const PipePointsCompanion(isDeleted: drift.Value(false)));
      }
    } else {
      // 软删除（移入回收站）
      await (widget.database.update(widget.database.pipePoints)
            ..where((t) => t.uuid.isIn(_selectedUuids)))
          .write(const PipePointsCompanion(isDeleted: drift.Value(true)));
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已成功$actionName ${pointsToProcess.length} 条数据')),
      );
      setState(() {
        _selectedUuids.clear();
        _isAllSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showRecycleBin ? '回收站' : '数据管理'),
        actions: [
          if (!_showRecycleBin)
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: '导出数据',
              onPressed: _handleAppBarExport,
            ),
          IconButton(
            icon: Icon(_showRecycleBin ? Icons.list : Icons.delete_outline),
            tooltip: _showRecycleBin ? '返回列表' : '回收站',
            onPressed: () {
              setState(() {
                _showRecycleBin = !_showRecycleBin;
                _selectedUuids.clear();
                _isAllSelected = false;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<PipePoint>>(
        stream: (widget.database.select(widget.database.pipePoints)
              ..where((t) => t.isDeleted.equals(_showRecycleBin)))
            .watch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final points = snapshot.data!;
          
          // 如果数据库变动导致选中的UUID不存在了，清理一下
          final currentUuids = points.map((e) => e.uuid).toSet();
          _selectedUuids.removeWhere((uuid) => !currentUuids.contains(uuid));
          
          if (points.isEmpty) {
            return Center(child: Text(_showRecycleBin ? '回收站为空' : '暂无数据'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isAllSelected && _selectedUuids.length == points.length,
                      onChanged: (v) => _toggleSelectAll(points),
                    ),
                    const Text('全选'),
                    const Spacer(),
                    if (_selectedUuids.isNotEmpty) ...[
                      if (!_showRecycleBin)
                        ElevatedButton.icon(
                          onPressed: () => _exportSelected(points),
                          icon: const Icon(Icons.download, size: 18),
                          label: Text('导出'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (_showRecycleBin) 
                        ElevatedButton.icon(
                          onPressed: () => _processSelected(points, isDelete: false),
                          icon: const Icon(Icons.restore, size: 18),
                          label: Text('恢复 (${_selectedUuids.length})'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => _processSelected(points, isDelete: true),
                        icon: const Icon(Icons.delete, size: 18),
                        label: Text(_showRecycleBin ? '彻底删除' : '删除'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                    if (_selectedUuids.isEmpty && !_showRecycleBin)
                      ElevatedButton.icon(
                        onPressed: () => _exportSelected(points),
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('导出全部'),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: points.length,
                  itemBuilder: (context, index) {
                    final point = points[index];
                    final isSelected = _selectedUuids.contains(point.uuid);

                    return ListTile(
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedUuids.add(point.uuid);
                            } else {
                              _selectedUuids.remove(point.uuid);
                            }
                            _isAllSelected = _selectedUuids.length == points.length;
                          });
                        },
                      ),
                      title: Text(point.uuid, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '类型: ${point.type}\n状态: ${point.auditStatus == 1 ? "已核查" : "未核查"}',
                      ),
                      trailing: point.auditStatus == 1
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.circle_outlined, color: Colors.grey),
                      onTap: () {
                         setState(() {
                            if (!isSelected) {
                              _selectedUuids.add(point.uuid);
                            } else {
                              _selectedUuids.remove(point.uuid);
                            }
                            _isAllSelected = _selectedUuids.length == points.length;
                          });
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
