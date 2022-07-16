library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity convolution_axi_v1_0 is
	generic (
		-- Users to add parameters here
        SIZE: integer := 160000; --????????
        WIDTH_num_of_pixels_in_bram : natural := 3; --Amount of pixels that can be placed in 64 bit bram slice (8 x 8 bit)
        DEFAULT_IMG_SIZE : integer := 100; -- WIDTH/height of the image
        WIDTH_data : integer := 64;
        WIDTH_adr : integer := 15;
        WIDTH_bram_adr : integer := 14;
        BRAM_size : integer := 22579;
        num_of_pixels : integer := 8;
        reg_nuber : natural := 81;
        WIDTH_conv_out_data : natural := 2;
        DEPTH : natural := 3;
        WIDTH_kernel_addr : natural := 8;
        WIDTH_img_size : integer := 7; --Number of bits needed to reporesent img size
        KERNEL_SIZE : integer := 9; -- widht/height of kernel
        WIDTH_kernel_size : integer := 4; --Number of bits needed to reporesent kernel size
        WIDTH_kernel_data : natural := 16; -- Number of bits needed to represent kernel value
        WIDTH_pixel : natural := 8; --Number of bits needed to represent pixel data
        WIDTH_kernel : natural := 16; --Number of bits needed to represent kernel data
        WIDTH_sum : natural := 32; --Number of bits needed to represent final sum data
        WIDTH_bram_in_out_adr : integer := 14; --Number of bits needed to represent number of all pixels addreses (100x100 or 425 x 425)
        WIDTH_kernel_adr : integer := 8; --Number of bits needed to represent kernel address data
        SIGNED_UNSIGNED : string := "signed";
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here
        bram_write_data_en_in : in std_logic;
        bram_pixel_data_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);
        bram_pixel_adr_in : in std_logic_vector (WIDTH_bram_adr - 1 downto 0);
        
        bram_read_sign_data_en: in std_logic;
        bram_sign_data_out: out std_logic_vector(WIDTH_conv_out_data - 1 downto 0);
        bram_sign_read_adr: in std_logic_vector(WIDTH_bram_adr -1 downto 0);
        -- bram interface for conv out data... write en is missing
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end convolution_axi_v1_0;

architecture arch_imp of convolution_axi_v1_0 is

    --signals 
    
    -- axi
    signal reset_s : std_logic;
    signal reg_data_s : std_logic;
    signal start_wr_s :  std_logic;
    
    signal start_axi_s : std_logic;
    signal done_axi_s : std_logic;
    signal ready_axi_s : std_logic;
    
    signal mem_addr_s : std_logic_vector(WIDTH_bram_adr-1 + 1 downto 0);
    signal mem_data_s : std_logic_vector(31 downto 0);
    signal mem_wr_s : std_logic;
    
    signal pixel_axi_data_s : std_logic_vector(WIDTH_pixel-1 downto 0);
    signal sign_axi_data_s : std_logic_vector(WIDTH_conv_out_data-1 downto 0);
    
    -- conv ip
    
    signal start_s : std_logic;
    signal ready_s : std_logic;
    signal done_s : std_logic;

    signal bram_read_data_en_s : std_logic;
    signal bram_pixel_data_s : std_logic_vector(WIDTH_pixel - 1 downto 0);
    signal bram_pixel_adr_s : std_logic_vector (WIDTH_bram_adr - 1 downto 0);
    -- bram interface for conv out data... write en is missing
    signal bram_conv_res_data_s :  std_logic_vector(WIDTH_conv_out_data - 1 downto 0);
    signal bram_conv_res_adr_s :  std_logic_vector(WIDTH_bram_adr - 1 downto 0);
    signal bram_conv_res_write_en_s :  std_logic;
	-- component declaration
	component convolution_axi_v1_0_S00_AXI is
		generic (
		WIDTH_pixel : natural := 8; --Number of bits needed to represent pixel data
         WIDTH_conv_out_data : natural := 2;
         WIDTH_bram_adr : integer := 14;
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
		reg_data_o : out std_logic;
        start_wr_o : out std_logic;
        
        start_axi_i : in std_logic;
        done_axi_i : in std_logic;
        ready_axi_i : in std_logic;
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component convolution_axi_v1_0_S00_AXI;
	
	component memory_submodule is
	generic (
        SIZE: integer := 160000; --????????
        WIDTH_num_of_pixels_in_bram : natural := 3; --Amount of pixels that can be placed in 64 bit bram slice (8 x 8 bit)
        DEFAULT_IMG_SIZE : integer := 100; -- WIDTH/height of the image
        WIDTH_data : integer := 64;
        WIDTH_adr : integer := 15;
        WIDTH_bram_adr : integer := 14;
        BRAM_size : integer := 22579;
        num_of_pixels : integer := 8;
        reg_nuber : natural := 81;
        WIDTH_conv_out_data : natural := 2;
        DEPTH : natural := 3;
        WIDTH_kernel_addr : natural := 8;
        WIDTH_img_size : integer := 7; --Number of bits needed to reporesent img size
        KERNEL_SIZE : integer := 9; -- widht/height of kernel
        WIDTH_kernel_size : integer := 4; --Number of bits needed to reporesent kernel size
        WIDTH_kernel_data : natural := 16; -- Number of bits needed to represent kernel value
        WIDTH_pixel : natural := 8; --Number of bits needed to represent pixel data
        WIDTH_kernel : natural := 16; --Number of bits needed to represent kernel data
        WIDTH_sum : natural := 32; --Number of bits needed to represent final sum data
        WIDTH_bram_in_out_adr : integer := 14; --Number of bits needed to represent number of all pixels addreses (100x100 or 425 x 425)
        WIDTH_kernel_adr : integer := 8; --Number of bits needed to represent kernel address data
        SIGNED_UNSIGNED : string := "signed");
    Port (
        clk : in std_logic;
        reset: in std_logic;
        
        
        --axi interface
        reg_data_i : in std_logic;
        start_wr_i : in std_logic;
--        done_wr_i : in std_logic;
--        ready_wr_i : in std_logic;
        
        start_axi_o : out std_logic;
        done_axi_o : out std_logic;
        ready_axi_o : out std_logic;
        
        mem_addr_i : in std_logic_vector(WIDTH_bram_adr-1 + 1 downto 0);
        mem_data_i : in std_logic_vector(31 downto 0);
        mem_wr_i : in std_logic;
        
        pixel_axi_data_o : out std_logic_vector(WIDTH_pixel-1 downto 0);
        sign_axi_data_o : out std_logic_vector(WIDTH_conv_out_data-1 downto 0);
        
        -- interfaces for IP
        start_out : out std_logic;
        ready_in : in std_logic;
        done_in : in std_logic;

        bram_read_data_en_in : in std_logic;
        bram_pixel_data_out : out std_logic_vector(WIDTH_pixel - 1 downto 0);
        bram_pixel_adr_in : in std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        -- bram interface for conv out data... write en is missing
        bram_conv_res_data_in : in std_logic_vector(WIDTH_conv_out_data - 1 downto 0);
        bram_conv_res_adr_in : in std_logic_vector(WIDTH_bram_in_out_adr - 1 downto 0);
        bram_conv_res_write_en_in : in std_logic
         );
        end component memory_submodule_e;
        
        
        component convolution_ip is
        generic (
        WIDTH_num_of_pixels_in_bram : natural := 3; --Amount of pixels that can be placed in 64 bit bram slice (8 x 8 bit)
        DEFAULT_IMG_SIZE : integer := 100; -- WIDTH/height of the image
        WIDTH_data : integer := 64;
        WIDTH_adr : integer := 15;
        WIDTH_bram_adr : integer := 14;
        BRAM_size : integer := 22579;
        num_of_pixels : integer := 8;
        reg_nuber : natural := 81;
        WIDTH_conv_out_data : natural := 2;
        DEPTH : natural := 3;
        WIDTH_kernel_addr : natural := 8;
        WIDTH_img_size : integer := 7; --Number of bits needed to reporesent img size
        KERNEL_SIZE : integer := 9; -- widht/height of kernel
        WIDTH_kernel_size : integer := 4; --Number of bits needed to reporesent kernel size
        WIDTH_kernel_data : natural := 16; -- Number of bits needed to represent kernel value
        WIDTH_pixel : natural := 8; --Number of bits needed to represent pixel data
        WIDTH_kernel : natural := 16; --Number of bits needed to represent kernel data
        WIDTH_sum : natural := 32; --Number of bits needed to represent final sum data
        WIDTH_bram_in_out_adr : integer := 14; --Number of bits needed to represent number of all pixels addreses (100x100 or 425 x 425)
        WIDTH_kernel_adr : integer := 8; --Number of bits needed to represent kernel address data
        SIGNED_UNSIGNED : string := "signed");
    port (
        -- ip interfaces
        clk : in std_logic;
        reset_in : in std_logic;
        start_in : in std_logic;
        ready_out : out std_logic;

        done_out : out std_logic;

        bram_read_data_en_out : out std_logic;
        bram_pixel_data_in : in std_logic_vector(WIDTH_pixel - 1 downto 0);
        bram_pixel_adr_out : out std_logic_vector (WIDTH_bram_in_out_adr - 1 downto 0);
        -- bram interface for conv out data... write en is missing
        bram_conv_res_data_out : out std_logic_vector(WIDTH_conv_out_data - 1 downto 0);
        bram_conv_res_adr_out : out std_logic_vector(WIDTH_bram_in_out_adr - 1 downto 0);
        bram_conv_res_write_en_out : out std_logic
        
        
         -- testing interfaces
    );
        end component convolution_ip_e;
begin

-- Instantiation of Axi Bus Interface S00_AXI
convolution_axi_v1_0_S00_AXI_inst : convolution_axi_v1_0_S00_AXI
	generic map (
	       WIDTH_pixel => WIDTH_pixel,--Number of bits needed to represent pixel data
         WIDTH_conv_out_data => WIDTH_conv_out_data,
         WIDTH_bram_adr=> WIDTH_bram_adr,
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	   reg_data_o=>reg_data_s,
	   start_wr_o=>start_wr_s,
	   ready_axi_i => ready_axi_s,
	   done_axi_i => done_axi_s,
	   start_axi_i => start_axi_s,
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
	process(bram_read_sign_data_en,bram_sign_read_adr,bram_pixel_adr_in)
	begin
	if(bram_read_sign_data_en = '1') then 
	   mem_addr_s <= bram_read_sign_data_en & bram_sign_read_adr;
	else
	   mem_addr_s <= bram_read_sign_data_en & bram_pixel_adr_in;
	end if;
	end process;
--    mem_addr_s <= bram_read_sign_data_en & bram_pixel_adr_in;
    mem_data_s <= conv_std_logic_vector(0, 32-8)&bram_pixel_data_in;
    mem_wr_s <= bram_write_data_en_in;
    bram_sign_data_out <= sign_axi_data_s;
    reset_s <= not s00_axi_aresetn;
	-- User logic ends
	
	mem_submodule: memory_submodule
	generic map(
	   SIZE => SIZE, --????????
        WIDTH_num_of_pixels_in_bram =>  WIDTH_num_of_pixels_in_bram, --Amount of pixels that can be placed in 64 bit bram slice (8 x 8 bit)
        DEFAULT_IMG_SIZE =>  DEFAULT_IMG_SIZE, -- WIDTH/height of the image
        WIDTH_data =>WIDTH_data,
        WIDTH_adr=> WIDTH_adr,
        WIDTH_bram_adr =>WIDTH_bram_adr,
        BRAM_size =>BRAM_size,
        num_of_pixels =>num_of_pixels,
        reg_nuber =>reg_nuber,
        WIDTH_conv_out_data =>WIDTH_conv_out_data,
        DEPTH =>DEPTH,
        WIDTH_kernel_addr=> WIDTH_kernel_addr,
        WIDTH_img_size =>WIDTH_img_size, --Number of bits needed to reporesent img size
        KERNEL_SIZE =>KERNEL_SIZE, -- widht/height of kernel
        WIDTH_kernel_size =>WIDTH_kernel_size, --Number of bits needed to reporesent kernel size
        WIDTH_kernel_data=> WIDTH_kernel_data, -- Number of bits needed to represent kernel value
        WIDTH_pixel =>WIDTH_pixel, --Number of bits needed to represent pixel data
        WIDTH_kernel =>WIDTH_kernel, --Number of bits needed to represent kernel data
        WIDTH_sum =>WIDTH_sum, --Number of bits needed to represent final sum data
        WIDTH_bram_in_out_adr =>WIDTH_bram_in_out_adr ,--Number of bits needed to represent number of all pixels addreses (100x100 or 425 x 425)
        WIDTH_kernel_adr=> WIDTH_kernel_adr, --Number of bits needed to represent kernel address data
        SIGNED_UNSIGNED=> SIGNED_UNSIGNED)
    port map(
        clk => s00_axi_aclk,
        reset => reset_s,
        
        reg_data_i => reg_data_s,
        start_wr_i => start_wr_s,
--        done_wr_i : in std_logic;
--        ready_wr_i : in std_logic;
         
        start_axi_o => start_axi_s,
        done_axi_o => done_axi_s,
        ready_axi_o => ready_axi_s,
        
        mem_addr_i =>mem_addr_s,
        mem_data_i =>mem_data_s,
        mem_wr_i =>mem_wr_s,
        
        pixel_axi_data_o =>pixel_axi_data_s,
        sign_axi_data_o =>sign_axi_data_s,
        
        -- interfaces for IP
        start_out => start_s,
        ready_in => ready_s,
        done_in => done_s,

        bram_read_data_en_in => bram_read_data_en_s,
        bram_pixel_data_out => bram_pixel_data_s,
        bram_pixel_adr_in => bram_pixel_adr_s,
        -- bram interface for conv out data... write en is missing
        bram_conv_res_data_in => bram_conv_res_data_s,
        bram_conv_res_adr_in => bram_conv_res_adr_s,
        bram_conv_res_write_en_in => bram_conv_res_write_en_s
    );
    
    convolution_module: convolution_ip
    generic map(
--	   SIZE => SIZE, --????????
        WIDTH_num_of_pixels_in_bram =>  WIDTH_num_of_pixels_in_bram, --Amount of pixels that can be placed in 64 bit bram slice (8 x 8 bit)
        DEFAULT_IMG_SIZE =>  DEFAULT_IMG_SIZE, -- WIDTH/height of the image
        WIDTH_data =>WIDTH_data,
        WIDTH_adr=> WIDTH_adr,
        WIDTH_bram_adr =>WIDTH_bram_adr,
        BRAM_size =>BRAM_size,
        num_of_pixels =>num_of_pixels,
        reg_nuber =>reg_nuber,
        WIDTH_conv_out_data =>WIDTH_conv_out_data,
        DEPTH =>DEPTH,
        WIDTH_kernel_addr=> WIDTH_kernel_addr,
        WIDTH_img_size =>WIDTH_img_size, --Number of bits needed to reporesent img size
        KERNEL_SIZE =>KERNEL_SIZE, -- widht/height of kernel
        WIDTH_kernel_size =>WIDTH_kernel_size, --Number of bits needed to reporesent kernel size
        WIDTH_kernel_data=> WIDTH_kernel_data, -- Number of bits needed to represent kernel value
        WIDTH_pixel =>WIDTH_pixel, --Number of bits needed to represent pixel data
        WIDTH_kernel =>WIDTH_kernel, --Number of bits needed to represent kernel data
        WIDTH_sum =>WIDTH_sum, --Number of bits needed to represent final sum data
        WIDTH_bram_in_out_adr =>WIDTH_bram_in_out_adr ,--Number of bits needed to represent number of all pixels addreses (100x100 or 425 x 425)
        WIDTH_kernel_adr=> WIDTH_kernel_adr, --Number of bits needed to represent kernel address data
        SIGNED_UNSIGNED=> SIGNED_UNSIGNED)
        port map (
             -- ip interfaces
            clk => s00_axi_aclk,
            reset_in => reset_s,
            start_in  => start_s,
            ready_out => ready_s,
    
            done_out  => done_s,
    
            bram_read_data_en_out => bram_read_data_en_s,
            bram_pixel_data_in => bram_pixel_data_s,
            bram_pixel_adr_out => bram_pixel_adr_s,
            -- bram interface for conv out data... write en is missing
            bram_conv_res_data_out => bram_conv_res_data_s,
            bram_conv_res_adr_out => bram_conv_res_adr_s,
            bram_conv_res_write_en_out  => bram_conv_res_write_en_s
        );

end arch_imp;
