import re
import unicodedata

class PersianNormalizer:
    """
    Persian Text Normalizer.
    Handles character unification (Arabic Yeh/Kaf to Persian), ZWNJ (نیم‌فاصله \u200c),
    diacritics/tashkeel stripping, and numeral conversion between Persian/Arabic and Latin digits.
    """

    # Diacritics regex (Tashkeel)
    DIACRITICS_REGEX = re.compile(r'[\u0610-\u061a\u064b-\u065e\u0670\u06d6-\u06dc\u06df-\u06e8\u06ea-\u06ed]')

    # Digits mappings
    FA_DIGITS = "۰۱۲۳۴۵۶۷۸۹"
    AR_DIGITS = "٠١٢٣٤٥٦٧٨٩"
    EN_DIGITS = "0123456789"

    FA_TO_EN_MAP = str.maketrans(FA_DIGITS + AR_DIGITS, EN_DIGITS * 2)
    EN_TO_FA_MAP = str.maketrans(EN_DIGITS, FA_DIGITS)

    # Character Unification Map
    CHAR_MAP = {
        '\u064a': '\u06cc',  # Arabic Yeh (ي) -> Persian Yeh (ی)
        '\u0649': '\u06cc',  # Alef Maksura (ى) -> Persian Yeh (ی)
        '\u0643': '\u06a9',  # Arabic Kaf (ك) -> Persian Kaf (ک)
        '\u06c0': '\u0647',  # Heh with Yeh above (ۀ) -> Heh (ه)
        '\u0671': '\u0627',  # Alef Wasla (ٱ) -> Alef (ا)
        '\u0624': '\u0648',  # Waw with Hamza -> Waw
        '\u0626': '\u06cc',  # Yeh with Hamza -> Yeh
    }

    CHAR_TRANS = str.maketrans(CHAR_MAP)

    @classmethod
    def convert_digits_to_en(cls, text: str) -> str:
        """Convert Persian and Arabic numerals (۰-۹, ٠-٩) to English numerals (0-9)."""
        if not text:
            return text
        return text.translate(cls.FA_TO_EN_MAP)

    @classmethod
    def convert_digits_to_fa(cls, text: str) -> str:
        """Convert English numerals (0-9) to Persian numerals (۰-۹)."""
        if not text:
            return text
        return text.translate(cls.EN_TO_FA_MAP)

    @classmethod
    def strip_diacritics(cls, text: str) -> str:
        """Remove Arabic/Persian diacritics (tashkeel, erab)."""
        if not text:
            return text
        return cls.DIACRITICS_REGEX.sub('', text)

    @classmethod
    def normalize_zwnj(cls, text: str) -> str:
        """Standardize Zero-Width Non-Joiner (ZWNJ / نیم‌فاصله \u200c)."""
        if not text:
            return text
        # Remove multiple consecutive ZWNJs
        text = re.sub(r'\u200c+', '\u200c', text)
        # If ZWNJ has spaces on both sides, replace with a single space
        text = re.sub(r'\s+\u200c\s+', ' ', text)
        # Remove space adjacent to ZWNJ
        text = re.sub(r'\s+\u200c', '\u200c', text)
        text = re.sub(r'\u200c\s+', '\u200c', text)
        # Remove ZWNJ at start or end of text
        text = re.sub(r'^\u200c|\u200c$', '', text)
        return text

    @classmethod
    def normalize(cls, text: str, remove_diacritics: bool = True, convert_digits: bool = True) -> str:
        """
        Full Persian text normalization pipeline.
        Unifies character variants, cleans ZWNJ, strips diacritics, and normalizes digits.
        """
        if not text:
            return ""

        # Unicode normalization
        text = unicodedata.normalize("NFC", text)

        # Character unification (Yeh / Kaf)
        text = text.translate(cls.CHAR_TRANS)

        # Remove diacritics if requested
        if remove_diacritics:
            text = cls.strip_diacritics(text)

        # Normalize ZWNJ
        text = cls.normalize_zwnj(text)

        # Convert digits to English numbers for uniform indexing if requested
        if convert_digits:
            text = cls.convert_digits_to_en(text)

        # Trim extra whitespace
        text = re.sub(r'\s+', ' ', text).strip()

        return text


class EnglishNormalizer:
    """
    English Text Normalizer.
    Trims, lowercases, cleans smart quotes, and normalizes whitespace.
    """

    QUOTE_MAP = str.maketrans({
        '“': '"',
        '”': '"',
        '‘': "'",
        '’': "'",
        '—': '-',
        '–': '-'
    })

    @classmethod
    def normalize(cls, text: str, lowercase: bool = True) -> str:
        if not text:
            return ""

        text = text.translate(cls.QUOTE_MAP)
        if lowercase:
            text = text.lower()

        text = re.sub(r'\s+', ' ', text).strip()
        return text


class ArabicNormalizer:
    """
    Arabic Text Normalizer for Quranic text processing.
    """

    DIACRITICS_REGEX = re.compile(r'[\u0610-\u061a\u064b-\u065e\u0670\u06d6-\u06dc\u06df-\u06e8\u06ea-\u06ed]')

    @classmethod
    def strip_tashkeel(cls, text: str) -> str:
        if not text:
            return ""
        # Remove diacritics
        clean = cls.DIACRITICS_REGEX.sub('', text)
        # Normalize Alefs
        clean = re.sub(r'[\u0622\u0623\u0625\u0671]', '\u0627', clean)
        return clean.strip()
