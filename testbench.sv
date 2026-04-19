`timescale 1ns/1ps

module CPU_TOP_tb();
  // Khai báo các tín hiệu kết nối với CPU_TOP
  reg clk;
  reg rst_n;
  wire [31:0] READDATA;
  wire [5:0] OP;
  // Khởi tạo thực thể CPU_TOP
  CUP_TOP dut (
    .clk(clk),
    .rst_n(rst_n),
    .OP(OP),
    .READDATA(READDATA)
  );

  // 1. Tạo xung Clock (Chu kỳ 10ns -> Tần số 100MHz)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // 2. Kịch bản Test
  initial begin
    // Khởi tạo hệ thống
    rst_n = 0;
    #40;          // Giữ reset trong 15ns
    rst_n = 1;    // Giải phóng reset để CPU bắt đầu chạy

    // Cho CPU chạy trong một khoảng thời gian đủ để thực hiện danh sách lệnh
    // Giả sử chương trình của bạn có 20 lệnh
    #20000;

    // Kết thúc mô phỏng
    $display("Mo phong hoan tat.");
    $stop;
  end

  // 3. Giám sát dữ liệu (Monitor)
  // In ra giá trị READDATA mỗi khi nó thay đổi để kiểm tra lệnh LW
  initial begin
    $monitor("Time: %0t | Reset: %b | Data from Memory: %h", $time, rst_n, READDATA);
  end

  // 4. (Tùy chọn) Lưu file để xem dạng sóng trên GTKWave hoặc Vivado
  initial begin
  $dumpfile("dump.vcd"); // Tên file xuất dữ liệu
    $dumpvars(1, CPU_TOP_tb.dut.DUT0.dut5);       // Lưu tất cả các biến trong testbench và module con
end

endmodule
