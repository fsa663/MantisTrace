# MantisTrace
<img width="150" height="150" alt="MantisTrace" src="https://github.com/user-attachments/assets/ac49af58-028d-4a14-b050-560f0a50c671" />

Open-source ray tracing code in MATLAB/Octave. It is now relaunched with new features and a clear roadmap.

<b>Current Features:</b>
* API for easy use
* 3D ray tracing and display (vectorized, efficient plotting)
* Thick lenses with support for **aspherical surfaces** and spherical aberrations
* Off-axis components and ray bundles
* Improved 3D visualization with clearer surfaces and bundles
* Back Focal Length and Circle of Least Confusion calculation
* No toolboxes or non-core MATLAB/Octave packages required
* Simple example scripts
<br>

The code has been tested on Octave 5.2 and 10.2. It is theoretically compatible with MATLAB R2017+.

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
- Chromatic aberration simulation (multi-wavelength rays and spot diagrams)
- Mini material library
- GUI v0.1 (longitudinal layout with optional 3D pop-out)
- Improved lens visualization in 3D and 2D

<b>Code Preview:</b>

In designs folder: You define the scene file (optical components and Sensor) 

In Main.m: You define the ray source and the computation parameters


