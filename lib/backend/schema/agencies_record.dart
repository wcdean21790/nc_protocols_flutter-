import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AgenciesRecord extends FirestoreRecord {
  AgenciesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "ProtocolList" field.
  List<String>? _protocolList;
  List<String> get protocolList => _protocolList ?? const [];
  bool hasProtocolList() => _protocolList != null;

  void _initializeFields() {
    _name = snapshotData['Name'] as String?;
    _protocolList = getDataList(snapshotData['ProtocolList']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Agencies');

  static Stream<AgenciesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AgenciesRecord.fromSnapshot(s));

  static Future<AgenciesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AgenciesRecord.fromSnapshot(s));

  static AgenciesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AgenciesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AgenciesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AgenciesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AgenciesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AgenciesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAgenciesRecordData({
  String? name,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Name': name,
    }.withoutNulls,
  );

  return firestoreData;
}

class AgenciesRecordDocumentEquality implements Equality<AgenciesRecord> {
  const AgenciesRecordDocumentEquality();

  @override
  bool equals(AgenciesRecord? e1, AgenciesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.name == e2?.name &&
        listEquality.equals(e1?.protocolList, e2?.protocolList);
  }

  @override
  int hash(AgenciesRecord? e) =>
      const ListEquality().hash([e?.name, e?.protocolList]);

  @override
  bool isValidKey(Object? o) => o is AgenciesRecord;
}
