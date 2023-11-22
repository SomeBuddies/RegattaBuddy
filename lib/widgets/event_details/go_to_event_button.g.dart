// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_to_event_button.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getUserTeamControllerHash() =>
    r'b039a6c33b030be1c828f1883ca3af8e3d10fb66';

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

/// See also [getUserTeamController].
@ProviderFor(getUserTeamController)
const getUserTeamControllerProvider = GetUserTeamControllerFamily();

/// See also [getUserTeamController].
class GetUserTeamControllerFamily extends Family<AsyncValue<Team?>> {
  /// See also [getUserTeamController].
  const GetUserTeamControllerFamily();

  /// See also [getUserTeamController].
  GetUserTeamControllerProvider call(
    Event event,
  ) {
    return GetUserTeamControllerProvider(
      event,
    );
  }

  @override
  GetUserTeamControllerProvider getProviderOverride(
    covariant GetUserTeamControllerProvider provider,
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
  String? get name => r'getUserTeamControllerProvider';
}

/// See also [getUserTeamController].
class GetUserTeamControllerProvider extends AutoDisposeFutureProvider<Team?> {
  /// See also [getUserTeamController].
  GetUserTeamControllerProvider(
    Event event,
  ) : this._internal(
          (ref) => getUserTeamController(
            ref as GetUserTeamControllerRef,
            event,
          ),
          from: getUserTeamControllerProvider,
          name: r'getUserTeamControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getUserTeamControllerHash,
          dependencies: GetUserTeamControllerFamily._dependencies,
          allTransitiveDependencies:
              GetUserTeamControllerFamily._allTransitiveDependencies,
          event: event,
        );

  GetUserTeamControllerProvider._internal(
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
    FutureOr<Team?> Function(GetUserTeamControllerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetUserTeamControllerProvider._internal(
        (ref) => create(ref as GetUserTeamControllerRef),
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
  AutoDisposeFutureProviderElement<Team?> createElement() {
    return _GetUserTeamControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserTeamControllerProvider && other.event == event;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, event.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetUserTeamControllerRef on AutoDisposeFutureProviderRef<Team?> {
  /// The parameter `event` of this provider.
  Event get event;
}

class _GetUserTeamControllerProviderElement
    extends AutoDisposeFutureProviderElement<Team?>
    with GetUserTeamControllerRef {
  _GetUserTeamControllerProviderElement(super.provider);

  @override
  Event get event => (origin as GetUserTeamControllerProvider).event;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
