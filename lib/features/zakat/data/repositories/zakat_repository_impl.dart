import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/zakat_summary.dart';
import '../../domain/repositories/zakat_repository.dart';
import '../datasources/remote/zakat_remote_datasource.dart';

@LazySingleton(as: ZakatRepository)
class ZakatRepositoryImpl implements ZakatRepository {
  ZakatRepositoryImpl(this._remote);

  final ZakatRemoteDataSource _remote;

  @override
  Future<Either<Failure, ZakatSummary>> getSummary() async {
    try {
      final json = await _remote.fetchSummary();
      return Right(
        ZakatSummary(
          id: json['id'] as String? ?? '',
          amount: (json['amount'] as num?)?.toDouble() ?? 0,
          currency: json['currency'] as String? ?? '',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
