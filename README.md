# MarimbaserrantesSuperCollider


Marimbas Errantes Performance and Technical
Documentation
Nehemias Alvarado
January 7, 2025
Analysis:
This piece was created with SuperCollider, blending live sound processing and generative composition. The main components consist of custom SynthDefs for instruments such as blip, reverb, and
bpfsaw, which generate sound through synthesizers and filters.

Live Performance:
Instruments: Synthesized sounds processed in real time, including marimba-like tones and
noise-based textures.
Sound Generation: Use the custom SynthDef(bpfsaw) for marimba sounds and other evolving
textures.
Effects: Reverb, distortion, and dynamic manipulation with real-time adjustments.
Score: Marimba Loop (Synth: blip) Performers will initiate loops that vary in frequency and
duration. These vary in pitch from a 300 Hz base upwards, with random adjustments.
Marimba Variations (Synth: bpfsaw) Dynamic pitch modulation, using Pbind to set random
note values, pan settings, and filter frequencies.
Sound Layering (Synth: multi) Layer multiple sounds using noise-based effects, producing
rich sound textures to be played in sequence.
Technical Documentation (Code Analysis):
Synth Definitions: Custom SuperCollider SynthDefs for sound generation and processing,
including basic tones (sine waves) and more complex effects (filters and delays).
Marimba Sounds: Generated using bpfsaw with modulation of parameters like cfmin, cfmax,
freq, rqmin, and rqmax. Multiple layers of marimba-like sounds are played in parallel for a rich,
textural effect.

Sound Processing: Real-time effects (e.g., Reverb, FreeVerb) are applied to manipulate the
audio dynamically, adding depth and space to the performance.
Performer Instructions:
Live Manipulation: Performers can adjust the intensity and density of the sound through real-time
control of the synthesizer’s parameters.
Performance Notes: The performer should focus on blending acoustic-like marimba sounds
with processed electronic effects, building evolving layers of sound and texture.
Engage with both fixed and real-time elements of the piece to add variety and expression to the
performance.
SynthDef/ blip:


![blip](https://github.com/user-attachments/assets/910d7a19-0399-4feb-938b-f0c7e0bd3511)
