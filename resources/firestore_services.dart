import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

// check if a collection exists in Firestore
  Future<bool> collectionExists({required String path}) async {
    final ref = FirebaseFirestore.instance.collection(path);
    return ref.limit(1).get().then((value) => value.size == 1 ? true : false);
  }

  WriteBatch newBatch() {
    return FirebaseFirestore.instance.batch();
  }

// update a document in Firestore
  Future<void> updateDocument({
    required String path,
    required Map<String, dynamic> data,
    WriteBatch? batch,
  }) async {
    final ref = FirebaseFirestore.instance.doc(path);
    if (batch == null) {
      await ref
          .update(data)
          .then((_) => debugPrint('Updated $path: $data'))
          .onError((error, stackTrace) => debugPrint('$error'));
    } else {
      batch.update(ref, data);
    }
  }

// add a document to a specified collection in Firestore and returns id
  Future<String> addDocument({
    required String path,
    required Map<String, dynamic> data,
    String? myId,
    WriteBatch? batch,
  }) async {
    final ref = FirebaseFirestore.instance.collection(path);
    String? id;
    if (myId == null) {
      var doc = ref.doc();
      id = doc.id;
      data.addAll({'id': id});
      if (batch == null) {
        await ref
            .doc(id)
            .set(data)
            .then((_) => debugPrint('Added to $path: $data'))
            .onError((error, stackTrace) => debugPrint('$error'));
      } else {
        batch.set(doc, data);
      }
    } else {
      data.addAll({'id': myId});
      if (batch == null) {
        await ref
            .doc(myId)
            .set(data)
            .then((_) => debugPrint('Added to $path: $data'))
            .onError((error, stackTrace) => debugPrint('$error'));
      } else {
        batch.set(ref.doc(myId), data);
      }
    }
    return id ?? myId ?? '';
  }

// delete a document from Firestore
  Future<void> deleteDocument({
    required String path,
    WriteBatch? batch,
  }) async {
    final ref = FirebaseFirestore.instance.doc(path);
    if (batch == null) {
      await ref.delete().then((value) => debugPrint('Deleted: $path'));
    } else {
      batch.delete(ref);
    }
  }

// delete a collection from Firestore
  Future<void> deleteCollection({
    required String path,
  }) async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    final ref = instance.collection(path);
    await ref.get().then((value) {
      for (var doc in value.docs) {
        batch.delete(doc.reference);
      }
    });
    await batch.commit();
  }

// emit a future of a document for one-time read from Firestore
  Future<T?> documentFuture<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    
    final ref = FirebaseFirestore.instance.doc(path);
    return ref.get().then((value) =>
        value.exists ? builder(value.data() as Map<String, dynamic>) : null);}

  

// emit a future of a collection for one-time read from Firestore
  Future<List<T>> collectionFuture<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Future<QuerySnapshot> snapshots = query.get();
    return snapshots.then(
      (value) {
        final result = value.docs
            .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>))
            .toList();
        if (sort != null) {
          result.sort(sort);
        }
        return result;
      },
    );
  }

// emit a stream of a document for real-time updates from Firestore
  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    final ref = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = ref.snapshots();
    return snapshots
        .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>));
  }

// emit a stream of a collection for real-time updates from Firestore
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>))
          .where((element) => element != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

// query for use with FirestoreListView
  Query<T> collectionQuery<T>({
    required String path,
    required Query<T> Function(Query query) queryBuilder,
  }) {
    final ref = FirebaseFirestore.instance.collection(path);
    Query<T> query = queryBuilder(ref);
    return query;
  }
}
