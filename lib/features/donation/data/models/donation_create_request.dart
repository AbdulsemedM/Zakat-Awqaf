/// Request body for `POST /api/payments/v1/donations`.
class DonationCreateRequest {
  const DonationCreateRequest({
    required this.donorMode,
    required this.paymentPurpose,
    required this.amountEtb,
    required this.address,
    required this.donor,
  });

  final String donorMode;
  final String paymentPurpose;
  final double amountEtb;
  final DonationAddress address;
  final DonationDonor donor;

  Map<String, dynamic> toJson() => {
        'donorMode': donorMode.trim(),
        'paymentPurpose': paymentPurpose.trim(),
        'amountEtb': amountEtb,
        'address': address.toJson(),
        'donor': donor.toJson(),
      };
}

class DonationAddress {
  const DonationAddress({
    required this.address1,
    this.address2 = '',
    required this.country,
    required this.administrativeArea,
    required this.locality,
    required this.postalCode,
  });

  final String address1;
  final String address2;
  final String country;
  final String administrativeArea;
  final String locality;
  final String postalCode;

  Map<String, dynamic> toJson() => {
        'address1': address1.trim(),
        'address2': address2.trim(),
        'country': country.trim(),
        'administrativeArea': administrativeArea.trim(),
        'locality': locality.trim(),
        'postalCode': postalCode.trim(),
      };
}

class DonationDonor {
  const DonationDonor({
    required this.fullName,
    required this.phone,
    required this.email,
  });

  final String fullName;
  final String phone;
  final String email;

  Map<String, dynamic> toJson() => {
        'fullName': fullName.trim(),
        'phone': phone.trim(),
        'email': email.trim(),
      };
}

enum DonorMode {
  anonymous('ANONYMOUS'),
  identified('IDENTIFIED');

  const DonorMode(this.apiValue);
  final String apiValue;
}
