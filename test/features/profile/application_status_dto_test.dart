import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/profile/data/models/application_status_dto.dart';

void main() {
  test('reads the documented /me/application fields', () {
    final dto = ApplicationStatusDto.fromJson({
      'id': '55',
      'fullName': 'Amina Hassen',
      'beneficiaryCategory': 'poor',
      'verificationStatus': 'rejected',
      'verificationReason': 'Document unreadable',
      'hasProfilePicture': false,
      'caseStatus': 'SUBMITTED',
    });
    expect(dto.verificationStatus, 'rejected');
    expect(dto.verificationReason, 'Document unreadable');
    expect(dto.caseStatus, 'SUBMITTED');
    expect(dto.beneficiaryCategory, 'poor');
  });

  test('absent fields stay null', () {
    final dto = ApplicationStatusDto.fromJson({
      'verificationStatus': 'pending',
    });
    expect(dto.verificationReason, isNull);
    expect(dto.caseStatus, isNull);
  });
}
