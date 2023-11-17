// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_position_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamPositionNotifierHash() =>
    r'6167958f13fb6f51d01858b5d5952e87f34a34d4';

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
    extends BuildlessAutoDisposeNotifier<Map<String, LatLng>> {
  late final Event event;

  Map<String, LatLng> build(
    Event event,
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
    Event event,
  ) {
    return TeamPositionNotifierProvider(
      event,
    );
  }

  @override
  TeamPositionNotifierProvider getProviderOverride(
    covariant TeamPositionNotifierProvider provider,
  ) {
    return call(
      provider.event,
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
class TeamPositionNotifierProvider extends AutoDisposeNotifierProviderImpl<
    TeamPositionNotifier, Map<String, LatLng>> {
  /// See also [TeamPositionNotifier].
  TeamPositionNotifierProvider(
    Event event,
  ) : this._internal(
          () => TeamPositionNotifier()..event = event,
          from: teamPositionNotifierProvider,
          name: r'teamPositionNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamPositionNotifierHash,
          dependencies: TeamPositionNotifierFamily._dependencies,
          allTransitiveDependencies:
              TeamPositionNotifierFamily._allTransitiveDependencies,
          event: event,
        );

  TeamPositionNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.event,
  }) : super.internal();

  final Event event;

  @override
  Map<String, LatLng> runNotifierBuild(
    covariant TeamPositionNotifier notifier,
  ) {
    return notifier.build(
      event,
    );
  }

  @override
  Override overrideWith(TeamPositionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TeamPositionNotifierProvider._internal(
        () => create()..event = event,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        event: event,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TeamPositionNotifier, Map<String, LatLng>>
      createElement() {
    return _TeamPositionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamPositionNotifierProvider && other.event == event;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, event.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TeamPositionNotifierRef
    on AutoDisposeNotifierProviderRef<Map<String, LatLng>> {
  /// The parameter `event` of this provider.
  Event get event;
}

class _TeamPositionNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<TeamPositionNotifier,
        Map<String, LatLng>> with TeamPositionNotifierRef {
  _TeamPositionNotifierProviderElement(super.provider);

  @override
  Event get event => (origin as TeamPositionNotifierProvider).event;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
