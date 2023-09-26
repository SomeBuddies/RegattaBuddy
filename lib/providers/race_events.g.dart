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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
