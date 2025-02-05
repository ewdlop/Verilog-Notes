module usb_interface (
    input clk,                  // System clock
    input rst,                  // Reset signal
    input usb_dp,               // USB Data Line (Single-ended or Differential)
    input usb_dn,               // USB Data Line (Single-ended or Differential)
    output [7:0] data_out,      // Data to be received from USB
    output data_ready,          // Data is ready to be processed
    output data_valid,          // Data is valid for further processing
    input [7:0] data_in,        // Data to be sent to USB
    input send_data             // Trigger signal to send data
);

    // USB core instantiation
    usb_device_controller #(
        .USB_VERSION(2)          // Specify USB version (e.g., USB 2.0)
    ) usb_core (
        .clk(clk),               // Clock input
        .rst(rst),               // Reset signal
        .usb_dp(usb_dp),         // USB Data+ line (single-ended or differential)
        .usb_dn(usb_dn),         // USB Data- line (single-ended or differential)
        .data_out(data_out),     // Data received from USB
        .data_ready(data_ready), // Data received and ready for processing
        .data_valid(data_valid), // Data valid flag
        .data_in(data_in),       // Data to be sent to USB
        .send_data(send_data)    // Trigger to send data to USB
    );

endmodule
