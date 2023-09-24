// ignore_for_file: unnecessary_getters_setters
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProtocolListStruct extends FFFirebaseStruct {
  ProtocolListStruct({
    String? universal,
    List<String>? adult,
    List<String>? list,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _universal = universal,
        _adult = adult,
        _list = list,
        super(firestoreUtilData);

  // "Universal" field.
  String? _universal;
  String get universal => _universal ?? '';
  set universal(String? val) => _universal = val;
  bool hasUniversal() => _universal != null;

  // "Adult" field.
  List<String>? _adult;
  List<String> get adult => _adult ?? const [];
  set adult(List<String>? val) => _adult = val;
  void updateAdult(Function(List<String>) updateFn) => updateFn(_adult ??= []);
  bool hasAdult() => _adult != null;

  // "List" field.
  List<String>? _list;
  List<String> get list => _list ?? const [];
  set list(List<String>? val) => _list = val;
  void updateList(Function(List<String>) updateFn) => updateFn(_list ??= []);
  bool hasList() => _list != null;

  static ProtocolListStruct fromMap(Map<String, dynamic> data) =>
      ProtocolListStruct(
        universal: data['Universal'] as String?,
        adult: getDataList(data['Adult']),
        list: getDataList(data['List']),
      );

  static ProtocolListStruct? maybeFromMap(dynamic data) =>
      data is Map<String, dynamic> ? ProtocolListStruct.fromMap(data) : null;

  Map<String, dynamic> toMap() => {
        'Universal': _universal,
        'Adult': _adult,
        'List': _list,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Universal': serializeParam(
          _universal,
          ParamType.String,
        ),
        'Adult': serializeParam(
          _adult,
          ParamType.String,
          true,
        ),
        'List': serializeParam(
          _list,
          ParamType.String,
          true,
        ),
      }.withoutNulls;

  static ProtocolListStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProtocolListStruct(
        universal: deserializeParam(
          data['Universal'],
          ParamType.String,
          false,
        ),
        adult: deserializeParam<String>(
          data['Adult'],
          ParamType.String,
          true,
        ),
        list: deserializeParam<String>(
          data['List'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'ProtocolListStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ProtocolListStruct &&
        universal == other.universal &&
        listEquality.equals(adult, other.adult) &&
        listEquality.equals(list, other.list);
  }

  @override
  int get hashCode => const ListEquality().hash([universal, adult, list]);
}

ProtocolListStruct createProtocolListStruct({
  String? universal,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ProtocolListStruct(
      universal: universal,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ProtocolListStruct? updateProtocolListStruct(
  ProtocolListStruct? protocolList, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    protocolList
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addProtocolListStructData(
  Map<String, dynamic> firestoreData,
  ProtocolListStruct? protocolList,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (protocolList == null) {
    return;
  }
  if (protocolList.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && protocolList.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final protocolListData =
      getProtocolListFirestoreData(protocolList, forFieldValue);
  final nestedData =
      protocolListData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = protocolList.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getProtocolListFirestoreData(
  ProtocolListStruct? protocolList, [
  bool forFieldValue = false,
]) {
  if (protocolList == null) {
    return {};
  }
  final firestoreData = mapToFirestore(protocolList.toMap());

  // Add any Firestore field values
  protocolList.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getProtocolListListFirestoreData(
  List<ProtocolListStruct>? protocolLists,
) =>
    protocolLists?.map((e) => getProtocolListFirestoreData(e, true)).toList() ??
    [];
