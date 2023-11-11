// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_position_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamPositionNotifierHash() =>
    r'70ccaac91aa2436525387a7257621f692a3cb411';

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

abstract class _$TeamPositionNotifier
    extends BuildlessNotifier<Map<String, LatLng>> {
  late final String eventId;

  Map<String, LatLng> build(
    String eventId,
  );
}

/// See also [TeamPositionNotifier].
@ProviderFor(TeamPositionNotifier)
const teamPositionNotifierProvider = TeamPositionNotifierFamily();

/// See also [TeamPositionNotifier].
class TeamPositionNotifierFamily extends Family<Map<String, LatLng>> {
  /// See also [TeamPositionNotifier].
  const TeamPositionNotifierFamily();

  /// See also [TeamPositionNotifier].
  TeamPositionNotifierProvider call(
    String eventId,
  ) {
    return TeamPositionNotifierProvider(
      eventId,
    );
  }

  @override
  TeamPositionNotifierProvider getProviderOverride(
    covariant TeamPositionNotifierProvider provider,
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
  String? get name => r'teamPositionNotifierProvider';
}

/// See also [TeamPositionNotifier].
class TeamPositionNotifierProvider
    extends NotifierProviderImpl<TeamPositionNotifier, Map<String, LatLng>> {
  /// See also [TeamPositionNotifier].
  TeamPositionNotifierProvider(
    String eventId,
  ) : this._internal(
          () => TeamPositionNotifier()..eventId = eventId,
          from: teamPositionNotifierProvider,
          name: r'teamPositionNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamPositionNotifierHash,
          dependencies: TeamPositionNotifierFamily._dependencies,
          allTransitiveDependencies:
              TeamPositionNotifierFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  TeamPositionNotifierProvider._internal(
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
  Map<String, LatLng> runNotifierBuild(
    covariant TeamPositionNotifier notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(TeamPositionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TeamPositionNotifierProvider._internal(
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
  NotifierProviderElement<TeamPositionNotifier, Map<String, LatLng>>
      createElement() {
    return _TeamPositionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamPositionNotifierProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TeamPositionNotifierRef on NotifierProviderRef<Map<String, LatLng>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _TeamPositionNotifierProviderElement
    extends NotifierProviderElement<TeamPositionNotifier, Map<String, LatLng>>
    with TeamPositionNotifierRef {
  _TeamPositionNotifierProviderElement(super.provider);

  @override
  String get eventId => (origin as TeamPositionNotifierProvider).eventId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
