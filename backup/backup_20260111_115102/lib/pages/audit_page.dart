import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../database/db.dart';

class AuditPage extends StatefulWidget {
  final PipePoint point;
  final AppDatabase database;
  final bool isNew;

  const AuditPage({
    super.key,
    required this.point,
    required this.database,
    this.isNew = false,
  });

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  final TextEditingController _uuidController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();

  List<File> _photoFiles = [];
  final ImagePicker _picker = ImagePicker();

  String _originalMaterial = '';

  @override
  void initState() {
    super.initState();

    if (widget.isNew) {
      // New record mode: initialize with generated UUID and empty values
      _uuidController.text = 'manual-${DateTime.now().millisecondsSinceEpoch}';
      _typeController.text = '';
      _lngController.text = widget.point.originLng.toString();
      _latController.text = widget.point.originLat.toString();
      _materialController.text = '';
      // Depth is empty by default
    } else {
      // Existing record mode: load from DB point
      _uuidController.text = widget.point.uuid;
      _typeController.text = widget.point.fixType ?? widget.point.type;
      _lngController.text =
          (widget.point.fixLng ?? widget.point.originLng).toString();
      _latController.text =
          (widget.point.fixLat ?? widget.point.originLat).toString();

      // Initialize material from fixMaterial or properties
      if (widget.point.fixMaterial != null) {
        _materialController.text = widget.point.fixMaterial!;
      } else {
        try {
          final props = jsonDecode(widget.point.properties);
          if (props is Map) {
            _originalMaterial =
                props['material']?.toString() ?? props['材质']?.toString() ?? '';
            _materialController.text = _originalMaterial;
          }
        } catch (_) {}
      }

      if (widget.point.fixDepth != null) {
        _depthController.text = widget.point.fixDepth.toString();
      }

      if (widget.point.photoPath != null &&
          widget.point.photoPath!.isNotEmpty) {
        try {
          // 尝试解析 JSON 列表
          final List<dynamic> paths = jsonDecode(widget.point.photoPath!);
          _photoFiles = paths.map((path) => File(path.toString())).toList();
        } catch (e) {
          // Fallback
          final file = File(widget.point.photoPath!);
          if (file.existsSync()) {
            _photoFiles = [file];
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _uuidController.dispose();
    _typeController.removeListener(_onFieldChanged);
    _lngController.removeListener(_onFieldChanged);
    _latController.removeListener(_onFieldChanged);
    _materialController.removeListener(_onFieldChanged);
    _depthController.removeListener(_onFieldChanged);

    _depthController.dispose();
    _typeController.dispose();
    _lngController.dispose();
    _latController.dispose();
    _materialController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {});
  }

  // Style helper
  TextStyle? _getStyle(bool isModified) {
    if (isModified) {
      return const TextStyle(
        color: Color(0xFFFF0000), // Red
        fontWeight: FontWeight.bold,
      );
    }
    return null;
  }

  bool get _isTypeModified => _typeController.text != widget.point.type;

  bool get _isMaterialModified => _materialController.text != _originalMaterial;

  bool get _isLngModified {
    final current = double.tryParse(_lngController.text);
    if (current == null) return true; // Treat invalid input as modified/error
    return (current - widget.point.originLng).abs() > 0.000001;
  }

  bool get _isLatModified {
    final current = double.tryParse(_latController.text);
    if (current == null) return true;
    return (current - widget.point.originLat).abs() > 0.000001;
  }

  // Depth is always "newly filled" audit data, so we style it if it has content
  bool get _isDepthModified => _depthController.text.isNotEmpty;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _photoFiles.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('拍照/选图失败: $e')),
        );
      }
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photoFiles.removeAt(index);
    });
  }

  Future<String?> _savePhotosToLocal() async {
    if (_photoFiles.isEmpty) return null;

    final appDir = await getApplicationDocumentsDirectory();
    List<String> savedPaths = [];

    for (int i = 0; i < _photoFiles.length; i++) {
      final file = _photoFiles[i];

      // 如果已经是应用目录下的文件（之前保存过的），直接使用路径
      if (p.isWithin(appDir.path, file.path)) {
        savedPaths.add(file.path);
        continue;
      }

      // 否则将临时文件复制到应用目录
      // 使用 UUID + 时间戳 + 索引 避免文件名冲突
      final fileName =
          '${widget.point.uuid}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final savedImage = await file.copy(p.join(appDir.path, fileName));
      savedPaths.add(savedImage.path);
    }

    // 将路径列表转换为 JSON 字符串
    return jsonEncode(savedPaths);
  }

  Future<void> _deletePoint() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要将此记录移入回收站吗？\n（照片将被保留）'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('移入回收站'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // 软删除：仅更新 isDeleted 字段，不删除本地照片
    final updatedPoint = widget.point.copyWith(
      isDeleted: true,
    );

    await widget.database
        .update(widget.database.pipePoints)
        .replace(updatedPoint);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onConfirm() async {
    final text = _depthController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入实测埋深')),
      );
      return;
    }

    final depth = double.tryParse(text);
    if (depth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的数字')),
      );
      return;
    }

    if (depth < 0.7) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('警告：埋深小于 0.7 米！')),
      );
      // return; // 允许保存，仅警告
    }

    final fixLng = double.tryParse(_lngController.text.trim());
    final fixLat = double.tryParse(_latController.text.trim());

    if (fixLng == null || fixLat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的经纬度')),
      );
      return;
    }

    // 保存所有图片并获取 JSON 字符串
    try {
      String? photoPathJson = await _savePhotosToLocal();

      if (widget.isNew) {
        // Create new record
        // Use Type as the main type if provided, otherwise 'unknown'
        // If the user entered a fixType, we use that as the initial type as well
        final type = _typeController.text.trim().isEmpty
            ? 'unknown'
            : _typeController.text.trim();
        final uuid = _uuidController.text.trim().isEmpty
            ? 'manual-${DateTime.now().millisecondsSinceEpoch}'
            : _uuidController.text.trim();

        await widget.database.into(widget.database.pipePoints).insert(
              PipePointsCompanion(
                uuid: drift.Value(uuid),
                type: drift.Value(type),
                originLng: drift.Value(fixLng),
                originLat: drift.Value(fixLat),
                properties: const drift.Value('{}'),
                auditStatus: const drift.Value(1),
                fixDepth: drift.Value(depth),
                fixType: drift.Value(_typeController.text.trim()),
                fixLng: drift.Value(fixLng),
                fixLat: drift.Value(fixLat),
                fixMaterial: drift.Value(_materialController.text.trim()),
                photoPath: drift.Value(photoPathJson),
                createdAt: drift.Value(DateTime.now()),
              ),
            );
      } else {
        // 更新数据库
        final updatedPoint = widget.point.copyWith(
          auditStatus: 1,
          fixDepth: drift.Value(depth),
          fixType: drift.Value(_typeController.text.trim()),
          fixLng: drift.Value(fixLng),
          fixLat: drift.Value(fixLat),
          fixMaterial: drift.Value(_materialController.text.trim()),
          photoPath: drift.Value(photoPathJson),
        );

        await widget.database
            .update(widget.database.pipePoints)
            .replace(updatedPoint);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? '新增点位' : '核查页'),
        actions: [
          if (!widget.isNew)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deletePoint,
              tooltip: '删除此记录',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isNew) ...[
              Text('UUID: ${widget.point.uuid}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                  '原始坐标: (${widget.point.originLng.toStringAsFixed(6)}, ${widget.point.originLat.toStringAsFixed(6)})'),
              const SizedBox(height: 20),
            ] else ...[
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text('请填写新点位信息:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: _uuidController,
                decoration: const InputDecoration(
                  labelText: 'UUID (唯一标识符)',
                  border: OutlineInputBorder(),
                  helperText: '默认自动生成，也可手动修改',
                ),
              ),
              const SizedBox(height: 16),
            ],

            // New fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _typeController,
                    style: _getStyle(_isTypeModified),
                    decoration: const InputDecoration(
                      labelText: '类型',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _materialController,
                    style: _getStyle(_isMaterialModified),
                    decoration: const InputDecoration(
                      labelText: '材质',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lngController,
                    style: _getStyle(_isLngModified),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '经度',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _latController,
                    style: _getStyle(_isLatModified),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '纬度',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _depthController,
              style: _getStyle(_isDepthModified),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '实测埋深 (米)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('现场照片:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${_photoFiles.length} 张',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),

            // 图片网格显示
            if (_photoFiles.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _photoFiles.length,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        _photoFiles[index],
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => _removePhoto(index),
                          child: Container(
                            color: Colors.black54,
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            else
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Center(
                  child: Text('暂无照片', style: TextStyle(color: Colors.grey)),
                ),
              ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('拍照'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('相册'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onConfirm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('确认并保存', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
