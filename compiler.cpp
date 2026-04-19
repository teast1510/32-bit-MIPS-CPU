#include <iostream>
#include <cstdint>
#include <iomanip>
#include <string>

using namespace std;

// R-type: Opcode(6) | Rs(5) | Rt(5) | Rd(5) | Pad(11)
uint32_t r_type(int opcode, int rs, int rt, int rd) {
    return (opcode << 26) | (rs << 21) | (rt << 16) | (rd << 11);
}

// I-type: Opcode(6) | Rs(5) | Rt(5) | Imm(16)
uint32_t i_type(int opcode, int rs, int rt, int imm) {
    return (opcode << 26) | (rs << 21) | (rt << 16) | (imm & 0xFFFF);
}

// Hàm hỗ trợ in ra 1 dòng lệnh Verilog chuẩn form
void printVerilogLine(int addr, uint32_t inst, string comment) {
    cout << "            6'd" << addr << ":  q = 32'h" 
         << hex << uppercase << setfill('0') << setw(8) << inst << dec 
         << "; // " << comment << "\n";
}

int main() {
    int a, x, b;
    cout << "Nhap a: "; cin >> a;
    cout << "Nhap x: "; cin >> x;
    cout << "Nhap b: "; cin >> b;

    int OP_ADD  = 0b000001;
    int OP_SW   = 0b000010;
    int OP_LW   = 0b000100;
    int OP_ADDI = 0b001000;

    cout << "\n================ KET QUA FILE VERILOG ================\n\n";
    cout << "module IMEM32 (\n";
    cout << "    input wire [5:0] addr, \n";
    cout << "    output reg [31:0] q\n";
    cout << ");\n";
    cout << "    always @(*) begin\n";
    cout << "        case (addr[5:0])\n";

    int addr = 0;
    uint32_t inst;

    // --- KHỞI TẠO ---
    cout << "            // --- KHOI TAO ---\n";
    
    inst = i_type(OP_ADDI, 0, 4, 0);
    printVerilogLine(addr, inst, "addi $4, $0, 0  -> y = 0 ($4 la accumulator)");
    addr += 4;

    inst = i_type(OP_ADDI, 0, 1, x);
    printVerilogLine(addr, inst, "addi $1, $0, " + to_string(x) + "  -> x = " + to_string(x));
    addr += 4;

    inst = i_type(OP_ADDI, 0, 2, a);
    printVerilogLine(addr, inst, "addi $2, $0, " + to_string(a) + "  -> a = " + to_string(a) + " (bien dem)");
    addr += 4;

    inst = i_type(OP_ADDI, 0, 3, b);
    printVerilogLine(addr, inst, "addi $3, $0, " + to_string(b) + "  -> b = " + to_string(b));
    addr += 4;

    // --- LOOP ---
    cout << "\n            // --- LOOP ---\n";
    int loop_count = 1;
    int a_temp = a;
    while (a_temp > 0) {
        cout << "            // Lan " << loop_count++ << ": \n";
        
        inst = r_type(OP_ADD, 4, 1, 4);
        printVerilogLine(addr, inst, "add  $4, $4, $1 -> y = y + x");
        addr += 4;

        inst = i_type(OP_ADDI, 2, 2, -1);
        printVerilogLine(addr, inst, "addi $2, $2, -1 -> a = a - 1");
        addr += 4;

        a_temp--;
    }

    // --- END ---
    cout << "\n            // --- END ---\n";
    inst = r_type(OP_ADD, 4, 3, 5);
    printVerilogLine(addr, inst, "add  $5, $4, $3 -> y = y + b");
    addr += 4;

    inst = i_type(OP_SW, 0, 5, 0);
    printVerilogLine(addr, inst, "sw   $5, 0($0)  -> Luu ket qua vao Word 0");
    addr += 4;

    uint32_t trap_inst = i_type(OP_LW, 0, 6, 0); 
    printVerilogLine(addr, trap_inst, "lw   $6, 0($0)  -> Doc Word 0 ra $6 (READDATA)");

    // --- DEFAULT ---
    cout << "\n            // TRAP:\n";
    cout << "            default: q = 32'h" << hex << uppercase << setfill('0') << setw(8) << trap_inst << dec << "; \n";
    
    // --- FOOTER ---
    cout << "        endcase\n";
    cout << "    end\n";
    cout << "endmodule\n";
    cout << "\n======================================================\n";

    return 0;
}
