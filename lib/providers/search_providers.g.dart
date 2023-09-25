// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

<<<<<<< HEAD
String _$firestoreEventsHash() => r'93b5b7b60c2fe10ab7c38fc77c16a4bfdf036a16';
=======
String _$firestoreEventsHash() => r'95776b7fbd01d7f875bdf9b52ffa68d882cf41d8';
>>>>>>> 8a6f12b (Create event repository)

/// See also [firestoreEvents].
@ProviderFor(firestoreEvents)
final firestoreEventsProvider = AutoDisposeFutureProvider<List<Event>>.internal(
  firestoreEvents,
  name: r'firestoreEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firestoreEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirestoreEventsRef = AutoDisposeFutureProviderRef<List<Event>>;
String _$eventListHash() => r'632d7f797cb78256a355a40136b18e85cd99846f';

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
  }) {
    return EventListProvider(
      query: query,
    );
  }

  @override
  EventListProvider getProviderOverride(
    covariant EventListProvider provider,
  ) {
    return call(
      query: provider.query,
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
  }) : this._internal(
          (ref) => eventList(
            ref as EventListRef,
            query: query,
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
        );

  EventListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String? query;

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
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Event>> createElement() {
    return _EventListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventListProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EventListRef on AutoDisposeFutureProviderRef<List<Event>> {
  /// The parameter `query` of this provider.
  String? get query;
}

class _EventListProviderElement
    extends AutoDisposeFutureProviderElement<List<Event>> with EventListRef {
  _EventListProviderElement(super.provider);

  @override
  String? get query => (origin as EventListProvider).query;
}

String _$currentSortTypeHash() => r'395d122c20eea89c049a4929543e65c0cb6810fb';

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
String _$currentSortOrderHash() => r'fe5045a0ec0785060d569b8ecd22d2e18168ce07';

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
