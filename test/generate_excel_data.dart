import 'dart:io';
import 'dart:math';
import 'package:excel/excel.dart';

void main() {
  var excel = Excel.createExcel();
  // 默认会创建一个名为 "Sheet1" 的工作表，或者我们可以重命名默认的
  Sheet sheetObject = excel['Sheet1'];

  // 添加表头
  // 符合要求：列名包含 uuid/id, type/类型, lng/经度, lat/纬度
  List<CellValue> headers = [
    TextCellValue('编号'), 
    TextCellValue('类型'), 
    TextCellValue('经度'), 
    TextCellValue('纬度'), 
    TextCellValue('材质'), 
    TextCellValue('预估埋深')
  ];
  sheetObject.appendRow(headers);

  // 兰州市中心
  double centerLat = 36.0611;
  double centerLng = 103.8343;
  Random random = Random();

  for (int i = 0; i < 10; i++) {
    String uuid = 'LZ-TEST-${1000 + i}';
    String type = random.nextBool() ? '给水管' : '燃气管';
    // 随机偏移 +/- 0.02 度 (约 2km)
    double lng = centerLng + (random.nextDouble() - 0.5) * 0.04;
    double lat = centerLat + (random.nextDouble() - 0.5) * 0.04;
    String material = random.nextBool() ? 'PE' : '铸铁';
    double depth = 0.5 + random.nextDouble() * 2.0; // 0.5 - 2.5m

    sheetObject.appendRow([
      TextCellValue(uuid),
      TextCellValue(type),
      DoubleCellValue(lng),
      DoubleCellValue(lat),
      TextCellValue(material),
      TextCellValue(depth.toStringAsFixed(2)),
    ]);
  }

  // 确保 test 目录存在
  var directory = Directory('test');
  if (!directory.existsSync()) {
    directory.createSync();
  }
  
  // 保存文件
  var fileBytes = excel.save();
  if (fileBytes != null) {
    File('test/111.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
    print('成功生成文件: ${Directory.current.path}/test/111.xlsx');
  } else {
    print('生成失败: 文件内容为空');
  }
}
