import 'package:cloud_firestore/cloud_firestore.dart';

extension TransactionMaybeExtension on Transaction? {
  Future<DocumentSnapshot<Object?>> maybeGet(
    DocumentReference docRef,
  ) {
    if (this == null) {
      return docRef.get();
    } else {
      return this!.get(docRef);
    }
  }

  void maybeSet(
    DocumentReference docRef,
    Map<String, dynamic> data,
  ) {
    if (this == null) {
      docRef.set(data);
    } else {
      this!.set(docRef, data);
    }
  }

  Future<DocumentReference<Object?>> maybeAdd(
    CollectionReference colRef,
    Map<String, dynamic> data,
  ) async {
    if (this == null) {
      final docRef = await colRef.add(data);
      return docRef;
    } else {
      final docRef = colRef.doc();
      this!.set(docRef, data);
      return docRef;
    }
  }

  void maybeUpdate(
    DocumentReference docRef,
    Map<String, dynamic> data,
  ) {
    if (this == null) {
      docRef.update(data);
    } else {
      this!.update(docRef, data);
    }
  }

  void maybeDelete(
    DocumentReference docRef,
  ) {
    if (this == null) {
      docRef.delete();
    } else {
      this!.delete(docRef);
    }
  }
}
