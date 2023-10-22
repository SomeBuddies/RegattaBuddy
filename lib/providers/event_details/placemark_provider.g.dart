// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placemark_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$placemarkHash() => r'4b9f3dd78c5ad564ea75b96cd6eb6c6bebc07012';

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

/// See also [placemark].
@ProviderFor(placemark)
const placemarkProvider = PlacemarkFamily();

/// See also [placemark].
class PlacemarkFamily extends Family<AsyncValue<List<Placemark>>> {
  /// See also [placemark].
  const PlacemarkFamily();

  /// See also [placemark].
  PlacemarkProvider call(
    LatLng location,
  ) {
    return PlacemarkProvider(
      location,
    );
  }

  @override
  PlacemarkProvider getProviderOverride(
    covariant PlacemarkProvider provider,
  ) {
    return call(
      provider.location,
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
  String? get name => r'placemarkProvider';
}

/// See also [placemark].
class PlacemarkProvider extends AutoDisposeFutureProvider<List<Placemark>> {
  /// See also [placemark].
  PlacemarkProvider(
    LatLng location,
  ) : this._internal(
          (ref) => placemark(
            ref as PlacemarkRef,
            location,
          ),
          from: placemarkProvider,
          name: r'placemarkProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$placemarkHash,
          dependencies: PlacemarkFamily._dependencies,
          allTransitiveDependencies: PlacemarkFamily._allTransitiveDependencies,
          location: location,
        );

  PlacemarkProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.location,
  }) : super.internal();

  final LatLng location;

  @override
  Override overrideWith(
    FutureOr<List<Placemark>> Function(PlacemarkRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlacemarkProvider._internal(
        (ref) => create(ref as PlacemarkRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        location: location,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Placemark>> createElement() {
    return _PlacemarkProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlacemarkProvider && other.location == location;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, location.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PlacemarkRef on AutoDisposeFutureProviderRef<List<Placemark>> {
  /// The parameter `location` of this provider.
  LatLng get location;
}

class _PlacemarkProviderElement
    extends AutoDisposeFutureProviderElement<List<Placemark>>
    with PlacemarkRef {
  _PlacemarkProviderElement(super.provider);

  @override
  LatLng get location => (origin as PlacemarkProvider).location;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
