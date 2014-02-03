module testbed;

reg input_valid = 0;
wire output_valid;
wire [255:0] H_0, H_out;

sha256_H_0 sha256_H_0 (.H_0(H_0));

sha256_block sha256_block (
    .clk(clk), .rst(rst),
    .H_in(H_0), .M_in(M_sha256_abc),
    .input_valid(input_valid),
    .H_out(H_out),
    .output_valid(output_valid)
);


// the "abc" test vector, padded
wire [511:0] M_sha256_abc = {
  256'h6162638000000000000000000000000000000000000000000000000000000000,
  256'h0000000000000000000000000000000000000000000000000000000000000018
};
wire [1023:0] M_sha512_abc = {
  256'h6162638000000000000000000000000000000000000000000000000000000000,
  256'h0000000000000000000000000000000000000000000000000000000000000000,
  256'h0000000000000000000000000000000000000000000000000000000000000000,
  256'h0000000000000000000000000000000000000000000000000000000000000018
};

// the "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq" test vector, padded
wire [1023:0] M_sha256_2block = {
  256'h6162636462636465636465666465666765666768666768696768696A68696A6B,
  256'h696A6B6C6A6B6C6D6B6C6D6E6C6D6E6F6D6E6F706E6F70718000000000000000,
  256'h0000000000000000000000000000000000000000000000000000000000000000,
  256'h00000000000000000000000000000000000000000000000000000000000001C0
};
wire [511:0] M_sha256_2block_a = M_sha256_2block[1023:512];
wire [511:0] M_sha256_2block_b = M_sha256_2block[511:0];

// a null message
wire [511:0] M_sha256_null = {
  256'h8000000000000000000000000000000000000000000000000000000000000000,
  256'h0000000000000000000000000000000000000000000000000000000000000000
};
wire [1023:0] M_sha512_null = {
  256'h8000000000000000000000000000000000000000000000000000000000000000,
  256'h0000000000000000000000000000000000000000000000000000000000000000,
  256'h0000000000000000000000000000000000000000000000000000000000000000,
  256'h0000000000000000000000000000000000000000000000000000000000000000
};


// driver

reg [31:0] ticks = 0;
reg clk = 1'b0;
reg rst = 1'b0;

initial begin
  $display("starting");
  tick;
  input_valid = 1'b1;
  tick;
  input_valid = 1'b0;
  repeat (256) begin
    tick;
  end
  $display("done");
  $finish;
end

task tick;
begin
  #1;
  ticks = ticks + 1;
  clk = 1;
  #1;
  clk = 0;
  dumpstate;
end
endtask

task dumpstate;
begin
  $display("ticks=%h H=%h", ticks, H_out);
end
endtask

endmodule
