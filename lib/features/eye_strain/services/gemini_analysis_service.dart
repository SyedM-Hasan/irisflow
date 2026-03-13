import 'dart:convert';
import 'dart:math' as math;

import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/eye_strain_state.dart';

class StrainAnalysis {
  final StrainLevel strainLevel;
  final double eyeVitality;
  final String recommendation;

  const StrainAnalysis({
    required this.strainLevel,
    required this.eyeVitality,
    required this.recommendation,
  });
}

/// Sends a 60-second [EarSample] buffer to Gemini 1.5 Flash and returns a
/// structured [StrainAnalysis] with strain level, eye vitality, and advice.
///
/// The API key is read from the compile-time env var GEMINI_API_KEY:
///   flutter run --dart-define=GEMINI_API_KEY=YOUR_KEY
class GeminiAnalysisService {
  GeminiAnalysisService._();

  static final GeminiAnalysisService instance = GeminiAnalysisService._();

  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  GenerativeModel? _model;

  void initialize() {
    if (_apiKey.isEmpty) return;
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.2,
      ),
    );
  }

  /// Analyzes the given buffer and returns a [StrainAnalysis].
  /// Falls back to heuristic analysis if no API key is configured.
  Future<StrainAnalysis> analyze({
    required List<EarSample> buffer,
    required int blinkCount,
    required double neutralEar,
  }) async {
    final metrics = _computeMetrics(
      buffer: buffer,
      blinkCount: blinkCount,
      neutralEar: neutralEar,
    );

    if (_model == null) {
      return _heuristicAnalysis(metrics);
    }

    try {
      return await _geminiAnalysis(metrics);
    } catch (_) {
      return _heuristicAnalysis(metrics);
    }
  }

  // ---------------------------------------------------------------------------

  _Metrics _computeMetrics({
    required List<EarSample> buffer,
    required int blinkCount,
    required double neutralEar,
  }) {
    if (buffer.isEmpty) {
      return _Metrics(
        avgEar: neutralEar,
        earStdDev: 0,
        minEar: neutralEar,
        blinkRate: 15,
        lowEarPct: 0,
      );
    }

    final values = buffer.map((s) => s.average).toList();
    final avg = values.reduce((a, b) => a + b) / values.length;
    final variance =
        values.map((v) => (v - avg) * (v - avg)).reduce((a, b) => a + b) /
            values.length;
    final stdDev = math.sqrt(variance);
    final minEar = values.reduce(math.min);
    final elapsed = buffer.last.timestamp
            .difference(buffer.first.timestamp)
            .inSeconds
            .clamp(1, 120) /
        60.0;
    final blinkRate = blinkCount / elapsed;
    final lowEarCount = values.where((v) => v < 0.25).length;
    final lowEarPct = (lowEarCount / values.length) * 100;

    return _Metrics(
      avgEar: avg,
      earStdDev: stdDev,
      minEar: minEar,
      blinkRate: blinkRate,
      lowEarPct: lowEarPct,
    );
  }

  Future<StrainAnalysis> _geminiAnalysis(_Metrics m) async {
    final prompt = '''
You are an ophthalmology assistant analyzing real-time eye monitoring data.

60-second session metrics:
- Blink rate: ${m.blinkRate.toStringAsFixed(1)} blinks/min (healthy: 15–20)
- Avg eye openness (EAR): ${m.avgEar.toStringAsFixed(3)} (1.0 = fully open)
- EAR stability (std dev): ${m.earStdDev.toStringAsFixed(3)}
- Minimum EAR (deepest blink): ${m.minEar.toStringAsFixed(3)}
- Time with very low EAR (<0.25): ${m.lowEarPct.toStringAsFixed(1)}%

Rules:
- Low blink rate + stable high EAR = deep focus (mild strain)
- Low blink rate + drooping EAR = fatigue (high strain)
- Normal blink rate + stable EAR = healthy

Respond with ONLY valid JSON (no markdown):
{
  "strainLevel": "relaxed" | "moderate" | "high",
  "eyeVitality": <0.0–1.0>,
  "recommendation": "<max 2 actionable sentences>"
}
''';

    final response = await _model!.generateContent([Content.text(prompt)]);
    final text = response.text ?? '';
    final json = jsonDecode(text) as Map<String, dynamic>;

    return StrainAnalysis(
      strainLevel: _parseLevel(json['strainLevel'] as String? ?? 'relaxed'),
      eyeVitality: (json['eyeVitality'] as num?)?.toDouble() ?? 0.8,
      recommendation: json['recommendation'] as String? ??
          'Keep monitoring your eye health.',
    );
  }

  StrainAnalysis _heuristicAnalysis(_Metrics m) {
    StrainLevel level;
    double vitality;
    String recommendation;

    if (m.blinkRate < 8 && m.avgEar < 0.5) {
      level = StrainLevel.high;
      vitality = 0.3 + (m.avgEar * 0.4).clamp(0, 0.3);
      recommendation =
          'High fatigue detected. Take a 5-minute break and look at something 20 feet away. '
          'Try blinking intentionally 10 times to re-lubricate your eyes.';
    } else if (m.blinkRate < 12 || m.avgEar < 0.65) {
      level = StrainLevel.moderate;
      vitality = 0.5 + (m.avgEar * 0.3).clamp(0, 0.3);
      recommendation =
          'Blink rate is below normal — your eyes may be drying out. '
          'Try the 20-20-20 rule: every 20 min, look 20 ft away for 20 seconds.';
    } else {
      level = StrainLevel.relaxed;
      vitality = 0.75 + (m.avgEar * 0.25).clamp(0, 0.25);
      recommendation =
          'Your eye health looks great. Maintain good lighting and keep regular breaks '
          'to sustain this healthy blink rhythm.';
    }

    return StrainAnalysis(
      strainLevel: level,
      eyeVitality: vitality.clamp(0.0, 1.0),
      recommendation: recommendation,
    );
  }

  StrainLevel _parseLevel(String raw) => switch (raw.toLowerCase()) {
        'high' => StrainLevel.high,
        'moderate' => StrainLevel.moderate,
        _ => StrainLevel.relaxed,
      };
}

class _Metrics {
  final double avgEar;
  final double earStdDev;
  final double minEar;
  final double blinkRate;
  final double lowEarPct;

  const _Metrics({
    required this.avgEar,
    required this.earStdDev,
    required this.minEar,
    required this.blinkRate,
    required this.lowEarPct,
  });
}
