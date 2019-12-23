#!/bin/bash

#cd src/rtl
xvlog base.v
xvlog tb/base_tb.v

xelab base_tb -debug typical

xsim work.base_tb -view ../../base_tb_behav.wcfg -gui
