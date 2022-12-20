It seems the sanest way (from a human perspective) of modelling an OPC-UA
server is to create a (relatively) simple XML file describing data and
relations (the ["model design"](http://opcfoundation.org/UA/ModelDesign.xsd)
format), convert it into another more machine-oriented XML file (the
[NodeSet2](http://opcfoundation.org/UA/2011/03/UANodeSet.xsd)) and then
generate the C source code to be linked against other server code.

The conversion from model design to NodeSet2 is performed by
[UA-ModelCompiler](https://github.com/OPCFoundation/UA-ModelCompiler), a tool
officially supported by the OPC foundation, while the generation of the C code
from NodeSet2 is performed by `nodeset_compiler.py`, a Python script provided
by the [Open62541](https://github.com/open62541/open62541) project.

While `nodeset_compiler.py`, apart from including it in PATH, does not require
any particular attention, the UA-ModelCompiler is strongly geared towards
Windows/DotNet platforms and it is in general quite unpleasant to work with.
In other words, compiling model designs on GNU/Linux systems is a nightmare.

The only documentation I found is the
[OPC-UA information model tutorial](https://opcua.rocks/from-modelling-to-execution-opc-ua-information-model-tutorial/),
which provides a strong foundation for understanding the whole process but the
commands reported there for converting the model design simply do not work.

After a lot of trials and errors, I came up with a solution based on `docker`
that does not require building and installing `UA-ModelCompiler` natively.
See the `Makefile` for the gory details.

The model design used by this project is an adaptation of the model from the
[excellent tutorial](https://youtu.be/gxA7SDNLHgc) by Industry40tv.
