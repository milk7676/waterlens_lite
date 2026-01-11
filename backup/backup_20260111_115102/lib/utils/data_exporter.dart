import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import '../database/db.dart';

class DataExporter {
  static Future<ExportResult> exportData(List<PipePoint> points) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: '选择导出位置',
        fileName: 'export_data',
        type: FileType.custom,
        allowedExtensions: ['json', 'geojson', 'xlsx', 'md'],
      );

      if (outputFile == null) {
        return ExportResult(success: false, message: '取消导出');
      }

      final file = File(outputFile);
      final ext = outputFile.split('.').last.toLowerCase();

      if (ext == 'json') {
        return await _exportJson(file, points);
      } else if (ext == 'geojson') {
        return await _exportGeoJson(file, points);
      } else if (ext == 'xlsx') {
        return await _exportXlsx(file, points);
      } else if (ext == 'md') {
        return await _exportMd(file, points);
      } else {
        // 如果没有扩展名或者不匹配，默认根据用户输入的文件名判断，或者默认 json
        return ExportResult(success: false, message: '不支持的导出格式: $ext');
      }
    } catch (e) {
      return ExportResult(success: false, message: '导出失败: $e');
    }
  }

  static Future<ExportResult> _exportJson(File file, List<PipePoint> points) async {
    try {
      final List<Map<String, dynamic>> data = points.map((p) {
        final vals = _getFinalValues(p);
        // Construct a clean JSON object with final values
        return {
          'uuid': vals['uuid'],
          'type': vals['type'],
          'lng': vals['lng'],
          'lat': vals['lat'],
          'material': vals['material'],
          'depth': vals['depth'],
          'auditStatus': vals['auditStatus'],
          'photoPath': vals['photoPath'],
          'properties': vals['propsMap'], // Export decoded properties
        };
      }).toList();
      await file.writeAsString(jsonEncode(data));
      return ExportResult(success: true, message: '成功导出 ${points.length} 条数据 (JSON)');
    } catch (e) {
      return ExportResult(success: false, message: 'JSON 导出失败: $e');
    }
  }

  static Future<ExportResult> _exportGeoJson(File file, List<PipePoint> points) async {
    try {
      final features = points.map((p) {
        final vals = _getFinalValues(p);
        Map<String, dynamic> properties = Map<String, dynamic>.from(vals['propsMap']);
        
        properties['uuid'] = vals['uuid'];
        properties['type'] = vals['type'];
        properties['material'] = vals['material'];
        properties['depth'] = vals['depth'];
        properties['auditStatus'] = vals['auditStatus'];
        if (vals['photoPath'] != null) properties['photoPath'] = vals['photoPath'];

        return {
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [vals['lng'], vals['lat']]
          },
          'properties': properties
        };
      }).toList();

      final geoJson = {
        'type': 'FeatureCollection',
        'features': features
      };

      await file.writeAsString(jsonEncode(geoJson));
      return ExportResult(success: true, message: '成功导出 ${points.length} 条数据 (GeoJSON)');
    } catch (e) {
      return ExportResult(success: false, message: 'GeoJSON 导出失败: $e');
    }
  }

  static Future<ExportResult> _exportXlsx(File file, List<PipePoint> points) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      // 表头
      sheet.appendRow([
        TextCellValue('编号'),
        TextCellValue('类型'),
        TextCellValue('经度'),
        TextCellValue('纬度'),
        TextCellValue('材质'),
        TextCellValue('实测埋深'),
        TextCellValue('状态'),
        TextCellValue('属性'),
        TextCellValue('照片路径'),
      ]);

      for (var p in points) {
        final vals = _getFinalValues(p);
        sheet.appendRow([
          TextCellValue(vals['uuid']),
          TextCellValue(vals['type']),
          DoubleCellValue(vals['lng']),
          DoubleCellValue(vals['lat']),
          TextCellValue(vals['material']),
          vals['depth'] is num ? DoubleCellValue(vals['depth']) : TextCellValue(vals['depth'].toString()),
          IntCellValue(vals['auditStatus']),
          TextCellValue(p.properties), // Keep raw properties string
          TextCellValue(vals['photoPath'] ?? ''),
        ]);
      }

      var fileBytes = excel.save();
      if (fileBytes != null) {
        await file.writeAsBytes(fileBytes);
        return ExportResult(success: true, message: '成功导出 ${points.length} 条数据 (Excel)');
      } else {
        return ExportResult(success: false, message: 'Excel 生成失败');
      }
    } catch (e) {
      return ExportResult(success: false, message: 'Excel 导出失败: $e');
    }
  }

  static Future<ExportResult> _exportMd(File file, List<PipePoint> points) async {
    try {
      final buffer = StringBuffer();
      
      // 表头
      buffer.writeln('| 编号 | 类型 | 经度 | 纬度 | 材质 | 实测埋深 | 状态 | 属性 | 照片路径 |');
      buffer.writeln('| --- | --- | --- | --- | --- | --- | --- | --- | --- |');

      for (var p in points) {
        final vals = _getFinalValues(p);
        buffer.write('| ${vals['uuid']} ');
        buffer.write('| ${vals['type']} ');
        buffer.write('| ${vals['lng']} ');
        buffer.write('| ${vals['lat']} ');
        buffer.write('| ${vals['material']} ');
        buffer.write('| ${vals['depth']} ');
        buffer.write('| ${vals['auditStatus']} ');
        // 替换换行符以防破坏 Markdown 表格格式
        buffer.write('| ${p.properties.replaceAll('\n', ' ')} ');
        buffer.write('| ${vals['photoPath'] ?? ""} |');
        buffer.writeln();
      }

      await file.writeAsString(buffer.toString());
      return ExportResult(success: true, message: '成功导出 ${points.length} 条数据 (Markdown)');
    } catch (e) {
      return ExportResult(success: false, message: 'Markdown 导出失败: $e');
    }
  }

  static Map<String, dynamic> _getFinalValues(PipePoint p) {
    Map<String, dynamic> props = {};
    try {
      props = jsonDecode(p.properties) as Map<String, dynamic>;
    } catch (_) {}

    final type = p.fixType ?? p.type;
    final lng = p.fixLng ?? p.originLng;
    final lat = p.fixLat ?? p.originLat;
    
    // Material might be in properties as 'material' or '材质'
    String? originalMaterial = props['material']?.toString() ?? props['材质']?.toString();
    final material = p.fixMaterial ?? originalMaterial ?? '';
    
    // Depth might be in properties as 'depth', '埋深', etc.
    // fixDepth is double?
    dynamic originalDepth = props['depth'] ?? props['埋深'];
    final depth = p.fixDepth ?? originalDepth ?? '';

    return {
      'uuid': p.uuid,
      'type': type,
      'lng': lng,
      'lat': lat,
      'material': material,
      'depth': depth,
      'auditStatus': p.auditStatus,
      'photoPath': p.photoPath,
      'propsMap': props,
    };
  }
}

class ExportResult {
  final bool success;
  final String message;

  ExportResult({required this.success, required this.message});
}
