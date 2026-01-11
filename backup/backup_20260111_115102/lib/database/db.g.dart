// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $PipePointsTable extends PipePoints
    with TableInfo<$PipePointsTable, PipePoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PipePointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originLngMeta =
      const VerificationMeta('originLng');
  @override
  late final GeneratedColumn<double> originLng = GeneratedColumn<double>(
      'origin_lng', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _originLatMeta =
      const VerificationMeta('originLat');
  @override
  late final GeneratedColumn<double> originLat = GeneratedColumn<double>(
      'origin_lat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _propertiesMeta =
      const VerificationMeta('properties');
  @override
  late final GeneratedColumn<String> properties = GeneratedColumn<String>(
      'properties', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _auditStatusMeta =
      const VerificationMeta('auditStatus');
  @override
  late final GeneratedColumn<int> auditStatus = GeneratedColumn<int>(
      'audit_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _fixDepthMeta =
      const VerificationMeta('fixDepth');
  @override
  late final GeneratedColumn<double> fixDepth = GeneratedColumn<double>(
      'fix_depth', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fixTypeMeta =
      const VerificationMeta('fixType');
  @override
  late final GeneratedColumn<String> fixType = GeneratedColumn<String>(
      'fix_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fixLngMeta = const VerificationMeta('fixLng');
  @override
  late final GeneratedColumn<double> fixLng = GeneratedColumn<double>(
      'fix_lng', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fixLatMeta = const VerificationMeta('fixLat');
  @override
  late final GeneratedColumn<double> fixLat = GeneratedColumn<double>(
      'fix_lat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fixMaterialMeta =
      const VerificationMeta('fixMaterial');
  @override
  late final GeneratedColumn<String> fixMaterial = GeneratedColumn<String>(
      'fix_material', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        uuid,
        type,
        originLng,
        originLat,
        properties,
        auditStatus,
        fixDepth,
        fixType,
        fixLng,
        fixLat,
        fixMaterial,
        photoPath,
        isDeleted,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pipe_points';
  @override
  VerificationContext validateIntegrity(Insertable<PipePoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('origin_lng')) {
      context.handle(_originLngMeta,
          originLng.isAcceptableOrUnknown(data['origin_lng']!, _originLngMeta));
    } else if (isInserting) {
      context.missing(_originLngMeta);
    }
    if (data.containsKey('origin_lat')) {
      context.handle(_originLatMeta,
          originLat.isAcceptableOrUnknown(data['origin_lat']!, _originLatMeta));
    } else if (isInserting) {
      context.missing(_originLatMeta);
    }
    if (data.containsKey('properties')) {
      context.handle(
          _propertiesMeta,
          properties.isAcceptableOrUnknown(
              data['properties']!, _propertiesMeta));
    } else if (isInserting) {
      context.missing(_propertiesMeta);
    }
    if (data.containsKey('audit_status')) {
      context.handle(
          _auditStatusMeta,
          auditStatus.isAcceptableOrUnknown(
              data['audit_status']!, _auditStatusMeta));
    }
    if (data.containsKey('fix_depth')) {
      context.handle(_fixDepthMeta,
          fixDepth.isAcceptableOrUnknown(data['fix_depth']!, _fixDepthMeta));
    }
    if (data.containsKey('fix_type')) {
      context.handle(_fixTypeMeta,
          fixType.isAcceptableOrUnknown(data['fix_type']!, _fixTypeMeta));
    }
    if (data.containsKey('fix_lng')) {
      context.handle(_fixLngMeta,
          fixLng.isAcceptableOrUnknown(data['fix_lng']!, _fixLngMeta));
    }
    if (data.containsKey('fix_lat')) {
      context.handle(_fixLatMeta,
          fixLat.isAcceptableOrUnknown(data['fix_lat']!, _fixLatMeta));
    }
    if (data.containsKey('fix_material')) {
      context.handle(
          _fixMaterialMeta,
          fixMaterial.isAcceptableOrUnknown(
              data['fix_material']!, _fixMaterialMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  PipePoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PipePoint(
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      originLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}origin_lng'])!,
      originLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}origin_lat'])!,
      properties: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}properties'])!,
      auditStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}audit_status'])!,
      fixDepth: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fix_depth']),
      fixType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fix_type']),
      fixLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fix_lng']),
      fixLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fix_lat']),
      fixMaterial: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fix_material']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $PipePointsTable createAlias(String alias) {
    return $PipePointsTable(attachedDatabase, alias);
  }
}

class PipePoint extends DataClass implements Insertable<PipePoint> {
  final String uuid;
  final String type;
  final double originLng;
  final double originLat;
  final String properties;
  final int auditStatus;
  final double? fixDepth;
  final String? fixType;
  final double? fixLng;
  final double? fixLat;
  final String? fixMaterial;
  final String? photoPath;
  final bool isDeleted;
  final DateTime? createdAt;
  const PipePoint(
      {required this.uuid,
      required this.type,
      required this.originLng,
      required this.originLat,
      required this.properties,
      required this.auditStatus,
      this.fixDepth,
      this.fixType,
      this.fixLng,
      this.fixLat,
      this.fixMaterial,
      this.photoPath,
      required this.isDeleted,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['type'] = Variable<String>(type);
    map['origin_lng'] = Variable<double>(originLng);
    map['origin_lat'] = Variable<double>(originLat);
    map['properties'] = Variable<String>(properties);
    map['audit_status'] = Variable<int>(auditStatus);
    if (!nullToAbsent || fixDepth != null) {
      map['fix_depth'] = Variable<double>(fixDepth);
    }
    if (!nullToAbsent || fixType != null) {
      map['fix_type'] = Variable<String>(fixType);
    }
    if (!nullToAbsent || fixLng != null) {
      map['fix_lng'] = Variable<double>(fixLng);
    }
    if (!nullToAbsent || fixLat != null) {
      map['fix_lat'] = Variable<double>(fixLat);
    }
    if (!nullToAbsent || fixMaterial != null) {
      map['fix_material'] = Variable<String>(fixMaterial);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  PipePointsCompanion toCompanion(bool nullToAbsent) {
    return PipePointsCompanion(
      uuid: Value(uuid),
      type: Value(type),
      originLng: Value(originLng),
      originLat: Value(originLat),
      properties: Value(properties),
      auditStatus: Value(auditStatus),
      fixDepth: fixDepth == null && nullToAbsent
          ? const Value.absent()
          : Value(fixDepth),
      fixType: fixType == null && nullToAbsent
          ? const Value.absent()
          : Value(fixType),
      fixLng:
          fixLng == null && nullToAbsent ? const Value.absent() : Value(fixLng),
      fixLat:
          fixLat == null && nullToAbsent ? const Value.absent() : Value(fixLat),
      fixMaterial: fixMaterial == null && nullToAbsent
          ? const Value.absent()
          : Value(fixMaterial),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      isDeleted: Value(isDeleted),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory PipePoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PipePoint(
      uuid: serializer.fromJson<String>(json['uuid']),
      type: serializer.fromJson<String>(json['type']),
      originLng: serializer.fromJson<double>(json['originLng']),
      originLat: serializer.fromJson<double>(json['originLat']),
      properties: serializer.fromJson<String>(json['properties']),
      auditStatus: serializer.fromJson<int>(json['auditStatus']),
      fixDepth: serializer.fromJson<double?>(json['fixDepth']),
      fixType: serializer.fromJson<String?>(json['fixType']),
      fixLng: serializer.fromJson<double?>(json['fixLng']),
      fixLat: serializer.fromJson<double?>(json['fixLat']),
      fixMaterial: serializer.fromJson<String?>(json['fixMaterial']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'type': serializer.toJson<String>(type),
      'originLng': serializer.toJson<double>(originLng),
      'originLat': serializer.toJson<double>(originLat),
      'properties': serializer.toJson<String>(properties),
      'auditStatus': serializer.toJson<int>(auditStatus),
      'fixDepth': serializer.toJson<double?>(fixDepth),
      'fixType': serializer.toJson<String?>(fixType),
      'fixLng': serializer.toJson<double?>(fixLng),
      'fixLat': serializer.toJson<double?>(fixLat),
      'fixMaterial': serializer.toJson<String?>(fixMaterial),
      'photoPath': serializer.toJson<String?>(photoPath),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  PipePoint copyWith(
          {String? uuid,
          String? type,
          double? originLng,
          double? originLat,
          String? properties,
          int? auditStatus,
          Value<double?> fixDepth = const Value.absent(),
          Value<String?> fixType = const Value.absent(),
          Value<double?> fixLng = const Value.absent(),
          Value<double?> fixLat = const Value.absent(),
          Value<String?> fixMaterial = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          bool? isDeleted,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      PipePoint(
        uuid: uuid ?? this.uuid,
        type: type ?? this.type,
        originLng: originLng ?? this.originLng,
        originLat: originLat ?? this.originLat,
        properties: properties ?? this.properties,
        auditStatus: auditStatus ?? this.auditStatus,
        fixDepth: fixDepth.present ? fixDepth.value : this.fixDepth,
        fixType: fixType.present ? fixType.value : this.fixType,
        fixLng: fixLng.present ? fixLng.value : this.fixLng,
        fixLat: fixLat.present ? fixLat.value : this.fixLat,
        fixMaterial: fixMaterial.present ? fixMaterial.value : this.fixMaterial,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  PipePoint copyWithCompanion(PipePointsCompanion data) {
    return PipePoint(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      type: data.type.present ? data.type.value : this.type,
      originLng: data.originLng.present ? data.originLng.value : this.originLng,
      originLat: data.originLat.present ? data.originLat.value : this.originLat,
      properties:
          data.properties.present ? data.properties.value : this.properties,
      auditStatus:
          data.auditStatus.present ? data.auditStatus.value : this.auditStatus,
      fixDepth: data.fixDepth.present ? data.fixDepth.value : this.fixDepth,
      fixType: data.fixType.present ? data.fixType.value : this.fixType,
      fixLng: data.fixLng.present ? data.fixLng.value : this.fixLng,
      fixLat: data.fixLat.present ? data.fixLat.value : this.fixLat,
      fixMaterial:
          data.fixMaterial.present ? data.fixMaterial.value : this.fixMaterial,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PipePoint(')
          ..write('uuid: $uuid, ')
          ..write('type: $type, ')
          ..write('originLng: $originLng, ')
          ..write('originLat: $originLat, ')
          ..write('properties: $properties, ')
          ..write('auditStatus: $auditStatus, ')
          ..write('fixDepth: $fixDepth, ')
          ..write('fixType: $fixType, ')
          ..write('fixLng: $fixLng, ')
          ..write('fixLat: $fixLat, ')
          ..write('fixMaterial: $fixMaterial, ')
          ..write('photoPath: $photoPath, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      uuid,
      type,
      originLng,
      originLat,
      properties,
      auditStatus,
      fixDepth,
      fixType,
      fixLng,
      fixLat,
      fixMaterial,
      photoPath,
      isDeleted,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PipePoint &&
          other.uuid == this.uuid &&
          other.type == this.type &&
          other.originLng == this.originLng &&
          other.originLat == this.originLat &&
          other.properties == this.properties &&
          other.auditStatus == this.auditStatus &&
          other.fixDepth == this.fixDepth &&
          other.fixType == this.fixType &&
          other.fixLng == this.fixLng &&
          other.fixLat == this.fixLat &&
          other.fixMaterial == this.fixMaterial &&
          other.photoPath == this.photoPath &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt);
}

class PipePointsCompanion extends UpdateCompanion<PipePoint> {
  final Value<String> uuid;
  final Value<String> type;
  final Value<double> originLng;
  final Value<double> originLat;
  final Value<String> properties;
  final Value<int> auditStatus;
  final Value<double?> fixDepth;
  final Value<String?> fixType;
  final Value<double?> fixLng;
  final Value<double?> fixLat;
  final Value<String?> fixMaterial;
  final Value<String?> photoPath;
  final Value<bool> isDeleted;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const PipePointsCompanion({
    this.uuid = const Value.absent(),
    this.type = const Value.absent(),
    this.originLng = const Value.absent(),
    this.originLat = const Value.absent(),
    this.properties = const Value.absent(),
    this.auditStatus = const Value.absent(),
    this.fixDepth = const Value.absent(),
    this.fixType = const Value.absent(),
    this.fixLng = const Value.absent(),
    this.fixLat = const Value.absent(),
    this.fixMaterial = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PipePointsCompanion.insert({
    required String uuid,
    required String type,
    required double originLng,
    required double originLat,
    required String properties,
    this.auditStatus = const Value.absent(),
    this.fixDepth = const Value.absent(),
    this.fixType = const Value.absent(),
    this.fixLng = const Value.absent(),
    this.fixLat = const Value.absent(),
    this.fixMaterial = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : uuid = Value(uuid),
        type = Value(type),
        originLng = Value(originLng),
        originLat = Value(originLat),
        properties = Value(properties);
  static Insertable<PipePoint> custom({
    Expression<String>? uuid,
    Expression<String>? type,
    Expression<double>? originLng,
    Expression<double>? originLat,
    Expression<String>? properties,
    Expression<int>? auditStatus,
    Expression<double>? fixDepth,
    Expression<String>? fixType,
    Expression<double>? fixLng,
    Expression<double>? fixLat,
    Expression<String>? fixMaterial,
    Expression<String>? photoPath,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (type != null) 'type': type,
      if (originLng != null) 'origin_lng': originLng,
      if (originLat != null) 'origin_lat': originLat,
      if (properties != null) 'properties': properties,
      if (auditStatus != null) 'audit_status': auditStatus,
      if (fixDepth != null) 'fix_depth': fixDepth,
      if (fixType != null) 'fix_type': fixType,
      if (fixLng != null) 'fix_lng': fixLng,
      if (fixLat != null) 'fix_lat': fixLat,
      if (fixMaterial != null) 'fix_material': fixMaterial,
      if (photoPath != null) 'photo_path': photoPath,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PipePointsCompanion copyWith(
      {Value<String>? uuid,
      Value<String>? type,
      Value<double>? originLng,
      Value<double>? originLat,
      Value<String>? properties,
      Value<int>? auditStatus,
      Value<double?>? fixDepth,
      Value<String?>? fixType,
      Value<double?>? fixLng,
      Value<double?>? fixLat,
      Value<String?>? fixMaterial,
      Value<String?>? photoPath,
      Value<bool>? isDeleted,
      Value<DateTime?>? createdAt,
      Value<int>? rowid}) {
    return PipePointsCompanion(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      originLng: originLng ?? this.originLng,
      originLat: originLat ?? this.originLat,
      properties: properties ?? this.properties,
      auditStatus: auditStatus ?? this.auditStatus,
      fixDepth: fixDepth ?? this.fixDepth,
      fixType: fixType ?? this.fixType,
      fixLng: fixLng ?? this.fixLng,
      fixLat: fixLat ?? this.fixLat,
      fixMaterial: fixMaterial ?? this.fixMaterial,
      photoPath: photoPath ?? this.photoPath,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (originLng.present) {
      map['origin_lng'] = Variable<double>(originLng.value);
    }
    if (originLat.present) {
      map['origin_lat'] = Variable<double>(originLat.value);
    }
    if (properties.present) {
      map['properties'] = Variable<String>(properties.value);
    }
    if (auditStatus.present) {
      map['audit_status'] = Variable<int>(auditStatus.value);
    }
    if (fixDepth.present) {
      map['fix_depth'] = Variable<double>(fixDepth.value);
    }
    if (fixType.present) {
      map['fix_type'] = Variable<String>(fixType.value);
    }
    if (fixLng.present) {
      map['fix_lng'] = Variable<double>(fixLng.value);
    }
    if (fixLat.present) {
      map['fix_lat'] = Variable<double>(fixLat.value);
    }
    if (fixMaterial.present) {
      map['fix_material'] = Variable<String>(fixMaterial.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PipePointsCompanion(')
          ..write('uuid: $uuid, ')
          ..write('type: $type, ')
          ..write('originLng: $originLng, ')
          ..write('originLat: $originLat, ')
          ..write('properties: $properties, ')
          ..write('auditStatus: $auditStatus, ')
          ..write('fixDepth: $fixDepth, ')
          ..write('fixType: $fixType, ')
          ..write('fixLng: $fixLng, ')
          ..write('fixLat: $fixLat, ')
          ..write('fixMaterial: $fixMaterial, ')
          ..write('photoPath: $photoPath, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PipePointsTable pipePoints = $PipePointsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [pipePoints];
}

typedef $$PipePointsTableCreateCompanionBuilder = PipePointsCompanion Function({
  required String uuid,
  required String type,
  required double originLng,
  required double originLat,
  required String properties,
  Value<int> auditStatus,
  Value<double?> fixDepth,
  Value<String?> fixType,
  Value<double?> fixLng,
  Value<double?> fixLat,
  Value<String?> fixMaterial,
  Value<String?> photoPath,
  Value<bool> isDeleted,
  Value<DateTime?> createdAt,
  Value<int> rowid,
});
typedef $$PipePointsTableUpdateCompanionBuilder = PipePointsCompanion Function({
  Value<String> uuid,
  Value<String> type,
  Value<double> originLng,
  Value<double> originLat,
  Value<String> properties,
  Value<int> auditStatus,
  Value<double?> fixDepth,
  Value<String?> fixType,
  Value<double?> fixLng,
  Value<double?> fixLat,
  Value<String?> fixMaterial,
  Value<String?> photoPath,
  Value<bool> isDeleted,
  Value<DateTime?> createdAt,
  Value<int> rowid,
});

class $$PipePointsTableFilterComposer
    extends Composer<_$AppDatabase, $PipePointsTable> {
  $$PipePointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get originLng => $composableBuilder(
      column: $table.originLng, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get originLat => $composableBuilder(
      column: $table.originLat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get properties => $composableBuilder(
      column: $table.properties, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get auditStatus => $composableBuilder(
      column: $table.auditStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fixDepth => $composableBuilder(
      column: $table.fixDepth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fixType => $composableBuilder(
      column: $table.fixType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fixLng => $composableBuilder(
      column: $table.fixLng, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fixLat => $composableBuilder(
      column: $table.fixLat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fixMaterial => $composableBuilder(
      column: $table.fixMaterial, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PipePointsTableOrderingComposer
    extends Composer<_$AppDatabase, $PipePointsTable> {
  $$PipePointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get originLng => $composableBuilder(
      column: $table.originLng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get originLat => $composableBuilder(
      column: $table.originLat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get properties => $composableBuilder(
      column: $table.properties, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get auditStatus => $composableBuilder(
      column: $table.auditStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fixDepth => $composableBuilder(
      column: $table.fixDepth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fixType => $composableBuilder(
      column: $table.fixType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fixLng => $composableBuilder(
      column: $table.fixLng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fixLat => $composableBuilder(
      column: $table.fixLat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fixMaterial => $composableBuilder(
      column: $table.fixMaterial, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PipePointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PipePointsTable> {
  $$PipePointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get originLng =>
      $composableBuilder(column: $table.originLng, builder: (column) => column);

  GeneratedColumn<double> get originLat =>
      $composableBuilder(column: $table.originLat, builder: (column) => column);

  GeneratedColumn<String> get properties => $composableBuilder(
      column: $table.properties, builder: (column) => column);

  GeneratedColumn<int> get auditStatus => $composableBuilder(
      column: $table.auditStatus, builder: (column) => column);

  GeneratedColumn<double> get fixDepth =>
      $composableBuilder(column: $table.fixDepth, builder: (column) => column);

  GeneratedColumn<String> get fixType =>
      $composableBuilder(column: $table.fixType, builder: (column) => column);

  GeneratedColumn<double> get fixLng =>
      $composableBuilder(column: $table.fixLng, builder: (column) => column);

  GeneratedColumn<double> get fixLat =>
      $composableBuilder(column: $table.fixLat, builder: (column) => column);

  GeneratedColumn<String> get fixMaterial => $composableBuilder(
      column: $table.fixMaterial, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PipePointsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PipePointsTable,
    PipePoint,
    $$PipePointsTableFilterComposer,
    $$PipePointsTableOrderingComposer,
    $$PipePointsTableAnnotationComposer,
    $$PipePointsTableCreateCompanionBuilder,
    $$PipePointsTableUpdateCompanionBuilder,
    (PipePoint, BaseReferences<_$AppDatabase, $PipePointsTable, PipePoint>),
    PipePoint,
    PrefetchHooks Function()> {
  $$PipePointsTableTableManager(_$AppDatabase db, $PipePointsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PipePointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PipePointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PipePointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> uuid = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> originLng = const Value.absent(),
            Value<double> originLat = const Value.absent(),
            Value<String> properties = const Value.absent(),
            Value<int> auditStatus = const Value.absent(),
            Value<double?> fixDepth = const Value.absent(),
            Value<String?> fixType = const Value.absent(),
            Value<double?> fixLng = const Value.absent(),
            Value<double?> fixLat = const Value.absent(),
            Value<String?> fixMaterial = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PipePointsCompanion(
            uuid: uuid,
            type: type,
            originLng: originLng,
            originLat: originLat,
            properties: properties,
            auditStatus: auditStatus,
            fixDepth: fixDepth,
            fixType: fixType,
            fixLng: fixLng,
            fixLat: fixLat,
            fixMaterial: fixMaterial,
            photoPath: photoPath,
            isDeleted: isDeleted,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String uuid,
            required String type,
            required double originLng,
            required double originLat,
            required String properties,
            Value<int> auditStatus = const Value.absent(),
            Value<double?> fixDepth = const Value.absent(),
            Value<String?> fixType = const Value.absent(),
            Value<double?> fixLng = const Value.absent(),
            Value<double?> fixLat = const Value.absent(),
            Value<String?> fixMaterial = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PipePointsCompanion.insert(
            uuid: uuid,
            type: type,
            originLng: originLng,
            originLat: originLat,
            properties: properties,
            auditStatus: auditStatus,
            fixDepth: fixDepth,
            fixType: fixType,
            fixLng: fixLng,
            fixLat: fixLat,
            fixMaterial: fixMaterial,
            photoPath: photoPath,
            isDeleted: isDeleted,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PipePointsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PipePointsTable,
    PipePoint,
    $$PipePointsTableFilterComposer,
    $$PipePointsTableOrderingComposer,
    $$PipePointsTableAnnotationComposer,
    $$PipePointsTableCreateCompanionBuilder,
    $$PipePointsTableUpdateCompanionBuilder,
    (PipePoint, BaseReferences<_$AppDatabase, $PipePointsTable, PipePoint>),
    PipePoint,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PipePointsTableTableManager get pipePoints =>
      $$PipePointsTableTableManager(_db, _db.pipePoints);
}
