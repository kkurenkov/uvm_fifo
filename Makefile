#|-----------------------------------------------
#| Makefile for SCFIFO verification
#| Author: Kurenkov Konstantin krendkrend@gmail.com
#|-----------------------------------------------

export VE_HOME ?= $(shell pwd)

GUI ?= 0
UVM_VERB ?= UVM_MEDIUM
TBENCH_NAME ?=tb_top

TOOL = irun
TOOL_OPTS  = -64bit
TOOL_OPTS += -l $@.log
TOOL_OPTS += -v93
TOOL_OPTS += -relax
TOOL_OPTS += -namemap_mixgen
TOOL_OPTS += -sv
TOOL_OPTS += -timescale 1ns/1ns
TOOL_OPTS += -bb_sigsize 40000
TOOL_OPTS += -disable_sem2009
TOOL_OPTS += -libext .v
TOOL_OPTS += -libext .sv
TOOL_OPTS += -nowarn CUVIHR
TOOL_OPTS += -pathpulse
TOOL_OPTS += -vtimescale 1ns/1ns
TOOL_OPTS += -access +rwc
TOOL_OPTS += -warn_multiple_driver

#################################
# Define AW and DW
TOOL_OPTS += -define DW=32
TOOL_OPTS += -define AW=4
#################################

UVM_OPTS  = -uvmhome CDNS-1.2
UVM_OPTS  += +UVM_NO_RELNOTES
UVM_OPTS  += +UVM_VERBOSITY=${UVM_VERB}

GUI_OPTS  = -gui
GUI_OPTS += -mcdump
GUI_OPTS += -linedebug

ifeq ($(GUI), 0)
	ENGUI=
else
	ENGUI= $(GUI_OPTS)
endif

SOURCE_LIST +=	-f $(VE_HOME)/example/tb_uvm_files.f

default: help

help:
	@echo -e "|------------------------------------------------------------------------"
	@echo -e "| RTL code FIFO repo by Olof Kindgren       github.com/olofk"
	@echo -e "| RTL code FIFO repo by Stefan Kristiansson github.com/skristiansson"
	@echo -e "| UVM Verif Example  by Kurenkov Konstantin github.com/kkurenkov"
	@echo -e "| Examples:"
	@echo -e "| make <testname> [GUI=1]"
	@echo -e "|------------------------------------------------------------------------"
	@echo -e "| Available list of tests:"
	@echo -e "|--------------------------------------------------"
	@echo -e "| 1. UVM TESTS:"
	@echo -e "| 1.1  base_test"
	@echo -e "| 1.2  simple_test"
	@echo -e "| 1.3  random_test"
	@echo -e "| 1.4  error_test"
	@echo -e "|--------------------------------------------------"

create_dir:
	rm -rf work
	mkdir work

base_test: create_dir
	cd ./work && ${TOOL} $(TOOL_OPTS) $(UVM_OPTS) ${ENGUI} ${SOURCE_LIST} +UVM_TESTNAME=kvt_scfifo_base_test

simple_test: create_dir
	cd ./work && ${TOOL} $(TOOL_OPTS) $(UVM_OPTS) ${ENGUI} ${SOURCE_LIST} +UVM_TESTNAME=kvt_scfifo_simple_test

random_test: create_dir
	cd ./work && ${TOOL} $(TOOL_OPTS) $(UVM_OPTS) ${ENGUI} ${SOURCE_LIST} +UVM_TESTNAME=kvt_scfifo_random_test

error_test: create_dir
	cd ./work && ${TOOL} $(TOOL_OPTS) $(UVM_OPTS) ${ENGUI} ${SOURCE_LIST} +UVM_TESTNAME=kvt_scfifo_with_error_test

clean:
	@rm -rf *run*
	@rm -rf *.cmd*
	@rm -rf *.log*
	@rm -rf INCA*
	@rm -rf xcelium.d/
	@rm -rf .si*
	@rm -rf waves*
	@rm -rf *history
	@rm -rf *.diag
	@rm -rf list_log
	@rm -rf ../logs/*
	@rm -rf work