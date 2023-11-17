// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_traces_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamTracesNotifierHash() =>
    r'0ba59251037d1991eaa9604402bc1ea5430c89c1';

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

abstract class _$TeamTracesNotifier
    extends BuildlessAutoDisposeNotifier<Map<String, Map<int, List<LatLng>>>> {
  late final String eventId;

  Map<String, Map<int, List<LatLng>>> build(
    String eventId,
  );
}

/// See also [TeamTracesNotifier].
@ProviderFor(TeamTracesNotifier)
const teamTracesNotifierProvider = TeamTracesNotifierFamily();

/// See also [TeamTracesNotifier].
class TeamTracesNotifierFamily
    extends Family<Map<String, Map<int, List<LatLng>>>> {
  /// See also [TeamTracesNotifier].
  const TeamTracesNotifierFamily();

  /// See also [TeamTracesNotifier].
  TeamTracesNotifierProvider call(
    String eventId,
  ) {
    return TeamTracesNotifierProvider(
      eventId,
    );
  }

  @override
  TeamTracesNotifierProvider getProviderOverride(
    covariant TeamTracesNotifierProvider provider,
  ) {
    return call(
      provider.eventId,
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
  String? get name => r'teamTracesNotifierProvider';
}

/// See also [TeamTracesNotifier].
class TeamTracesNotifierProvider extends AutoDisposeNotifierProviderImpl<
    TeamTracesNotifier, Map<String, Map<int, List<LatLng>>>> {
  /// See also [TeamTracesNotifier].
  TeamTracesNotifierProvider(
    String eventId,
  ) : this._internal(
          () => TeamTracesNotifier()..eventId = eventId,
          from: teamTracesNotifierProvider,
          name: r'teamTracesNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamTracesNotifierHash,
          dependencies: TeamTracesNotifierFamily._dependencies,
          allTransitiveDependencies:
              TeamTracesNotifierFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  TeamTracesNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  Map<String, Map<int, List<LatLng>>> runNotifierBuild(
    covariant TeamTracesNotifier notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(TeamTracesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TeamTracesNotifierProvider._internal(
        () => create()..eventId = eventId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TeamTracesNotifier,
      Map<String, Map<int, List<LatLng>>>> createElement() {
    return _TeamTracesNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamTracesNotifierProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TeamTracesNotifierRef
    on AutoDisposeNotifierProviderRef<Map<String, Map<int, List<LatLng>>>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _TeamTracesNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<TeamTracesNotifier,
        Map<String, Map<int, List<LatLng>>>> with TeamTracesNotifierRef {
  _TeamTracesNotifierProviderElement(super.provider);

  @override
  String get eventId => (origin as TeamTracesNotifierProvider).eventId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
