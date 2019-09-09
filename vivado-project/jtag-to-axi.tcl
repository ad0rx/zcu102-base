variable GPIO_BASE     80000000
variable UART_BASE     80001000
variable UART_TX       $UART_BASE+4

variable TIMER_BASE    80002000
variable TIMER_CONTROL $TIMER_BASE+0
variable TIMER_COUNTER $TIMER_BASE+8


create_hw_axi_txn write_gpio_txn [get_hw_axis hw_axi_1] -type WRITE -address $GPIO_BASE -data {00000055} -force
run_hw_axi write_gpio_txn

create_hw_axi_txn write_gpio_txn [get_hw_axis hw_axi_1] -type WRITE -address $GPIO_BASE -data {000000AA} -force
run_hw_axi write_gpio_txn

#create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -size 8 -data {00000055} -force

#create_hw_axi_txn read_timer_txn [get_hw_axis hw_axi_1] -type read -address $TIMER_BASE -size 32 -force
#run_hw_axi read_timer_txn
