// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tournament _$TournamentFromJson(Map<String, dynamic> json) {
  return _Tournament.fromJson(json);
}

/// @nodoc
mixin _$Tournament {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get maxPlayers => throw _privateConstructorUsedError;
  int get currentRound => throw _privateConstructorUsedError;
  int get totalRounds => throw _privateConstructorUsedError;
  DrawHandling get drawHandling => throw _privateConstructorUsedError;
  TournamentStatus get status => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Tournament to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tournament
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TournamentCopyWith<Tournament> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentCopyWith<$Res> {
  factory $TournamentCopyWith(
          Tournament value, $Res Function(Tournament) then) =
      _$TournamentCopyWithImpl<$Res, Tournament>;
  @useResult
  $Res call(
      {String id,
      String name,
      int maxPlayers,
      int currentRound,
      int totalRounds,
      DrawHandling drawHandling,
      TournamentStatus status,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$TournamentCopyWithImpl<$Res, $Val extends Tournament>
    implements $TournamentCopyWith<$Res> {
  _$TournamentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tournament
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? maxPlayers = null,
    Object? currentRound = null,
    Object? totalRounds = null,
    Object? drawHandling = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      maxPlayers: null == maxPlayers
          ? _value.maxPlayers
          : maxPlayers // ignore: cast_nullable_to_non_nullable
              as int,
      currentRound: null == currentRound
          ? _value.currentRound
          : currentRound // ignore: cast_nullable_to_non_nullable
              as int,
      totalRounds: null == totalRounds
          ? _value.totalRounds
          : totalRounds // ignore: cast_nullable_to_non_nullable
              as int,
      drawHandling: null == drawHandling
          ? _value.drawHandling
          : drawHandling // ignore: cast_nullable_to_non_nullable
              as DrawHandling,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TournamentStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TournamentImplCopyWith<$Res>
    implements $TournamentCopyWith<$Res> {
  factory _$$TournamentImplCopyWith(
          _$TournamentImpl value, $Res Function(_$TournamentImpl) then) =
      __$$TournamentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int maxPlayers,
      int currentRound,
      int totalRounds,
      DrawHandling drawHandling,
      TournamentStatus status,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$$TournamentImplCopyWithImpl<$Res>
    extends _$TournamentCopyWithImpl<$Res, _$TournamentImpl>
    implements _$$TournamentImplCopyWith<$Res> {
  __$$TournamentImplCopyWithImpl(
      _$TournamentImpl _value, $Res Function(_$TournamentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tournament
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? maxPlayers = null,
    Object? currentRound = null,
    Object? totalRounds = null,
    Object? drawHandling = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TournamentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      maxPlayers: null == maxPlayers
          ? _value.maxPlayers
          : maxPlayers // ignore: cast_nullable_to_non_nullable
              as int,
      currentRound: null == currentRound
          ? _value.currentRound
          : currentRound // ignore: cast_nullable_to_non_nullable
              as int,
      totalRounds: null == totalRounds
          ? _value.totalRounds
          : totalRounds // ignore: cast_nullable_to_non_nullable
              as int,
      drawHandling: null == drawHandling
          ? _value.drawHandling
          : drawHandling // ignore: cast_nullable_to_non_nullable
              as DrawHandling,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TournamentStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentImpl implements _Tournament {
  const _$TournamentImpl(
      {required this.id,
      required this.name,
      required this.maxPlayers,
      this.currentRound = 0,
      required this.totalRounds,
      this.drawHandling = DrawHandling.bothLose,
      this.status = TournamentStatus.registration,
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt});

  factory _$TournamentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int maxPlayers;
  @override
  @JsonKey()
  final int currentRound;
  @override
  final int totalRounds;
  @override
  @JsonKey()
  final DrawHandling drawHandling;
  @override
  @JsonKey()
  final TournamentStatus status;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Tournament(id: $id, name: $name, maxPlayers: $maxPlayers, currentRound: $currentRound, totalRounds: $totalRounds, drawHandling: $drawHandling, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.maxPlayers, maxPlayers) ||
                other.maxPlayers == maxPlayers) &&
            (identical(other.currentRound, currentRound) ||
                other.currentRound == currentRound) &&
            (identical(other.totalRounds, totalRounds) ||
                other.totalRounds == totalRounds) &&
            (identical(other.drawHandling, drawHandling) ||
                other.drawHandling == drawHandling) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, maxPlayers,
      currentRound, totalRounds, drawHandling, status, createdAt, updatedAt);

  /// Create a copy of Tournament
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentImplCopyWith<_$TournamentImpl> get copyWith =>
      __$$TournamentImplCopyWithImpl<_$TournamentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentImplToJson(
      this,
    );
  }
}

abstract class _Tournament implements Tournament {
  const factory _Tournament(
      {required final String id,
      required final String name,
      required final int maxPlayers,
      final int currentRound,
      required final int totalRounds,
      final DrawHandling drawHandling,
      final TournamentStatus status,
      @TimestampConverter() final DateTime? createdAt,
      @TimestampConverter() final DateTime? updatedAt}) = _$TournamentImpl;

  factory _Tournament.fromJson(Map<String, dynamic> json) =
      _$TournamentImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get maxPlayers;
  @override
  int get currentRound;
  @override
  int get totalRounds;
  @override
  DrawHandling get drawHandling;
  @override
  TournamentStatus get status;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of Tournament
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentImplCopyWith<_$TournamentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
