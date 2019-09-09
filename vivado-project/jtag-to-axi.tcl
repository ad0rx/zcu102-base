variable GPIO_BASE     80000000
variable UART_BASE     80001000
variable UART_TX       [expr $UART_BASE + 4]
variable UART_STATUS   [expr $UART_BASE + 8]


variable TIMER_BASE    80002000
variable TIMER_CONTROL $TIMER_BASE+0
variable TIMER_COUNTER $TIMER_BASE+8

create_hw_axi_txn write_gpio_txn_55 [get_hw_axis hw_axi_1] -type WRITE -address $GPIO_BASE -data {00000055} -force
create_hw_axi_txn write_gpio_txn_AA [get_hw_axis hw_axi_1] -type WRITE -address $GPIO_BASE -data {000000AA} -force
for {set i 0} {$i < 10} {incr i} {

    run_hw_axi write_gpio_txn_55
    run_hw_axi write_gpio_txn_AA

}

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 1 -data {00000048} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 1 -data {00000065} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 1 -data {0000006C} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 1 -data {0000006C} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 1 -data {0000006F} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 1 -data {0000002C} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 1 -data {00000020} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 1 -data {00000057} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 2 -data {0000006F} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 2 -data {00000072} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 2 -data {0000006C} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 2 -data {00000064} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 2 -data {00000021} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 2 -data {0000000D} -force
run_hw_axi write_uart_txn

create_hw_axi_txn write_uart_txn [get_hw_axis hw_axi_1] -type WRITE -address $UART_TX -len 2 -data {0000000A} -force
run_hw_axi write_uart_txn

# At this point, we know the PL is up and working...
#create_hw_axi_txn read_timer_txn [get_hw_axis hw_axi_1] -type read -address $TIMER_BASE -size 32 -force
#run_hw_axi read_timer_txn
