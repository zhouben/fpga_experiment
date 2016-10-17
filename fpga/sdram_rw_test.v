`ifdef RW_INTERVAL
always @ ( negedge clk or negedge rst_n )
begin
    if( !rst_n ) begin
        i           <= 4'd0;
        wr_load     <= 1'b1;
        rd_load     <= 1'b1;
        sys_rd      <= 1'b0;
        sys_we      <= 1'b0;
        sys_data_in <= 20'd0;
        counter     <= 20'd0;
        verify_led  <= 1'b0;
        wr_base_addr<= 22'd0;
        rd_base_addr<= 22'd0;
    end else begin
        case( i )
            4'd0: begin
                sys_data_in <= 20'd0;
                counter     <= 20'd0;
                //等待SDRAM初始化完成
                if (sdram_init_done) begin
                    i <= i + 1'b1;
                    wr_load<=1'b0;
                end
                else begin
                    i <= 4'd0;
                    wr_load<=1'b1;
                    rd_load<=1'b1;
                end
            end

            4'd1: begin
                //写512个16bit数据到SDRAM
                if( sys_data_in[8:0] ==9'd511 ) begin
                    i       <= i + 1'b1;
                    sys_data_in[19:9] <= sys_data_in[19:9] + 11'd1;
                    sys_data_in[ 8:0] <= 9'd0;
                    sys_we  <=1'b0;
                    rd_load <=1'b0;
                end
                else begin
                    sys_we      <= 1'b1;
                    sys_data_in[8:0] <= counter;
                    counter     <= counter + 1'b1;
                    i <= 4'd1;
                end
            end

            4'd2: begin
                sys_rd  <= 1'b1;
                counter <= counter+1'b1;
                //从SDRAM读取512个16bit数据
                if (counter == 9'd511 ) begin
                    i       <= i + 1'b1;
                end
                else begin
                    if ((counter != 9'd0) & (sys_data_out[8:0] + 9'd1 != counter)) begin
                        verify_led <= 1'b1;
                    end
                    i       <= 4'd2;
                end
            end

            4'd3: begin
                i       <= 4'd4;
                sys_rd  <= 1'b0;
            end
            4'd4: begin
                if (cnt == 26'd1) begin
                    i <= 4'd1;
                end
            end
        endcase
    end
end
`endif
`ifdef SEQUENTIAL_RW
localparam IDLE         = 4'd0;
localparam WRITING      = 4'd1;
localparam WRITE_PENDING= 4'd2;
localparam READING      = 4'd3;
localparam READ_PENDING = 4'd4;
localparam TERMINATE    = 4'd5;

always @ ( negedge clk or negedge rst_n )
begin
    if( !rst_n ) begin
        i           <= IDLE;
        wr_load     <= 1'b1;
        rd_load     <= 1'b1;
        sys_rd      <= 1'b0;
        sys_we      <= 1'b0;
        sys_data_in <= 20'd0;
        counter     <= 20'd0;
        verify_led  <= 1'b0;
        wr_base_addr<= 22'd0;
        rd_base_addr<= 22'd0;
    end else begin
        rd_load     <= 1'b0;
        wr_load     <= 1'b0;
        sys_rd      <= 1'b0;
        sys_we      <= 1'b0;
        case( i )
            IDLE: begin
                sys_data_in <= 20'd0;
                counter     <= 20'd0;
                //等待SDRAM初始化完成
                if (sdram_init_done & (~sdram_wr_req)) begin
                    i           <= WRITING;
                    wr_load     <=1'b0;
                    sys_data_in <= 20'd0;
                    sys_we      <= 1'b1;
                end
                else begin
                    i <= 4'd0;
                    wr_load<=1'b1;
                    rd_load<=1'b1;
                end
            end

            WRITING: begin
                //写512个16bit数据到SDRAM
                if (sys_data_in == {20{1'b1}}) begin
                    sys_we  <= 1'b0;
                    if (~sdram_rd_req) begin
                        i       <= READING;
                        sys_rd  <= 1'b1;
                        rd_load <= 1'b0;
                        counter <= 20'd0;
                    end
                end else if ((sys_data_in[8:0] == 9'd511) && (sdram_wr_req)) begin
                    i       <= WRITE_PENDING;
                    sys_we  <= 1'b0;
                    sys_data_in <= sys_data_in + 20'd1;
                end else begin
                    sys_we      <= 1'b1;
                    sys_data_in <= sys_data_in + 20'd1;
                end
            end
            WRITE_PENDING: begin
                if (~sdram_wr_req) begin
                    i       <= WRITING;
                    sys_we  <= 1'b0;
                end
            end

            READING: begin
                if (counter == {20{1'b1}}) begin
                    i       <= TERMINATE;
                    sys_rd  <= 1'b0;
                end else if ((counter[8:0] == 9'd511) && (sdram_rd_req)) begin
                    i       <= READ_PENDING;
                    sys_rd  <= 1'b0;
                end else begin
                    sys_rd  <= 1'b1;
                    counter <= counter + 20'b1;
                    if (sys_data_out != counter[15:0]) begin
                        verify_led <= 1'b1;
                    end
                end
            end

            READ_PENDING: begin
                if (~sdram_rd_req) begin
                    i   <= READING;
                    sys_rd  <= 1'b1;
                end
            end

            TERMINATE: begin
                sys_rd  <= 1'b0;
                sys_we  <= 1'b0;
            end
        endcase
    end
end
`endif
`ifdef ADV_RW
localparam IDLE         = 4'd0;
localparam LOAD_ADDR    = 4'd1;
localparam WAIT_RDY_0   = 4'd2;
localparam WAIT_RDY_1   = 4'd3;
localparam WRITING      = 4'd4;
localparam WRITE_PENDING= 4'd5;
localparam LOAD_RD_ADDR = 4'd6;
localparam READING      = 4'd7;
localparam READ_PENDING = 4'd8;
localparam TERMINATE    = 4'd9;

always @ ( negedge clk or negedge rst_n )
begin
    if( !rst_n ) begin
        i           <= IDLE;
        wr_load     <= 1'b0;
        rd_load     <= 1'b0;
        sys_rd      <= 1'b0;
        sys_we      <= 1'b0;
        sys_data_in <= 20'd0;
        counter     <= 20'd0;
        verify_led  <= 1'b0;
        wr_base_addr<= 22'd0;
        rd_base_addr<= 22'd0;
        dly_cnt     <= 3'd0;
    end else begin
        rd_load     <= 1'b0;
        wr_load     <= 1'b0;
        sys_rd      <= 1'b0;
        sys_we      <= 1'b0;
        case( i )
            IDLE: begin
                sys_data_in <= 20'd0;
                counter     <= 20'd0;
                //等待SDRAM初始化完成
                if (sdram_init_done & (~sdram_wr_req)) begin
                    i           <= LOAD_ADDR;
                    wr_load     <=1'b0;
                    sys_data_in <= 20'd0;
                    sys_we      <= 1'b0;
                end
                else begin
                    i <= 4'd0;
                    wr_load<=1'b0;
                    rd_load<=1'b0;
                end
            end
            LOAD_ADDR: begin    // 1
                if (~sdram_wr_req) begin
                    wr_load <= 1'b1;
                    i       <= WAIT_RDY_0;
                end
            end

            WAIT_RDY_0: begin
                wr_load <= 1'b1;
                i   <= WAIT_RDY_1;
            end
            WAIT_RDY_1: begin
                wr_load         <= 1'b0;
                if (~sdram_wr_req) begin
                    i               <= WRITING;
                    sys_we          <= 1'b1;
                    sys_data_in     <= wr_base_addr[19:0];
                    wr_base_addr[10:8]  <= wr_base_addr[10:8] + 3'd2;
                end
            end

            WRITING: begin  // 4
                //写 256 个16bit数据到SDRAM
                if (sys_data_in[7:0] == 8'd255) begin
                    i       <= WRITE_PENDING;
                    sys_we  <= 1'b0;
                    dly_cnt <= 3'd0;
                    sys_data_in <= sys_data_in + 20'd1;
                end else begin
                    sys_we      <= 1'b1;
                    sys_data_in <= sys_data_in + 20'd1;
                end
            end
            // 5
            WRITE_PENDING: begin
                if(dly_cnt == DLY_CNT) begin
                    if (~sdram_wr_req) begin
                        sys_we  <= 1'b0;
                        i       <= LOAD_ADDR;
                        wr_load <= 1'b0;
                        if (wr_base_addr[10:8] == 3'd4) begin
                            wr_base_addr[10:8] <= 3'd1;
                        end else if (wr_base_addr[10:8] == 3'd5) begin
                            i       <= LOAD_RD_ADDR;
                            rd_load         <= 1'b1;
                            rd_base_addr    <= 20'd0;
                        end
                    end
                end else dly_cnt <= dly_cnt + 3'd1;
            end

            LOAD_RD_ADDR: begin // 6
            rd_load         <= 1'b0;
                if (sys_rd_fifo_empty) begin
                    i               <= LOAD_RD_ADDR;
                end else begin
                    sys_rd          <= 1'b1;
                    i               <= READING;
                end
            end

            READING: begin  // 7
                if (counter[9:0] == {10{1'b1}}) begin
                    i       <= TERMINATE;
                    sys_rd  <= 1'b0;
                end else if ((counter[7:0] == 8'd255) && (sys_rd_fifo_empty)) begin
                    i       <= READ_PENDING;
                    sys_rd  <= 1'b0;
                end else begin
                    sys_rd  <= 1'b1;
                    counter <= counter + 20'b1;
                    if (sys_data_out != counter[15:0]) begin
                        verify_led <= 1'b1;
                    end
                end
            end

            READ_PENDING: begin
                if (~sys_rd_fifo_empty) begin
                    i   <= READING;
                    sys_rd  <= 1'b1;
                end
            end

            TERMINATE: begin
                sys_rd  <= 1'b0;
                sys_we  <= 1'b0;
            end
        endcase
    end
end
`endif

