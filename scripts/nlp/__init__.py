"""
NLP Package for Quran Knowledge Platform.
Provides text normalization, diacritics stripping, digit conversion, and character unification
specifically optimized for Persian, Arabic, and English text processing.
"""
from .normalizer import PersianNormalizer, EnglishNormalizer, ArabicNormalizer

__all__ = ["PersianNormalizer", "EnglishNormalizer", "ArabicNormalizer"]
