// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationSenderHash() => r'6f16332cc0623ec39b54c2b83efda2c5393d340e';

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

/// See also [locationSender].
@ProviderFor(locationSender)
const locationSenderProvider = LocationSenderFamily();

/// See also [locationSender].
class LocationSenderFamily extends Family<LocationSender> {
  /// See also [locationSender].
  const LocationSenderFamily();

  /// See also [locationSender].
  LocationSenderProvider call(
    void Function(String) setErrorMessage,
  ) {
    return LocationSenderProvider(
      setErrorMessage,
    );
  }

  @override
  LocationSenderProvider getProviderOverride(
    covariant LocationSenderProvider provider,
  ) {
    return call(
      provider.setErrorMessage,
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
  String? get name => r'locationSenderProvider';
}

/// See also [locationSender].
class LocationSenderProvider extends AutoDisposeProvider<LocationSender> {
  /// See also [locationSender].
  LocationSenderProvider(
    void Function(String) setErrorMessage,
  ) : this._internal(
          (ref) => locationSender(
            ref as LocationSenderRef,
            setErrorMessage,
          ),
          from: locationSenderProvider,
          name: r'locationSenderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$locationSenderHash,
          dependencies: LocationSenderFamily._dependencies,
          allTransitiveDependencies:
              LocationSenderFamily._allTransitiveDependencies,
          setErrorMessage: setErrorMessage,
        );

  LocationSenderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.setErrorMessage,
  }) : super.internal();

  final void Function(String) setErrorMessage;

  @override
  Override overrideWith(
    LocationSender Function(LocationSenderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocationSenderProvider._internal(
        (ref) => create(ref as LocationSenderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        setErrorMessage: setErrorMessage,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<LocationSender> createElement() {
    return _LocationSenderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationSenderProvider &&
        other.setErrorMessage == setErrorMessage;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, setErrorMessage.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LocationSenderRef on AutoDisposeProviderRef<LocationSender> {
  /// The parameter `setErrorMessage` of this provider.
  void Function(String) get setErrorMessage;
}

class _LocationSenderProviderElement
    extends AutoDisposeProviderElement<LocationSender> with LocationSenderRef {
  _LocationSenderProviderElement(super.provider);

  @override
  void Function(String) get setErrorMessage =>
      (origin as LocationSenderProvider).setErrorMessage;
}

String _$locationSpeedHash() => r'4c7b48e7e30f3d187faca0c05df891d5b2232b97';

/// See also [LocationSpeed].
@ProviderFor(LocationSpeed)
final locationSpeedProvider =
    AutoDisposeNotifierProvider<LocationSpeed, double>.internal(
  LocationSpeed.new,
  name: r'locationSpeedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationSpeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocationSpeed = AutoDisposeNotifier<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
