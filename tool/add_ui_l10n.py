"""Add shared UI strings to all app_*.arb files with machine translation."""
from __future__ import annotations

import json
import re
import time
from pathlib import Path

from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parents[1]
L10N = ROOT / 'lib' / 'l10n'

LOCALES = {'am': 'am', 'ar': 'ar', 'om': 'om', 'so': 'so'}

KEEP_LITERAL = {
    'regRegistrationCodeHint',
    'regPhoneHint',
    'loginNewToBaraka',
}

PLACEHOLDER_RE = re.compile(r'(\{[^{}]+\})')


def protect(text: str) -> tuple[str, list[str]]:
    tokens: list[str] = []

    def repl(m: re.Match[str]) -> str:
        tokens.append(m.group(1))
        return f'__PH_{len(tokens) - 1}__'

    return PLACEHOLDER_RE.sub(repl, text), tokens


def restore(text: str, tokens: list[str]) -> str:
    for i, token in enumerate(tokens):
        text = text.replace(f'__PH_{i}__', token)
    return text


def translate(text: str, target: str, translator: GoogleTranslator) -> str:
    if not text.strip() or text in KEEP_LITERAL:
        return text
    protected, tokens = protect(text)
    for attempt in range(3):
        try:
            return restore(translator.translate(protected), tokens)
        except Exception:
            time.sleep(1.0 * (attempt + 1))
    return text


EN_STRINGS: dict[str, str] = {
    'changeAppModeTooltip': 'Change mode',
    'switchedToAwqafMode': 'Switched to Awqaf mode',
    'switchToAwqaf': 'Switch to Awqaf',
    'switchedToZakatMode': 'Switched to Zakat mode',
    'switchToZakat': 'Switch to Zakat',
    'navAwqaf': 'Awqaf',
    'loginForgotPassword': 'Forgot password?',
    'loginForgotPasswordComingSoon': 'Forgot password coming soon',
    'loginNewToBaraka': 'New to Baraka? ',
    'loginCreateAccount': 'Create an account',
    'loginCreateAccountComingSoon': 'Create account coming soon',
    'profileDisbursementIntro': 'Choose where you want to receive disbursements.',
    'profileCoopAccountLabel': 'Coop Bank Account Number',
    'profileCoopAccountHint': 'Enter your account number',
    'profileCoopAccountRequired': 'Please enter your Coop Bank account number.',
    'profileSaveAccount': 'Save Account',
    'faydaIdentityVerification': 'Identity verification',
    'commonBack': 'Back',
    'commonContinue': 'Continue',
    'commonFinish': 'Finish',
    'commonTakePhoto': 'Take Photo',
    'commonChooseGallery': 'Choose from Gallery',
    'commonChooseFile': 'Choose File',
    'regTitle': 'Beneficiary Registration',
    'regMethodFastTrack': 'Fast-Track with Fayda',
    'regMethodManual': 'Manual Registration',
    'regMethodInstitution': 'Institution Registration',
    'regMethodFastTrackDesc': 'Securely verify identity with National ID and continue in minutes.',
    'regMethodManualDesc': 'Share your information and supporting details for trusted review.',
    'regMethodInstitutionDesc': 'Register your organization and submit required compliance documents.',
    'regSecureIdentityTitle': 'Secure Identity Verification',
    'regChooseMethodSubtitle': 'Choose your preferred registration method to begin your journey.',
    'regFastTrackFaydaTitle': 'Fast-Track with National ID (Fayda)',
    'regFastTrackFaydaSubtitle': 'Authenticate using your national digital ID.',
    'regManualTitle': 'Manual Registration',
    'regManualSubtitle': 'Upload supporting documentation for review.',
    'regInstitutionCardTitle': 'Register as Institution',
    'regInstitutionCardSubtitle': 'Company, NGO, cooperative, or government entity.',
    'regRegistrationCodeLabel': 'Registration code',
    'regRegistrationCodeHint': 'EZW-A1B2-C3D4',
    'regEncryptedPrivate': 'Encrypted & Private',
    'regEncryptedPrivateBody': 'Your data is secured and handled in line with privacy standards.',
    'regVerificationInterrupted': 'Verification interrupted',
    'regReopenVerification': 'Reopen verification',
    'regRetryListening': 'Retry listening',
    'regCameraPermissionError': 'Could not open camera/gallery. Please check permissions.',
    'regSelectBirthdate': 'Select birthdate',
    'regManualIdentityTitle': 'Manual Identity Registration',
    'regFirstName': 'First Name',
    'regLastName': 'Last Name',
    'regGrandfatherName': "Grandfather's Name",
    'regPhoneNumber': 'Phone Number',
    'regPhoneHint': '+251911223344 or 0911223344',
    'regEmail': 'Email',
    'regGender': 'Gender',
    'regMale': 'Male',
    'regFemale': 'Female',
    'regBeneficiaryCategory': 'Beneficiary Category',
    'regNotes': 'Notes',
    'regNotesHint': 'e.g. Zakat support applicant',
    'regUploadProfilePicture': 'Upload Profile Picture',
    'regVerifyingFaydaBanner': 'Verifying with Fayda… Complete verification in the browser when it opens.',
    'regNeedsAssessment': 'Needs Assessment',
    'regSituationLabel': 'Describe your current situation',
    'regSituationHint': 'Explain hardship, dependents, and urgent needs...',
    'regUploadProof': 'Upload Proof',
    'regDisbursementSetup': 'Disbursement Setup',
    'regTelebirrTitle': 'Telebirr Wallet',
    'regTelebirrSubtitle': 'Instant mobile money transfer',
    'regMpesaTitle': 'M-Pesa',
    'regMpesaSubtitle': 'Secure mobile payment network',
    'regCoopbankTitle': 'Coopbank Account',
    'regCoopbankSubtitle': 'Direct bank deposit',
    'regAccountOrMobile': 'Account or Mobile Number',
    'regFullLegalName': 'Full Legal Name',
    'regAgreementTitle': 'Agreement & Sharia Compliance',
    'regAgreementBody': 'I declare information is truthful and will use aid according to policy.',
    'regInstitutionRegistration': 'Institution Registration',
    'regInstitutionType': 'Institution Type',
    'regLegalName': 'Legal Name',
    'regTradingName': 'Trading Name',
    'regTradeRegistrationNumber': 'Trade Registration Number',
    'regTin': 'Tax Identification Number (TIN)',
    'regVatOptional': 'VAT Registration Number (optional)',
    'regRegion': 'Region',
    'regCity': 'City',
    'regAddress': 'Address',
    'regNotesOptional': 'Notes (optional)',
    'regAuthorityDocTitle': 'Authority to act document required',
    'regAuthorityDocBody': 'Enable if someone other than a registered signatory submits.',
    'regFilePickError': 'Could not pick file. Please check permissions.',
    'regUploadKycTitle': 'Upload KYC Documents',
    'regUploadKycBody': 'Upload each required document. You can finish once all required documents are uploaded.',
    'regReference': 'Reference: {id}',
    'regNoDocumentsRequired': 'No documents required at this time.',
    'regRequired': 'Required',
    'regOptional': 'Optional',
    'regSelectedFile': 'Selected: {name}',
    'regUploaded': 'Uploaded',
    'regUpload': 'Upload',
    'regCreatePasswordTitle': 'Create Your Password',
    'regCreatePasswordBody': 'Choose a secure password for your account. You will use it to sign in after registration.',
    'regPassword': 'Password',
    'regConfirmPassword': 'Confirm Password',
    'regPasswordRules': 'Password must be at least 8 characters and include uppercase, lowercase, a number, and a special character.',
    'regPasswordSuccess': 'Password set successfully. Welcome to Mejlis Digital Hub.',
    'regInstitutionComplete': 'Institution registration complete. Reference: {id}',
    'regInstitutionCompleteGeneric': 'Institution registration complete.',
    'regCompleteLocal': 'Registration complete. Needs and disbursement details are saved locally.',
    'regContinueWithFayda': 'Continue with Fayda',
    'regVerifyingFayda': 'Verifying with Fayda…',
    'regSubmitContinue': 'Submit & Continue',
    'regSetPasswordContinue': 'Set Password & Continue',
    'regSetPasswordFinish': 'Set Password & Finish',
}


def merge_into_arb(path: Path, strings: dict[str, str]) -> None:
    data = json.loads(path.read_text(encoding='utf-8'))
    for key, value in strings.items():
        data[key] = value
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def main() -> None:
    if not (L10N / 'app_en.arb').read_text(encoding='utf-8').find('regTitle') >= 0:
        merge_into_arb(L10N / 'app_en.arb', EN_STRINGS)
        print(f'added {len(EN_STRINGS)} keys to en')
    else:
        print('en UI keys already present')

    for locale, google_code in LOCALES.items():
        print(f'translating {locale}...')
        translator = GoogleTranslator(source='en', target=google_code)
        translated = {}
        for i, (key, value) in enumerate(EN_STRINGS.items(), start=1):
            if key in KEEP_LITERAL:
                translated[key] = value
            else:
                translated[key] = translate(value, google_code, translator)
            if i % 15 == 0:
                time.sleep(0.3)
        merge_into_arb(L10N / f'app_{locale}.arb', translated)
        print(f'  merged {len(translated)} keys into {locale}')

    print('done')


if __name__ == '__main__':
    main()
