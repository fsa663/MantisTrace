# MantisTrace
<p align="center">
<img width="150" height="150" alt="MantisTrace" src="https://github.com/user-attachments/assets/ac49af58-028d-4a14-b050-560f0a50c671" />
</p>
Open-source ray tracing code in MATLAB/Octave. It is now relaunched with new features and a clear roadmap.

<b>Current Features:</b>
* API for easy use
* 3D ray tracing and display (vectorized, efficient plotting)
* Thick lenses with support for **aspherical surfaces** and spherical aberrations
* Off-axis components and ray bundles
* **Chromatic** Aberrations and Dispersion (beta)
* Mini-Material Library
* Improved 3D visualization with clearer surfaces and bundles
* Back Focal Length and Circle of Least Confusion calculation
* No toolboxes or non-core MATLAB/Octave packages required
* Simple example scripts
<br>


The code has been tested on Octave 5.2 and 10.2. It is theoretically compatible with MATLAB R2017+.
I have started it back in 2020. I am relaunching it now, because I believe it is based on solid algorthmic foundation.

<p align="center">
<img width="350"  alt="2D_Raytrace" src="https://github.com/user-attachments/assets/b72a80c4-21cf-418c-967d-1a8a43c8a53b" />
<img width="350"  alt="3D_raytrace" src="https://github.com/user-attachments/assets/65fcbca5-5c73-49d0-ba2e-a4057625480f" />
<img width="350"  alt="spot_plot" src="https://github.com/user-attachments/assets/4ea5eb81-4abc-41c3-ae41-6d6b567d6044" />

</p>


## 🚧 Gaps (Not Yet Supported)
- Polarization effects  
- Interference / diffraction  
<br>

## 🛠 Roadmap
- Documentation
- Higher Level Api (lenses instead of surfaces)
- Popular Examples
- Free sensor placement (not limited to axis-aligned planes)
- GUI v0.1 (longitudinal layout with optional 3D pop-out)
- Improved lens visualization in 3D and 2D

<b>Code Preview:</b>

In designs folder: You define the scene file (optical components and Sensor) 

In Main.m: You define the ray source and the computation parameters


