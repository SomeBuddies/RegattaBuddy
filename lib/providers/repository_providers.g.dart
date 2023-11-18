// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventRepositoryHash() => r'd409dd63b14a2464564cd99500feef45d0d3bda7';

/// See also [eventRepository].
@ProviderFor(eventRepository)
final eventRepositoryProvider = AutoDisposeProvider<EventRepository>.internal(
  eventRepository,
  name: r'eventRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EventRepositoryRef = AutoDisposeProviderRef<EventRepository>;
String _$userRepositoryHash() => r'56f0461b0ffec4a35a4fa0b829769e8e7850495d';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = Provider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRepositoryRef = ProviderRef<UserRepository>;
String _$teamRepositoryHash() => r'a13ecb0a3eff2e90b3c2d61d180adb7b7c91ee70';

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

/// See also [teamRepository].
@ProviderFor(teamRepository)
const teamRepositoryProvider = TeamRepositoryFamily();

/// See also [teamRepository].
class TeamRepositoryFamily extends Family<TeamRepository> {
  /// See also [teamRepository].
  const TeamRepositoryFamily();

  /// See also [teamRepository].
  TeamRepositoryProvider call(
    Event event,
  ) {
    return TeamRepositoryProvider(
      event,
    );
  }

  @override
  TeamRepositoryProvider getProviderOverride(
    covariant TeamRepositoryProvider provider,
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
  String? get name => r'teamRepositoryProvider';
}

/// See also [teamRepository].
class TeamRepositoryProvider extends Provider<TeamRepository> {
  /// See also [teamRepository].
  TeamRepositoryProvider(
    Event event,
  ) : this._internal(
          (ref) => teamRepository(
            ref as TeamRepositoryRef,
            event,
          ),
          from: teamRepositoryProvider,
          name: r'teamRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamRepositoryHash,
          dependencies: TeamRepositoryFamily._dependencies,
          allTransitiveDependencies:
              TeamRepositoryFamily._allTransitiveDependencies,
          event: event,
        );

  TeamRepositoryProvider._internal(
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
  Override overrideWith(
    TeamRepository Function(TeamRepositoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamRepositoryProvider._internal(
        (ref) => create(ref as TeamRepositoryRef),
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
  ProviderElement<TeamRepository> createElement() {
    return _TeamRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamRepositoryProvider && other.event == event;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, event.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TeamRepositoryRef on ProviderRef<TeamRepository> {
  /// The parameter `event` of this provider.
  Event get event;
}

class _TeamRepositoryProviderElement extends ProviderElement<TeamRepository>
    with TeamRepositoryRef {
  _TeamRepositoryProviderElement(super.provider);

  @override
  Event get event => (origin as TeamRepositoryProvider).event;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
