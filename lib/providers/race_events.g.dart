// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race_events.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamScoresHash() => r'1910ca3c059535567e0f9f6c3840e4d834151084';

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

/// See also [teamScores].
@ProviderFor(teamScores)
const teamScoresProvider = TeamScoresFamily();

/// See also [teamScores].
class TeamScoresFamily extends Family<AsyncValue<Map<String, List<int>>>> {
  /// See also [teamScores].
  const TeamScoresFamily();

  /// See also [teamScores].
  TeamScoresProvider call(
    String eventId,
  ) {
    return TeamScoresProvider(
      eventId,
    );
  }

  @override
  TeamScoresProvider getProviderOverride(
    covariant TeamScoresProvider provider,
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
  String? get name => r'teamScoresProvider';
}

/// See also [teamScores].
class TeamScoresProvider
    extends AutoDisposeStreamProvider<Map<String, List<int>>> {
  /// See also [teamScores].
  TeamScoresProvider(
    String eventId,
  ) : this._internal(
          (ref) => teamScores(
            ref as TeamScoresRef,
            eventId,
          ),
          from: teamScoresProvider,
          name: r'teamScoresProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamScoresHash,
          dependencies: TeamScoresFamily._dependencies,
          allTransitiveDependencies:
              TeamScoresFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  TeamScoresProvider._internal(
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
    Stream<Map<String, List<int>>> Function(TeamScoresRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamScoresProvider._internal(
        (ref) => create(ref as TeamScoresRef),
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
  AutoDisposeStreamProviderElement<Map<String, List<int>>> createElement() {
    return _TeamScoresProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamScoresProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TeamScoresRef on AutoDisposeStreamProviderRef<Map<String, List<int>>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _TeamScoresProviderElement
    extends AutoDisposeStreamProviderElement<Map<String, List<int>>>
    with TeamScoresRef {
  _TeamScoresProviderElement(super.provider);

  @override
  String get eventId => (origin as TeamScoresProvider).eventId;
}

String _$currentRoundHash() => r'd48aadeb0fa4c1092dbadd43f0cbbcbd6031d490';

abstract class _$CurrentRound extends BuildlessAutoDisposeNotifier<int> {
  late final String eventId;

  int build(
    String eventId,
  );
}

/// See also [CurrentRound].
@ProviderFor(CurrentRound)
const currentRoundProvider = CurrentRoundFamily();

/// See also [CurrentRound].
class CurrentRoundFamily extends Family<int> {
  /// See also [CurrentRound].
  const CurrentRoundFamily();

  /// See also [CurrentRound].
  CurrentRoundProvider call(
    String eventId,
  ) {
    return CurrentRoundProvider(
      eventId,
    );
  }

  @override
  CurrentRoundProvider getProviderOverride(
    covariant CurrentRoundProvider provider,
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
  String? get name => r'currentRoundProvider';
}

/// See also [CurrentRound].
class CurrentRoundProvider
    extends AutoDisposeNotifierProviderImpl<CurrentRound, int> {
  /// See also [CurrentRound].
  CurrentRoundProvider(
    String eventId,
  ) : this._internal(
          () => CurrentRound()..eventId = eventId,
          from: currentRoundProvider,
          name: r'currentRoundProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentRoundHash,
          dependencies: CurrentRoundFamily._dependencies,
          allTransitiveDependencies:
              CurrentRoundFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  CurrentRoundProvider._internal(
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
  int runNotifierBuild(
    covariant CurrentRound notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(CurrentRound Function() create) {
    return ProviderOverride(
      origin: this,
      override: CurrentRoundProvider._internal(
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
  AutoDisposeNotifierProviderElement<CurrentRound, int> createElement() {
    return _CurrentRoundProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentRoundProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CurrentRoundRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _CurrentRoundProviderElement
    extends AutoDisposeNotifierProviderElement<CurrentRound, int>
    with CurrentRoundRef {
  _CurrentRoundProviderElement(super.provider);

  @override
  String get eventId => (origin as CurrentRoundProvider).eventId;
}

String _$currentRoundStatusHash() =>
    r'016d8ed69a427df774434fb87f89cd0934c4c927';

/// See also [CurrentRoundStatus].
@ProviderFor(CurrentRoundStatus)
final currentRoundStatusProvider =
    AutoDisposeNotifierProvider<CurrentRoundStatus, RoundStatus>.internal(
  CurrentRoundStatus.new,
  name: r'currentRoundStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentRoundStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentRoundStatus = AutoDisposeNotifier<RoundStatus>;
String _$currentlyTrackedTeamsHash() =>
    r'9fc1fe411947b21406842b902cf2fe8e2b04d815';

/// See also [CurrentlyTrackedTeams].
@ProviderFor(CurrentlyTrackedTeams)
final currentlyTrackedTeamsProvider =
    AutoDisposeNotifierProvider<CurrentlyTrackedTeams, Set<String>>.internal(
  CurrentlyTrackedTeams.new,
  name: r'currentlyTrackedTeamsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentlyTrackedTeamsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentlyTrackedTeams = AutoDisposeNotifier<Set<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
