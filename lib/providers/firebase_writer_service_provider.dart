import 'package:regatta_buddy/services/firebase_writer_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'firebase_providers.dart';

part 'firebase_writer_service_provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseWriterService firebaseWriterService(FirebaseWriterServiceRef ref) {
  final firebaseDatabase = ref.watch(firebaseDbProvider);

  return FirebaseWriterService(firebaseDatabase);
}
