// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firestoreEventsHash() => r'e5054d3af085109be5e4ca089e111d826ce30fe9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [firestoreEvents].
@ProviderFor(firestoreEvents)
const firestoreEventsProvider = FirestoreEventsFamily();

/// See also [firestoreEvents].
class FirestoreEventsFamily extends Family<AsyncValue<List<Event>>> {
  /// See also [firestoreEvents].
  const FirestoreEventsFamily();

  /// See also [firestoreEvents].
  FirestoreEventsProvider call({
    String? userId,
  }) {
    return FirestoreEventsProvider(
      userId: userId,
    );
  }

  @override
  FirestoreEventsProvider getProviderOverride(
    covariant FirestoreEventsProvider provider,
  ) {
    return call(
      userId: provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'firestoreEventsProvider';
}

/// See also [firestoreEvents].
class FirestoreEventsProvider extends AutoDisposeFutureProvider<List<Event>> {
  /// See also [firestoreEvents].
  FirestoreEventsProvider({
    String? userId,
  }) : this._internal(
          (ref) => firestoreEvents(
            ref as FirestoreEventsRef,
            userId: userId,
          ),
          from: firestoreEventsProvider,
          name: r'firestoreEventsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$firestoreEventsHash,
          dependencies: FirestoreEventsFamily._dependencies,
          allTransitiveDependencies:
              FirestoreEventsFamily._allTransitiveDependencies,
          userId: userId,
        );

  FirestoreEventsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String? userId;

  @override
  Override overrideWith(
    FutureOr<List<Event>> Function(FirestoreEventsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FirestoreEventsProvider._internal(
        (ref) => create(ref as FirestoreEventsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Event>> createElement() {
    return _FirestoreEventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FirestoreEventsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FirestoreEventsRef on AutoDisposeFutureProviderRef<List<Event>> {
  /// The parameter `userId` of this provider.
  String? get userId;
}

class _FirestoreEventsProviderElement
    extends AutoDisposeFutureProviderElement<List<Event>>
    with FirestoreEventsRef {
  _FirestoreEventsProviderElement(super.provider);

  @override
  String? get userId => (origin as FirestoreEventsProvider).userId;
}

String _$eventListHash() => r'ee09cb2f4d564b0b63644bcbfe79b8633c996a8b';

/// See also [eventList].
@ProviderFor(eventList)
const eventListProvider = EventListFamily();

/// See also [eventList].
class EventListFamily extends Family<AsyncValue<List<Event>>> {
  /// See also [eventList].
  const EventListFamily();

  /// See also [eventList].
  EventListProvider call({
    String? query,
    bool? isUserView,
  }) {
    return EventListProvider(
      query: query,
      isUserView: isUserView,
    );
  }

  @override
  EventListProvider getProviderOverride(
    covariant EventListProvider provider,
  ) {
    return call(
      query: provider.query,
      isUserView: provider.isUserView,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'eventListProvider';
}

/// See also [eventList].
class EventListProvider extends AutoDisposeFutureProvider<List<Event>> {
  /// See also [eventList].
  EventListProvider({
    String? query,
    bool? isUserView,
  }) : this._internal(
          (ref) => eventList(
            ref as EventListRef,
            query: query,
            isUserView: isUserView,
          ),
          from: eventListProvider,
          name: r'eventListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventListHash,
          dependencies: EventListFamily._dependencies,
          allTransitiveDependencies: EventListFamily._allTransitiveDependencies,
          query: query,
          isUserView: isUserView,
        );

  EventListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.isUserView,
  }) : super.internal();

  final String? query;
  final bool? isUserView;

  @override
  Override overrideWith(
    FutureOr<List<Event>> Function(EventListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventListProvider._internal(
        (ref) => create(ref as EventListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        isUserView: isUserView,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Event>> createElement() {
    return _EventListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventListProvider &&
        other.query == query &&
        other.isUserView == isUserView;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, isUserView.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EventListRef on AutoDisposeFutureProviderRef<List<Event>> {
  /// The parameter `query` of this provider.
  String? get query;

  /// The parameter `isUserView` of this provider.
  bool? get isUserView;
}

class _EventListProviderElement
    extends AutoDisposeFutureProviderElement<List<Event>> with EventListRef {
  _EventListProviderElement(super.provider);

  @override
  String? get query => (origin as EventListProvider).query;
  @override
  bool? get isUserView => (origin as EventListProvider).isUserView;
}

String _$currentSortTypeHash() => r'63d9f3a7ca850112baab2aa4d80f636a78838a89';

/// See also [CurrentSortType].
@ProviderFor(CurrentSortType)
final currentSortTypeProvider =
    AutoDisposeNotifierProvider<CurrentSortType, SortType>.internal(
  CurrentSortType.new,
  name: r'currentSortTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSortTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentSortType = AutoDisposeNotifier<SortType>;
String _$currentSortOrderHash() => r'b1195ed9a4a9f309b07cdeb6ff729b56d48da993';

/// See also [CurrentSortOrder].
@ProviderFor(CurrentSortOrder)
final currentSortOrderProvider =
    AutoDisposeNotifierProvider<CurrentSortOrder, SortOrder>.internal(
  CurrentSortOrder.new,
  name: r'currentSortOrderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSortOrderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentSortOrder = AutoDisposeNotifier<SortOrder>;
String _$showPastEventsHash() => r'bcd92f64a392b472f570d0a595f40f7f3eb5b5c4';

/// See also [ShowPastEvents].
@ProviderFor(ShowPastEvents)
final showPastEventsProvider =
    AutoDisposeNotifierProvider<ShowPastEvents, bool>.internal(
  ShowPastEvents.new,
  name: r'showPastEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$showPastEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShowPastEvents = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
