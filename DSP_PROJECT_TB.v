module DSP_PROJECT_TB();
reg [17:0] A , B , D;
reg [47:0] C;
reg CLK , CARRYIN;
reg [7:0] OPMODE;
reg [17:0] BCIN;
reg RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
reg CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
reg [ 47:0 ] PCIN;
wire [17:0] BCOUT ;
wire [ 47:0] PCOUT;
wire [ 47: 0] P;
wire [35:0] M;
wire CARRYOUT , CARRYOUTF;
reg [ 47: 0] previous_p ;
reg previous_carryout;
DSP_PROJECT DUT (A,B,C,D,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,
RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
initial begin 
    CLK = 0;
    forever begin
        #1 CLK = ~ CLK;
    end
end
initial begin 
    RSTA = 1;
    RSTB = 1;
    RSTM = 1;
    RSTP = 1;
    RSTC =1;
    RSTD = 1;
    RSTCARRYIN = 1; 
    RSTOPMODE = 1;
    repeat(10) begin
        A =$random;
        B =$random;
        C =$random;
        D =$random;
        CARRYIN =$random;
        OPMODE =$random;
        BCIN =$random;
        PCIN =$random;
        CEA = $random;
        CEB = $random;
        CEM = $random;
        CEP = $random;
        CEC = $random;
        CED = $random;
        CECARRYIN = $random;
        CEOPMODE = $random;
        @(negedge CLK);
        if( P || M  || P  || BCOUT  || PCOUT || CARRYOUT || CARRYOUTF ) begin
            $display(" output error in rsest ");
            $stop;
        end
    end
        RSTA = 0;
        RSTB = 0;
        RSTM = 0;
        RSTP = 0;
        RSTC = 0;
        RSTD = 0;
        RSTCARRYIN = 0; 
        RSTOPMODE = 0;
        CEA = 1;
        CEB = 1;
        CEM = 1;
        CEP = 1;
        CEC = 1;
        CED = 1;
        CECARRYIN = 1;
        CEOPMODE = 1;

        // verify DSP path1

        OPMODE = 8'b11011101;
        A = 18'h14;   // 20
        B = 18'hA;   // 10
        C = 48'h15E; // 350
        D = 18'h19;  // 25
        repeat (10) begin
        CARRYIN =$random;
        BCIN =$random;
        PCIN =$random;
        repeat(4) @(negedge CLK);
        if( BCOUT != 18'hf || M != 36'h12c || PCOUT != 48'h32 || P != 48'h32 || CARRYOUT != 0 || CARRYOUTF != 0 ) begin
            $display(" output error ");
            $stop;
        end
        end
        
        // verify path2
       

        OPMODE = 8'b00010000;
        A = 18'h14;   // 20
        B = 18'hA;   // 10
        C = 48'h15E; // 350
        D = 18'h19;  // 25
        repeat(10) begin
        CARRYIN =$random;
        BCIN =$random;
        PCIN =$random;
        repeat(3) @(negedge CLK);
           if( BCOUT != 18'h23 || M != 36'h2bc || PCOUT != 0 || P != 0 || CARRYOUT != 0 || CARRYOUTF != 0 ) begin
            $display(" output error ");
            $stop;
        end
        end
        
        previous_p = P;
        previous_carryout = CARRYOUT;

        // verify path3

        OPMODE = 8'b00001010;
        A = 18'h14;   // 20
        B = 18'hA;   // 10
        C = 48'h15E; // 350
        D = 18'h19;  // 25
        repeat(10) begin
        CARRYIN =$random;
        BCIN =$random;
        PCIN =$random;
        repeat(3) @(negedge CLK);
        if( BCOUT != 18'ha || M != 36'hc8 || P != previous_p || PCOUT != previous_p || CARRYOUT != previous_carryout || CARRYOUTF !=previous_carryout) begin
            $display(" output error ");
            $stop;
        end
        previous_p = P;
        previous_carryout = CARRYOUT;
        end

        // verify path4

        OPMODE = 8'b10100111;
        A = 18'h5;   // 5
        B = 18'h6;   // 6
        C = 48'h15E; // 350
        D = 18'h19;  // 25
        PCIN = 48'hBB8 ; // 3000
        repeat(10) begin
        BCIN =$random;
        CARRYIN =$random;
         repeat(3) @(negedge CLK);
        if( BCOUT != 18'h6 || M != 36'h1e || P != 48'hfe6fffec0bb1 || PCOUT != 48'hfe6fffec0bb1 || CARRYOUT != 1 || CARRYOUTF !=1) begin
            $display(" output error ");
            $stop;
        end
        end
        $stop;
end
      initial begin
        $monitor ( "p=%h , pcout = %h , carryout = %h , carryoutf = %h , m = %h , Bcout = %h" , P , PCOUT , CARRYOUT , CARRYOUTF , M, BCOUT);
      end
endmodule



        










        


       







   
        




        
    



    



