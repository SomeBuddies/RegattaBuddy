// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teams_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamsHash() => r'cc50e79a3324289163a157a553725c8b9daf3b46';

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

/// See also [teams].
@ProviderFor(teams)
const teamsProvider = TeamsFamily();

/// See also [teams].
class TeamsFamily extends Family<AsyncValue<List<Team>>> {
  /// See also [teams].
  const TeamsFamily();

  /// See also [teams].
  TeamsProvider call(
    String eventId,
  ) {
    return TeamsProvider(
      eventId,
    );
  }

  @override
  TeamsProvider getProviderOverride(
    covariant TeamsProvider provider,
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
  String? get name => r'teamsProvider';
}

/// See also [teams].
class TeamsProvider extends AutoDisposeFutureProvider<List<Team>> {
  /// See also [teams].
  TeamsProvider(
    String eventId,
  ) : this._internal(
          (ref) => teams(
            ref as TeamsRef,
            eventId,
          ),
          from: teamsProvider,
          name: r'teamsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamsHash,
          dependencies: TeamsFamily._dependencies,
          allTransitiveDependencies: TeamsFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  TeamsProvider._internal(
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
    FutureOr<List<Team>> Function(TeamsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamsProvider._internal(
        (ref) => create(ref as TeamsRef),
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
  AutoDisposeFutureProviderElement<List<Team>> createElement() {
    return _TeamsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamsProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TeamsRef on AutoDisposeFutureProviderRef<List<Team>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _TeamsProviderElement extends AutoDisposeFutureProviderElement<List<Team>>
    with TeamsRef {
  _TeamsProviderElement(super.provider);

  @override
  String get eventId => (origin as TeamsProvider).eventId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
