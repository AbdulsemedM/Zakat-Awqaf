// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zakat_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ZakatSummary {
  String get id => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Create a copy of ZakatSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZakatSummaryCopyWith<ZakatSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZakatSummaryCopyWith<$Res> {
  factory $ZakatSummaryCopyWith(
    ZakatSummary value,
    $Res Function(ZakatSummary) then,
  ) = _$ZakatSummaryCopyWithImpl<$Res, ZakatSummary>;
  @useResult
  $Res call({String id, double amount, String currency});
}

/// @nodoc
class _$ZakatSummaryCopyWithImpl<$Res, $Val extends ZakatSummary>
    implements $ZakatSummaryCopyWith<$Res> {
  _$ZakatSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ZakatSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? currency = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ZakatSummaryImplCopyWith<$Res>
    implements $ZakatSummaryCopyWith<$Res> {
  factory _$$ZakatSummaryImplCopyWith(
    _$ZakatSummaryImpl value,
    $Res Function(_$ZakatSummaryImpl) then,
  ) = __$$ZakatSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, double amount, String currency});
}

/// @nodoc
class __$$ZakatSummaryImplCopyWithImpl<$Res>
    extends _$ZakatSummaryCopyWithImpl<$Res, _$ZakatSummaryImpl>
    implements _$$ZakatSummaryImplCopyWith<$Res> {
  __$$ZakatSummaryImplCopyWithImpl(
    _$ZakatSummaryImpl _value,
    $Res Function(_$ZakatSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ZakatSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? currency = null,
  }) {
    return _then(
      _$ZakatSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ZakatSummaryImpl implements _ZakatSummary {
  const _$ZakatSummaryImpl({
    required this.id,
    required this.amount,
    required this.currency,
  });

  @override
  final String id;
  @override
  final double amount;
  @override
  final String currency;

  @override
  String toString() {
    return 'ZakatSummary(id: $id, amount: $amount, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZakatSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, amount, currency);

  /// Create a copy of ZakatSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZakatSummaryImplCopyWith<_$ZakatSummaryImpl> get copyWith =>
      __$$ZakatSummaryImplCopyWithImpl<_$ZakatSummaryImpl>(this, _$identity);
}

abstract class _ZakatSummary implements ZakatSummary {
  const factory _ZakatSummary({
    required final String id,
    required final double amount,
    required final String currency,
  }) = _$ZakatSummaryImpl;

  @override
  String get id;
  @override
  double get amount;
  @override
  String get currency;

  /// Create a copy of ZakatSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZakatSummaryImplCopyWith<_$ZakatSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
