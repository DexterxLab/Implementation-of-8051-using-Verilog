module Register_File(
    input clk,
    input write_en,
    input [1:0] bank_sel,
    input [2:0] read_addr_1, read_addr_2,
    input [4:0] write_addr,
    input [7:0] write_data,
    output [7:0] read_data_1, read_data_2
);

    reg [7:0] working_register [0:31];
    
    reg [7:0] accumulator;
    // assign read_data_1 = register[read_addr_1];
    // assign read_data_2 = register[read_addr_2];
    // Combinational logic - happens instantly
    wire [4:0] phys_addr_1 = {bank_sel, read_addr_1};
    wire [4:0] phys_addr_2 = {bank_sel, read_addr_2};

    // Read logic
    assign read_data_1 = working_reg[phys_addr_1];
    assign read_data_2 = working_reg[phys_addr_2];
    always @(posedge clk) begin
        if (write_en) begin
            working_register[write_addr] <= write_data;
        end
    end

endmodule