module reg_mux ( in, en , clk , rst , out , sel );
parameter width = 18;
parameter RSTTYPE = "SYNC";
input [ width-1 : 0] in;
input rst , clk , sel , en;
output reg [ width-1 : 0] out;
reg [ width-1 : 0] in_reg;
generate  // regester 
    if ( RSTTYPE == "SYNC") begin  // sync reset 
        always@ ( posedge clk ) begin
            if(rst)
            in_reg <= 0;
           else begin
                if( en )
                in_reg <= in;
            end
        end
    end
    else begin   // async reset
        always@ ( posedge clk or posedge rst) begin
            if(rst )
            in_reg <=0;
            else begin
                if( en )
                in_reg <= in;
            end
        end
    end
endgenerate
// mux
always@(*) begin
if (sel)
out = in_reg;
else
out = in;
end
endmodule


