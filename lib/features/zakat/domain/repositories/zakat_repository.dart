import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/zakat_summary.dart';

abstract class ZakatRepository {
  Future<Either<Failure, ZakatSummary>> getSummary();
}
