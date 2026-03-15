import 'dart:convert';
import 'dart:developer';

/// Safely attempts to decode [source] as JSON.
///
/// Returns `null` if [source] is:
/// - null or empty
/// - not JSON-shaped (doesn't start with `{` or `[`)
/// - malformed JSON
///
/// This prevents [FormatException] crashes when the server returns
/// plain text like "Not Found" instead of JSON.
dynamic safeJsonDecode(String? source) {
  if (source == null || source.trim().isEmpty) return null;

  final trimmed = source.trim();

  // Quick check: JSON must start with { or [
  if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) {
    log('safeJsonDecode: Response is not JSON: "${trimmed.length > 100 ? trimmed.substring(0, 100) : trimmed}"');
    return null;
  }

  try {
    return json.decode(trimmed);
  } on FormatException catch (e) {
    log('safeJsonDecode: FormatException: $e');
    return null;
  }
}
