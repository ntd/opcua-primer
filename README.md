It seems the sanest way (from a human perspective) for modelling an OPC-UA
server is to create a (relatively) simple XML file describing data and
relations (the ["model design"](http://opcfoundation.org/UA/ModelDesign.xsd)),
converting it into another more machine oriented XML file
(the [NodeSet2](http://opcfoundation.org/UA/2011/03/UANodeSet.xsd) format) and
then generating the C code to be linked against other server code.

Conversion from model design to NodeSet2 is performed by
(UA-ModelCompiler)[https://github.com/OPCFoundation/UA-ModelCompiler],
officially supported by the OPC foundation, while the generation of the C code
from the NodeSet2 file is performed by `nodeset_compiler.py`, a Python script
provided by the [Open62541](https://github.com/open62541/open62541) project.

While `nodeset_compiler.py`, apart from including it in PATH, does not require
any particular handling, the UA-ModelCompiler is strongly geared towards
Windows/DotNet platforms and it is generally quite unpleasant to use. Compiling
model designs on GNU/Linux systems is, mildly put, a nightmare.

The only documentation I found is the [OPC-UA information model
tutorial](https://opcua.rocks/from-modelling-to-execution-opc-ua-information-model-tutorial/),
which provides a strong foundation for understanding the whole process but the
commands reported there simply do not work.

Here I use `docker` to mitigate these issues: see the `Makefile` for the
details.

The model design used in this example is an adaptation of the model from the
[excellent tutorial](https://youtu.be/gxA7SDNLHgc) by Industry40tv.
