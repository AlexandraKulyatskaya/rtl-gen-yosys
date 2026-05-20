// Параметризуемый синхронный счётчик с синхронным сбросом
module counter #(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst_n,
    input wire clr,
    input wire en,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= {WIDTH{1'b0}};
        end else if (clr) begin
            q <= {WIDTH{1'b0}}; // Синхронный сброс
        end else if (en) begin
            q <= q + 1'b1;      // Инкремент
        end
    end

endmodule

