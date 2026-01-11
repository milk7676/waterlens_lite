import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import '../database/db.dart';

class DataImporter {
  static Future<ImportResult> importFile(String filePath, AppDatabase database) async {
    final file = File(filePath);
    final ext = filePath.split('.').last.toLowerCase();

    try {
      if (ext == 'xlsx') {
        return await _importXlsx(file, database);
      } else if (ext == 'md') {
        return await _importMd(file, database);
      } else if (ext == 'json' || ext == 'geojson') {
        return await _importGeoJson(file, database);
      } else {
        return ImportResult(success: false, message: '不支持的文件格式: $ext');
      }
    } catch (e) {
      return ImportResult(success: false, message: '导入失败: $e');
    }
  }

  static Future<ImportResult> _importGeoJson(File file, AppDatabase database) async {
    try {
      final content = await file.readAsString();
      final Map<String, dynamic> geoJson = jsonDecode(content);

      if (geoJson['type'] != 'FeatureCollection' || geoJson['features'] == null) {
        return ImportResult(success: false, message: 'GeoJSON 格式错误：必须是 FeatureCollection');
      }

      final List<dynamic> features = geoJson['features'];
      int count = 0;

      for (var feature in features) {
        if (feature['type'] != 'Feature') continue;
        
        final geometry = feature['geometry'];
        if (geometry == null || geometry['type'] != 'Point') continue;
        
        final List<dynamic> coordinates = geometry['coordinates'];
        if (coordinates.length < 2) continue;
        
        final double lng = (coordinates[0] as num).toDouble();
        final double lat = (coordinates[1] as num).toDouble();
        final Map<String, dynamic> properties = feature['properties'] ?? {};
        
        final String uuid = properties['uuid']?.toString() ?? 
                           'geojson-${DateTime.now().millisecondsSinceEpoch}-$count';
        final String type = properties['type']?.toString() ?? 'imported';

        await database.into(database.pipePoints).insert(
          PipePointsCompanion(
            uuid: Value(uuid),
            type: Value(type),
            originLng: Value(lng),
            originLat: Value(lat),
            properties: Value(jsonEncode(properties)),
            auditStatus: const Value(0),
          ),
          mode: InsertMode.insertOrReplace,
        );
        count++;
      }
      return ImportResult(success: true, message: '成功导入 $count 条数据 (GeoJSON)');
    } catch (e) {
      return ImportResult(success: false, message: 'GeoJSON 解析失败: $e');
    }
  }

  static Future<ImportResult> _importXlsx(File file, AppDatabase database) async {
    try {
      var bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);

      int count = 0;
      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        if (sheet == null) continue;

        // 假设第一行是表头
        List<String?> headers = [];
        bool isFirstRow = true;

        for (var row in sheet.rows) {
          if (isFirstRow) {
            headers = row.map((e) => e?.value?.toString().toLowerCase()).toList();
            isFirstRow = false;
            continue;
          }

          if (row.isEmpty) continue;

          String? uuid;
          String type = 'imported';
          double? lng;
          double? lat;
          Map<String, dynamic> properties = {};

          for (int i = 0; i < row.length; i++) {
            if (i >= headers.length) break;
            
            final header = headers[i] ?? 'col_$i';
            final value = row[i]?.value;
            if (value == null) continue;

            final strValue = value.toString();

            if (header.contains('uuid') || header.contains('id') || header == '编号') {
              uuid = strValue;
            } else if (header.contains('type') || header == '类型') {
              type = strValue;
            } else if (header.contains('lng') || header.contains('lon') || header.contains('经度')) {
              lng = double.tryParse(strValue);
            } else if (header.contains('lat') || header.contains('纬度')) {
              lat = double.tryParse(strValue);
            } else {
              properties[header] = strValue;
            }
          }

          if (lng != null && lat != null) {
            uuid ??= 'xlsx-${DateTime.now().millisecondsSinceEpoch}-$count';
            
            await database.into(database.pipePoints).insert(
              PipePointsCompanion(
                uuid: Value(uuid),
                type: Value(type),
                originLng: Value(lng),
                originLat: Value(lat),
                properties: Value(jsonEncode(properties)),
                auditStatus: const Value(0),
              ),
              mode: InsertMode.insertOrReplace,
            );
            count++;
          }
        }
      }
      return ImportResult(success: true, message: '成功导入 $count 条数据 (Excel)');
    } catch (e) {
      return ImportResult(success: false, message: 'Excel 解析失败: $e');
    }
  }

  static Future<ImportResult> _importMd(File file, AppDatabase database) async {
    try {
      final lines = await file.readAsLines();
      int count = 0;
      List<String> headers = [];

      // 简单的 Markdown 表格解析器
      // 寻找表头行：| header1 | header2 | ...
      // 寻找分隔行：| --- | --- | ...
      
      bool headerFound = false;

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;
        
        // 检查是否是表格行
        if (!line.startsWith('|') || !line.endsWith('|')) continue;

        final parts = line.split('|').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        if (parts.isEmpty) continue;

        if (!headerFound) {
          // 假设第一行是表头
          headers = parts.map((e) => e.toLowerCase()).toList();
          headerFound = true;
          continue;
        }

        // 跳过分隔行 (例如 |---|---|)
        if (parts.first.contains('---')) continue;

        // 解析数据行
        String? uuid;
        String type = 'imported';
        double? lng;
        double? lat;
        Map<String, dynamic> properties = {};

        for (int i = 0; i < parts.length; i++) {
          if (i >= headers.length) break;
          
          final header = headers[i];
          final value = parts[i];

          if (header.contains('uuid') || header.contains('id') || header == '编号') {
            uuid = value;
          } else if (header.contains('type') || header == '类型') {
            type = value;
          } else if (header.contains('lng') || header.contains('lon') || header.contains('经度')) {
            lng = double.tryParse(value);
          } else if (header.contains('lat') || header.contains('纬度')) {
            lat = double.tryParse(value);
          } else {
            properties[header] = value;
          }
        }

        if (lng != null && lat != null) {
          uuid ??= 'md-${DateTime.now().millisecondsSinceEpoch}-$count';
          
          await database.into(database.pipePoints).insert(
            PipePointsCompanion(
              uuid: Value(uuid),
              type: Value(type),
              originLng: Value(lng),
              originLat: Value(lat),
              properties: Value(jsonEncode(properties)),
              auditStatus: const Value(0),
            ),
            mode: InsertMode.insertOrReplace,
          );
          count++;
        }
      }
      
      if (count == 0) {
        return ImportResult(success: false, message: '未在 Markdown 文件中找到有效的表格数据');
      }
      return ImportResult(success: true, message: '成功导入 $count 条数据 (Markdown)');

    } catch (e) {
      return ImportResult(success: false, message: 'Markdown 解析失败: $e');
    }
  }
}

class ImportResult {
  final bool success;
  final String message;

  ImportResult({required this.success, required this.message});
}
