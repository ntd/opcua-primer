# Run with GNU make.
#
# `docker` and `open62541` must be already installed properly. Remember
# to include `nodeset_compiler.py` in PATH or to explicitly specify it
# (e.g. `make NODESETCOMPILER=/path/to/nodeset_compiler.py`).
#
# - `make` builds the OPC-UA server
# - `make clean` removes previous builds
# - `make check` validates the model design XML
#
# This is what I see on my system (ArchLinux) after a successful build:
# ```
# $ make
# docker run -u 1000:100 --mount type=bind,source=/home/nicola/sandbox/opcua-primer,target=/data --rm -it -w /data ghcr.io/opcfoundation/ua-modelcompiler:latest compile -d2 OpcTestModel.xml -cg compiled/OpcTestModel.csv -o2 compiled/
# nodeset_compiler.py -e deps/Opc.Ua.NodeSet2.xml -x compiled/OpcTestModel.NodeSet2.xml OpcTestModel
# INFO:__main__:Preprocessing (existing) deps/Opc.Ua.NodeSet2.xml
# INFO:__main__:Preprocessing compiled/OpcTestModel.NodeSet2.xml
# INFO:__main__:Generating Code for Backend: open62541
# INFO:__main__:NodeSet generation code successfully printed
# gcc -o server server.c OpcTestModel.c $(pkg-config --cflags --libs open62541)
# ```


# Docker image to use
IMAGE = ghcr.io/opcfoundation/ua-modelcompiler:latest

# Docker Working Directory
DWD = /data

PKGCONFIG = pkg-config
XMLLINT = xmllint
MODELCOMPILER = docker run -u $(shell id -u):$(shell id -g) --mount type=bind,source=$(CURDIR),target=$(DWD) --rm -it -w $(DWD) $(IMAGE) compile
NODESETCOMPILER = nodeset_compiler.py


all: server

server: server.c OpcTestModel.c OpcTestModel.h
	gcc -o server server.c OpcTestModel.c $$($(PKGCONFIG) --cflags --libs open62541)

clean:
	-rm -fr compiled/ OpcTestModel.c OpcTestModel.h server

check: check-model

check-model: OpcTestModel.xml
	@$(XMLLINT) --noout --schema 'deps/UA Model Design.xsd' $<

compiled/OpcTestModel.csv compiled/OpcTestModel.NodeSet2.xml &: OpcTestModel.xml
	@-mkdir -p compiled
	$(MODELCOMPILER) -d2 $< -cg compiled/OpcTestModel.csv -o2 compiled/

OpcTestModel.c OpcTestModel.h &: compiled/OpcTestModel.NodeSet2.xml
	$(NODESETCOMPILER) -e deps/Opc.Ua.NodeSet2.xml -x $< OpcTestModel


nodeset: compiled/OpcTestModel.NodeSet2.xml

.phony: all clean check check-model
