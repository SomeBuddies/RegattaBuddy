// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventRepositoryHash() => r'44e4b339143bbeab6fcab3d5eeca65aa2c938ad7';

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
String _$teamRepositoryHash() => r'387de16d8ddc3a34f2f1ad7ae5d9fe0b72763622';

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
    String eventId,
  ) {
    return TeamRepositoryProvider(
      eventId,
    );
  }

  @override
  TeamRepositoryProvider getProviderOverride(
    covariant TeamRepositoryProvider provider,
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
  String? get name => r'teamRepositoryProvider';
}

/// See also [teamRepository].
class TeamRepositoryProvider extends Provider<TeamRepository> {
  /// See also [teamRepository].
  TeamRepositoryProvider(
    String eventId,
  ) : this._internal(
          (ref) => teamRepository(
            ref as TeamRepositoryRef,
            eventId,
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
          eventId: eventId,
        );

  TeamRepositoryProvider._internal(
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
        eventId: eventId,
      ),
    );
  }

  @override
  ProviderElement<TeamRepository> createElement() {
    return _TeamRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamRepositoryProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TeamRepositoryRef on ProviderRef<TeamRepository> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _TeamRepositoryProviderElement extends ProviderElement<TeamRepository>
    with TeamRepositoryRef {
  _TeamRepositoryProviderElement(super.provider);

  @override
  String get eventId => (origin as TeamRepositoryProvider).eventId;
}

String _$scoreRepositoryHash() => r'3131a95e56754b933c3efee71f60b1c60a3a9226';

/// See also [scoreRepository].
@ProviderFor(scoreRepository)
final scoreRepositoryProvider = Provider<ScoreRepository>.internal(
  scoreRepository,
  name: r'scoreRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scoreRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ScoreRepositoryRef = ProviderRef<ScoreRepository>;
String _$eventMessageSenderHash() =>
    r'9469cca670fb752d6df0aa540ab3539a5885e726';

/// See also [eventMessageSender].
@ProviderFor(eventMessageSender)
final eventMessageSenderProvider = Provider<EventMessageSender>.internal(
  eventMessageSender,
  name: r'eventMessageSenderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventMessageSenderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EventMessageSenderRef = ProviderRef<EventMessageSender>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
