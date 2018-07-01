	component lcd1602 is
		port (
			clk         : in    std_logic                    := 'X';             -- clk
			reset       : in    std_logic                    := 'X';             -- reset
			address     : in    std_logic                    := 'X';             -- address
			chipselect  : in    std_logic                    := 'X';             -- chipselect
			read        : in    std_logic                    := 'X';             -- read
			write       : in    std_logic                    := 'X';             -- write
			writedata   : in    std_logic_vector(7 downto 0) := (others => 'X'); -- writedata
			readdata    : out   std_logic_vector(7 downto 0);                    -- readdata
			waitrequest : out   std_logic;                                       -- waitrequest
			LCD_DATA    : inout std_logic_vector(7 downto 0) := (others => 'X'); -- DATA
			LCD_ON      : out   std_logic;                                       -- ON
			LCD_BLON    : out   std_logic;                                       -- BLON
			LCD_EN      : out   std_logic;                                       -- EN
			LCD_RS      : out   std_logic;                                       -- RS
			LCD_RW      : out   std_logic                                        -- RW
		);
	end component lcd1602;

	u0 : component lcd1602
		port map (
			clk         => CONNECTED_TO_clk,         --                clk.clk
			reset       => CONNECTED_TO_reset,       --              reset.reset
			address     => CONNECTED_TO_address,     --   avalon_lcd_slave.address
			chipselect  => CONNECTED_TO_chipselect,  --                   .chipselect
			read        => CONNECTED_TO_read,        --                   .read
			write       => CONNECTED_TO_write,       --                   .write
			writedata   => CONNECTED_TO_writedata,   --                   .writedata
			readdata    => CONNECTED_TO_readdata,    --                   .readdata
			waitrequest => CONNECTED_TO_waitrequest, --                   .waitrequest
			LCD_DATA    => CONNECTED_TO_LCD_DATA,    -- external_interface.DATA
			LCD_ON      => CONNECTED_TO_LCD_ON,      --                   .ON
			LCD_BLON    => CONNECTED_TO_LCD_BLON,    --                   .BLON
			LCD_EN      => CONNECTED_TO_LCD_EN,      --                   .EN
			LCD_RS      => CONNECTED_TO_LCD_RS,      --                   .RS
			LCD_RW      => CONNECTED_TO_LCD_RW       --                   .RW
		);

