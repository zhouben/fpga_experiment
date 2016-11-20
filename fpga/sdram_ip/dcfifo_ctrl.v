/*-------------------------------------------------------------------------
Description			:		sdram vga controller with picture display.
Modification History	:
Data			By			Version			Change Description
===========================================================================
15/02/1
--------------------------------------------------------------------------*/

`timescale 1 ns / 1 ns
module dcfifo_ctrl
(
	//global clock
	input				clk_ref,		//ȫ��ʱ��
	input 				clk_write,		//fifoд����ʱ��
	input				clk_read,		//fifo������ʱ��
	input 				rst_n,			//ȫ�ָ�λ

	//burst length
	input		[8:0]	wr_length,		//sdram��ͻ������
	input		[8:0]	rd_length,		//sdramдͻ������
	input				wr_load,		//sdramд��ַ������λ
	input		[23:0]	wr_addr,		//sdramд��ַ
	input		[23:0]	wr_max_addr,	//sdram���д��ַ
	input				rd_load,		//sdram����ַ������λ
	input		[23:0]	rd_addr,		//sdram����ַ
	input		[23:0]	rd_max_addr,	//sdram������ַ

	//wrfifo:  fifo 2 sdram
	input 				wrf_wrreq,		//д��sdram���ݻ���fifo��������,��Ϊfifoд�ź�
	input		[15:0] 	wrf_din,		//д��sdram���ݻ���fifoд�����ߣ�д��sdram���ݣ�
	output 	reg			sdram_wr_req,	//д��sdram�����ź�
	input 				sdram_wr_ack,	//д��sdram��Ӧ�ź�,��Ϊfifo���ź�
	output		[15:0] 	sdram_din,		//д��sdram���ݻ���fifo�����������
	output	reg	[23:0] 	sdram_wraddr,	//д��sdramʱ��ַ�ݴ�����{bank[1:0],row[11:0],column[7:0]}

	//rdfifo: sdram 2 fifo
	input 				rdf_rdreq,		//��ȡsdram���ݻ���fifo�������
	output		[15:0] 	rdf_dout,		//��ȡsdram���ݻ���fifo������ߣ���ȡsdram���ݣ�
	output 	reg			sdram_rd_req,	//��ȡsdram�����ź�
	input 				sdram_rd_ack,	//��ȡsdram��Ӧ�ź�,��Ϊfifo����д��Ч�ź�
	input		[15:0] 	sdram_dout,		//��ȡsdram���ݻ���fifo��������
	output	reg	[23:0] 	sdram_rdaddr,	//��ȡsdramʱ��ַ�ݴ�����{bank[1:0],row[11:0],column[7:0]}

	//sdram address control
	input				sdram_init_done,	//sdram��ʼ������ź�
	output	reg			frame_write_done,	//sdram write one frame
	output	reg			frame_read_done	//sdram read one frame

);

//------------------------------------------------
//sdram��д��Ӧ��ɱ����½��ز���
reg	sdram_wr_ackr1, sdram_wr_ackr2;
reg sdram_rd_ackr1, sdram_rd_ackr2;
always @(posedge clk_ref or negedge rst_n)
begin
	if(!rst_n)
		begin
		sdram_wr_ackr1 <= 1'b0;
		sdram_wr_ackr2 <= 1'b0;
		sdram_rd_ackr1 <= 1'b0;
		sdram_rd_ackr2 <= 1'b0;
		end
	else
		begin
		sdram_wr_ackr1 <= sdram_wr_ack;
		sdram_wr_ackr2 <= sdram_wr_ackr1;
		sdram_rd_ackr1 <= sdram_rd_ack;
		sdram_rd_ackr2 <= sdram_rd_ackr1;
		end
end
wire write_done = sdram_wr_ackr2 & ~sdram_wr_ackr1;	//sdram_wr_ack�½��ر�־λ
wire read_done = sdram_rd_ackr2 & ~sdram_rd_ackr1;	//sdram_rd_ack�½��ر�־λ

//------------------------------------------------
//ͬ��sdram��д��ַ��ʼֵ��λ�ź�
reg	wr_load_r1, wr_load_r2;
reg	rd_load_r1, rd_load_r2;
always@(posedge clk_ref or negedge rst_n)
begin
	if(!rst_n)
		begin
		wr_load_r1 <= 1'b0;
		wr_load_r2 <= 1'b0;
		rd_load_r1 <= 1'b0;
		rd_load_r2 <= 1'b0;
		end
	else
		begin
		wr_load_r1 <= wr_load;
		wr_load_r2 <= wr_load_r1;
		rd_load_r1 <= rd_load;
		rd_load_r2 <= rd_load_r1;
		end
end
wire	wr_load_flag = ~wr_load_r2 & wr_load_r1;	//��ַ���������ر�־λ
wire	rd_load_flag = ~rd_load_r2 & rd_load_r1;	//��ַ���������ر�־λ


//------------------------------------------------
//sdramд��ַ����ģ�飨���ȣ�
always @(posedge clk_ref or negedge rst_n)
begin
	if(!rst_n)
		begin
		sdram_wraddr <= 24'd0;
		frame_write_done <= 1'b0;
		end
	else if(wr_load_flag)						//����sdramд�����ַ
		begin
		sdram_wraddr <= wr_addr;
		frame_write_done <= 1'b0;
		end
	else if(write_done)						//ͻ��д�����
		begin
		if(sdram_wraddr < wr_max_addr - wr_length)
			begin
			sdram_wraddr <= sdram_wraddr + wr_length;
			frame_write_done <= 1'b0;
			end
		else
			begin
			sdram_wraddr <= sdram_wraddr;		//��ֹ����������ַ
			frame_write_done <= 1'b1;
			end
		end
	else
		begin
		sdram_wraddr <= sdram_wraddr;			//�����ַ
		frame_write_done <= frame_write_done;
		end
end

//------------------------------------------------
//sdram����ַ����ģ��(���)
always @(posedge clk_ref or negedge rst_n)
begin
	if(!rst_n)
		begin
		sdram_rdaddr <= 22'd0;
		frame_read_done <= 0;
		end
	else if(rd_load_flag)						//����sdram��ȡ����ַ
		begin
		sdram_rdaddr <= rd_addr;
		frame_read_done <= 0;
		end
	else if(read_done)							//ͻ���������
		begin
		if(sdram_rdaddr < rd_max_addr - rd_length)
			begin
			sdram_rdaddr <= sdram_rdaddr + rd_length;
			frame_read_done <= 0;
			end
		else
			begin
			sdram_rdaddr <= sdram_rdaddr;		//��ֹ����������ַ
			frame_read_done <= 1;
			end
		end
	else
		begin
		sdram_rdaddr <= sdram_rdaddr;			//�����ַ
		frame_read_done <= frame_read_done;
		end
end



//-------------------------------------
//sdram ��д�źŲ���ģ��
wire	[8:0] 	wrf_use;
wire	[8:0] 	rdf_use;
always@(posedge clk_ref or negedge rst_n)
begin
	if(!rst_n)
		begin
		sdram_wr_req <= 0;
		sdram_rd_req <= 0;
		end
	else if(sdram_init_done == 1'b1)
		begin						//д�����ȣ������ڷ�ֹ���ݶ�ʧ
		if(wrf_use >= wr_length)	// && wr_load_flag == 1'b0)
			begin					//wrfifo��ͻ������
			sdram_wr_req <= 1;		//дsdarmʹ��
			sdram_rd_req <= 0;		//��sdram����
			end
		else if(rdf_use < rd_length ) // && rd_load_flag == 1'b0)
			begin					//rdfifo��ͻ������
			sdram_wr_req <= 0;		//дsdram����
            // for debug
			//sdram_rd_req <= 1;		//��sdramʹ��
			sdram_rd_req <= 0;		//��sdram����
			end
		else
			begin
			sdram_wr_req <= 0;		//дsdram����
			sdram_rd_req <= 0;		//��sdram����
			end
		end
	else
		begin
		sdram_wr_req <= 0;			//дsdram����
		sdram_rd_req <= 0;			//��sdram����
		end
end

//------------------------------------------------
//����sdramд�����ݻ���fifoģ��
wrfifo	u_wrfifo
(
	.rst		(~rst_n ),			//wrfifo�첽�����źţ�����Ҫ��| wr_load_flag
	//input 2 fifo
	.wr_clk		(clk_write),		//wrfifoдʱ��50MHz
	.wr_en		(wrf_wrreq),		//wrfifoдʹ���ź�
	.din		(wrf_din),			//wrfifo������������
	//fifo 2sdram
	.rd_clk		(clk_ref),			//wrfifo��ʱ��100MHz
	.rd_en		(sdram_wr_ack),		//wrfifo��ʹ���ź�
	.dout			(sdram_din),		//wrfifo�����������
	//user port
   .full(), // output full
   .empty(), // output empty
	.rd_data_count	(wrf_use),			//wrfifo�洢��������
	.wr_data_count	()
);


//------------------------------------------------
//����sdram�������ݻ���fifoģ��
rdfifo	u_rdfifo
(
	.rst		(~rst_n | rd_load_flag),		//rdfifo�첽�����ź�
	//sdram 2 fifo
	.wr_clk		(clk_ref),       	//rdfifoдʱ��100MHz
	.wr_en		(sdram_rd_ack),  	//rdfifoдʹ���ź�
	.din		(sdram_dout),  		//rdfifo������������
	//fifo 2 output
	.rd_clk		(clk_read),       //rdfifo��ʱ��50MHz
	.rd_en		(rdf_rdreq),     	//rdfifo��ʹ���ź�
	.dout			(rdf_dout),			//rdfifo�����������
	//user port
	.full(), // output full
   .empty(), // output empty
	.rd_data_count	(),              //rdfifo�洢��������
	.wr_data_count	(rdf_use)        	   //rdfifo�洢��������
);



endmodule