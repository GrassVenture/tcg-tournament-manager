// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Match _$MatchFromJson(Map<String, dynamic> json) {
  return _Match.fromJson(json);
}

/// @nodoc
mixin _$Match {
  String get id => throw _privateConstructorUsedError;
  String get tournamentId => throw _privateConstructorUsedError;
  int get round => throw _privateConstructorUsedError;
  String get player1Id => throw _privateConstructorUsedError;
  String? get player2Id => throw _privateConstructorUsedError; // null の場合は不戦勝
  MatchResult get result => throw _privateConstructorUsedError;
  String? get reportedBy => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get reportedAt => throw _privateConstructorUsedError;

  /// Serializes this Match to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchCopyWith<Match> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchCopyWith<$Res> {
  factory $MatchCopyWith(Match value, $Res Function(Match) then) =
      _$MatchCopyWithImpl<$Res, Match>;
  @useResult
  $Res call(
      {String id,
      String tournamentId,
      int round,
      String player1Id,
      String? player2Id,
      MatchResult result,
      String? reportedBy,
      @TimestampConverter() DateTime? reportedAt});
}

/// @nodoc
class _$MatchCopyWithImpl<$Res, $Val extends Match>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? round = null,
    Object? player1Id = null,
    Object? player2Id = freezed,
    Object? result = null,
    Object? reportedBy = freezed,
    Object? reportedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tournamentId: null == tournamentId
          ? _value.tournamentId
          : tournamentId // ignore: cast_nullable_to_non_nullable
              as String,
      round: null == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as int,
      player1Id: null == player1Id
          ? _value.player1Id
          : player1Id // ignore: cast_nullable_to_non_nullable
              as String,
      player2Id: freezed == player2Id
          ? _value.player2Id
          : player2Id // ignore: cast_nullable_to_non_nullable
              as String?,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as MatchResult,
      reportedBy: freezed == reportedBy
          ? _value.reportedBy
          : reportedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reportedAt: freezed == reportedAt
          ? _value.reportedAt
          : reportedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchImplCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$$MatchImplCopyWith(
          _$MatchImpl value, $Res Function(_$MatchImpl) then) =
      __$$MatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tournamentId,
      int round,
      String player1Id,
      String? player2Id,
      MatchResult result,
      String? reportedBy,
      @TimestampConverter() DateTime? reportedAt});
}

/// @nodoc
class __$$MatchImplCopyWithImpl<$Res>
    extends _$MatchCopyWithImpl<$Res, _$MatchImpl>
    implements _$$MatchImplCopyWith<$Res> {
  __$$MatchImplCopyWithImpl(
      _$MatchImpl _value, $Res Function(_$MatchImpl) _then)
      : super(_value, _then);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? round = null,
    Object? player1Id = null,
    Object? player2Id = freezed,
    Object? result = null,
    Object? reportedBy = freezed,
    Object? reportedAt = freezed,
  }) {
    return _then(_$MatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tournamentId: null == tournamentId
          ? _value.tournamentId
          : tournamentId // ignore: cast_nullable_to_non_nullable
              as String,
      round: null == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as int,
      player1Id: null == player1Id
          ? _value.player1Id
          : player1Id // ignore: cast_nullable_to_non_nullable
              as String,
      player2Id: freezed == player2Id
          ? _value.player2Id
          : player2Id // ignore: cast_nullable_to_non_nullable
              as String?,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as MatchResult,
      reportedBy: freezed == reportedBy
          ? _value.reportedBy
          : reportedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reportedAt: freezed == reportedAt
          ? _value.reportedAt
          : reportedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchImpl implements _Match {
  const _$MatchImpl(
      {required this.id,
      required this.tournamentId,
      required this.round,
      required this.player1Id,
      this.player2Id,
      this.result = MatchResult.pending,
      this.reportedBy,
      @TimestampConverter() this.reportedAt});

  factory _$MatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchImplFromJson(json);

  @override
  final String id;
  @override
  final String tournamentId;
  @override
  final int round;
  @override
  final String player1Id;
  @override
  final String? player2Id;
// null の場合は不戦勝
  @override
  @JsonKey()
  final MatchResult result;
  @override
  final String? reportedBy;
  @override
  @TimestampConverter()
  final DateTime? reportedAt;

  @override
  String toString() {
    return 'Match(id: $id, tournamentId: $tournamentId, round: $round, player1Id: $player1Id, player2Id: $player2Id, result: $result, reportedBy: $reportedBy, reportedAt: $reportedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tournamentId, tournamentId) ||
                other.tournamentId == tournamentId) &&
            (identical(other.round, round) || other.round == round) &&
            (identical(other.player1Id, player1Id) ||
                other.player1Id == player1Id) &&
            (identical(other.player2Id, player2Id) ||
                other.player2Id == player2Id) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.reportedBy, reportedBy) ||
                other.reportedBy == reportedBy) &&
            (identical(other.reportedAt, reportedAt) ||
                other.reportedAt == reportedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, tournamentId, round,
      player1Id, player2Id, result, reportedBy, reportedAt);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      __$$MatchImplCopyWithImpl<_$MatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchImplToJson(
      this,
    );
  }
}

abstract class _Match implements Match {
  const factory _Match(
      {required final String id,
      required final String tournamentId,
      required final int round,
      required final String player1Id,
      final String? player2Id,
      final MatchResult result,
      final String? reportedBy,
      @TimestampConverter() final DateTime? reportedAt}) = _$MatchImpl;

  factory _Match.fromJson(Map<String, dynamic> json) = _$MatchImpl.fromJson;

  @override
  String get id;
  @override
  String get tournamentId;
  @override
  int get round;
  @override
  String get player1Id;
  @override
  String? get player2Id; // null の場合は不戦勝
  @override
  MatchResult get result;
  @override
  String? get reportedBy;
  @override
  @TimestampConverter()
  DateTime? get reportedAt;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
