exec xvlog base.v
exec xvlog tb/base_tb.v
exec xelab base_tb -debug typical
xsim work.base_tb -view ../../base_tb_behav.wcfg
run 500 ns
