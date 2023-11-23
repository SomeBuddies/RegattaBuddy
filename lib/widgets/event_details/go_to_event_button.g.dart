// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_to_event_button.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getUserTeamControllerHash() =>
    r'2a8675d52180e2667145b49b1f8b41e7215fb176';

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
  GetUserTeamControllerProvider call({
    required String? userId,
    required String eventId,
  }) {
    return GetUserTeamControllerProvider(
      userId: userId,
      eventId: eventId,
    );
  }

  @override
  GetUserTeamControllerProvider getProviderOverride(
    covariant GetUserTeamControllerProvider provider,
  ) {
    return call(
      userId: provider.userId,
      eventId: provider.eventId,
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
  GetUserTeamControllerProvider({
    required String? userId,
    required String eventId,
  }) : this._internal(
          (ref) => getUserTeamController(
            ref as GetUserTeamControllerRef,
            userId: userId,
            eventId: eventId,
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
          userId: userId,
          eventId: eventId,
        );

  GetUserTeamControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.eventId,
  }) : super.internal();

  final String? userId;
  final String eventId;

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
        userId: userId,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Team?> createElement() {
    return _GetUserTeamControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserTeamControllerProvider &&
        other.userId == userId &&
        other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetUserTeamControllerRef on AutoDisposeFutureProviderRef<Team?> {
  /// The parameter `userId` of this provider.
  String? get userId;

  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _GetUserTeamControllerProviderElement
    extends AutoDisposeFutureProviderElement<Team?>
    with GetUserTeamControllerRef {
  _GetUserTeamControllerProviderElement(super.provider);

  @override
  String? get userId => (origin as GetUserTeamControllerProvider).userId;
  @override
  String get eventId => (origin as GetUserTeamControllerProvider).eventId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
