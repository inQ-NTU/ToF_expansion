# ToF_expansion
A minimal code to simulate interference pattern data acquisition and relative phase extraction of a two parallel one-dimensional Bose gas in time-of-flight experiments. In particular, this code takes into account longitudinal expansion and mixing with common degrees of freedom (see Ref. [1]). This code requires "Statistics and Machine Learning Toolbox" and "Optimization Toolbox". 

The directory is structured as follows: <br />
├── classes &emsp;&emsp;            # main classes  <br />
├── examples &emsp;                 # minimal examples <br />
├── results  &emsp;&emsp;&nbsp;     # more complex use cases for generating results in the paper <br />
├── input    &emsp;&ensp;&emsp;&nbsp;     # input files needed for examples and results <br />
└── README.md <br />

The structure of the classes is shown in the diagram below. The red vertical lines represent inheritance and the blue lines represent simulation workflow.  <br/>
![class_structure](classes/class_structure.png)

## References
[1] van Nieuwkerk, Y. D., Schmiedmayer, J., & Essler, F. (2018). Projective phase measurements in one-dimensional Bose gases. SciPost Physics, 5(5), 046.
