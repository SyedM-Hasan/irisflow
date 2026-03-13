Eye Strain Guard: Technical & UI Design Guide
=============================================

This document defines the architecture, data pipeline, and user interface standards for a real-time eye strain detection system using **Flutter** and **Google Genkit**.

System Architecture
-------------------

The feature follows a **Hybrid Edge-Cloud** model to ensure low latency and user privacy.

1.  **Client (Flutter):** Handles high-frequency camera data and extracts geometric features.
    
2.  **Server/Cloud (Genkit):** Analyzes geometric trends to predict psychological and physiological strain levels.
    

The Detection Pipeline
----------------------

### 1\. Data Capture & Extraction (On-Device)

*   **Tool:** google\_mlkit\_face\_detection.
    
*   **Metric:** **Eye Aspect Ratio (EAR)**.
    

$$EAR = \\frac{||p\_2 - p\_6|| + ||p\_3 - p\_5||}{2 ||p\_1 - p\_4||}$$

### 2\. Genkit Orchestration (The Intelligence)

Genkit acts as the "Medical Brain." It doesn't just see data; it interprets **intent**.

*   **Input:** 60-second rolling buffer (Blink rate, EAR stability).
    
*   **Reasoning:** Gemini 1.5 Flash distinguishes between "Focusing" (low blink) and "Fatigue" (droopy eyelids).
    

UI & UX Theme Guidelines
------------------------

The UI should prioritize **"Calm Technology."** Since the user is already experiencing eye strain, the app must not contribute to it with bright colors or aggressive animations.

### 1\. Visual Language & Color Palette

*   **Base Theme:** Force **Dark Mode** or a "Soft Sepia" high-contrast mode when strain is detected.
    
*   **Strain Indicators:**
    
    *    **Low:** Mint Green (Relaxed).
        
    *   **Moderate:** Soft Amber (Caution).
        
    *   **High:** Muted Coral (Action required—avoid bright "Neon Red").
        
*   **Typography:** Use sans-serif fonts with increased line-spacing ($1.5x$) to reduce "crowding" during high-strain periods.
    

### 2\. Core UI Components

**FeatureUI ImplementationBehaviorThe Live Monitor**Micro-overlay or "Status Dot"A small pulse in the corner of the screen. Blue = Active, Red = Blink alert.**Strain Meter**Frosted Glass (Glassmorphism) CardA non-intrusive card that shows "Eye Vitality" percentage.**The "Break" Overlay**Full-screen Blur (BackdropFilter)When High Strain is hit, gently blur the background to force the user to look away.**Calibration View**Guided "Follow the Dot"A setup screen to map the user's "Neutral Eye Openness."

### 3\. Adaptive UI Adjustments (Automation)

When Genkit predicts **Moderate to High Strain**, the Flutter UI should automatically:

*   **Reduce Brightness:** Use a black Opacity layer over the whole app.
    
*   **Warmth Filter:** Increase the yellow tint (Blue light filter).
    
*   **Text Scaling:** Automatically bump textScaleFactor by $10-15\\%$ to reduce squinting.
    

Tech Stack
----------

*   **Frontend:** Flutter (Dart)
    
*   **Camera:** camera + google\_mlkit\_face\_detection
    
*   **Orchestration:** Genkit for Dart
    
*   **LLM:** Gemini 1.5 Flash
    
*   **State Management:** Riverpod (Ideal for streaming real-time EAR data).
    

Implementation Roadmap
----------------------

1.  **Phase 1:** Implement the CameraDetector widget to log EAR values to a Stream.
    
2.  **Phase 2:** Connect the stream to a Genkit flow that triggers every 2 minutes.
    
3.  **Phase 3:** Create the **Adaptive Theme Engine** that reacts to the Genkit strainLevel output.