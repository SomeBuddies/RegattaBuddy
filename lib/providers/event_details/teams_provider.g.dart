// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teams_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamsHash() => r'e2b3e2535512d7480bf1766416ffb1f566a84ec0';

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
    Event event,
  ) {
    return TeamsProvider(
      event,
    );
  }

  @override
  TeamsProvider getProviderOverride(
    covariant TeamsProvider provider,
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
  String? get name => r'teamsProvider';
}

/// See also [teams].
class TeamsProvider extends AutoDisposeFutureProvider<List<Team>> {
  /// See also [teams].
  TeamsProvider(
    Event event,
  ) : this._internal(
          (ref) => teams(
            ref as TeamsRef,
            event,
          ),
          from: teamsProvider,
          name: r'teamsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamsHash,
          dependencies: TeamsFamily._dependencies,
          allTransitiveDependencies: TeamsFamily._allTransitiveDependencies,
          event: event,
        );

  TeamsProvider._internal(
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
        event: event,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Team>> createElement() {
    return _TeamsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamsProvider && other.event == event;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, event.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TeamsRef on AutoDisposeFutureProviderRef<List<Team>> {
  /// The parameter `event` of this provider.
  Event get event;
}

class _TeamsProviderElement extends AutoDisposeFutureProviderElement<List<Team>>
    with TeamsRef {
  _TeamsProviderElement(super.provider);

  @override
  Event get event => (origin as TeamsProvider).event;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
