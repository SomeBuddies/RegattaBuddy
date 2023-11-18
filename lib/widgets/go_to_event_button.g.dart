// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_to_event_button.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getUserTeamIdControllerHash() =>
    r'8f2346feec04c2a1c2a41284f8e2cd5dce92e8b9';

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

/// See also [getUserTeamIdController].
@ProviderFor(getUserTeamIdController)
const getUserTeamIdControllerProvider = GetUserTeamIdControllerFamily();

/// See also [getUserTeamIdController].
class GetUserTeamIdControllerFamily extends Family<AsyncValue<String?>> {
  /// See also [getUserTeamIdController].
  const GetUserTeamIdControllerFamily();

  /// See also [getUserTeamIdController].
  GetUserTeamIdControllerProvider call(
    Event event,
  ) {
    return GetUserTeamIdControllerProvider(
      event,
    );
  }

  @override
  GetUserTeamIdControllerProvider getProviderOverride(
    covariant GetUserTeamIdControllerProvider provider,
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
  String? get name => r'getUserTeamIdControllerProvider';
}

/// See also [getUserTeamIdController].
class GetUserTeamIdControllerProvider
    extends AutoDisposeFutureProvider<String?> {
  /// See also [getUserTeamIdController].
  GetUserTeamIdControllerProvider(
    Event event,
  ) : this._internal(
          (ref) => getUserTeamIdController(
            ref as GetUserTeamIdControllerRef,
            event,
          ),
          from: getUserTeamIdControllerProvider,
          name: r'getUserTeamIdControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getUserTeamIdControllerHash,
          dependencies: GetUserTeamIdControllerFamily._dependencies,
          allTransitiveDependencies:
              GetUserTeamIdControllerFamily._allTransitiveDependencies,
          event: event,
        );

  GetUserTeamIdControllerProvider._internal(
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
    FutureOr<String?> Function(GetUserTeamIdControllerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetUserTeamIdControllerProvider._internal(
        (ref) => create(ref as GetUserTeamIdControllerRef),
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
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _GetUserTeamIdControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserTeamIdControllerProvider && other.event == event;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, event.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetUserTeamIdControllerRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `event` of this provider.
  Event get event;
}

class _GetUserTeamIdControllerProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with GetUserTeamIdControllerRef {
  _GetUserTeamIdControllerProviderElement(super.provider);

  @override
  Event get event => (origin as GetUserTeamIdControllerProvider).event;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
