# MantisTrace

Open-source ray tracing code in MATLAB/Octave. It is now relaunched with new features and a clear roadmap.

<b>Current Features:</b>
* 3D ray tracing and display (vectorized, efficient plotting)
* Thick lenses with support for **aspherical surfaces** and spherical aberrations
* Off-axis components and ray bundles
* Improved 3D visualization with clearer surfaces and bundles
* Back Focal Length and Circle of Least Confusion calculation
* Simple example scripts
<br>

The code has been tested on Octave 10.2. MATLAB friendly version (soon)

<p align="center">
  <img src="https://user-images.githubusercontent.com/49459541/95596533-2dfdb900-0a56-11eb-8c9b-fac2d2208e8e.PNG" width="350" title="3D Ray Tracing">
  <img src="https://user-images.githubusercontent.com/49459541/95596560-3524c700-0a56-11eb-9576-c322b56f469a.PNG" width="350" title="2D Ray Tracing">
  <img src="https://user-images.githubusercontent.com/49459541/95596548-3229d680-0a56-11eb-94b2-8dfd42ab4519.PNG" width="350" title="Spot Plotting">
</p>


## 🚧 Gaps (Not Yet Supported)
- Polarization effects  
- Chromatic aberrations & dispersion  
- Interference / diffraction  
- Lens/material libraries
<br>

## 🛠 Roadmap
- Free sensor placement (not limited to axis-aligned planes)
- MATLAB-friendly packaging for easier use
- Chromatic aberration simulation (multi-wavelength rays and spot diagrams)
- Mini material library
- GUI v0.1 (longitudinal layout with optional 3D pop-out)

<b>Code Preview:</b>

In designs folder: You define the scene file (optical components and Sensor) 

In Main.m: You define the ray source and the computation parameters


