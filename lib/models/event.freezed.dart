// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get id => throw _privateConstructorUsedError;
  String get hostId => throw _privateConstructorUsedError;
  @LatLngConverter()
  List<LatLng> get route => throw _privateConstructorUsedError;
  @LatLngConverter()
  LatLng get location => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call(
      {@JsonKey(includeFromJson: false, includeToJson: false) String id,
      String hostId,
      @LatLngConverter() List<LatLng> route,
      @LatLngConverter() LatLng location,
      DateTime date,
      String name,
      String description});
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostId = null,
    Object? route = null,
    Object? location = null,
    Object? date = null,
    Object? name = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      route: null == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$_EventCopyWith(_$_Event value, $Res Function(_$_Event) then) =
      __$$_EventCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(includeFromJson: false, includeToJson: false) String id,
      String hostId,
      @LatLngConverter() List<LatLng> route,
      @LatLngConverter() LatLng location,
      DateTime date,
      String name,
      String description});
}

/// @nodoc
class __$$_EventCopyWithImpl<$Res> extends _$EventCopyWithImpl<$Res, _$_Event>
    implements _$$_EventCopyWith<$Res> {
  __$$_EventCopyWithImpl(_$_Event _value, $Res Function(_$_Event) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostId = null,
    Object? route = null,
    Object? location = null,
    Object? date = null,
    Object? name = null,
    Object? description = null,
  }) {
    return _then(_$_Event(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      route: null == route
          ? _value._route
          : route // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Event implements _Event {
  const _$_Event(
      {@JsonKey(includeFromJson: false, includeToJson: false) this.id = '',
      required this.hostId,
      @LatLngConverter() required final List<LatLng> route,
      @LatLngConverter() required this.location,
      required this.date,
      required this.name,
      required this.description})
      : _route = route;

  factory _$_Event.fromJson(Map<String, dynamic> json) =>
      _$$_EventFromJson(json);

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String id;
  @override
  final String hostId;
  final List<LatLng> _route;
  @override
  @LatLngConverter()
  List<LatLng> get route {
    if (_route is EqualUnmodifiableListView) return _route;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_route);
  }

  @override
  @LatLngConverter()
  final LatLng location;
  @override
  final DateTime date;
  @override
  final String name;
  @override
  final String description;

  @override
  String toString() {
    return 'Event(id: $id, hostId: $hostId, route: $route, location: $location, date: $date, name: $name, description: $description)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Event &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            const DeepCollectionEquality().equals(other._route, _route) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      hostId,
      const DeepCollectionEquality().hash(_route),
      location,
      date,
      name,
      description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EventCopyWith<_$_Event> get copyWith =>
      __$$_EventCopyWithImpl<_$_Event>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EventToJson(
      this,
    );
  }
}

abstract class _Event implements Event {
  const factory _Event(
      {@JsonKey(includeFromJson: false, includeToJson: false) final String id,
      required final String hostId,
      @LatLngConverter() required final List<LatLng> route,
      @LatLngConverter() required final LatLng location,
      required final DateTime date,
      required final String name,
      required final String description}) = _$_Event;

  factory _Event.fromJson(Map<String, dynamic> json) = _$_Event.fromJson;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get id;
  @override
  String get hostId;
  @override
  @LatLngConverter()
  List<LatLng> get route;
  @override
  @LatLngConverter()
  LatLng get location;
  @override
  DateTime get date;
  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$_EventCopyWith<_$_Event> get copyWith =>
      throw _privateConstructorUsedError;
}
